local config = require('config.client')
local sharedConfig = require('config.shared')
local playerState = LocalPlayer.state
local alcoholLevel = playerState.alcohol or 0
local playerWalk

local function resetEffect()
    exports.scully_emotemenu:setWalk(playerWalk or 'move_m@casual@a')
    playerWalk = nil
    SetPedIsDrunk(cache.ped, false)
    ShakeGameplayCam('DRUNK_SHAKE', 0.0)
    SetPedConfigFlag(cache.ped, 100, false)
    ClearTimecycleModifier()
end

local function drunkEffect(severity)
    if not playerWalk then
        playerWalk = exports.scully_emotemenu:getCurrentWalk()
    end
    exports.scully_emotemenu:setWalk(severity.walk or 'move_m@drunk@slightlydrunk')
    ShakeGameplayCam('DRUNK_SHAKE', severity.shake or 0.25)
    SetPedConfigFlag(cache.ped, 100, true)
    SetTransitionTimecycleModifier(severity.timecycle or 'Drunk', 0.5)
end

local function drunkLoop()
    if not playerState.isLoggedIn or not playerState.alcohol or playerState.alcohol <= 0 then
        return
    end
    CreateThread(function()
        while playerState.alcohol > 0 do
            SetPedIsDrunk(cache.ped, true)
            local severity
            for k, v in pairs(config.effect.severitySteps) do
                if alcoholLevel >= k then
                    severity = v
                end
            end

            if severity then
                drunkEffect(severity)
            end

            Wait(60000 * sharedConfig.alcoholDecayTime)

            if alcoholLevel > 0 then
                alcoholLevel -= sharedConfig.alcoholDecayAmount
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
            playerState:set('alcohol', alcoholLevel, true)
            if playerState.alcohol == 0 then
                resetEffect()
            end
        end
    end)
end

lib.callback.register('consumables:client:DrinkAlcohol', function(anim, prop)
    if lib.progressBar({
        duration = math.random(3000, 6000),
        label = 'Drinking liquor...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true
        },
        anim = anim or {
            clip = 'loop_bottle',
            dict = 'mp_player_intdrink',
            flag = 49
        },
        prop = prop or {
            {
                model = 'prop_amb_beer_bottle',
                bone = 18905,
                pos = {x = 0.12, y = 0.008, z = 0.03},
                rot = {x = 240.0, y = -60.0, z = 0.0}
            }
        }
    }) then -- if completed
        return true
    else -- if canceled
        exports.qbx_core:Notify('Canceled...', 'error')
        return false
    end
end)

AddStateBagChangeHandler('alcohol', ('player:%s'):format(cache.serverId), function(_, _, value)
    if type(value) ~= 'number' then return end
    if (not alcoholLevel or alcoholLevel <= 0) and value > 0 then
        alcoholLevel = value
        SetTimeout(config.delayEffect, drunkLoop)
        return
    end
    alcoholLevel = value
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    playerState:set('alcohol', 0, true)
    resetEffect()
end)

RegisterNetEvent('qbx_medical:client:playerRevived', function()
    TriggerServerEvent('y_alcoholism:server:playerRevived')
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        if playerState.alcohol and playerState.alcohol > 0 then
            drunkLoop()
        else
            resetEffect()
        end
    end
end)
