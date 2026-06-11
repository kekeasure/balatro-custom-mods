local ModifierWarning = rawget(_G, "BalatroModifierWarning") or {}
_G.BalatroModifierWarning = ModifierWarning

ModifierWarning.config = ModifierWarning.config or {
    warn_enhancement = true,
    warn_seal = true,
    hide_on_face_down = true
}

local vanilla_seal_consumables = {
    ["Talisman"] = "Gold",
    ["Deja Vu"] = "Red",
    ["Trance"] = "Blue",
    ["Medium"] = "Purple"
}

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
            key = cfg.extra or vanilla_seal_consumables[card.ability.name]
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

function ModifierWarning.card_would_overwrite(card)
    if not card or not G or not G.hand or card.area ~= G.hand then return false end
    if not card_is_highlighted(card) then return false end
    if ModifierWarning.config.hide_on_face_down and is_face_down(card) then return false end

    local conversion = active_conversion()
    if not conversion then return false end

    if conversion.kind == "enhancement" then
        local old_key = current_enhancement_key(card)
        return old_key and old_key ~= conversion.key
    end

    if conversion.kind == "seal" then
        return card.seal and card.seal ~= conversion.key
    end

    return false
end

local function draw_warning_frame(card)
    if not prep_draw or not love or not love.graphics or not G or not G.TILESIZE then return end
    local vt = card.VT or card.T
    if not vt then return end

    local width = vt.w or card.T.w
    local height = vt.h or card.T.h
    local pulse = 0.78 + 0.16 * math.sin((G.TIMERS and G.TIMERS.REAL or 0) * 7)
    local border_pad = 0.035
    local corner = 0.24

    prep_draw(card, 1.035)
    love.graphics.setLineWidth(0.035)
    love.graphics.setColor(1, 0.47, 0.04, pulse)
    love.graphics.rectangle(
        "line",
        -border_pad,
        -border_pad,
        width + border_pad * 2,
        height + border_pad * 2,
        0.10
    )

    love.graphics.setColor(1, 0.47, 0.04, 0.14)
    love.graphics.rectangle("fill", 0, 0, width, height, 0.08)

    love.graphics.setColor(1, 0.36, 0.02, pulse)
    love.graphics.polygon("fill", width - corner, 0, width, 0, width, corner)
    love.graphics.setLineWidth(0.012)
    love.graphics.setColor(1, 1, 1, pulse)
    local x = width - corner * 0.32
    love.graphics.line(x, corner * 0.18, x, corner * 0.58)
    love.graphics.rectangle("fill", x - 0.012, corner * 0.72, 0.024, 0.024)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.pop()
end

if SMODS and SMODS.DrawStep then
    SMODS.DrawStep {
        key = "modifier_warning_frame",
        order = 990,
        func = function(card)
            if ModifierWarning.card_would_overwrite(card) then
                draw_warning_frame(card)
            end
        end
    }
end
