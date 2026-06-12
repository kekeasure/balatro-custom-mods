local ShopUndo = rawget(_G, "BalatroShopUndo") or {}
_G.BalatroShopUndo = ShopUndo

ShopUndo.history = ShopUndo.history or {}
ShopUndo.max_history = ShopUndo.max_history or 12
ShopUndo.ui = ShopUndo.ui or {}
ShopUndo.ui.count_text = ShopUndo.ui.count_text or "0"
ShopUndo.restoring = false

local SHOP_KINDS = {
    shop_buy = true,
    shop_sell = true,
    shop_redeem = true
}

local function language_key()
    local lang = G and G.SETTINGS and (G.SETTINGS.real_language or G.SETTINGS.language) or nil
    return type(lang) == "string" and lang:lower() or ""
end

local function is_chinese_language()
    return language_key():sub(1, 2) == "zh"
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
    if not is_chinese_language() then return "en" end
    return is_traditional_chinese() and "zh_tw" or "zh_cn"
end

local shop_undo_text = {
    en = {
        undo = "Undo",
        sub = "Shop",
        buy_prefix = "Before Buy #",
        buy_suffix = "",
        sell_prefix = "Before Sell #",
        sell_suffix = "",
        redeem_prefix = "Before Voucher #",
        redeem_suffix = ""
    },
    zh_cn = {
        undo = "回退",
        sub = "商店",
        buy_prefix = "第 ",
        buy_suffix = " 次购买前",
        sell_prefix = "第 ",
        sell_suffix = " 次出售前",
        redeem_prefix = "第 ",
        redeem_suffix = " 次兑换券前"
    },
    zh_tw = {
        undo = "回退",
        sub = "商店",
        buy_prefix = "第 ",
        buy_suffix = " 次購買前",
        sell_prefix = "第 ",
        sell_suffix = " 次出售前",
        redeem_prefix = "第 ",
        redeem_suffix = " 次兌換券前"
    }
}

local function loc(key)
    local lang = shop_undo_text[language_group()] or shop_undo_text.en
    return lang[key] or shop_undo_text.en[key] or key
end

local function is_shop_state()
    return G and G.STATES and G.STATE == G.STATES.SHOP
end

local function current_shop_key()
    if not G or not G.GAME then return nil end
    return table.concat({
        tostring(G.GAME.round_resets and G.GAME.round_resets.ante or ""),
        tostring(G.GAME.blind_on_deck or ""),
        tostring(G.GAME.round or "")
    }, "|")
end

