local StepBack = rawget(_G, "BalatroStepBack") or {}
_G.BalatroStepBack = StepBack

StepBack.history = StepBack.history or {}
StepBack.max_history = StepBack.max_history or 20
StepBack.ui = StepBack.ui or { count_text = "0" }
StepBack.restoring = false

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

local function can_capture(kind, hook)
    if StepBack.restoring then return false end
    if not G or not G.GAME or not G.hand or not G.hand.highlighted then return false end
    if G.STATE ~= G.STATES.SELECTING_HAND then return false end
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

local function action_label(kind)
    local round = G.GAME.current_round or {}
    if kind == "play" then
        return "出牌 " .. tostring((round.hands_played or 0) + 1)
    end
    return "弃牌 " .. tostring((round.discards_used or 0) + 1)
end

local function capture(kind, hook)
    if not can_capture(kind, hook) then return end
    if not ensure_current_blind_history() then return end

    local save_table = build_save_table()
    if not save_table then return end

    StepBack.history[#StepBack.history + 1] = {
        label = action_label(kind),
        kind = kind,
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
            { n = G.UIT.T, config = { text = "选择回到哪一步之前", scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true } }
        }}
    }

    if #StepBack.history == 0 then
        rows[#rows + 1] = { n = G.UIT.R, config = { align = "cm", padding = 0.08 }, nodes = {
            { n = G.UIT.T, config = { text = "当前盲注还没有可回退记录", scale = 0.4, colour = G.C.UI.TEXT_LIGHT } }
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
                label = { entry.label .. " 前" },
                button = func_name,
                minw = 5.2,
                minh = 0.8,
                scale = 0.42,
                colour = i == #StepBack.history and G.C.GREEN or G.C.BLUE
            })
        end
    end

    return create_UIBox_generic_options({
        back_label = "返回",
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

local original_check_for_unlock = check_for_unlock
function check_for_unlock(args)
    if StepBack.restoring and args and args.type == "continue_game" then return end
    return original_check_for_unlock(args)
end

local original_create_UIBox_buttons = create_UIBox_buttons
function create_UIBox_buttons()
    local t = original_create_UIBox_buttons()
    local text_scale = 0.36
    local undo_button = {
        n = G.UIT.C,
        config = {
            id = "stepback_undo_button",
            align = "tm",
            minw = 1.35,
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
                { n = G.UIT.T, config = { text = "回退", scale = text_scale, colour = G.C.UI.TEXT_LIGHT } }
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
            minw = 1.35,
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
                { n = G.UIT.T, config = { text = "记录", scale = text_scale, colour = G.C.UI.TEXT_LIGHT } }
            }},
            { n = G.UIT.R, config = { align = "cm", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = "列表", scale = text_scale * 0.7, colour = G.C.UI.TEXT_LIGHT } }
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
