local ModifierWarning = rawget(_G, "BalatroModifierWarning") or {}
_G.BalatroModifierWarning = ModifierWarning

ModifierWarning.config = ModifierWarning.config or {
    warn_enhancement = true,
    warn_seal = true,
    hide_on_face_down = true
}
ModifierWarning.text_cache = ModifierWarning.text_cache or {}

local vanilla_seal_consumables = {
    ["Talisman"] = "Gold",
    ["Deja Vu"] = "Red",
    ["Trance"] = "Blue",
    ["Medium"] = "Purple"
}

local texts = {
    en = {
        replace = "REPLACE"
    },
    zh_cn = {
        replace = "覆盖提醒"
    },
    zh_tw = {
        replace = "覆蓋提醒"
    }
}

local seal_names = {
    en = {
        Red = "Red",
        Blue = "Blue",
        Gold = "Gold",
        Purple = "Purple"
    },
    zh_cn = {
        Red = "红蜡封",
        Blue = "蓝蜡封",
        Gold = "金蜡封",
        Purple = "紫蜡封"
    },
    zh_tw = {
        Red = "紅蠟封",
        Blue = "藍蠟封",
        Gold = "金蠟封",
        Purple = "紫蠟封"
    }
}

local function language_key()
    local lang = G and G.SETTINGS and (G.SETTINGS.real_language or G.SETTINGS.language) or nil
    return type(lang) == "string" and lang:lower() or ""
end

local function is_traditional_chinese()
    local lang = language_key()
    if lang:sub(1, 2) ~= "zh" then return false end
    return lang:find("tw", 1, true)
        or lang:find("hk", 1, true)
        or lang:find("mo", 1, true)
        or lang:find("hant", 1, true)
        or lang:find("traditional", 1, true)
end

local function language_group()
    local lang = language_key()
    if lang:sub(1, 2) ~= "zh" then return "en" end
    return is_traditional_chinese() and "zh_tw" or "zh_cn"
end

local function loc_text(key)
    local group = language_group()
    local pack = texts[group] or texts.en
    return pack[key] or texts.en[key] or key
end

local function is_face_down(card)
    if not card then return true end
    if card.facing == "back" or card.sprite_facing == "back" then return true end
    if card.ability and card.ability.wheel_flipped then return true end
    if type(card.should_hide_front) == "function" then
        local ok, hidden = pcall(function() return card:should_hide_front() end)
        if ok and hidden then return true end
    end
    return false
end

local function card_is_highlighted(card)
    if not card then return false end
    if card.highlighted then return true end
    if G and G.hand and G.hand.highlighted then
        for _, highlighted in ipairs(G.hand.highlighted) do
            if highlighted == card then return true end
        end
    end
    return false
end

local function normalize_seal_key(key)
    if not key then return nil end
    if G and G.P_SEALS and G.P_SEALS[key] then return key end

    local raw_key = tostring(key)
    local lower = raw_key:lower()
    if lower == "red" or lower == "red_seal" then return "Red" end
    if lower == "blue" or lower == "blue_seal" then return "Blue" end
    if lower == "gold" or lower == "gold_seal" then return "Gold" end
    if lower == "purple" or lower == "purple_seal" then return "Purple" end

    if SMODS and SMODS.Seal and SMODS.Seal.badge_to_key then
        local mapped = SMODS.Seal.badge_to_key[raw_key] or SMODS.Seal.badge_to_key[lower]
        if mapped then
            local mapped_key = tostring(mapped)
            if mapped_key ~= raw_key and mapped_key:lower() ~= lower then
                return normalize_seal_key(mapped) or mapped
            end
            return mapped
        end
    end

    return raw_key
end

local function current_enhancement_key(card)
    if not card or not card.config then return nil end
    local center = card.config.center
    local key = card.config.center_key
    if not key and type(center) == "table" then key = center.key end
    if not key and type(center) == "string" then key = center end
    if not key or key == "c_base" then return nil end

    local center_obj = G and G.P_CENTERS and G.P_CENTERS[key] or center
    if center_obj and center_obj.set == "Enhanced" then return key end
    if card.ability and card.ability.set == "Enhanced" then return key end
    return nil
