Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)


Framework.Commands.Add("cash", "Check cash", {}, false, function(source, args)
	TriggerClientEvent('hud:client:ShowMoney', source, "cash")
end)