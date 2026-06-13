local StepBack = rawget(_G, "BalatroStepBack") or {}
_G.BalatroStepBack = StepBack

StepBack.history = StepBack.history or {}
StepBack.max_history = StepBack.max_history or 20
StepBack.ui = StepBack.ui or { count_text = "0" }
StepBack.restoring = false
StepBack.expanded_index = StepBack.expanded_index or nil
StepBack.history_page = StepBack.history_page or nil

local STORAGE_KEY = "balatro_stepback_state"
local HISTORY_PAGE_SIZE = 4
local USE_REAL_CARD_PREVIEW = true
local REAL_CARD_PREVIEW_SCALE = 0.6

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
        discard_preview = "Discard",
        cards_prefix = "Cards:",
        hidden_card = "Face-down",
        unknown_card = "?",
        details = "Details",
        hide_details = "Hide",
        restore_here = "Go",
        prev_page = "Prev",
        next_page = "Next",
        page_prefix = "Page ",
        page_separator = "/",
        page_suffix = "",
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
        discard_preview = "弃牌",
        cards_prefix = "牌：",
        hidden_card = "背面",
        unknown_card = "？",
        details = "详情",
        hide_details = "收起",
        restore_here = "回退",
        prev_page = "上一页",
        next_page = "下一页",
        page_prefix = "第 ",
        page_separator = "/",
        page_suffix = " 页",
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
        discard_preview = "棄牌",
        cards_prefix = "牌：",
        hidden_card = "背面",
        unknown_card = "？",
        details = "詳情",
        hide_details = "收起",
        restore_here = "回退",
        prev_page = "上一頁",
        next_page = "下一頁",
        page_prefix = "第 ",
        page_separator = "/",
        page_suffix = " 頁",
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