end

local function consumable_conversion(card)
    if not card or not card.ability or not card.ability.consumeable then return nil end
    local cfg = card.ability.consumeable

    if ModifierWarning.config.warn_enhancement and cfg.mod_conv and G and G.P_CENTERS then
        local center = G.P_CENTERS[cfg.mod_conv]
        if center and center.set == "Enhanced" then
            return {
                kind = "enhancement",
                key = cfg.mod_conv
            }
        end
    end

    if ModifierWarning.config.warn_seal and vanilla_seal_consumables[card.ability.name] then
        return {
            kind = "seal",
            key = normalize_seal_key(cfg.extra or vanilla_seal_consumables[card.ability.name])
        }
    end

    return nil
end

local function target_count_is_valid(conversion_card)
    if not conversion_card or not G or not G.hand or not G.hand.highlighted then return false end
    local count = #G.hand.highlighted
    if count <= 0 then return false end
    local ability = conversion_card.ability and conversion_card.ability.consumeable
    if ability and ability.max_highlighted then
        local max_count = ability.mod_num or ability.max_highlighted
        local min_count = ability.min_highlighted or 1
        return count <= max_count and count >= min_count
    end
    return true
end

local function active_conversion()
    local areas = {
        G and G.consumeables or false,
        G and G.pack_cards or false
    }

    for i = 1, #areas do
        local area = areas[i]
        if area then
            for _, card in ipairs(area.highlighted or {}) do
                local conversion = consumable_conversion(card)
                if conversion and target_count_is_valid(card) then return conversion end
            end
            for _, card in ipairs(area.cards or {}) do
                if card.highlighted then
                    local conversion = consumable_conversion(card)
                    if conversion and target_count_is_valid(card) then return conversion end
                end
            end
        end
    end

    return nil
end

local function safe_localize_name(set, key)
    if type(localize) ~= "function" then return nil end
    local ok, result = pcall(function()
        return localize { type = "name_text", set = set, key = key }
    end)
    if ok and type(result) == "string" and result ~= "" and result ~= "ERROR" then
        return result
    end
    return nil
end

local function shorten_modifier_name(name, kind)
    if type(name) ~= "string" then return nil end
    if language_group() == "en" then
        name = name:gsub("%s+[Cc]ard$", "")
        name = name:gsub("%s+[Ss]eal$", "")
    end
    if kind == "seal" and language_group() == "en" then
        name = name:gsub("^%s+", ""):gsub("%s+$", "")
    end
    return name
end

local function enhancement_name(key)
    local localized = safe_localize_name("Enhanced", key)
    if localized then return shorten_modifier_name(localized, "enhancement") end

    local center = G and G.P_CENTERS and G.P_CENTERS[key] or nil
    local fallback = center and (center.label or center.effect or center.name) or tostring(key)
    return shorten_modifier_name(fallback, "enhancement") or tostring(key)
end

local function seal_name(key)
    key = normalize_seal_key(key)
    if not key then return nil end

    local loc_key = tostring(key):lower() .. "_seal"
    local localized = safe_localize_name("Other", loc_key)
    if localized then return shorten_modifier_name(localized, "seal") end

    local group = language_group()
    if seal_names[group] and seal_names[group][key] then return seal_names[group][key] end
    if seal_names.en[key] then return seal_names.en[key] end

    local seal = G and G.P_SEALS and G.P_SEALS[key] or nil
    local fallback = seal and (seal.label or seal.name) or tostring(key)
    return shorten_modifier_name(fallback, "seal") or tostring(key)
end

local function modifier_name(kind, key)
    if kind == "enhancement" then return enhancement_name(key) end
    if kind == "seal" then return seal_name(key) end
    return tostring(key)
end

