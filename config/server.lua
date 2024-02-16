return {

    --- % of chance to increase alcohol tolerance
    alcoholToleranceIncreaseChance = 0.1,

    --- % of alcohol tolerance increase
    alcoholToleranceIncrease = 0.05,

    ---@class anim
    ---@field clip string
    ---@field dict string
    ---@field flag number

    ---@class prop
    ---@field model string
    ---@field bone number
    ---@field pos vector3
    ---@field rot vector3

    ---@class stressRelief
    ---@field min number
    ---@field max number

    ---@class consumable
    ---@field min number
    ---@field max number
    ---@field anim anim?
    ---@field prop table?
    ---@field stressRelief table?
    ---@field alcoholLevel number?

    ---@class alcoholItem : consumable

    ---@type table<string, consumable>
    alcoholItems = {
        champagne = {
            min = 20,
            max = 40,
            alcoholLevel = 0.25,
            prop = {
                bone = 18905,
                pos = vec3(0.10000000149011, -0.02999999932944, 0.02999999932944),
                rot = vec3(-100.0, 0.0, -10.0),
                model = "prop_drink_champ"
            },
            anim = {
                flag = 49,
                dict = "anim@heists@humane_labs@finale@keycards",
                clip = "ped_a_enter_loop"
            }
        },
        whiskey = {
            min = 20,
            max = 30,
            alcoholLevel = 0.5,
            prop = {
                bone = 60309,
                pos = vec3(0.0, 0.0, 0.0),
                rot = vec3(0.0, 0.0, 0.0),
                model = "prop_cs_whiskey_bottle"
            },
            anim = {
                flag = 49,
                dict = "mp_player_intdrink",
                clip = "loop_bottle"
            }
        },
        vodka = {
            min = 20,
            max = 40,
            alcoholLevel = 0.5,
            prop = {
                bone = 18905,
                pos = vec3(0.0, -0.25999999046325, 0.10000000149011),
                rot = vec3(240.0, -60.0, 0.0),
                model = "prop_vodka_bottle"
            },
            anim = {
                flag = 49,
                dict = "mp_player_intdrink",
                clip = "loop_bottle"
            }
        },
        beer = {
            min = 30,
            max = 40,
            alcoholLevel = 0.15,
            prop = {
                bone = 18905,
                pos = vec3(0.03999999910593, -0.14000000059604, 0.10000000149011),
                rot = vec3(240.0, -60.0, 0.0),
                model = "prop_beerdusche"
            },
            anim = {
                flag = 49,
                dict = "mp_player_intdrink",
                clip = "loop_bottle"
            }
        },
        wine = {
            min = 20,
            alcoholLevel = 0.125,
            max = 40,
            prop = {
                bone = 18905,
                pos = vec3(0.0, -0.25999999046325, 0.10000000149011),
                rot = vec3(240.0, -60.0, 0.0),
                model = "prop_wine_rose"
            },
            anim = {
                flag = 49,
                dict = "mp_player_intdrink",
                clip = "loop_bottle"
            }
        },
        grapejuice = {
            max = 25,
            min = 10,
            alcoholLevel = 0.075,
            prop = {
                bone = 18905,
                pos = vec3(0.0, -0.25999999046325, 0.10000000149011),
                rot = vec3(240.0, -60.0, 0.0),
                model = "prop_wine_rose"
            },
            anim = {
                flag = 49,
                dict = "mp_player_intdrink",
                clip = "loop_bottle"
            }
        }
    }
}