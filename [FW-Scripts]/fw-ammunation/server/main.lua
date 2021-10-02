Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

local timeOut = false

local alarmTriggered = false

RegisterServerEvent('fw-ammunation:server:setVitrineState')
AddEventHandler('fw-ammunation:server:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
    TriggerClientEvent('fw-ammunation:client:setVitrineState', -1, stateType, state, k)
end)

RegisterServerEvent('fw-ammunation:server:vitrineReward')
AddEventHandler('fw-ammunation:server:vitrineReward', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local otherchance = math.random(1, 4)
    local odd = math.random(1, 3)

    if otherchance == odd then
        local item = math.random(1, #Config.VitrineRewards)
        local amount = math.random(Config.VitrineRewards[item]["amount"]["min"], Config.VitrineRewards[item]["amount"]["max"])
        if Player.Functions.AddItem(Config.VitrineRewards[item]["item"], amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, Framework.Shared.Items[Config.VitrineRewards[item]["item"]], 'add')
        else
            TriggerClientEvent('Framework:Notify', src, 'Je hebt teveel op zak..', 'error')
        end
    else
        local amount = math.random(2, 4)
        if Player.Functions.AddItem("pistol-ammo", amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, Framework.Shared.Items["pistol-ammo"], 'add')
        else
            TriggerClientEvent('Framework:Notify', src, 'Je hebt teveel op zak..', 'error')
        end
    end
end)

RegisterServerEvent('fw-ammunation:server:setTimeout')
AddEventHandler('fw-ammunation:server:setTimeout', function()
    if not timeOut then
        timeOut = true
        TriggerEvent('fw-scoreboard:server:SetActivityBusy', "ammunation", true)
        Citizen.CreateThread(function()
            Citizen.Wait(Config.Timeout)

            for k, v in pairs(Config.Locations) do
                Config.Locations[k]["isOpened"] = false
                TriggerClientEvent('fw-ammunation:client:setVitrineState', -1, 'isOpened', false, k)
                TriggerClientEvent('fw-ammunation:client:setAlertState', -1, false)
                TriggerEvent('fw-scoreboard:server:SetActivityBusy', "ammunation", false)
            end
            timeOut = false
            alarmTriggered = false
        end)
    end
end)

RegisterServerEvent('fw-ammunation:server:PoliceAlertMessage')
AddEventHandler('fw-ammunation:server:PoliceAlertMessage', function(title, coords, blip)
    local src = source
    local alertData = {
        title = title,
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = "Mogelijk overval gaande bij de Ammu Nation<br>Beschikbare camera: Nvt",
    }

    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                if blip then
                    if not alarmTriggered then
                        TriggerClientEvent("fw-phone:client:addPoliceAlert", v, alertData)
                        TriggerClientEvent("fw-ammunation:client:PoliceAlertMessage", v, title, coords, blip)
                        alarmTriggered = true
                    end
                else
                    TriggerClientEvent("fw-phone:client:addPoliceAlert", v, alertData)
                    TriggerClientEvent("fw-ammunation:client:PoliceAlertMessage", v, title, coords, blip)
                end
            end
        end
    end
end)

Framework.Functions.CreateCallback('fw-ammunation:server:getCops', function(source, cb)
	local amount = 0
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
	end
	cb(amount)
end)