function ModifierWarning.warning_for_card(card)
    if not card or not G or not G.hand or card.area ~= G.hand then return false end
    if not card_is_highlighted(card) then return false end
    if ModifierWarning.config.hide_on_face_down and is_face_down(card) then return false end

    local conversion = active_conversion()
    if not conversion then return false end

    if conversion.kind == "enhancement" then
        local old_key = current_enhancement_key(card)
        if old_key and old_key ~= conversion.key then
            return {
                kind = conversion.kind,
                old_key = old_key,
                new_key = conversion.key,
                old_name = modifier_name(conversion.kind, old_key),
                new_name = modifier_name(conversion.kind, conversion.key)
            }
        end
    end

    if conversion.kind == "seal" then
        local old_key = normalize_seal_key(card.seal)
        local new_key = normalize_seal_key(conversion.key)
        if old_key and new_key and old_key ~= new_key then
            return {
                kind = conversion.kind,
                old_key = old_key,
                new_key = new_key,
                old_name = modifier_name(conversion.kind, old_key),
                new_name = modifier_name(conversion.kind, new_key)
            }
        end
    end

    return false
end

function ModifierWarning.card_would_overwrite(card)
    return ModifierWarning.warning_for_card(card) and true or false
end

local function draw_font()
    if G and G.LANG and G.LANG.font and G.LANG.font.FONT then return G.LANG.font end
    if G and G.LANGUAGES and G.LANGUAGES["en-us"] and G.LANGUAGES["en-us"].font then
        return G.LANGUAGES["en-us"].font
    end
    return nil
end

local function font_scales(font, scale)
    local tile_size = G and G.TILESIZE or 20
    local font_scale = font and font.FONTSCALE or 0.1
    local squish = font and font.squish or 1
    return scale * squish * font_scale / tile_size, scale * font_scale / tile_size
end

local function cached_text(text, font)
    if not love or not love.graphics or not love.graphics.newText then return nil end
    local font_obj = font and font.FONT or love.graphics.getFont()
    if not font_obj then return nil end

    local cache_key = tostring(font_obj) .. "\n" .. tostring(text)
    local cached = ModifierWarning.text_cache[cache_key]
    if not cached then
        cached = love.graphics.newText(font_obj, tostring(text))
        ModifierWarning.text_cache[cache_key] = cached
    end
    return cached
end

local function text_width(text, font, scale)
    local sx = font_scales(font, scale)
    local drawable = cached_text(text, font)
    if drawable and drawable.getWidth then return drawable:getWidth() * sx end
    local font_obj = font and font.FONT or nil
    if font_obj and font_obj.getWidth then return font_obj:getWidth(tostring(text)) * sx end
    return tostring(text):len() * 0.08 * scale
end

local function text_height(text, font, scale)
    local _, sy = font_scales(font, scale)
    local drawable = cached_text(text, font)
    if drawable and drawable.getHeight then return drawable:getHeight() * sy end
    local font_obj = font and font.FONT or nil
    if font_obj and font_obj.getHeight then return font_obj:getHeight() * sy end
    return 0.20 * scale
end

local function draw_text(text, x, y, max_w, scale, colour, align)
    local font = draw_font()
    local drawable = cached_text(text, font)
    if not drawable then return end

    local sx, sy = font_scales(font, scale)
    local width = drawable:getWidth() * sx
    if max_w and width > max_w and width > 0 then
        local shrink = max_w / width
        sx = sx * shrink
        sy = sy * shrink
        width = max_w
    end

    local draw_x = x
    if align == "center" then draw_x = x - width / 2 end
    if align == "right" then draw_x = x - width end

    love.graphics.setColor(0.10, 0.02, 0.00, 0.85)
    love.graphics.draw(drawable, draw_x + 0.018, y + 0.016, 0, sx, sy)
    love.graphics.setColor(colour[1], colour[2], colour[3], colour[4] or 1)
    love.graphics.draw(drawable, draw_x, y, 0, sx, sy)
end

local function draw_text_center_y(text, x, center_y, max_w, scale, colour, align)
    local font = draw_font()
    local height = text_height(text, font, scale)
    draw_text(text, x, center_y - height / 2, max_w, scale, colour, align)
