SMODS.Joker {
    key = 'Shotgun',
    atlas = 'placeholders',
    pos = {
        x = 0,
        y = 0
    },
    config = {
        extra = {
            mult = 8
        }        
    },
    rarity = 1,
    cost = 3,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.after and context.main_eval and not context.blueprint then
            if card.ability.extra.mult <= 1 then
            card.ability.extra.mult = 8
                return {
                    message = 'Reload',
                    colour = G.C.ORANGE
                }
            else
                card.ability.extra.mult = card.ability.extra.mult / 2
                return {
                    message = 'halved',
                    colour = G.C.MULT
                }
            end
        end
             
        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.extra.mult = 8
                return {
                    message = "Reload",
                    colour = G.C.ORANGE
                }
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end

    end
}