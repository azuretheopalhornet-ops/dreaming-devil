SMODS.Joker {
    key = 'RPG',
    atlas = 'placeholders',
    pos = {
        x = 4,
        y = 0
    },

    config = {
        extra = {
            chips = 50,
            xmult = 1,
            dollars = 1,
            boss_xmult = 0.80,
            form = 0,

            chance1 = 0.25,
            chance2 = 0.25,
            chance3 = 0.25,
            chance4 = 0.25
        }
    },

    rarity = 3,
    cost = 6,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.xmult,
                card.ability.extra.dollars,
                card.ability.extra.boss_xmult
            }
        }
    end,
    calculate = function(self, card, context)

        if context.joker_main then

            local roll = pseudorandom("rpg")

            local extra = card.ability.extra


            if roll < extra.chance1 then

                extra.form = 1

                card.ability.extra.chips = card.ability.extra.chips + 50

                local amount = math.min(0.01, extra.chance4)

                extra.chance4 = extra.chance4 - amount
                extra.chance1 = extra.chance1 + amount


            elseif roll < extra.chance1 + extra.chance2 then

                extra.form = 2

                card.ability.extra.xmult = card.ability.extra.xmult + 0.05

                local amount = math.min(0.01, extra.chance4)

                extra.chance4 = extra.chance4 - amount
                extra.chance2 = extra.chance2 + amount


            elseif roll < extra.chance1 + extra.chance2 + extra.chance3 then

                extra.form = 3

                card.ability.extra.dollars = card.ability.extra.dollars + 1

                local amount = math.min(0.01, extra.chance4)

                extra.chance4 = extra.chance4 - amount
                extra.chance3 = extra.chance3 + amount


            else

                extra.form = 4

                extra.boss_xmult = math.max(0, extra.boss_xmult - 0.05)

                local removed = 0

                local amount = math.min(0.02, extra.chance1)
                extra.chance1 = extra.chance1 - amount
                removed = removed + amount


                amount = math.min(0.02, extra.chance2)
                extra.chance2 = extra.chance2 - amount
                removed = removed + amount


                amount = math.min(0.02, extra.chance3)
                extra.chance3 = extra.chance3 - amount
                removed = removed + amount


                extra.chance4 = extra.chance4 + removed

            end


            card.children.center:set_sprite_pos({
                x = extra.form,
                y = 0
            })
            card:juice_up(0.5, 0.5)
            play_sound('tarot1')

            if extra.form == 1 then

                return {
                    chips = extra.chips
                }

            elseif extra.form == 2 then

                return {
                    xmult = extra.xmult
                }

            elseif extra.form == 3 then

                return {
                    dollars = extra.dollars
                }

            elseif extra.form == 4 then

                return {
                    xmult = extra.boss_xmult
                    }

            end

        end


        if context.end_of_round then

            card.ability.extra.form = 0

            card.children.center:set_sprite_pos({
                x = 4,
                y = 0
            })

        end

    end
}