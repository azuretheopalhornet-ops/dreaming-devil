--#region Global Variables and States

G.active_shop_tab = G.active_shop_tab or "standard"

--#endregion

--#region Atlases

SMODS.Atlas {
    key = 'placeholders',
    path = 'placeholders.png',
    px = 71,
    py = 95
}

--#endregion

--#region Custom Types

local mint_green = {0.45, 0.88, 0.68, 1.0}

SMODS.ConsumableType {
    key = 'Item',
    primary_colour = mint_green,
    secondary_colour = {1.0, 1.0, 1.0, 1.0},
    shop_rate = 0.0, -- Set to 0.0 so they only spawn in your Mall tab!
    loc_txt = {
        name = "Item",
        collection = "Item Cards",
        undiscovered = {
            name = "Undiscovered Item",
            text = { "Buy an item at the mall", "to discover this item!" }
        }
    }
}

--#endregion

--#region File Loading

local jokers_src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path .. "src/jokers")
for _, file in ipairs(jokers_src) do
    assert(SMODS.load_file("src/jokers/" .. file))()
end

local consumables_src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path .. "src/consumables")
for _, file in ipairs(consumables_src) do
    assert(SMODS.load_file("src/consumables/" .. file))()
end

local boosters_src = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path .. "src/boosters")
for _, file in ipairs(boosters_src) do
    assert(SMODS.load_file("src/boosters/" .. file))()
end

--#endregion

--#region Fusion Handlers

G.FUNCS.kyubey_fuse_jokers = function(e)
    if not G.jokers or not G.jokers.cards then return end
    local card_kin, card_gin
    for _, c in ipairs(G.jokers.cards) do
        if c.config.center.key == 'j_kyubey_kin' and not card_kin then card_kin = c end
        if c.config.center.key == 'j_kyubey_gin' and not card_gin then card_gin = c end
    end
    if card_kin and card_gin then
        card_kin:juice_up(0.5, 0.5)
        card_gin:juice_up(0.5, 0.5)
        G.jokers:remove_card(card_kin)
        card_kin:remove()
        G.jokers:remove_card(card_gin)
        card_gin:remove()
        local fused_card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_kyubey_twisted_sisters', nil)
        fused_card:add_to_deck()
        G.jokers:emplace(fused_card)
        fused_card:juice_up(0.8, 0.8)
        if G.el and G.el.context_menu then 
            G.el.context_menu:remove()
            G.el.context_menu = nil
        end
    end
end

--#endregion

-- ====================================================================
-- MALL INTERFACE & TAB SWITCHING LOGIC
-- ====================================================================

local old_enter_shop = G.FUNCS.enter_shop
G.FUNCS.enter_shop = function(e)
    old_enter_shop(e)
    
    G.shop_mall_items = CardArea(
        G.ROOM.T.x + 0.2, G.ROOM.T.y + 2, 
        3 * 1.15, 1.45, 
        {card_limit = 3, type = 'shop', highlight_limit = 1}
    )
    fill_mall_shop()
end

function fill_mall_shop()
    if not G.shop_mall_items then return end
    while #G.shop_mall_items.cards < G.shop_mall_items.config.card_limit do
        local card = create_card('Item', G.shop_mall_items, nil, nil, nil, nil, 'c_kyubey_three_d_glasses', 'mall_shop')
        card:start_materialize()
        card.cost = 4
        card.price = 4
        G.shop_mall_items:emplace(card)
    end
end

G.FUNCS.set_shop_tab_standard = function(e)
    G.active_shop_tab = "standard"
    if G.shop then G.shop:create_UIBox() end
end

G.FUNCS.set_shop_tab_mall = function(e)
    G.active_shop_tab = "mall"
    if G.shop then G.shop:create_UIBox() end
end

G.FUNCS.reroll_mall_shop = function(e)
    local reroll_cost = G.GAME.round_resets.reroll_cost
    if G.GAME.dollars >= reroll_cost then
        ease_dollars(-reroll_cost)
        G.GAME.round_resets.reroll_cost = reroll_cost + 1
        
        if G.shop_mall_items and G.shop_mall_items.cards then
            for i = #G.shop_mall_items.cards, 1, -1 do
                G.shop_mall_items.cards[i]:remove()
            end
        end
        
        fill_mall_shop()
        if G.shop then G.shop:create_UIBox() end
    else
        play_sound('cancel')
    end
end

-- FIXED: Completely overhauled layout generation to safely bind the row array fields 
local original_create_UIBox_shop = create_UIBox_shop
function create_UIBox_shop()
    local navigation_bar = {
        n = G.UIT.R,
        config = {align = "cm", padding = 0.05, r = 0.1, colour = G.C.BLACK},
        nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.1}, nodes = {
                UIBox_button({label = {"Standard Shop"}, button = "set_shop_tab_standard", colour = G.active_shop_tab == "standard" and G.C.GREEN or G.C.RED, minw = 1.8, minh = 0.5})
            }},
            {n = G.UIT.C, config = {align = "cm", padding = 0.1}, nodes = {
                UIBox_button({label = {"The Mall"}, button = "set_shop_tab_mall", colour = G.active_shop_tab == "mall" and G.C.GREEN or G.C.RED, minw = 1.8, minh = 0.5})
            }}
        }
    }

    if G.active_shop_tab == "standard" then
        local base_ui = original_create_UIBox_shop()
        -- Safely search and inject navigation directly into the master UI root container
        if base_ui and base_ui.nodes and base_ui.nodes[1] and base_ui.nodes[1].nodes then
            table.insert(base_ui.nodes[1].nodes, 1, navigation_bar)
        end
        return base_ui

    elseif G.active_shop_tab == "mall" then
        return {
            n = G.UIT.ROOT,
            config = {align = "cm", colour = G.C.CLEAR},
            nodes = {
                {
                    n = G.UIT.R,
                    config = {align = "cm", padding = 0.2, colour = G.C.DARK_EDITION, r = 0.2},
                    nodes = {
                        navigation_bar,
                        {n = G.UIT.R, config = {align = "cm", padding = 0.4}, nodes = {
                            {n = G.UIT.O, config = {object = G.shop_mall_items}}
                        }},
                        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                            UIBox_button({label = {"Reroll ($" .. tostring(G.GAME.round_resets.reroll_cost) .. ")"}, button = "reroll_mall_shop", colour = G.C.GREEN, minw = 2.2, minh = 0.6})
                        }}
                    }
                }
            }
        }
    end
end

local native_get_current_pool = get_current_pool
function get_current_pool(_type, _rarity, _legendary, _append)
    if G.localization and G.localization.misc and G.localization.misc.dictionary then
        G.localization.misc.dictionary.k_Item = "Item"
        G.localization.misc.dictionary.k_item = "Item"
    end

    if _type == 'Joker' and not _legendary and math.random() < 0.02 then
        local target_pool = {'j_kyubey_kin', 'j_kyubey_gin', 'j_kyubey_yin', 'j_kyubey_yang'}
        return {target_pool[math.random(1, #target_pool)]}, 'joker_rare_pool'
    end
    return native_get_current_pool(_type, _rarity, _legendary, _append)
end