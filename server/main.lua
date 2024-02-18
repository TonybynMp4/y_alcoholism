lib.versionCheck('Qbox-project/qbx_alcoholism')
local config = require 'config.server'

for alcohol, params in pairs(config.alcoholItems) do
    exports.qbx_core:CreateUseableItem(alcohol, function(source, item)
        local playerState = Player(source).state
        local player = exports.qbx_core:GetPlayer(source)
        if not player then return end

        if not params.stressRelief then
            params.stressRelief = {
                min = -4,
                max = -1
            }
        end

        local drank = lib.callback.await('consumables:client:DrinkAlcohol', source, item.name, { anim = params.anim, prop = params.prop, stressRelief = params.stressRelief})
        if not drank then return end
        if not exports.ox_inventory:RemoveItem(source, item.name, 1, nil, item.slot) then return end
        local sustenance = playerState.thirst + math.random(params.min, params.max)
        playerState:set('thirst', sustenance, true)
        player.Functions.SetMetaData('thirst', sustenance)

        local alcoholTolerance = player.PlayerData.metadata.alcoholTolerance or 0
        -- you can build tolerance to reduce up to 50% of the alcohol level
        local newAlcohol = playerState.alcohol + ((params.alcoholLevel / 2) * (1 - alcoholTolerance)) + (params.alcoholLevel / 2)

        playerState:set('alcohol', newAlcohol, true)
        player.Functions.SetMetaData('alcohol', newAlcohol)

        if alcoholTolerance < 1.0 and math.random() <= config.alcoholToleranceIncreaseChance then
            player.Functions.SetMetaData('alcoholTolerance', alcoholTolerance + config.alcoholToleranceIncrease)
            exports.qbx_core:Notify(source, 'You feel like you can handle your liquor better now', 'success')
        end

        playerState:set('stress', playerState.stress - math.random(params.stressRelief.min, params.stressRelief.max), true)

        TriggerClientEvent('hud:client:UpdateNeeds', source, player.PlayerData.metadata.thirst, sustenance)
    end)
end

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local player = exports.qbx_core:GetPlayer(source)
    Player(source).state:set('alcohol', player.PlayerData.metadata.alcohol, true)
end)

AddStateBagChangeHandler('alcohol', nil, function(bagName, key, value)
    local source = GetPlayerFromStateBagName(bagName)
    if source == 0 then return end
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end
    player.Functions.SetMetaData('alcohol', value)
end)