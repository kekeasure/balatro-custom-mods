local StepBack = rawget(_G, "BalatroStepBack") or {}
_G.BalatroStepBack = StepBack

StepBack.history = StepBack.history or {}
StepBack.max_history = StepBack.max_history or 20
StepBack.ui = StepBack.ui or { count_text = "0" }
StepBack.restoring = false

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

local stepback_text = {
    en = {
        undo = "Back",
        history = "History",
        history_sub = "List",
        choose = "Choose where to step back",
        no_history = "No checkpoints in this blind",
        play_restore_prefix = "Go back before Play #",
        play_restore_suffix = "",
        discard_restore_prefix = "Go back before Discard #",
        discard_restore_suffix = "",
        consumeable_restore_prefix = "Go back before Consumable #",
        consumeable_restore_suffix = "",
        back = "Back"
    },
    zh_cn = {
        undo = "回退",
        history = "记录",
        history_sub = "列表",
        choose = "选择要回到哪一步之前",
        no_history = "当前盲注还没有可回退记录",
        play_restore_prefix = "回到第 ",
        play_restore_suffix = " 次出牌前",
        discard_restore_prefix = "回到第 ",
        discard_restore_suffix = " 次弃牌前",
        consumeable_restore_prefix = "回到第 ",
        consumeable_restore_suffix = " 次使用消耗牌前",
        back = "返回"
    },
    zh_tw = {
        undo = "回退",
        history = "記錄",
        history_sub = "列表",
        choose = "選擇要回到哪一步之前",
        no_history = "目前盲注還沒有可回退記錄",
        play_restore_prefix = "回到第 ",
        play_restore_suffix = " 次出牌前",
        discard_restore_prefix = "回到第 ",
        discard_restore_suffix = " 次棄牌前",
        consumeable_restore_prefix = "回到第 ",
        consumeable_restore_suffix = " 次使用消耗牌前",
        back = "返回"
    }
}

local function loc(key)
    local lang = stepback_text[language_group()] or stepback_text.en
    return lang[key] or stepback_text.en[key] or key
end

local function is_pack_state()
    return G.STATE == G.STATES.TAROT_PACK
        or G.STATE == G.STATES.PLANET_PACK
        or G.STATE == G.STATES.SPECTRAL_PACK
        or G.STATE == G.STATES.BUFFOON_PACK
        or G.STATE == G.STATES.STANDARD_PACK
        or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
end

local function current_blind_key()
    if not G or not G.GAME or not G.GAME.blind then return nil end
    return table.concat({
        tostring(G.GAME.round_resets and G.GAME.round_resets.ante or ""),
        tostring(G.GAME.blind_on_deck or ""),
        tostring(G.GAME.blind.name or ""),
        tostring(G.GAME.blind.chips or ""),
        tostring(G.GAME.round or "")
    }, "|")
end

local function refresh_ui()
    StepBack.ui.count_text = tostring(#StepBack.history)
end

local function ensure_current_blind_history()
    local key = current_blind_key()
    if not key then return false end
    if StepBack.blind_key ~= key then
        StepBack.blind_key = key
        StepBack.history = {}
        refresh_ui()
    end
    return true
end

local function build_save_table()
    if not G or not G.GAME or not G.GAME.blind then return nil end
    if not G.STAGES or G.STAGE ~= G.STAGES.RUN then return nil end
    if is_pack_state() or G.F_NO_SAVING == true then return nil end

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
        SCORING_CALC = G.GAME.current_scoring_calculation:save(),
        BACK = G.GAME.selected_back:save(),
        VERSION = G.VERSION
    })
end

local function is_held_consumeable(card)
    return card
        and G
        and G.consumeables
        and card.area == G.consumeables
        and card.ability
        and card.ability.consumeable
end