local function refresh_ui()
    StepBack.ui.count_text = tostring(#StepBack.history)
end

local write_persisted_history
local load_persisted_history

local function clear_history()
    StepBack.history = {}
    StepBack.blind_key = nil
    StepBack.expanded_index = nil
    StepBack.history_page = nil
    refresh_ui()
    if write_persisted_history then write_persisted_history() end
end

local function current_run_key()
    if not G or not G.GAME then return "" end

    local seed = G.GAME.pseudorandom and G.GAME.pseudorandom.seed or ""
    local back = ""
    if G.GAME.selected_back_key then
        back = G.GAME.selected_back_key.key or G.GAME.selected_back_key.name or tostring(G.GAME.selected_back_key)
    elseif G.GAME.selected_back then
        back = G.GAME.selected_back.name or tostring(G.GAME.selected_back)
    end

    local challenge = ""
    if G.GAME.challenge then
        challenge = G.GAME.challenge.id or G.GAME.challenge.name or tostring(G.GAME.challenge)
    end

    return table.concat({
        tostring(seed),
        tostring(back),
        tostring(G.GAME.stake or ""),
        tostring(challenge)
    }, "|")
end

local function current_blind_key()
    if not G or not G.GAME or not G.GAME.blind then return nil end
    return table.concat({
        current_run_key(),
        tostring(G.GAME.round_resets and G.GAME.round_resets.ante or ""),
        tostring(G.GAME.blind_on_deck or ""),
        tostring(G.GAME.blind.name or ""),
        tostring(G.GAME.blind.chips or ""),
        tostring(G.GAME.round or "")
    }, "|")
end

write_persisted_history = function()
    if not G or not G.GAME then return end
    if StepBack.blind_key and StepBack.history and #StepBack.history > 0 then
        G.GAME[STORAGE_KEY] = {
            version = 1,
            blind_key = StepBack.blind_key,
            history = copy_table(StepBack.history)
        }
    else
        G.GAME[STORAGE_KEY] = nil
    end
end

load_persisted_history = function()
    if not G or not G.GAME then return false end
    local stored = G.GAME[STORAGE_KEY]
    if type(stored) ~= "table" or type(stored.history) ~= "table" then return false end

    local key = current_blind_key()
    if not key or stored.blind_key ~= key then return false end

    StepBack.blind_key = key
    StepBack.history = copy_table(stored.history)
    StepBack.expanded_index = nil
    StepBack.history_page = nil
    refresh_ui()
    return true
end

local function ensure_current_blind_history()
    local key = current_blind_key()
    if not key then return false end
    if StepBack.blind_key ~= key then
        if not load_persisted_history() then
            StepBack.history = {}
            StepBack.blind_key = key
            StepBack.expanded_index = nil
            StepBack.history_page = nil
            refresh_ui()
            write_persisted_history()
        end
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

    local stored_state = G.GAME[STORAGE_KEY]
    G.GAME[STORAGE_KEY] = nil

    local save_table = recursive_table_cull({
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

    G.GAME[STORAGE_KEY] = stored_state
    return save_table
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

local function preview_card_save(card)
    if not card then return nil end
    local card_state = nil
    if card.save then
        card_state = card:save()
    end

    local center_key = card.config and card.config.center_key or nil
    local center = card.config and card.config.center or nil
    if not center_key and type(center) == "table" then center_key = center.key end
    if not center_key and type(center) == "string" then center_key = center end

    local card_key = card.config and card.config.card_key or nil
    local front = card.config and card.config.card or nil
    if (not card_key or not (G.P_CARDS and G.P_CARDS[card_key])) and G.P_CARDS and front then
        for key, value in pairs(G.P_CARDS) do
            if value == front then
                card_key = key
                break
            end
        end
    end
    if (not card_key or not (G.P_CARDS and G.P_CARDS[card_key])) and G.P_CARDS and card.base then
        for key, value in pairs(G.P_CARDS) do
            if value and value.suit == card.base.suit and value.value == card.base.value then
                card_key = key
                break
            end
        end
    end
    if (not card_key or not (G.P_CARDS and G.P_CARDS[card_key])) and SMODS and SMODS.Suits and SMODS.Ranks and card.base then
        local suit = SMODS.Suits[card.base.suit]
        local rank = SMODS.Ranks[card.base.value]
        if suit and rank and suit.card_key and rank.card_key then
            card_key = suit.card_key .. "_" .. rank.card_key
        end
    end

    return {
        card_state = card_state and copy_table(card_state) or nil,
        center_key = center_key or "c_base",
        card_key = card_key,
        playing_card = card.playing_card,
        base = card.base and copy_table(card.base) or nil,
        ability = card.ability and copy_table(card.ability) or nil,
        edition = card.edition and copy_table(card.edition) or nil,
        seal = card.seal,
        facing = card.facing,
        sprite_facing = card.sprite_facing,
        debuff = card.debuff,
        pinned = card.pinned
    }
end

local function action_preview(kind)
    if kind ~= "play" and kind ~= "discard" then return nil end
    if not G or not G.hand or not G.hand.highlighted then return nil end

    local cards = {}
    for _, card in ipairs(G.hand.highlighted) do
        local saved = preview_card_save(card)
        if saved then cards[#cards + 1] = saved end
    end
    if #cards == 0 then return nil end

    local hand_key = nil
    local hand_name = nil
    if kind == "play" and G.FUNCS and type(G.FUNCS.get_poker_hand_info) == "function" then
        local ok, text, disp_text = pcall(function()
            return G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        end)
        if ok and text and text ~= "NULL" then
            hand_key = text
            hand_name = disp_text or text
        end
    elseif kind == "discard" then
        hand_name = loc("discard_preview")
    end

    return {
        cards = cards,
        card_count = #G.hand.highlighted,
        hand_key = hand_key,
        hand_name = hand_name
    }
end

local poker_hand_names = {
    en = {
        ["Five of a Kind"] = "Five of a Kind",
        Flush = "Flush",
        ["Flush Five"] = "Flush Five",
        ["Flush House"] = "Flush House",
        ["Four of a Kind"] = "Four of a Kind",
        ["Full House"] = "Full House",
        ["High Card"] = "High Card",
        Pair = "Pair",
        ["Royal Flush"] = "Royal Flush",
        Straight = "Straight",
        ["Straight Flush"] = "Straight Flush",
        ["Three of a Kind"] = "Three of a Kind",
        ["Two Pair"] = "Two Pair"
    },
    zh_cn = {
        ["Five of a Kind"] = "五条",
        Flush = "同花",
        ["Flush Five"] = "同花五条",
        ["Flush House"] = "同花葫芦",
        ["Four of a Kind"] = "四条",
        ["Full House"] = "葫芦",
        ["High Card"] = "高牌",
        Pair = "对子",
        ["Royal Flush"] = "皇家同花顺",
        Straight = "顺子",
        ["Straight Flush"] = "同花顺",
        ["Three of a Kind"] = "三条",
        ["Two Pair"] = "两对"
    },
    zh_tw = {
        ["Five of a Kind"] = "五條",
        Flush = "同花",
        ["Flush Five"] = "同花五條",
        ["Flush House"] = "同花葫蘆",
        ["Four of a Kind"] = "四條",
        ["Full House"] = "葫蘆",
        ["High Card"] = "高牌",
        Pair = "對子",
        ["Royal Flush"] = "皇家同花順",
        Straight = "順子",
        ["Straight Flush"] = "同花順",
        ["Three of a Kind"] = "三條",
        ["Two Pair"] = "兩對"
    }
}

local function localize_poker_hand_name(hand_key)
    if not hand_key or hand_key == "" then return nil end

    if type(localize) == "function" then
        local ok, result = pcall(localize, hand_key, "poker_hands")
        if ok and result and result ~= "ERROR" then
            return result
        end
    end

    local names = poker_hand_names[language_group()] or poker_hand_names.en
    return names[hand_key]
end

local function entry_hand_label(entry)
    if not entry or not entry.preview then return nil end
    if entry.kind == "discard" then return loc("discard_preview") end

    local preview = entry.preview
    if preview.hand_key then
        return localize_poker_hand_name(preview.hand_key) or tostring(preview.hand_key)
    end
    if preview.hand_name then
        return localize_poker_hand_name(preview.hand_name) or tostring(preview.hand_name)
    end
    return nil
end

local rank_short = {
    Ace = "A",
    King = "K",
    Queen = "Q",
    Jack = "J",
    Ten = "10",
    ["10"] = "10",
    ["9"] = "9",
    ["8"] = "8",
    ["7"] = "7",
    ["6"] = "6",
    ["5"] = "5",
    ["4"] = "4",
    ["3"] = "3",
    ["2"] = "2"
}

local suit_short = {
    en = {
        Spades = "S",
        Hearts = "H",
        Clubs = "C",
        Diamonds = "D",
        spades = "S",
        hearts = "H",
        clubs = "C",
        diamonds = "D"
    },
    zh_cn = {
        Spades = "黑",
        Hearts = "红",
        Clubs = "梅",
        Diamonds = "方",
        spades = "黑",
        hearts = "红",
        clubs = "梅",
        diamonds = "方"
    },
    zh_tw = {
        Spades = "黑",
        Hearts = "紅",
        Clubs = "梅",
        Diamonds = "方",
        spades = "黑",
        hearts = "紅",
        clubs = "梅",
        diamonds = "方"
    }
}

local suit_symbol = {
    Spades = "♠",
    Hearts = "♥",
    Clubs = "♣",
    Diamonds = "♦",
    spades = "♠",
    hearts = "♥",
    clubs = "♣",
    diamonds = "♦"
}

local card_key_suit_symbol = {
    S = "♠",
    H = "♥",
    C = "♣",
    D = "♦"
}

local card_key_suit_short = {
    en = {
        S = "S",
        H = "H",
        C = "C",
        D = "D"
    },
    zh_cn = {
        S = "黑",
        H = "红",
        C = "梅",
        D = "方"
    },
    zh_tw = {
        S = "黑",
        H = "紅",
        C = "梅",
        D = "方"
    }
}

local card_key_rank_short = {
    A = "A",
    K = "K",
    Q = "Q",
    J = "J",
    T = "10"
}

local enhancement_icon = {
    m_bonus = "+",
    m_mult = "×",
    m_wild = "✦",
    m_glass = "◇",
    m_steel = "▣",
    m_stone = "◆",
    m_gold = "$",
    m_lucky = "★"
}

local edition_icon = {
    foil = "▤",
    holo = "◈",
    polychrome = "✦",
    negative = "−"
}

local seal_icon = {
    Gold = "●",
    Red = "●",
    Blue = "●",
    Purple = "●"
}

local enhancement_short = {
    en = {
        m_bonus = "Bonus",
        m_mult = "Mult",
        m_wild = "Wild",
        m_glass = "Glass",
        m_steel = "Steel",
        m_stone = "Stone",
        m_gold = "Gold",
        m_lucky = "Lucky"
    },
    zh_cn = {
        m_bonus = "+筹",
        m_mult = "+倍",
        m_wild = "万能",
        m_glass = "玻璃",
        m_steel = "钢铁",
        m_stone = "石头",
        m_gold = "黄金",
        m_lucky = "幸运"
    },
    zh_tw = {
        m_bonus = "+籌",
        m_mult = "+倍",
        m_wild = "萬用",
        m_glass = "玻璃",
        m_steel = "鋼鐵",
        m_stone = "石頭",
        m_gold = "黃金",
        m_lucky = "幸運"
    }
}

local edition_short = {
    en = {
        foil = "Foil",
        holo = "Holo",
        polychrome = "Poly",
        negative = "Neg"
    },
    zh_cn = {
        foil = "闪箔",
        holo = "镭射",
        polychrome = "多彩",
        negative = "负片"
    },
    zh_tw = {
        foil = "閃箔",
        holo = "全像",
        polychrome = "多彩",
        negative = "負片"
    }
}

local seal_short = {
    en = {
        Gold = "Gold Seal",
        Red = "Red Seal",
        Blue = "Blue Seal",
        Purple = "Purple Seal"
    },
    zh_cn = {
        Gold = "金封",
        Red = "红封",
        Blue = "蓝封",
        Purple = "紫封"
    },
    zh_tw = {
        Gold = "金封",
        Red = "紅封",
        Blue = "藍封",
        Purple = "紫封"
    }
}

local function short_from_center_key(center_key)
    if not center_key or center_key == "c_base" then return nil end

    local lang = language_group()
    local known = (enhancement_short[lang] or enhancement_short.en)[center_key]
    if known then return known end

    local center = G and G.P_CENTERS and G.P_CENTERS[center_key] or nil
    local name = center and (center.name or (center.loc_txt and center.loc_txt.name)) or nil
    if type(name) == "string" and name ~= "" then return name end

    return tostring(center_key):gsub("^m_", "")
end

local function short_from_edition(edition)
    if type(edition) ~= "table" then return nil end
    local lang = language_group()
    local labels = edition_short[lang] or edition_short.en

    if edition.foil then return labels.foil end
    if edition.holo then return labels.holo end
    if edition.polychrome then return labels.polychrome end
    if edition.negative then return labels.negative end
    if edition.type and labels[edition.type] then return labels[edition.type] end
    if edition.key and labels[edition.key] then return labels[edition.key] end

    return edition.type or edition.key
end

local function short_from_seal(seal)
    if not seal then return nil end
    local lang = language_group()
    local labels = seal_short[lang] or seal_short.en
    local key = tostring(seal):gsub("_seal$", "")
    key = key:sub(1, 1):upper() .. key:sub(2):lower()
    return labels[key] or tostring(seal)
end

local function short_from_suit(suit)
    local lang = language_group()
    local labels = suit_short[lang] or suit_short.en
    return labels[suit] or tostring(suit or "")
end

local function short_from_card_key_suit(suit_key)
    local lang = language_group()
    local labels = card_key_suit_short[lang] or card_key_suit_short.en
    return labels[suit_key] or ""
end

local function symbol_from_suit(suit)
    return suit_symbol[suit] or short_from_suit(suit)
end

local function symbol_from_card_key_suit(suit_key)
    return card_key_suit_symbol[suit_key] or short_from_card_key_suit(suit_key)
end

local function rank_suit_from_card_key(card_key)
    if type(card_key) ~= "string" then return nil end

    local suit_key, rank_key = card_key:match("^([SHCD])_(.+)$")
    if not suit_key or not rank_key then return nil end

    local rank = card_key_rank_short[rank_key] or rank_key
    return rank .. short_from_card_key_suit(suit_key)
end

local function rank_suit_parts_from_card_key(card_key)
    if type(card_key) ~= "string" then return nil, nil, nil end

    local suit_key, rank_key = card_key:match("^([SHCD])_(.+)$")
    if not suit_key or not rank_key then return nil, nil, nil end

    return card_key_rank_short[rank_key] or rank_key, symbol_from_card_key_suit(suit_key), suit_key
end

local function card_summary_text(card_save)
    if type(card_save) ~= "table" then return loc("unknown_card") end
    if card_save.facing == "back" or card_save.sprite_facing == "back" then
        return loc("hidden_card")
    end

    local tags = {}
    local center_label = short_from_center_key(card_save.center_key)
    if center_label then tags[#tags + 1] = center_label end

    local edition_label = short_from_edition(card_save.edition)
    if edition_label then tags[#tags + 1] = edition_label end

    local seal_label = short_from_seal(card_save.seal)
    if seal_label then tags[#tags + 1] = seal_label end

    local base_text = nil
    if card_save.center_key == "m_stone" then
        base_text = center_label or loc("unknown_card")
        tags = {}
        if edition_label then tags[#tags + 1] = edition_label end
        if seal_label then tags[#tags + 1] = seal_label end
    elseif card_save.base then
        local value = tostring(card_save.base.value or "")
        local rank = rank_short[value] or value
        local suit = short_from_suit(card_save.base.suit)
        if rank ~= "" or suit ~= "" then
            base_text = rank .. suit
        end
    end

    if not base_text or base_text == "" then
        base_text = rank_suit_from_card_key(card_save.card_key) or loc("unknown_card")
    end

    if #tags > 0 then
        return base_text .. "[" .. table.concat(tags, "/") .. "]"
    end
    return base_text
end

local function approximate_text_width(text)
    local width = 0
    local i = 1
    while i <= #text do
        local byte = text:byte(i)
        if byte and byte >= 240 then
            width = width + 2
            i = i + 4
        elseif byte and byte >= 224 then
            width = width + 2
            i = i + 3
        elseif byte and byte >= 192 then
            width = width + 2
            i = i + 2
        else
            width = width + 1
            i = i + 1
        end
    end
    return width
end

local function card_summary_lines(preview)
    if not preview or type(preview.cards) ~= "table" or #preview.cards == 0 then return nil end

    local tokens = {}
    for _, card_save in ipairs(preview.cards) do
        tokens[#tokens + 1] = card_summary_text(card_save)
    end
    if #tokens == 0 then return nil end

    local max_width = is_chinese_language() and 24 or 31
    local prefix = loc("cards_prefix")
    local lines = {}
    local current = prefix
    local current_width = approximate_text_width(current)

    for _, token in ipairs(tokens) do
        local separator = current == prefix and " " or "  "
        local next_width = current_width + approximate_text_width(separator .. token)
        if current ~= prefix and next_width > max_width then
            lines[#lines + 1] = current
            current = "  " .. token
            current_width = approximate_text_width(current)
        else
            current = current .. separator .. token
            current_width = next_width
        end
    end

    lines[#lines + 1] = current
    return lines
end

local enhancement_badge = {
    en = {
        m_bonus = "+C",
        m_mult = "+M",
        m_wild = "Wild",
        m_glass = "Glass",
        m_steel = "Steel",
        m_stone = "Stone",
        m_gold = "Gold",
        m_lucky = "Luck"
    },
    zh_cn = {
        m_bonus = "+筹",
        m_mult = "+倍",
        m_wild = "万能",
        m_glass = "玻璃",
        m_steel = "钢铁",
        m_stone = "石头",
        m_gold = "黄金",
        m_lucky = "幸运"
    },
    zh_tw = {
        m_bonus = "+籌",
        m_mult = "+倍",
        m_wild = "萬用",
        m_glass = "玻璃",
        m_steel = "鋼鐵",
        m_stone = "石頭",
        m_gold = "黃金",
        m_lucky = "幸運"
    }
}

local edition_badge = {
    en = {
        foil = "Foil",
        holo = "Holo",
        polychrome = "Poly",
        negative = "Neg"
    },
    zh_cn = {
        foil = "闪",
        holo = "镭",
        polychrome = "彩",
        negative = "负"
    },
    zh_tw = {
        foil = "閃",
        holo = "像",
        polychrome = "彩",
        negative = "負"
    }
}

local seal_badge = {
    en = {
        Gold = "G",
        Red = "R",
        Blue = "B",
        Purple = "P"
    },
    zh_cn = {
        Gold = "金",
        Red = "红",
        Blue = "蓝",
        Purple = "紫"
    },
    zh_tw = {
        Gold = "金",
        Red = "紅",
        Blue = "藍",
        Purple = "紫"
    }
}

local function fallback_colour(colour, fallback)
    return colour or fallback or G.C.WHITE
end

local function suit_colour(suit)
    local red = fallback_colour(G.C.RED, G.C.MULT)
    local black = fallback_colour(G.C.BLACK, G.C.UI and G.C.UI.TEXT_DARK)
    if suit == "Hearts" or suit == "Diamonds" or suit == "hearts" or suit == "diamonds" then
        return red
    end
    return black
end

local function tag_colour(center_key)
    if center_key == "m_gold" or center_key == "m_lucky" then return fallback_colour(G.C.MONEY, G.C.GOLD) end
    if center_key == "m_steel" then return fallback_colour(G.C.CHIPS, G.C.BLUE) end
    if center_key == "m_glass" or center_key == "m_mult" then return fallback_colour(G.C.MULT, G.C.RED) end
    if center_key == "m_wild" then return fallback_colour(G.C.PURPLE, G.C.ORANGE) end
    if center_key == "m_stone" then return fallback_colour(G.C.UI and G.C.UI.BACKGROUND_INACTIVE, G.C.BLACK) end
    if center_key == "m_bonus" then return fallback_colour(G.C.CHIPS, G.C.BLUE) end
    return fallback_colour(G.C.ORANGE, G.C.BLUE)
end

local function seal_colour(seal)
    local key = seal and tostring(seal):gsub("_seal$", "") or nil
    key = key and (key:sub(1, 1):upper() .. key:sub(2):lower()) or nil
    if key == "Gold" then return fallback_colour(G.C.MONEY, G.C.GOLD) end
    if key == "Red" then return fallback_colour(G.C.RED, G.C.MULT) end
    if key == "Blue" then return fallback_colour(G.C.BLUE, G.C.CHIPS) end
    if key == "Purple" then return fallback_colour(G.C.PURPLE, G.C.ORANGE) end
    return fallback_colour(G.C.UI and G.C.UI.BACKGROUND_INACTIVE, G.C.BLACK)
end

local function edition_colour(edition)
    if type(edition) ~= "table" then return fallback_colour(G.C.DARK_EDITION, G.C.ORANGE) end
    if edition.negative then return fallback_colour(G.C.DARK_EDITION, G.C.BLACK) end
    if edition.polychrome then return fallback_colour(G.C.PURPLE, G.C.ORANGE) end
    if edition.holo then return fallback_colour(G.C.RED, G.C.ORANGE) end
    if edition.foil then return fallback_colour(G.C.CHIPS, G.C.BLUE) end
    return fallback_colour(G.C.DARK_EDITION, G.C.ORANGE)
end

local function edition_icon_from_edition(edition)
    if type(edition) ~= "table" then return nil end
    if edition.foil then return edition_icon.foil end
    if edition.holo then return edition_icon.holo end
    if edition.polychrome then return edition_icon.polychrome end
    if edition.negative then return edition_icon.negative end
    if edition.type and edition_icon[edition.type] then return edition_icon[edition.type] end
    if edition.key and edition_icon[edition.key] then return edition_icon[edition.key] end
    return nil
end

local function seal_key(seal)
    if not seal then return nil end
    local key = tostring(seal):gsub("_seal$", "")
    return key:sub(1, 1):upper() .. key:sub(2):lower()
end

local function suit_colour_from_card_key_suit(suit_key)
    if suit_key == "H" or suit_key == "D" then
        return fallback_colour(G.C.RED, G.C.MULT)
    end
    return fallback_colour(G.C.BLACK, G.C.UI and G.C.UI.TEXT_DARK)
end

local function history_page_count()
    return math.max(1, math.ceil(#(StepBack.history or {}) / HISTORY_PAGE_SIZE))
end

local function clamp_history_page()
    local pages = history_page_count()
    if not StepBack.history_page then StepBack.history_page = pages end
    if StepBack.history_page < 1 then StepBack.history_page = 1 end
    if StepBack.history_page > pages then StepBack.history_page = pages end
    return pages
end

local function page_for_history_index(index)
    return math.max(1, math.ceil((index or 1) / HISTORY_PAGE_SIZE))
end

local function reopen_history_overlay()
    if G and G.FUNCS and G.FUNCS.overlay_menu then
        G.FUNCS.overlay_menu({ definition = create_UIBox_stepback_history() })
    end
end

local function badge_from_center_key(center_key)
    if not center_key or center_key == "c_base" then return nil end
    local lang = language_group()
    local known = (enhancement_badge[lang] or enhancement_badge.en)[center_key]
    if known then return known end
    local label = short_from_center_key(center_key)
    if not label then return nil end
    if is_chinese_language() then return label:sub(1, 6) end
    return label:sub(1, 5)
end

local function badge_from_edition(edition)
    if type(edition) ~= "table" then return nil end
    local lang = language_group()
    local labels = edition_badge[lang] or edition_badge.en
    if edition.foil then return labels.foil end
    if edition.holo then return labels.holo end
    if edition.polychrome then return labels.polychrome end
    if edition.negative then return labels.negative end
    if edition.type and labels[edition.type] then return labels[edition.type] end
    if edition.key and labels[edition.key] then return labels[edition.key] end
    return nil
end

local function badge_from_seal(seal)
    if not seal then return nil end
    local lang = language_group()
    local labels = seal_badge[lang] or seal_badge.en
    local key = tostring(seal):gsub("_seal$", "")
    key = key:sub(1, 1):upper() .. key:sub(2):lower()
    return labels[key]
end

local function preview_card_visual_data(card_save)
    local hidden = type(card_save) ~= "table"
        or card_save.facing == "back"
        or card_save.sprite_facing == "back"

    if hidden then
        return {
            rank = "?",
            suit = "?",
            suit_colour = fallback_colour(G.C.UI and G.C.UI.TEXT_INACTIVE, G.C.UI and G.C.UI.TEXT_LIGHT),
            card_colour = fallback_colour(G.C.UI and G.C.UI.BACKGROUND_INACTIVE, G.C.BLACK),
            icons = {
                {
                    text = "?",
                    colour = fallback_colour(G.C.UI and G.C.UI.TEXT_INACTIVE, G.C.UI and G.C.UI.BACKGROUND_INACTIVE)
                }
            }
        }
    end

    local rank = loc("unknown_card")
    local suit = ""
    local suit_col = fallback_colour(G.C.BLACK, G.C.UI and G.C.UI.TEXT_DARK)

    if card_save.center_key == "m_stone" then
        rank = is_chinese_language() and "石" or "St"
        suit = "◆"
        suit_col = fallback_colour(G.C.UI and G.C.UI.TEXT_DARK, G.C.BLACK)
    elseif card_save.base then
        local value = tostring(card_save.base.value or "")
        rank = rank_short[value] or value
        suit = symbol_from_suit(card_save.base.suit)
        suit_col = suit_colour(card_save.base.suit)
    else
        local from_key_rank, from_key_suit, suit_key = rank_suit_parts_from_card_key(card_save.card_key)
        if from_key_rank then
            rank = from_key_rank
            suit = from_key_suit or ""
            suit_col = suit_colour_from_card_key_suit(suit_key)
        end
    end

    local icons = {}
    if card_save.center_key and card_save.center_key ~= "c_base" then
        icons[#icons + 1] = {
            text = enhancement_icon[card_save.center_key] or "*",
            colour = tag_colour(card_save.center_key)
        }
    end

    local edition_label = edition_icon_from_edition(card_save.edition)
    if edition_label then
        icons[#icons + 1] = {
            text = edition_label,
            colour = edition_colour(card_save.edition)
        }
    end

    local seal_label = seal_icon[seal_key(card_save.seal) or ""]
    if seal_label then
        icons[#icons + 1] = {
            text = seal_label,
            colour = seal_colour(card_save.seal)
        }
    end

    return {
        rank = rank ~= "" and rank or loc("unknown_card"),
        suit = suit,
        suit_colour = suit_col,
        card_colour = fallback_colour(G.C.WHITE, G.C.UI and G.C.UI.TEXT_LIGHT),
        icons = icons
    }
end

local function create_preview_card_tile(card_save)
    local visual = preview_card_visual_data(card_save)
    local dark_text = fallback_colour(G.C.UI and G.C.UI.TEXT_DARK, G.C.BLACK)
    local light_text = fallback_colour(G.C.UI and G.C.UI.TEXT_LIGHT, G.C.WHITE)
    local rank_scale = is_chinese_language() and 0.4 or 0.42
    local suit_scale = 0.22
    local icon_scale = 0.11

    local icon_nodes = {}
    for _, icon in ipairs(visual.icons or {}) do
        icon_nodes[#icon_nodes + 1] = { n = G.UIT.C, config = {
            align = "cm",
            minw = 0.16,
            minh = 0.16,
            padding = 0.001,
            r = 0.03,
            colour = icon.colour or fallback_colour(G.C.ORANGE, G.C.BLUE),
            outline = 0.25,
            outline_colour = fallback_colour(G.C.WHITE, G.C.UI and G.C.UI.TEXT_LIGHT)
        }, nodes = {
            { n = G.UIT.T, config = { text = icon.text or "", scale = icon_scale, colour = light_text, shadow = false } }
        }}
    end
    if #icon_nodes == 0 then
        icon_nodes[#icon_nodes + 1] = { n = G.UIT.C, config = { align = "cm", minw = 0.16, minh = 0.16, colour = visual.card_colour }, nodes = {} }
    end

    return { n = G.UIT.C, config = { align = "cm", padding = 0.018 }, nodes = {
        { n = G.UIT.C, config = {
            align = "cm",
            padding = 0.02,
            r = 0.06,
            colour = visual.card_colour,
            emboss = 0.04,
            outline = 0.6,
            outline_colour = fallback_colour(G.C.JOKER_GREY, G.C.GREY),
            minw = 0.78,
            minh = 1.08
        }, nodes = {
            { n = G.UIT.R, config = { align = "cl", padding = 0, minw = 0.72, minh = 0.2 }, nodes = {
                { n = G.UIT.C, config = { align = "cm", minw = 0.2 }, nodes = {
                    { n = G.UIT.T, config = { text = visual.suit or "", scale = suit_scale, colour = visual.suit_colour or dark_text, shadow = false } }
                }},
                { n = G.UIT.C, config = { align = "cm", minw = 0.48 }, nodes = {} }
            }},
            { n = G.UIT.R, config = { align = "cm", padding = 0.002, minw = 0.72, minh = 0.52 }, nodes = {
                { n = G.UIT.T, config = { text = visual.rank, scale = rank_scale, colour = visual.suit_colour or dark_text, shadow = false } }
            }},
            { n = G.UIT.R, config = { align = "cm", padding = 0.002, minw = 0.72, minh = 0.2 }, nodes = icon_nodes }
        }}
    }}
end

local function front_from_preview_card_save(card_save)
    if not card_save or not G or not G.P_CARDS then return nil end
    if card_save.card_key and G.P_CARDS[card_save.card_key] then
        return G.P_CARDS[card_save.card_key]
    end
    if card_save.card_state and card_save.card_state.save_fields and card_save.card_state.save_fields.card then
        local key = card_save.card_state.save_fields.card
        if G.P_CARDS[key] then return G.P_CARDS[key] end
    end
    if card_save.base then
        for _, value in pairs(G.P_CARDS) do
            if value and value.suit == card_save.base.suit and value.value == card_save.base.value then
                return value
            end
        end
    end
    return G.P_CARDS.empty
end

local function center_from_preview_card_save(card_save)
    if not card_save or not G or not G.P_CENTERS then return nil end
    local key = card_save.center_key
    if (not key or not G.P_CENTERS[key]) and card_save.card_state and card_save.card_state.save_fields then
        key = card_save.card_state.save_fields.center
    end
    return (key and G.P_CENTERS[key]) or G.P_CENTERS.c_base
end

local function create_real_preview_card(card_save, scale)
    if not USE_REAL_CARD_PREVIEW or type(card_save) ~= "table" then return nil end
    if not G or not G.P_CARDS or not G.P_CENTERS or not Card then return nil end

    local front = front_from_preview_card_save(card_save)
    local center = center_from_preview_card_save(card_save)
    if not center then return nil end

    local params = {}
    if card_save.card_state and type(card_save.card_state.params) == "table" then
        params = copy_table(card_save.card_state.params)
    end
    params.bypass_discovery_center = true
    params.bypass_discovery_ui = true
    params.bypass_lock = true
    if params.playing_card == nil then
        params.playing_card = card_save.playing_card
        if params.playing_card == nil then params.playing_card = true end
    end

    local card = Card(0, 0, G.CARD_W * scale, G.CARD_H * scale, front, center, params)
    if not card then return nil end

    if card_save.ability then card.ability = copy_table(card_save.ability) end
    if card_save.base then card.base = copy_table(card_save.base) end
    if card_save.edition then card.edition = copy_table(card_save.edition) end
    card.seal = card_save.seal
    card.debuff = card_save.debuff
    card.pinned = card_save.pinned
    card.facing = card_save.facing or (card_save.card_state and card_save.card_state.facing) or card.facing
    card.sprite_facing = card_save.sprite_facing or (card_save.card_state and card_save.card_state.sprite_facing) or card.sprite_facing
    card.states.hover.can = false
    card.states.drag.can = false
    card.states.click.can = false
    card.states.collide.can = false
    return card
end

local function create_real_preview_card_rows(preview)
    if not USE_REAL_CARD_PREVIEW then return nil end
    if not preview or type(preview.cards) ~= "table" or #preview.cards == 0 then return nil end
    if not CardArea or not Card then return nil end

    local scale = REAL_CARD_PREVIEW_SCALE
    local outer_rows = {}
    local row_cards = {}

    local function flush_row()
        if #row_cards == 0 then return end
        local preview_cards = {}
        for _, card_save in ipairs(row_cards) do
            local card = create_real_preview_card(card_save, scale)
            if not card then
                for _, created in ipairs(preview_cards) do
                    created:remove()
                end
                return nil
            end
            preview_cards[#preview_cards + 1] = card
        end

        local area_width = math.max(1.1, math.min(5.85, 0.45 + #row_cards * G.CARD_W * scale * 1.55))
        local area_height = G.CARD_H * scale * 1.18
        local area = CardArea(
            0, 0,
            area_width,
            area_height,
            { card_limit = #row_cards, type = "title_2", view_deck = true, highlight_limit = 0, card_w = G.CARD_W * scale, draw_layers = { "card" } }
        )

        for _, card in ipairs(preview_cards) do
            card.T.x = area.T.x + area.T.w / 2
            card.T.y = area.T.y
            area:emplace(card, nil, card.facing == "back")
        end

        outer_rows[#outer_rows + 1] = { n = G.UIT.R, config = { align = "cm", padding = 0.015 }, nodes = {
            { n = G.UIT.O, config = { object = area, can_collide = false } }
        }}
        row_cards = {}
        return true
    end

    for i, card_save in ipairs(preview.cards) do
        row_cards[#row_cards + 1] = card_save
        if #row_cards == 5 or i == #preview.cards then
            if not flush_row() then return nil end
        end
    end

    if #outer_rows == 0 then return nil end
    return { n = G.UIT.R, config = {
        align = "cm",
        padding = 0.04,
        r = 0.08,
        colour = G.C.UI.TRANSPARENT_DARK,
        minw = 5.85,
        minh = math.max(0.9, (G.CARD_H * scale * 1.25) * #outer_rows)
    }, nodes = {
        { n = G.UIT.C, config = { align = "cm", padding = 0.02 }, nodes = outer_rows }
    }}
end

local function create_badge_preview_card_rows(preview)
    if not preview or type(preview.cards) ~= "table" or #preview.cards == 0 then return nil end

    local outer_rows = {}
    local row_nodes = {}
    for i, card_save in ipairs(preview.cards) do
        row_nodes[#row_nodes + 1] = create_preview_card_tile(card_save)
        if #row_nodes == 5 or i == #preview.cards then
            outer_rows[#outer_rows + 1] = { n = G.UIT.R, config = { align = "cm", padding = 0.01 }, nodes = row_nodes }
            row_nodes = {}
        end
    end

    return { n = G.UIT.R, config = {
        align = "cm",
        padding = 0.035,
        r = 0.08,
        colour = G.C.UI.TRANSPARENT_DARK,
        minw = 5.85,
        minh = math.max(1.16, 1.16 * #outer_rows)
    }, nodes = {
        { n = G.UIT.C, config = { align = "cm", padding = 0.02 }, nodes = outer_rows }
    }}
end

local function create_preview_card_rows(preview)
    return create_real_preview_card_rows(preview) or create_badge_preview_card_rows(preview)
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
        preview = action_preview(kind),
        save = save_table
    }

    while #StepBack.history > StepBack.max_history do
        table.remove(StepBack.history, 1)
    end
    StepBack.expanded_index = nil
    StepBack.history_page = history_page_count()
    refresh_ui()
    write_persisted_history()
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
    StepBack.expanded_index = nil
    StepBack.history_page = history_page_count()
    refresh_ui()
    write_persisted_history()

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

local function create_history_entry_row(index, entry, restore_func_name, detail_func_name)
    local preview = entry and entry.preview or nil
    local expanded = StepBack.expanded_index == index
    local preview_rows = expanded and create_preview_card_rows(preview) or nil
    local has_card_preview = preview and type(preview.cards) == "table" and #preview.cards > 0
    local row_colour = index == #StepBack.history and G.C.GREEN or G.C.BLUE
    local detail_colour = expanded and G.C.ORANGE or row_colour
    local label_scale = is_chinese_language() and 0.29 or 0.25
    local hand_scale = is_chinese_language() and 0.28 or 0.24
    local details_scale = is_chinese_language() and 0.25 or 0.21
    local restore_scale = is_chinese_language() and 0.28 or 0.25
    local marker = has_card_preview and (expanded and "- " or "+ ") or ""
    local hand_label = entry_hand_label(entry)

    local content = {
        { n = G.UIT.C, config = { align = "cl", minw = 4.25, maxw = 4.25 }, nodes = {
            { n = G.UIT.T, config = { text = marker .. entry_restore_label(entry), scale = label_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true } }
        }}
    }

    if hand_label then
        content[#content + 1] = { n = G.UIT.C, config = { align = "cm", minw = 1.05, maxw = 1.05, padding = 0.02 }, nodes = {
            { n = G.UIT.T, config = { text = hand_label, scale = hand_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true } }
        }}
    else
        content[#content + 1] = { n = G.UIT.C, config = { align = "cm", minw = 1.05, maxw = 1.05, padding = 0.02 }, nodes = {} }
    end

    if has_card_preview then
        content[#content + 1] = { n = G.UIT.C, config = { align = "cr", minw = 0.72, maxw = 0.72, padding = 0.02 }, nodes = {
            { n = G.UIT.T, config = { text = expanded and loc("hide_details") or loc("details"), scale = details_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true } }
        }}
    else
        content[#content + 1] = { n = G.UIT.C, config = { align = "cm", minw = 0.72, maxw = 0.72, padding = 0.02 }, nodes = {} }
    end

    local stack_nodes = {
        { n = G.UIT.R, config = { align = "cm", padding = 0.01 }, nodes = {
            { n = G.UIT.C, config = {
                id = detail_func_name,
                align = "cm",
                padding = 0.055,
                r = 0.1,
                hover = has_card_preview,
                colour = has_card_preview and detail_colour or row_colour,
                button = has_card_preview and detail_func_name or nil,
                shadow = true,
                minw = 6.35,
                minh = 0.64
            }, nodes = content },
            { n = G.UIT.C, config = {
                id = restore_func_name,
                align = "cm",
                padding = 0.055,
                r = 0.1,
                hover = true,
                colour = row_colour,
                button = restore_func_name,
                shadow = true,
                minw = 1.05,
                minh = 0.64
            }, nodes = {
                { n = G.UIT.T, config = { text = loc("restore_here"), scale = restore_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true } }
            }}
        }}
    }

    if has_card_preview then
        stack_nodes[#stack_nodes + 1] = preview_rows
    end

    return { n = G.UIT.R, config = { align = "cm", padding = 0.035 }, nodes = {
        { n = G.UIT.C, config = { align = "cm", padding = 0 }, nodes = stack_nodes }
    }}
end

G.FUNCS.stepback_history_prev_page = function()
    ensure_current_blind_history()
    StepBack.history_page = (StepBack.history_page or history_page_count()) - 1
    StepBack.expanded_index = nil
    clamp_history_page()
    reopen_history_overlay()
end

G.FUNCS.stepback_history_next_page = function()
    ensure_current_blind_history()
    StepBack.history_page = (StepBack.history_page or history_page_count()) + 1
    StepBack.expanded_index = nil
    clamp_history_page()
    reopen_history_overlay()
end

local function create_page_button(label, func_name, enabled)
    return { n = G.UIT.C, config = {
        align = "cm",
        padding = 0.05,
        r = 0.08,
        hover = enabled,
        colour = enabled and G.C.BLUE or G.C.UI.BACKGROUND_INACTIVE,
        button = enabled and func_name or nil,
        shadow = enabled,
        minw = 1.45,
        minh = 0.5
    }, nodes = {
        { n = G.UIT.T, config = { text = label, scale = is_chinese_language() and 0.26 or 0.23, colour = G.C.UI.TEXT_LIGHT, shadow = enabled } }
    }}
end

function create_UIBox_stepback_history()
    ensure_current_blind_history()
    local pages = clamp_history_page()
    local page = StepBack.history_page or pages

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
        local start_index = ((page - 1) * HISTORY_PAGE_SIZE) + 1
        local end_index = math.min(#StepBack.history, start_index + HISTORY_PAGE_SIZE - 1)

        for i = start_index, end_index do
            local entry = StepBack.history[i]
            local restore_func_name = "stepback_restore_" .. tostring(i)
            local detail_func_name = "stepback_detail_" .. tostring(i)
            local restore_index = i
            G.FUNCS[restore_func_name] = function()
                restore_snapshot(restore_index)
            end

            G.FUNCS[detail_func_name] = function()
                if StepBack.expanded_index == restore_index then
                    StepBack.expanded_index = nil
                else
                    StepBack.expanded_index = restore_index
                end
                StepBack.history_page = page_for_history_index(restore_index)
                reopen_history_overlay()
            end

            rows[#rows + 1] = create_history_entry_row(i, entry, restore_func_name, detail_func_name)
        end

        if pages > 1 then
            rows[#rows + 1] = { n = G.UIT.R, config = { align = "cm", padding = 0.08 }, nodes = {
                create_page_button(loc("prev_page"), "stepback_history_prev_page", page > 1),
                { n = G.UIT.C, config = { align = "cm", minw = 1.25, padding = 0.03 }, nodes = {
                    { n = G.UIT.T, config = {
                        text = loc("page_prefix") .. tostring(page) .. loc("page_separator") .. tostring(pages) .. loc("page_suffix"),
                        scale = is_chinese_language() and 0.27 or 0.24,
                        colour = G.C.UI.TEXT_LIGHT,
                        shadow = true
                    } }
                }},
                create_page_button(loc("next_page"), "stepback_history_next_page", page < pages)
            }}
        end
    end

    return create_UIBox_generic_options({
        back_label = loc("back"),
        minw = 8.9,
        contents = rows
    })
end

G.FUNCS.stepback_open_history = function()
    if not can_undo() then return end
    StepBack.expanded_index = nil
    StepBack.history_page = history_page_count()
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

local original_start_run = G.FUNCS.start_run
G.FUNCS.start_run = function(e, args)
    local continuing_saved_run = args and args.type == "continue_game"
    if not StepBack.restoring and not continuing_saved_run then
        clear_history()
    end

    local result = original_start_run(e, args)

    if not StepBack.restoring and continuing_saved_run then
        StepBack.history = {}
        StepBack.blind_key = nil
        refresh_ui()
        if not load_persisted_history() and G.E_MANAGER then
            G.E_MANAGER:add_event(Event({
                no_delete = true,
                trigger = "after",
                delay = 0.05,
                func = function()
                    load_persisted_history()
                    return true
                end
            }))
        end
    end

    return result
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