end

local function parallax_offset(card)
    local parent = card and card.parent
    local x = (card.layered_parallax and card.layered_parallax.x)
        or (parent and parent.layered_parallax and parent.layered_parallax.x)
        or 0
    local y = (card.layered_parallax and card.layered_parallax.y)
        or (parent and parent.layered_parallax and parent.layered_parallax.y)
        or 0
    return x, y
end

local function clamp(value, min_value, max_value)
    if min_value and value < min_value then return min_value end
    if max_value and value > max_value then return max_value end
    return value
end

local function warning_bounds(badge_w)
    local room = G and G.ROOM and G.ROOM.T or nil
    local min_x = 0.08
    local max_x = room and room.w and (room.w - 0.08) or nil

    local hand = G and G.hand and G.hand.T or nil
    if hand and hand.x and hand.w and hand.w > badge_w + 0.30 then
        min_x = math.max(min_x, hand.x - 0.20)
        max_x = math.min(max_x or (hand.x + hand.w), hand.x + hand.w + 0.20)
    end

    if max_x and max_x - min_x <= badge_w + 0.10 and room and room.w then
        min_x = 0.08
        max_x = room.w - 0.08
    end

    return min_x, max_x, room and room.h or nil
end

local function draw_relation_arrow(cx, cy, width, colour)
    local half = width / 2
    local head = math.min(0.11, width * 0.34)
    love.graphics.setLineWidth(0.026)
    love.graphics.setColor(colour[1], colour[2], colour[3], colour[4] or 1)
    love.graphics.line(cx - half, cy, cx + half - head, cy)
    love.graphics.polygon(
        "fill",
        cx + half, cy,
        cx + half - head, cy - head * 0.62,
        cx + half - head, cy + head * 0.62
    )
end