local function can_capture(kind, hook, card)
    if StepBack.restoring then return false end
    if not G or not G.GAME or not G.hand or not G.hand.highlighted then return false end
    if G.STATE ~= G.STATES.SELECTING_HAND then return false end
    if kind == "consumeable" then
        return is_held_consumeable(card)
    end
    if #G.hand.highlighted <= 0 then return false end
    if kind == "play" then
        if G.play and G.play.cards and G.play.cards[1] then return false end
        if G.GAME.blind and G.GAME.blind.block_play then return false end
        return #G.hand.highlighted <= math.max(G.GAME.starting_params.play_limit, 1)
    end
    if kind == "discard" then
        if hook then return false end
        if (G.GAME.current_round.discards_left or 0) <= 0 then return false end
        return #G.hand.highlighted <= math.max(G.GAME.starting_params.discard_limit, 0)
    end
    return false
end

local function action_number(kind)
    local round = G.GAME.current_round or {}
    if kind == "play" then
        return (round.hands_played or 0) + 1
    end
    if kind == "consumeable" then
        local count = 0
        for _, entry in ipairs(StepBack.history or {}) do
            if entry.kind == "consumeable" then count = count + 1 end
        end
        return count + 1
    end
    return (round.discards_used or 0) + 1
end

local function restore_label(kind, number)
    if kind == "play" then
        return loc("play_restore_prefix") .. tostring(number or "?") .. loc("play_restore_suffix")
    end
    if kind == "consumeable" then
        return loc("consumeable_restore_prefix") .. tostring(number or "?") .. loc("consumeable_restore_suffix")
    end
    return loc("discard_restore_prefix") .. tostring(number or "?") .. loc("discard_restore_suffix")
end

local function action_label(kind)
    return restore_label(kind, action_number(kind))
end

local function entry_restore_label(entry)
    if entry and entry.kind then
        return restore_label(entry.kind, entry.action_number)
    end
    return entry and entry.label or "?"
end

local function capture(kind, hook, card)
    if not can_capture(kind, hook, card) then return end
    if not ensure_current_blind_history() then return end

    local save_table = build_save_table()
    if not save_table then return end

    StepBack.history[#StepBack.history + 1] = {
        label = action_label(kind),
        kind = kind,
        action_number = action_number(kind),
        save = save_table
    }

    while #StepBack.history > StepBack.max_history do
        table.remove(StepBack.history, 1)
    end
    refresh_ui()
end

local function can_undo()
    if StepBack.restoring then return false end
    if not G or not G.GAME or not G.STATES then return false end
    if G.STATE ~= G.STATES.SELECTING_HAND then return false end
    ensure_current_blind_history()
    return #StepBack.history > 0
end

local function restore_snapshot(index)
    if not can_undo() then return end
    local snapshot = StepBack.history[index]
    if not snapshot or not snapshot.save then return end

    local restore_history = {}
    for i = 1, index - 1 do
        restore_history[i] = StepBack.history[i]
    end

    local restore_save = copy_table(snapshot.save)
    if G.OVERLAY_MENU then G.FUNCS.exit_overlay_menu() end

    StepBack.restoring = true
    G.E_MANAGER:clear_queue()
    G:delete_run()
    G:start_run({ savetext = restore_save })

    StepBack.history = restore_history
    StepBack.blind_key = current_blind_key()
    refresh_ui()

    G.E_MANAGER:add_event(Event({
        no_delete = true,
        trigger = "after",
        delay = 0.05,
        func = function()
            StepBack.restoring = false
            refresh_ui()
            return true
        end
    }))
end

