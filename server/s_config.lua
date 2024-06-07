Config = {
    DigItem = 'lapio', -- item what using the digging
    PanItem = 'vaskooli',
    DigTime = 25, -- in seconds
    PanTime = 25, -- in seconds
    Chance = 100, -- what the chance is get dig gold, only 1-100
    SandItem = 'hiekka',
    GoldItem = 'kultahippu',
    PanItemAmount = 3,
    Min = 1,
    Max = 5,
    GoldAmount = 2,
    ChanceForNothing = 35, -- millä toden näköisyydellä et saa mitään huuhdonnasta?
    Webhook = '', -- you can put webhook here or s_main.lua  = local logs = '' or Config.Webhook
    Items = { -- pan items
       "kultahippu",
    },
    Areas = {
        { coords = vec3(2805.8113, 3937.2444, 45.2431), area = 80.0 }, -- sandy shores area
        { coords = vec3(384.8882, 6828.3813, 3.5766), area = 100.0 }, -- paleto bay
        { coords = vec3(-2067.1526, -560.8336, 4.4029), area = 70.0 }, -- los santos peach
    }
}