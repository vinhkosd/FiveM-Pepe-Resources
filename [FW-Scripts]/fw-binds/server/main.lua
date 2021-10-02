Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Commands.Add("binds", "Open commandbinding menu", {}, false, function(source, args)
	TriggerClientEvent("fw-binds:client:openUI", source)
end)

RegisterServerEvent('fw-binds:server:setKeyMeta')
AddEventHandler('fw-binds:server:setKeyMeta', function(keyMeta)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    Player.Functions.SetMetaData("commandbinds", keyMeta)
end)