local function refresh_ui()
    ShopUndo.ui.count_text = tostring(#ShopUndo.history)
end

local function ensure_current_shop_history()
    local key = current_shop_key()
    if not key then return false end
    if ShopUndo.shop_key ~= key then
        ShopUndo.shop_key = key
        ShopUndo.history = {}
        refresh_ui()
    end
    return true
end

local function is_blocked_state()
    if not G or not G.STATES then return true end
    return G.STATE == G.STATES.TAROT_PACK
        or G.STATE == G.STATES.PLANET_PACK
        or G.STATE == G.STATES.SPECTRAL_PACK
        or G.STATE == G.STATES.BUFFOON_PACK
        or G.STATE == G.STATES.STANDARD_PACK
        or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
end

local function build_save_table()
    if not G or not G.GAME or not G.GAME.blind then return nil end
    if not G.STAGES or G.STAGE ~= G.STAGES.RUN then return nil end
    if not is_shop_state() or is_blocked_state() or G.F_NO_SAVING == true then return nil end

    local card_areas = {}
    for k, v in pairs(G) do
        if type(v) == "table" and v.is and v:is(CardArea) then
            local card_area_ser = v:save()
            if card_area_ser then card_areas[k] = card_area_ser end
        end
    end

    local tags = {}
    for k, v in ipairs(G.GAME.tags or {}) do
        if type(v) == "table" and v.is and v:is(Tag) then
            local tag_ser = v:save()
            if tag_ser then tags[k] = tag_ser end
        end
    end

    return recursive_table_cull({
        cardAreas = card_areas,
        tags = tags,
        GAME = G.GAME,
        STATE = G.STATE,
        ACTION = G.action or nil,
        BLIND = G.GAME.blind:save(),
        SCORING_CALC = G.GAME.current_scoring_calculation and G.GAME.current_scoring_calculation:save() or nil,
        BACK = G.GAME.selected_back and G.GAME.selected_back:save() or nil,
        VERSION = G.VERSION
    })
end

local function card_is_affordable(card)
    if not card or not G or not G.GAME then return false end
    local cost = card.cost or 0
    return cost <= 0 or cost <= ((G.GAME.dollars or 0) - (G.GAME.bankrupt_at or 0))
end

local function has_buy_space(card)
    if not card or not card.ability then return false end
    if card.ability.set == "Voucher" or card.ability.set == "Enhanced" or card.ability.set == "Default" then
        return true
    end

    local slots_used = 1 + (card.ability.extra_slots_used or 0)
    local card_limit = card.ability.card_limit or 0
    if card.ability.set == "Joker" and G.jokers then
        return #G.jokers.cards + slots_used <= G.jokers.config.card_limit + card_limit
    end
    if card.ability.consumeable and G.consumeables then
        return #G.consumeables.cards + slots_used <= G.consumeables.config.card_limit + card_limit
    end
    return false
end

local function can_capture(kind, action_id, card)
    if ShopUndo.restoring or not SHOP_KINDS[kind] or not is_shop_state() then return false end
    if not card or not card.is or not card:is(Card) then return false end

    if kind == "shop_sell" then
        return card.can_sell_card and card:can_sell_card()
    end

    if not card_is_affordable(card) then return false end

    if kind == "shop_buy" then
        if not G.shop_jokers or card.area ~= G.shop_jokers then return false end
        if action_id == "buy_and_use" then
            return card.can_use_consumeable and card:can_use_consumeable()
        end
        return has_buy_space(card)
    end

    if kind == "shop_redeem" then
        return G.shop_vouchers and card.area == G.shop_vouchers and card.ability and card.ability.set == "Voucher"
    end

    return false
end

local function count_kind(kind)
    local count = 0
    for _, entry in ipairs(ShopUndo.history or {}) do
        if entry.kind == kind then count = count + 1 end
    end
    return count
end

local function action_number(kind)
    return count_kind(kind) + 1
end

local function restore_label(kind, number)
    if kind == "shop_sell" then
        return loc("sell_prefix") .. tostring(number or "?") .. loc("sell_suffix")
    end
    if kind == "shop_redeem" then
        return loc("redeem_prefix") .. tostring(number or "?") .. loc("redeem_suffix")
    end
    return loc("buy_prefix") .. tostring(number or "?") .. loc("buy_suffix")
end

local function capture(kind, action_id, card)
    if not can_capture(kind, action_id, card) then return false end
    if not ensure_current_shop_history() then return false end

    local save_table = build_save_table()
    if not save_table then return false end

    local number = action_number(kind)
    ShopUndo.history[#ShopUndo.history + 1] = {
        kind = kind,
        action_number = number,
        label = restore_label(kind, number),
        save = save_table
    }

    while #ShopUndo.history > ShopUndo.max_history do
        table.remove(ShopUndo.history, 1)
    end
    refresh_ui()
    return true
end

local function remove_latest_if_added(was_added)
    if was_added then
        table.remove(ShopUndo.history)
        refresh_ui()
    end
end

local function can_undo()
    if ShopUndo.restoring or not is_shop_state() then return false end
    ensure_current_shop_history()
    return #ShopUndo.history > 0
end

local function restore_latest()
    if not can_undo() then return end
    local index = #ShopUndo.history
    local snapshot = ShopUndo.history[index]
    if not snapshot or not snapshot.save then return end

    local restore_history = {}
    for i = 1, index - 1 do
        restore_history[i] = ShopUndo.history[i]
    end

    local restore_save = copy_table(snapshot.save)
    if G.OVERLAY_MENU then G.FUNCS.exit_overlay_menu() end

    ShopUndo.restoring = true
    G.E_MANAGER:clear_queue()
    G:delete_run()
    G:start_run({ savetext = restore_save })

    ShopUndo.history = restore_history
    ShopUndo.shop_key = current_shop_key()
    refresh_ui()

    G.E_MANAGER:add_event(Event({
        no_delete = true,
        trigger = "after",
        delay = 0.05,
        func = function()
            ShopUndo.restoring = false
            refresh_ui()
            return true
        end
    }))
end

G.FUNCS.shopundo_can_undo = function(e)
    if can_undo() then
        e.config.colour = G.C.GREEN
        e.config.button = "shopundo_undo"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.shopundo_undo = function()
    restore_latest()
end

local original_buy_from_shop = G.FUNCS.buy_from_shop
G.FUNCS.buy_from_shop = function(e)
    local card = e and e.config and e.config.ref_table or nil
    local action_id = e and e.config and e.config.id or nil
    local added = capture("shop_buy", action_id, card)
    local result = original_buy_from_shop(e)
    if result == false then remove_latest_if_added(added) end
    return result
end

local original_sell_card = G.FUNCS.sell_card
G.FUNCS.sell_card = function(e)
    local card = e and e.config and e.config.ref_table or nil
    capture("shop_sell", nil, card)
    return original_sell_card(e)
end

local original_use_card = G.FUNCS.use_card
G.FUNCS.use_card = function(e, mute, nosave)
    local card = e and e.config and e.config.ref_table or nil
    if is_shop_state() and card and card.ability and card.ability.set == "Voucher" then
        capture("shop_redeem", nil, card)
    end
    return original_use_card(e, mute, nosave)
end

local function create_shop_undo_button()
    local text_scale = is_chinese_language() and 0.34 or 0.36
    return {
        n = G.UIT.R,
        config = {
            id = "shopundo_button",
            align = "cm",
            minw = 2.8,
            minh = 0.9,
            r = 0.15,
            colour = G.C.UI.BACKGROUND_INACTIVE,
            one_press = true,
            button = "shopundo_undo",
            func = "shopundo_can_undo",
            hover = true,
            shadow = true
        },
        nodes = {
            { n = G.UIT.R, config = { align = "cm", padding = 0.04 }, nodes = {
                { n = G.UIT.T, config = { text = loc("undo"), scale = text_scale, colour = G.C.WHITE, shadow = true } }
            }},
            { n = G.UIT.R, config = { align = "cm", padding = 0.01 }, nodes = {
                { n = G.UIT.T, config = { text = loc("sub") .. " ", scale = text_scale * 0.66, colour = G.C.WHITE, shadow = true } },
                { n = G.UIT.T, config = { ref_table = ShopUndo.ui, ref_value = "count_text", scale = text_scale * 0.66, colour = G.C.WHITE, shadow = true } }
            }}
        }
    }
end

local function insert_shop_undo_button(node)
    if type(node) ~= "table" or type(node.nodes) ~= "table" then return false end
    for i, child in ipairs(node.nodes) do
        if type(child) == "table" and child.config and child.config.button == "reroll_shop" then
            table.insert(node.nodes, i + 1, create_shop_undo_button())
            return true
        end
    end
    for _, child in ipairs(node.nodes) do
        if insert_shop_undo_button(child) then return true end
    end
    return false
end

if G.UIDEF and G.UIDEF.shop then
    local original_shop = G.UIDEF.shop
    G.UIDEF.shop = function(...)
        local t = original_shop(...)
        insert_shop_undo_button(t)
        return t
    end
end

refresh_ui()