G.FUNCS.stepback_can_undo = function(e)
    if can_undo() then
        e.config.colour = G.C.GREEN
        e.config.button = "stepback_undo"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.stepback_undo = function()
    if not can_undo() then return end
    restore_snapshot(#StepBack.history)
end

G.FUNCS.stepback_can_open_history = function(e)
    if can_undo() then
        e.config.colour = G.C.ORANGE
        e.config.button = "stepback_open_history"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

function create_UIBox_stepback_history()
    ensure_current_blind_history()

    local rows = {
        { n = G.UIT.R, config = { align = "cm", padding = 0.05 }, nodes = {
            { n = G.UIT.T, config = { text = loc("choose"), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true } }
        }}
    }

    if #StepBack.history == 0 then
        rows[#rows + 1] = { n = G.UIT.R, config = { align = "cm", padding = 0.08 }, nodes = {
            { n = G.UIT.T, config = { text = loc("no_history"), scale = 0.4, colour = G.C.UI.TEXT_LIGHT } }
        }}
    else
        for i, entry in ipairs(StepBack.history) do
            local func_name = "stepback_restore_" .. tostring(i)
            local restore_index = i
            G.FUNCS[func_name] = function()
                restore_snapshot(restore_index)
            end
            rows[#rows + 1] = UIBox_button({
                id = func_name,
                label = { entry_restore_label(entry) },
                button = func_name,
                minw = 5.2,
                minh = 0.8,
                scale = 0.42,
                colour = i == #StepBack.history and G.C.GREEN or G.C.BLUE
            })
        end
    end

    return create_UIBox_generic_options({
        back_label = loc("back"),
        minw = 6,
        contents = rows
    })
end

G.FUNCS.stepback_open_history = function()
    if not can_undo() then return end
    G.FUNCS.overlay_menu({
        definition = create_UIBox_stepback_history()
    })
end

local original_play_cards_from_highlighted = G.FUNCS.play_cards_from_highlighted
G.FUNCS.play_cards_from_highlighted = function(e)
    capture("play")
    return original_play_cards_from_highlighted(e)
end

local original_discard_cards_from_highlighted = G.FUNCS.discard_cards_from_highlighted
G.FUNCS.discard_cards_from_highlighted = function(e, hook)
    capture("discard", hook)
    return original_discard_cards_from_highlighted(e, hook)
end

local original_use_card = G.FUNCS.use_card
G.FUNCS.use_card = function(e, mute, nosave)
    local card = e and e.config and e.config.ref_table or nil
    capture("consumeable", nil, card)
    return original_use_card(e, mute, nosave)
end

local original_check_for_unlock = check_for_unlock
function check_for_unlock(args)
    if StepBack.restoring and args and args.type == "continue_game" then return end
    return original_check_for_unlock(args)
end

local original_create_UIBox_buttons = create_UIBox_buttons
function create_UIBox_buttons()
    local t = original_create_UIBox_buttons()
    local text_scale = is_chinese_language() and 0.36 or 0.29
    local button_width = is_chinese_language() and 1.35 or 1.55
    local undo_button = {
        n = G.UIT.C,
        config = {
            id = "stepback_undo_button",
            align = "tm",
            minw = button_width,
            minh = 1.3,
            padding = 0.18,
            r = 0.1,
            hover = true,
            colour = G.C.UI.BACKGROUND_INACTIVE,
            button = "stepback_undo",
            shadow = true,
            func = "stepback_can_undo"
        },
        nodes = {
            { n = G.UIT.R, config = { align = "cm", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = loc("undo"), scale = text_scale, colour = G.C.UI.TEXT_LIGHT } }
            }},
            { n = G.UIT.R, config = { align = "cm", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { ref_table = StepBack.ui, ref_value = "count_text", scale = text_scale * 0.7, colour = G.C.UI.TEXT_LIGHT } }
            }}
        }
    }

    local history_button = {
        n = G.UIT.C,
        config = {
            id = "stepback_history_button",
            align = "tm",
            minw = button_width,
            minh = 1.3,
            padding = 0.18,
            r = 0.1,
            hover = true,
            colour = G.C.UI.BACKGROUND_INACTIVE,
            button = "stepback_open_history",
            shadow = true,
            func = "stepback_can_open_history"
        },
        nodes = {
            { n = G.UIT.R, config = { align = "cm", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = loc("history"), scale = text_scale, colour = G.C.UI.TEXT_LIGHT } }
            }},
            { n = G.UIT.R, config = { align = "cm", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = loc("history_sub"), scale = text_scale * 0.7, colour = G.C.UI.TEXT_LIGHT } }
            }}
        }
    }

    if t and t.nodes then
        table.insert(t.nodes, 2, undo_button)
        table.insert(t.nodes, 3, history_button)
    end
    return t
end

refresh_ui()
