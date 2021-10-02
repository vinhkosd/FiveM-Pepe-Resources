Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Functions.CreateCallback('fw-hospital:server:pay:hospital', function(source, cb)
	local Player = Framework.Functions.GetPlayer(source)
	local CurrentCash = Player.PlayerData.money['cash']
	if Player.Functions.RemoveMoney('cash', Config.BedPayment, 'Ziekenhuis') then
		cb(true)
	elseif Player.Functions.RemoveMoney('bank', Config.BedPayment, 'Ziekenhuis') then
		cb(true)
	else
		TriggerClientEvent('Framework:Notify', source, "Je hebt niet genoeg contant..", "error", 4500)
		cb(false)
	end

end)

RegisterServerEvent('fw-hospital:server:set:state')
AddEventHandler('fw-hospital:server:set:state', function(type, state)
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	if Player ~= nil then
		Player.Functions.SetMetaData(type, state)
	end
end)

RegisterServerEvent('fw-hospital:server:dead:respawn')
AddEventHandler('fw-hospital:server:dead:respawn', function()
	local Player = Framework.Functions.GetPlayer(source)
	Player.Functions.RemoveMoney('bank', Config.RespawnPrice, 'respawn-fund')
	Player.Functions.ClearInventory()
	Citizen.SetTimeout(250, function()
		Player.Functions.Save()
	end)
end)

RegisterServerEvent('fw-hospital:server:save:health:armor')
AddEventHandler('fw-hospital:server:save:health:armor', function(PlayerHealth, PlayerArmor)
	local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil then
		Player.Functions.SetMetaData('health', PlayerHealth)
		Player.Functions.SetMetaData('armor', PlayerArmor)
	end
end)

RegisterServerEvent('fw-hospital:server:revive:player')
AddEventHandler('fw-hospital:server:revive:player', function(PlayerId)
	local TargetPlayer = Framework.Functions.GetPlayer(PlayerId)
	if TargetPlayer ~= nil then
		TriggerClientEvent('fw-hospital:client:revive', TargetPlayer.PlayerData.source, true, true)
	end
end)

RegisterServerEvent('fw-hospital:server:heal:player')
AddEventHandler('fw-hospital:server:heal:player', function(TargetId)
	local TargetPlayer = Framework.Functions.GetPlayer(TargetId)
	if TargetPlayer ~= nil then
		TriggerClientEvent('fw-hospital:client:heal', TargetPlayer.PlayerData.source)
	end
end)

RegisterServerEvent('fw-hospital:server:take:blood:player')
AddEventHandler('fw-hospital:server:take:blood:player', function(TargetId)
	local src = source
	local SourcePlayer = Framework.Functions.GetPlayer(src)
	local TargetPlayer = Framework.Functions.GetPlayer(TargetId)
	if TargetPlayer ~= nil then
	 local Info = {vialid = math.random(11111,99999), vialname = TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname, bloodtype = TargetPlayer.PlayerData.metadata['bloodtype'], vialbsn = TargetPlayer.PlayerData.citizenid}
	 SourcePlayer.Functions.AddItem('bloodvial', 1, false, Info)
	 TriggerClientEvent('fw-inventory:client:ItemBox', SourcePlayer.PlayerData.source, Framework.Shared.Items['bloodvial'], "add")
	end
end)

RegisterServerEvent('fw-hospital:server:set:bed:state')
AddEventHandler('fw-hospital:server:set:bed:state', function(BedData, bool)
	Config.Beds[BedData]['Busy'] = bool
	TriggerClientEvent('fw-hospital:client:set:bed:state', -1 , BedData, bool)
end)

Framework.Commands.Add("revive", "Revive een speler of jezelf", {{name="id", help="Speler ID (mag leeg zijn)"}}, false, function(source, args)
	if args[1] ~= nil then
		local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('fw-hospital:client:revive', Player.PlayerData.source, true, true)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
		end
	else
		TriggerClientEvent('fw-hospital:client:revive', source, true, true)
	end
end, "admin")

Framework.Commands.Add("setambulance", "Neem neen ambulancier aan", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
      if TargetPlayer ~= nil then
          TriggerClientEvent('Framework:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen als ambulancier! gefeliciteerd!', 'success')
          TriggerClientEvent('Framework:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' aangenomen als ambulancier!', 'success')
          TargetPlayer.Functions.SetJob('ambulance')
      end
    end
end)

Framework.Commands.Add("fireambulance", "Ontsla een ambulancier", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
      if TargetPlayer ~= nil then
          TriggerClientEvent('Framework:Notify', TargetPlayer.PlayerData.source, 'Je bent ontslagen!', 'error')
          TriggerClientEvent('Framework:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' ontslagen!', 'success')
          TargetPlayer.Functions.SetJob('unemployed')
      end
    end
end)