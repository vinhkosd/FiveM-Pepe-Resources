Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Commands.Add("radar", "Toggle snelheidsradar :)", {}, false, function(source, args)
	local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("wk:toggleRadar", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)