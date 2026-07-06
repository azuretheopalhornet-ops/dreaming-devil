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
    secondary_colour = {1.0, 1.0, 1.0, 1.0}, -- White text
    loc_txt = {
        name = "Item",
        collection = "Item Cards",
        undiscovered = {
            name = "Undiscovered Item",
            text = { "Buy a pack at a sale", "to discover this item!" }
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

--#region Fusion Click Handlers

-- Handles the actual fusion event when the player clicks the pink "FUSE" button
G.FUNCS.kyubey_fuse_jokers = function(e)
    -- Safety check: Make sure player still has both cards before running
    if not G.jokers or not G.jokers.cards then return end
    
    local card_kin, card_gin
    for _, c in ipairs(G.jokers.cards) do
        if c.config.center.key == 'j_kyubey_kin' and not card_kin then card_kin = c end
        if c.config.center.key == 'j_kyubey_gin' and not card_gin then card_gin = c end
    end
    
    if card_kin and card_gin then
        -- Visual squish/juice effect on the source cards
        card_kin:juice_up(0.5, 0.5)
        card_gin:juice_up(0.5, 0.5)
        
        -- Delete the material cards from the player's Joker area
        G.jokers:remove_card(card_kin)
        card_kin:remove()
        G.jokers:remove_card(card_gin)
        card_gin:remove()
        
        -- Create, spawn, and slot in Twisted Sisters
        local fused_card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_kyubey_twisted_sisters', nil)
        fused_card:add_to_deck()
        G.jokers:emplace(fused_card)
        fused_card:juice_up(0.8, 0.8)
        
        -- Cleanly close the selection context overlay window
        if G.el and G.el.context_menu then 
            G.el.context_menu:remove()
            G.el.context_menu = nil
        end
    end
end

-- ====================================================================
-- POOL SPAWN OVERRIDE (Jokers and Boosters)
-- ====================================================================
local native_get_current_pool = get_current_pool
function get_current_pool(_type, _rarity, _legendary, _append)
    -- FIXED: Changed 'p_kyubey_yardsale' to 'p_rainbowquartz_yardsale' to match Mod ID registration
    if _type == 'Booster' then
        return {'p_rainbowquartz_yardsale'}, 'booster_debug_pool'
    end

    -- 0.02 means a 2% chance per slot. Change to 0.05 for 5%, 0.10 for 10%, etc.
    if _type == 'Joker' and not _legendary and math.random() < 0.02 then
        local target_pool = {
            'j_kyubey_kin', 
            'j_kyubey_gin', 
            'j_kyubey_yin', 
            'j_kyubey_yang'
        }
        local chosen_joker = target_pool[math.random(1, #target_pool)]
        return {chosen_joker}, 'joker_rare_pool'
    end
    return native_get_current_pool(_type, _rarity, _legendary, _append)
end

--#endregion