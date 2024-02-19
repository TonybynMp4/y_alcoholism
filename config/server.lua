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
        whiskey = {
            min = 20,
            max = 30,
            alcoholLevel = 0.5,
            stressRelief = {
                min = 1,
                max = 4
            },
        },
        beer = {
            min = 30,
            max = 40,
            stressRelief = {
                min = 1,
                max = 4
            },
            alcoholLevel = 0.25
        },
        vodka = {
            min = 20,
            max = 40,
            alcoholLevel = 0.5,
            stressRelief = {
                min = 1,
                max = 4
            }
        }
    }
}