local function draw_warning_badge(card, warning)
    if not love or not love.graphics or not G or not G.TILESIZE then return end
    local vt = card.VT or card.T
    if not vt then return end

    local font = draw_font()
    local header = loc_text("replace")
    local old_name = warning.old_name or ""
    local new_name = warning.new_name or ""
    local has_relation = old_name ~= "" and new_name ~= ""
    local chinese = language_group() ~= "en"
    local header_scale = chinese and 0.34 or 0.34
    local relation_scale = chinese and 0.29 or 0.27
    local arrow_w = chinese and 0.36 or 0.32
    local relation_w = 0
    if has_relation then
        relation_w = text_width(old_name, font, relation_scale)
            + text_width(new_name, font, relation_scale)
            + arrow_w
            + 0.34
    end
    local header_w = text_width(header, font, header_scale)
    local badge_w = math.max(chinese and 2.85 or 2.35, math.min(chinese and 4.25 or 3.70, math.max(header_w + 0.94, relation_w + 0.54)))
    local badge_h = has_relation and (chinese and 0.90 or 0.82) or 0.54
    local px, py = parallax_offset(card)
    local min_x, max_x, room_h = warning_bounds(badge_w)
    local center_x = (vt.x or 0) + (vt.w or 0) / 2 + px
    if max_x then center_x = clamp(center_x, min_x + badge_w / 2, max_x - badge_w / 2) end

    local badge_above = true
    local anchor_y = (vt.y or 0) - 0.12 + py
    if room_h and anchor_y - badge_h < 0.08 then
        badge_above = false
        anchor_y = (vt.y or 0) + (vt.h or 0) + 0.16 + py
        anchor_y = clamp(anchor_y, 0.08, room_h - badge_h - 0.08)
    elseif room_h then
        anchor_y = clamp(anchor_y, badge_h + 0.08, room_h - 0.08)
    end

    love.graphics.push()
    love.graphics.scale((G.TILESCALE or 1) * G.TILESIZE)
    love.graphics.translate(center_x, anchor_y)
    love.graphics.scale(clamp(vt.scale or 1, 1, 1.08))

    local pulse = 0.88 + 0.10 * math.sin((G.TIMERS and G.TIMERS.REAL or 0) * 7.5)
    local x = -badge_w / 2
    local y = badge_above and -badge_h or 0
    local radius = 0.09

    love.graphics.setColor(0, 0, 0, 0.50)
    love.graphics.rectangle("fill", x + 0.04, y + 0.05, badge_w, badge_h, radius)

    love.graphics.setColor(0.12, 0.045, 0.025, 0.96)
    love.graphics.rectangle("fill", x, y, badge_w, badge_h, radius)
    love.graphics.setColor(0.80, 0.12, 0.03, 0.95 * pulse)
    love.graphics.rectangle("fill", x, y, 0.16, badge_h, radius)

    local inner_x = x + 0.20
    local inner_w = badge_w - 0.25
    if has_relation then
        love.graphics.setColor(0.06, 0.025, 0.015, 0.76)
        love.graphics.rectangle("fill", inner_x, y + badge_h * 0.49, inner_w, badge_h * 0.40, 0.055)
    end

    love.graphics.setLineWidth(0.018)
    love.graphics.setColor(1.00, 0.62, 0.08, 0.96)
    love.graphics.rectangle("line", x, y, badge_w, badge_h, radius)

    local header_center_y = y + badge_h * 0.28
    local relation_center_y = y + badge_h * 0.70
    local icon_cx = x + 0.37
    local icon_cy = header_center_y
    love.graphics.setColor(1.00, 0.82, 0.06, 0.96)
    love.graphics.polygon(
        "fill",
        icon_cx, icon_cy - 0.13,
        icon_cx - 0.13, icon_cy + 0.115,
        icon_cx + 0.13, icon_cy + 0.115
    )
    love.graphics.setColor(0.30, 0.04, 0.00, 0.95)
    love.graphics.setLineWidth(0.022)
    love.graphics.line(icon_cx, icon_cy - 0.050, icon_cx, icon_cy + 0.038)
    love.graphics.rectangle("fill", icon_cx - 0.011, icon_cy + 0.066, 0.022, 0.022)

    draw_text_center_y(header, x + 0.58, header_center_y, badge_w - 0.70, header_scale, {1, 1, 1, 1}, "left")
    if has_relation then
        local old_w = text_width(old_name, font, relation_scale)
        local new_w = text_width(new_name, font, relation_scale)
        local max_text_w = badge_w - 0.70 - arrow_w
        if old_w + new_w > max_text_w and old_w + new_w > 0 then
            relation_scale = relation_scale * math.max(0.72, max_text_w / (old_w + new_w))
            old_w = text_width(old_name, font, relation_scale)
            new_w = text_width(new_name, font, relation_scale)
        end

        local total_w = old_w + new_w + arrow_w + 0.24
        local old_right = -total_w / 2 + old_w
        local arrow_cx = old_right + 0.12 + arrow_w / 2
        local new_left = arrow_cx + arrow_w / 2 + 0.12

        draw_text_center_y(old_name, old_right, relation_center_y, old_w + 0.02, relation_scale, {1, 0.93, 0.66, 1}, "right")
        draw_relation_arrow(arrow_cx, relation_center_y, arrow_w, {1, 0.82, 0.12, 1})
        draw_text_center_y(new_name, new_left, relation_center_y, new_w + 0.02, relation_scale, {1, 0.93, 0.66, 1}, "left")
    end

    love.graphics.setColor(0.92, 0.12, 0.03, 0.95)
    if badge_above then
        love.graphics.polygon("fill", -0.09, y + badge_h - 0.01, 0.09, y + badge_h - 0.01, 0, y + badge_h + 0.13)
    else
        love.graphics.polygon("fill", -0.09, y + 0.01, 0.09, y + 0.01, 0, y - 0.13)
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.pop()
end

if SMODS and SMODS.DrawStep then
    SMODS.DrawStep {
        key = "modifier_warning_badge",
        order = 990,
        func = function(card)
            local warning = ModifierWarning.warning_for_card(card)
            if warning then
                draw_warning_badge(card, warning)
            end
        end
    }
end
