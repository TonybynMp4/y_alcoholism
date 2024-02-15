local config = require("config.client")
local isDrunk = false
local alcoholLevel = LocalPlayer.state.alcohol or 0
local playerWalk

local function resetEffect()
    exports.scully_emotemenu:setWalk(playerWalk or "move_m@casual@a")
    playerWalk = nil
    SetPedIsDrunk(cache.ped, false)
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetPedConfigFlag(cache.ped, 100, false)
    ClearTimecycleModifier()
end

local function drunkEffect(severity)
    if not playerWalk then
        playerWalk = exports.scully_emotemenu:getCurrentWalk()
    end
    exports.scully_emotemenu:setWalk(severity.walk or 'move_m@drunk@slightlydrunk')
    SetPedIsDrunk(cache.ped, true)
    ShakeGameplayCam("DRUNK_SHAKE", severity.shake or 0.25)
    SetPedConfigFlag(cache.ped, 100, true)
    SetTimecycleModifier(severity.timecycle or "Drunk")
end

local function drunkLoop()
    CreateThread(function()
        while isDrunk do
            local severity
            for k, v in pairs(config.effect.severitySteps) do
                if alcoholLevel >= k then
                    severity = v
                end
            end

            if severity then
                drunkEffect(severity)
            end

            Wait(1000 * 60 * config.alcoholDecayTime)

            if alcoholLevel > 0 then
                alcoholLevel -= config.alcoholDecayAmount
            end

            if alcoholLevel >= config.ethylComaValue then
                alcoholLevel = 0
                resetEffect()
                SetEntityHealth(cache.ped, 0)
            end

            if playerWalk and alcoholLevel and not severity then
                exports.scully_emotemenu:setWalk(playerWalk)
                playerWalk = nil
            end

            alcoholLevel = alcoholLevel > 0 and alcoholLevel or 0
            LocalPlayer.state:set("alcohol", alcoholLevel, true)
            isDrunk = alcoholLevel > 0
            if not isDrunk then
                resetEffect()
            end
        end
    end)
end

AddStateBagChangeHandler("alcohol", ('player:%s'):format(cache.serverId), function(_, _, value)
    alcoholLevel = value
    if value > 0 and not isDrunk then
        isDrunk = true
        SetTimeout(config.delayEffect, drunkLoop)
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        if LocalPlayer.state.alcohol and LocalPlayer.state.alcohol > 0 then
            isDrunk = true
            drunkLoop()
        else
            resetEffect()
        end
    end
end)