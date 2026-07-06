local mint_green = {0.45, 0.88, 0.68, 1.0}

SMODS.Booster {
    key = 'yardsale',
    config = { choose = 1, extra = 3 },
    group_key = 'k_kyubey_packs',
    weight = 1, 
    kind = 'Item',
    atlas = 'placeholders', 
    pos = { x = 0, y = 0 },
    
    loc_txt = {
        name = "Yard Sale",
        text = { "Choose {1} of up to", "{2} hidden Items" }
    },

    -- FIXED: Now properly instantiates a real Card object inside the pack selection grid
    create_card = function(self, card, i)
        return create_card('Item', G.pack_cards, nil, nil, nil, nil, nil, nil)
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { math.min(card.ability.choose + (G.GAME.modifiers.booster_choice_mod or 0), math.max(1, card.ability.extra + (G.GAME.modifiers.booster_size_mod or 0))), math.max(1, card.ability.extra + (G.GAME.modifiers.booster_size_mod or 0)) } }
    end,

    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, mint_green)
        ease_background_colour({ new_colour = mint_green, special_colour = G.C.BLACK, contrast = 2 })
    end,
}

SMODS.Booster {
    key = 'mallsale',
    config = { choose = 2, extra = 5 },
    group_key = 'k_kyubey_packs',
    weight = 0.5, 
    kind = 'Item',
    atlas = 'placeholders',
    pos = { x = 0, y = 0 },
    
    loc_txt = {
        name = "Mall Sale",
        text = { "Choose {1} of up to", "{2} hidden Items" }
    },

    create_card = function(self, card, i)
        return create_card('Item', G.pack_cards, nil, nil, nil, nil, nil, nil)
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { math.min(card.ability.choose + (G.GAME.modifiers.booster_choice_mod or 0), math.max(1, card.ability.extra + (G.GAME.modifiers.booster_size_mod or 0))), math.max(1, card.ability.extra + (G.GAME.modifiers.booster_size_mod or 0)) } }
    end,

    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, mint_green)
        ease_background_colour({ new_colour = mint_green, special_colour = G.C.BLACK, contrast = 2 })
    end,
}