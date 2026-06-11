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
        replace = "REPLACE!"
    },
    zh_cn = {
        replace = "覆盖!"
    },
    zh_tw = {
        replace = "覆蓋!"
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

    love.graphics.setColor(0.10, 0.02, 0.00, 0.85)
    love.graphics.draw(drawable, draw_x + 0.018, y + 0.016, 0, sx, sy)
    love.graphics.setColor(colour[1], colour[2], colour[3], colour[4] or 1)
    love.graphics.draw(drawable, draw_x, y, 0, sx, sy)
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

local function draw_warning_badge(card, warning)
    if not love or not love.graphics or not G or not G.TILESIZE then return end
    local vt = card.VT or card.T
    if not vt then return end

    local font = draw_font()
    local header = loc_text("replace")
    local detail = (warning.old_name and warning.new_name)
        and (warning.old_name .. " > " .. warning.new_name)
        or ""
    local chinese = language_group() ~= "en"
    local header_scale = chinese and 0.36 or 0.29
    local detail_scale = chinese and 0.24 or 0.21
    local detail_w = detail ~= "" and text_width(detail, font, detail_scale) or 0
    local header_w = text_width(header, font, header_scale)
    local badge_w = math.max(1.30, math.min(2.05, math.max(header_w + 0.60, detail_w + 0.22)))
    local badge_h = detail ~= "" and 0.56 or 0.34
    local px, py = parallax_offset(card)
    local room_w = G.ROOM and G.ROOM.T and G.ROOM.T.w or nil
    local center_x = (vt.x or 0) + (vt.w or 0) / 2 + px
    if room_w then center_x = clamp(center_x, badge_w / 2 + 0.08, room_w - badge_w / 2 - 0.08) end

    love.graphics.push()
    love.graphics.scale(G.TILESCALE * G.TILESIZE)
    love.graphics.translate(center_x, (vt.y or 0) - 0.12 + py)
    love.graphics.scale(vt.scale or 1)

    local pulse = 0.88 + 0.10 * math.sin((G.TIMERS and G.TIMERS.REAL or 0) * 7.5)
    local x = -badge_w / 2
    local y = -badge_h
    local radius = 0.07

    love.graphics.setColor(0, 0, 0, 0.48)
    love.graphics.rectangle("fill", x + 0.035, y + 0.045, badge_w, badge_h, radius)

    love.graphics.setColor(0.92, 0.12, 0.03, 0.96 * pulse)
    love.graphics.rectangle("fill", x, y, badge_w, badge_h, radius)
    if detail ~= "" then
        love.graphics.setColor(0.23, 0.06, 0.03, 0.92)
        love.graphics.rectangle("fill", x + 0.035, y + 0.28, badge_w - 0.07, 0.23, 0.04)
    end

    love.graphics.setLineWidth(0.014)
    love.graphics.setColor(1.00, 0.68, 0.07, 0.95)
    love.graphics.rectangle("line", x, y, badge_w, badge_h, radius)

    local icon_cx = x + 0.20
    local icon_cy = y + 0.17
    love.graphics.setColor(1.00, 0.82, 0.06, 0.96)
    love.graphics.polygon(
        "fill",
        icon_cx, icon_cy - 0.12,
        icon_cx - 0.12, icon_cy + 0.10,
        icon_cx + 0.12, icon_cy + 0.10
    )
    love.graphics.setColor(0.30, 0.04, 0.00, 0.95)
    love.graphics.setLineWidth(0.018)
    love.graphics.line(icon_cx, icon_cy - 0.045, icon_cx, icon_cy + 0.035)
    love.graphics.rectangle("fill", icon_cx - 0.010, icon_cy + 0.060, 0.020, 0.020)

    draw_text(header, x + 0.40, y + 0.025, badge_w - 0.46, header_scale, {1, 1, 1, 1}, "left")
    if detail ~= "" then
        draw_text(detail, 0, y + 0.295, badge_w - 0.18, detail_scale, {1, 0.90, 0.58, 1}, "center")
    end

    love.graphics.setColor(0.92, 0.12, 0.03, 0.95)
    love.graphics.polygon("fill", -0.08, y + badge_h - 0.01, 0.08, y + badge_h - 0.01, 0, y + badge_h + 0.12)

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
