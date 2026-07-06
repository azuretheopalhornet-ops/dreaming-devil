SMODS.Consumable {
    key = 'three_d_glasses',
    set = 'Item',
    atlas = 'placeholders',
    pos = { x = 0, y = 1 }, 
    cost = 4,
    unlocked = true,
    discovered = true,
    
    loc_txt = {
        name = "3D Glasses",
        text = { "Flips a selected reality-shifting", "Joker to its alternate form." }
    },
    
    can_use = function(self, card)
        if G.jokers and G.jokers.highlighted and #G.jokers.highlighted == 1 then
            local target = G.jokers.highlighted[1]
            if target.config.center.key == 'j_kyubey_yin' or 
               target.config.center.key == 'j_kyubey_yang' or
               target.config.center.key == 'j_kyubey_kin' or
               target.config.center.key == 'j_kyubey_gin' then
                return true
            end
        end
        return false
    end,

    use = function(self, card, area, copier)
        local target = G.jokers.highlighted[1]
        local new_key = nil

        if target.config.center.key == 'j_kyubey_yin' then new_key = 'j_kyubey_kin'
        elseif target.config.center.key == 'j_kyubey_kin' then new_key = 'j_kyubey_yin'
        elseif target.config.center.key == 'j_kyubey_yang' then new_key = 'j_kyubey_gin'
        elseif target.config.center.key == 'j_kyubey_gin' then new_key = 'j_kyubey_yang'
        end

        if new_key then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    target:set_ability(G.P_CENTERS[new_key], nil, true)
                    target:juice_up(0.5, 0.5)
                    return true
                end
            }))
        end
    end
}