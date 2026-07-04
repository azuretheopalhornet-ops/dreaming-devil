SMODS.Joker {
    key = 'silvia',
    atlas = 'placeholders',
    pos = {
        x = 1,
        y = 0
    },

    config = {
        extra = {
            chips = 100,
            mult = 0,
            bosses = 0
        }
    },

    rarity = 1,
    cost = 5,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.mult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end

        if context.end_of_round and G.GAME.blind and G.GAME.blind.boss then
            card.ability.extra.bosses = card.ability.extra.bosses + 1

            if card.ability.extra.bosses % 2 == 1 then
                card.ability.extra.chips = card.ability.extra.chips + 50
                return {
                    message = "+50 Chips",
                    colour = G.C.CHIPS
                }
            else
                card.ability.extra.mult = card.ability.extra.mult + 2
                return {
                    message = "+2 Mult",
                    colour = G.C.MULT
                }
            end
        end
    end
}