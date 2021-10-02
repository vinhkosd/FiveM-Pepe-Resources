Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('fw-hud:server:gain:stress')
AddEventHandler('fw-hud:server:gain:stress', function(Amount)
    local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil then
	  local NewStress = Player.PlayerData.metadata["stress"] + Amount
	  if NewStress <= 0 then NewStress = 0 end
	  if NewStress > 100 then NewStress = 100 end
	  Player.Functions.SetMetaData("stress", NewStress)
      TriggerClientEvent("fw-hud:client:update:stress", Player.PlayerData.source, NewStress)
	end
end)

RegisterServerEvent('fw-hud:server:remove:stress')
AddEventHandler('fw-hud:server:remove:stress', function(Amount)
    local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil then
	  local NewStress = Player.PlayerData.metadata["stress"] - Amount
	  if NewStress <= 0 then NewStress = 0 end
	  if NewStress > 100 then NewStress = 100 end
	  Player.Functions.SetMetaData("stress", NewStress)
      TriggerClientEvent("fw-hud:client:update:stress", Player.PlayerData.source, NewStress)
	end
end)

Framework.Commands.Add("cash", "Xem số tiền hiện tại của bạn", {}, false, function(source, args)
    TriggerClientEvent('fw-hud:client:show:cash', source)
end)

Framework.Commands.Add("players", "Xem số người chơi online", {}, false, function(source, args)
	TriggerClientEvent('fw-hud:client:show:current:players', source)
end)