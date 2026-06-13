local SupernovaTracker = rawget(_G, "BalatroSupernovaTracker") or {}
_G.BalatroSupernovaTracker = SupernovaTracker

local MOD_VERSION = "1.0.2"

SupernovaTracker.version = MOD_VERSION

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

local text = {
    en = {
        title = "Current Supernova bonus",
        none = "No poker hands played yet",
        plus = "+"
    },
    zh_cn = {
        title = "当前超新星加成",
        none = "还没有打出过牌型",
        plus = "+"
    },
    zh_tw = {
        title = "目前超新星加成",
        none = "還沒有打出過牌型",
        plus = "+"
    }
}

local poker_hand_fallbacks = {
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

local poker_hand_order = {
    "Flush Five",
    "Flush House",
    "Five of a Kind",
    "Straight Flush",
    "Four of a Kind",
    "Full House",
    "Flush",
    "Straight",
    "Three of a Kind",
    "Two Pair",
    "Pair",
    "High Card"
}

local poker_hand_order_lookup = {}
for index, key in ipairs(poker_hand_order) do
    poker_hand_order_lookup[key] = index
end

local function loc(key)
    local lang = text[language_group()] or text.en
    return lang[key] or text.en[key] or key
end

local function localized_poker_hand(key)
    if type(localize) == "function" then
        local ok, result = pcall(localize, key, "poker_hands")
        if ok and type(result) == "string" and result ~= "" and result ~= "ERROR" then
            return result
        end
    end

    local group = language_group()
    local fallbacks = poker_hand_fallbacks[group] or poker_hand_fallbacks.en
    return fallbacks[key] or poker_hand_fallbacks.en[key] or tostring(key)
end

local function is_supernova(card)
    return card
        and card.config
        and card.config.center
        and card.config.center.key == "j_supernova"
end

local function first_colour(...)
    for i = 1, select("#", ...) do
        local colour = select(i, ...)
        if colour then return colour end
    end
    return { 1, 1, 1, 1 }
end

local function ui_colour(key)
    return G and G.C and G.C.UI and G.C.UI[key] or nil
end

local function tracker_gold()
    local colours = G and G.C or {}
    return first_colour(colours.GOLD, colours.MONEY, colours.ORANGE, colours.MULT, ui_colour("TEXT_LIGHT"))
end

local function hand_name_scale(name)
    if is_chinese_language() then return 0.18 end
    local length = type(name) == "string" and #name or 0
    if length >= 14 then return 0.145 end
    if length >= 11 then return 0.155 end
    return 0.17
end

local function collect_hand_rows()
    local hands = G and G.GAME and G.GAME.hands
    if type(hands) ~= "table" then return {} end

    local rows = {}
    local added = {}

    for _, key in ipairs(poker_hand_order) do
        local data = hands[key]
        rows[#rows + 1] = {
            key = key,
            name = localized_poker_hand(key),
            played = type(data) == "table" and tonumber(data.played) or 0,
            order = poker_hand_order_lookup[key] or 999
        }
        added[key] = true
    end

    local extra_rows = {}
    for key, data in pairs(hands) do
        if not added[key] and type(data) == "table" and data.visible ~= false then
            extra_rows[#extra_rows + 1] = {
                key = key,
                name = localized_poker_hand(key),
                played = tonumber(data.played) or 0,
                order = tonumber(data.order) or 999
            }
        end
    end

    table.sort(extra_rows, function(a, b)
        if a.order == b.order then return a.key < b.key end
        return a.order < b.order
    end)

    for _, row in ipairs(extra_rows) do
        rows[#rows + 1] = row
    end

    return rows
end

local function make_text(text_value, colour, scale)
    return {
        n = G.UIT.T,
        config = {
            text = text_value,
            colour = colour,
            scale = scale,
            shadow = true
        }
    }
end

local function make_hand_chip(row)
    local bg = row.played > 0 and G.C.UI.TRANSPARENT_DARK or G.C.UI.BACKGROUND_INACTIVE
    return {
        n = G.UIT.C,
        config = {
            align = "cm",
            padding = 0.035,
            r = 0.06,
            colour = bg,
            minw = 1.52,
            minh = 0.30
        },
        nodes = {
            make_text(row.name, G.C.UI.TEXT_LIGHT, hand_name_scale(row.name)),
            make_text(" " .. loc("plus") .. tostring(row.played), tracker_gold(), is_chinese_language() and 0.21 or 0.19)
        }
    }
end

local function build_hand_grid(rows)
    if #rows == 0 then
        return {
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.02 },
                nodes = { make_text(loc("none"), G.C.UI.TEXT_INACTIVE, 0.21) }
            }
        }
    end

    local grid = {}
    local index = 1
    while index <= #rows do
        local row_nodes = {}
        for _ = 1, 3 do
            if rows[index] then
                row_nodes[#row_nodes + 1] = make_hand_chip(rows[index])
            end
            index = index + 1
        end
        grid[#grid + 1] = {
            n = G.UIT.R,
            config = { align = "cm", padding = 0.025 },
            nodes = row_nodes
        }
    end

    return grid
end

local function build_tracker_block()
    local rows = collect_hand_rows()
    local nodes = {
        {
            n = G.UIT.R,
            config = { align = "cm", padding = 0.02 },
            nodes = {
                make_text(loc("title"), G.C.ORANGE, is_chinese_language() and 0.24 or 0.22)
            }
        }
    }

    local grid = build_hand_grid(rows)
    for i = 1, #grid do
        nodes[#nodes + 1] = grid[i]
    end

    return {
        n = G.UIT.R,
        config = {
            align = "cm",
            padding = 0.05,
            r = 0.08,
            colour = G.C.UI.TRANSPARENT_DARK
        },
        nodes = {
            {
                n = G.UIT.C,
                config = { align = "cm", padding = 0.035 },
                nodes = nodes
            }
        }
    }
end

local function can_show_tracker()
    return G and G.GAME and type(G.GAME.hands) == "table"
end

local function build_tracker_desc_rows()
    local rows = collect_hand_rows()
    local desc_rows = {
        {
            make_text(loc("title"), G.C.ORANGE, is_chinese_language() and 0.24 or 0.22)
        }
    }

    if #rows == 0 then
        desc_rows[#desc_rows + 1] = {
            make_text(loc("none"), G.C.UI.TEXT_INACTIVE, 0.21)
        }
        return desc_rows
    end

    local index = 1
    while index <= #rows do
        local row_nodes = {}
        for _ = 1, 3 do
            if rows[index] then
                row_nodes[#row_nodes + 1] = make_hand_chip(rows[index])
            end
            index = index + 1
        end
        desc_rows[#desc_rows + 1] = row_nodes
    end

    return desc_rows
end

local function append_tracker(ui)
    if type(ui) ~= "table" or type(ui.main) ~= "table" or not can_show_tracker() then return ui end

    for _, row in ipairs(build_tracker_desc_rows()) do
        if type(row) == "table" and row.n == nil then
            ui.main[#ui.main + 1] = row
        end
    end
    return ui
end

if Card and Card.generate_UIBox_ability_table and not SupernovaTracker.hooked then
    SupernovaTracker.original_generate_UIBox_ability_table = Card.generate_UIBox_ability_table

    function Card:generate_UIBox_ability_table()
        local ui = SupernovaTracker.original_generate_UIBox_ability_table(self)
        if is_supernova(self) then
            return append_tracker(ui)
        end
        return ui
    end

    SupernovaTracker.hooked = true
end
