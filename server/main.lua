lib.versionCheck('TonybynMp4/y_alcoholism')
local config = require 'config.server'
local sharedConfig = require 'config.shared'

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

        local drank = lib.callback.await('consumables:client:DrinkAlcohol', source, params.anim, params.prop)
        if not drank then return end
        if not exports.ox_inventory:RemoveItem(source, item.name, 1, nil, item.slot) then return end
        local sustenance = lib.math.clamp(playerState.thirst + math.random(params.min, params.max), 0, 100)
        playerState:set('thirst', sustenance, true)

        local alcoholTolerance = player.PlayerData.metadata.alcoholTolerance or 0
        -- you can build tolerance to reduce up to 50% of the alcohol level
        local newAlcohol = (playerState.alcohol or 0) + ((params.alcoholLevel / 2) * (1 - alcoholTolerance)) + (params.alcoholLevel / 2)

        playerState:set('alcohol', newAlcohol, true)
        player.Functions.SetMetaData('alcohol', newAlcohol)

        if alcoholTolerance < 1.0 and math.random() <= config.alcoholToleranceIncreaseChance then
            player.Functions.SetMetaData('alcoholTolerance', alcoholTolerance + config.alcoholToleranceIncrease)
            exports.qbx_core:Notify(source, 'You feel like you can handle your liquor better now', 'success')
        end

		playerState:set('stress', lib.math.clamp((playerState.stress or 0) - math.random(params.stressRelief.min, params.stressRelief.max), 0, 100), true)
        TriggerClientEvent('hud:client:UpdateNeeds', source, playerState.thirst, sustenance)
    end)
end

---Compatibility with txAdmin Menu's heal options.
---This is an admin only server side event that will pass the target player id or -1.
---@class EventData
---@field id number
---@param eventData EventData
AddEventHandler('txAdmin:events:healedPlayer', function(eventData)
	if GetInvokingResource() ~= 'monitor' or type(eventData) ~= 'table' or type(eventData.id) ~= 'number' then
		return
	end

    local target = eventData.id
    if target ~= -1 then
        local player = exports.qbx_core:GetPlayer(target)
        if not player then return end
        player.Functions.SetMetaData('alcohol', 0)

        local playerState = Player(target).state
        if not playerState then return end
        return playerState:set('alcohol', 0, true)
    end

    for _, id in ipairs(GetPlayers()) do
        local player = exports.qbx_core:GetPlayer(id)
        if not player then goto continue end
        player.Functions.SetMetaData('alcohol', 0)

        local playerState = Player(id).state
        if not playerState then goto continue end
        playerState:set('alcohol', 0, true)
        ::continue::
    end
end)

RegisterNetEvent('y_alcoholism:server:playerRevived', function()
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end
    player.Functions.SetMetaData('alcohol', 0)
    Player(source).state:set('alcohol', 0, true)
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local player = exports.qbx_core:GetPlayer(source)
    local lastLoggedOut = player.PlayerData.lastLoggedOut
    if not lastLoggedOut then return end
    local timePassed = (os.time() - lastLoggedOut/1000) / 60
    local alcohol = player.PlayerData.metadata.alcohol
    alcohol -= (timePassed / sharedConfig.alcoholDecayTime) * sharedConfig.alcoholDecayAmount

    Player(source).state:set('alcohol', alcohol, true)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end
    player.Functions.SetMetaData('alcohol', Player(source).state.alcohol)
    Player(source).state:set('alcohol', 0, true)
end)

AddStateBagChangeHandler('alcohol', nil, function(bagName, _, value)
    local source = GetPlayerFromStateBagName(bagName)
    if source == 0 then return end
	if value == Player(source).state.alcohol then return end
	local player = exports.qbx_core:GetPlayer(source)
    if not player then return end
    if value == player.PlayerData.metadata.alcohol then return end
    player.Functions.SetMetaData('alcohol', value)
end)
