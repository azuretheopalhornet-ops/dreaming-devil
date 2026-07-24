SMODS.Joker {
    key = 'Silvia',
    atlas = 'placeholders',
    pos = {
        x = 1,
        y = 0
    },
    config = {
        extra = {
            chips = 69,
            mult = 0,
            bosses = 0
        }
    },
    rarity = 2,
    cost = 4,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.mult
            }
        }
    end,

    calculate = function(self, card, context)

        if context.end_of_round and context.beat_boss and context.main_eval then
            card.ability.extra.hand = card.ability.extra.hand + 1

            if card.ability.extra.bosses % 2 == 1 then
                card.ability.extra.chips = card.ability.extra.chips + 50
                card_eval_status_text(card, 'extra', nil, nil, nil,
                {message = '+50 chips',
                colour = G.C.CHIPS
                })
            end

            if card.ability.extra.bosses % 2 == 0 then
                card.ability.extra.mult = card.ability.extra.mult + 2
                card_eval_status_text(card, 'extra', nil, nil, nil, 
                {message = '+2 mult',
                colour = G.C.MULT
                })
            end

            if card.ability.extra.bosses == 4 then
                ease_dollars(-10)
                card_eval_status_text(card, 'extra', nil, 3, nil, {message = 'sorry i owed the la mafia some money'})
            end
        end

        if context.joker_main then
        return{
            chips = card.ability.extra.chips,
            mult = card.ability.extra.mult
        }
    end 

end
}