Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Functions.CreateCallback('fw-scoreboard:server:GetActiveCops', function(source, cb)
    local retval = 0
    
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                retval = retval + 1
            end
        end
    end

    cb(retval)
end)

Framework.Functions.CreateCallback('fw-scoreboard:server:GetActiveEms', function(source, cb)
    local retval = 0
    
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "ambulance" and Player.PlayerData.job.onduty) or (Player.PlayerData.job.name == "doctor" and Player.PlayerData.job.onduty) then
                retval = retval + 1
            end
        end
    end

    cb(retval)
end)

Framework.Functions.CreateCallback('fw-scoreboard:server:GetConfig', function(source, cb)
    cb(Config.IllegalActions)
end)

RegisterServerEvent('fw-scoreboard:server:SetActivityBusy')
AddEventHandler('fw-scoreboard:server:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
    TriggerClientEvent('fw-scoreboard:client:SetActivityBusy', -1, activity, bool)
end)