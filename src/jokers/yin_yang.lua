-- ====================================================================
-- YIN JOKER
-- ====================================================================
SMODS.Joker {
    key = 'yin',
    atlas = 'placeholders',
    pos = { x = 0, y = 0 },
    rarity = 4,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    in_pool = function(self) return true end,

    loc_txt = {
        name = "Yin",
        text = { "{C:chips}+800{} Chips and", "{C:mult}+10{} Mult." }
    },

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge("Fusion", G.C.KYUBEY_HOT_PINK, G.C.WHITE, 1.2)
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { chip_mod = 800, mult_mod = 10, message = '+800 Chips +10 Mult', card = card }
        end
    end
}

-- ====================================================================
-- YANG JOKER (FIXED)
-- ====================================================================
SMODS.Joker {
    key = 'yang',
    atlas = 'placeholders',
    pos = { x = 0, y = 0 },
    rarity = 4,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    in_pool = function(self) return true end,

    loc_txt = {
        name = "Yang",
        text = { "{C:attention}+2{} Discards,", "{X:mult,C:white}X5{} Mult." }
    },

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge("Fusion", G.C.KYUBEY_HOT_PINK, G.C.WHITE, 1.2)
    end,

    -- Safely modifies round discards with fallback protections
    add_to_deck = function(self, card, from_debuff)
        if G.GAME and G.GAME.round_resets then
            G.GAME.round_resets.discards = (G.GAME.round_resets.discards or 0) + 2
            G.GAME.current_round.discards = (G.GAME.current_round.discards or 0) + 2
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if G.GAME and G.GAME.round_resets then
            G.GAME.round_resets.discards = math.max(0, (G.GAME.round_resets.discards or 2) - 2)
            G.GAME.current_round.discards = math.max(0, (G.GAME.current_round.discards or 2) - 2)
        end
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { xmult_mod = 5, message = 'X5 Mult', card = card }
        end
    end
}