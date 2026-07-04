SMODS.Joker {
    key = 'silvia',
    atlas = 'placeholders',
    pos = { x = 1, y = 0 },

    rarity = 2,
    cost = 5,

    -- FORCE sell value to 3
    calculate_sell_cost = function(self, card)
        return 3
    end,

    config = {
        extra = {
            chips = 69,
            mult = 0,
            bosses = 0,
            money_counter = 0,
            triggered = false
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.mult
            }
        }
    end,

    calculate = function(self, card, context)

        -- main effect
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end

        -- reset per round
        if context.setting_blind then
            card.ability.extra.triggered = false
        end

        -- boss reward logic
        if context.end_of_round
        and G.GAME.blind
        and G.GAME.blind.boss
        and not card.ability.extra.triggered then

            card.ability.extra.triggered = true
            card.ability.extra.bosses = card.ability.extra.bosses + 1
            card.ability.extra.money_counter = card.ability.extra.money_counter + 1

            local msg = ""
            local col = G.C.CHIPS

            if card.ability.extra.bosses % 2 == 1 then
                card.ability.extra.chips = card.ability.extra.chips + 50
                msg = "+50 Chips"
                col = G.C.CHIPS
            else
                card.ability.extra.mult = card.ability.extra.mult + 2
                msg = "+2 Mult"
                col = G.C.MULT
            end

            -- mafia message (2 seconds)
            if card.ability.extra.money_counter >= 4 then
                card.ability.extra.money_counter = 0

                msg = msg .. " | Sorry, I needed money for La Mafia (-$4)"
                col = G.C.RED

                return {
                    message = msg,
                    colour = col,
                    delay = 2
                }
            end

            return {
                message = msg,
                colour = col
            }
        end
    end
}