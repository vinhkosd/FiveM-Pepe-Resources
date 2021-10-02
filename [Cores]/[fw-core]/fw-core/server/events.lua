-- Player joined
RegisterServerEvent("Framework:PlayerJoined")
AddEventHandler('Framework:PlayerJoined', function()
	local src = source
end)

AddEventHandler('playerDropped', function(reason) 
	local src = source
	TriggerClientEvent('Framework:Client:OnPlayerUnload', src)
	TriggerClientEvent('Framework:Player:UpdatePlayerPosition', src)
	TriggerEvent("fw-logs:server:SendLog", "joinleave", "Dropped", "red", "**".. GetPlayerName(src) .. "** ("..GetPlayerIdentifiers(src)[1]..") left..")
	if reason ~= "Reconnecting" and src > 60000 then return false end
	if(src==nil or (Framework.Players[src] == nil)) then return false end
	Framework.Players[src].Functions.Save()
	Framework.Players[src] = nil
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
	deferrals.defer()
	local src = source
	Wait(1500)
	deferrals.update("Checking name...")
	Wait(1500)
	local name = GetPlayerName(src)
	if name == nil then 
		Framework.Functions.Kick(src, 'Gelieve geen lege steam naam te gebruiken.', setKickReason, deferrals)
        CancelEvent()
        return false
	end
	if(string.match(name, "[*%%'=`\"]")) then
        Framework.Functions.Kick(src, 'Je hebt in je naam een teken('..string.match(name, "[*%%'=`\"]")..') zitten wat niet is toegestaan.\nGelieven deze uit je steam-naam te halen.', setKickReason, deferrals)
        CancelEvent()
        return false
	end
	if (string.match(name, "drop") or string.match(name, "table") or string.match(name, "database")) then
        Framework.Functions.Kick(src, 'Je hebt in je naam een woord (drop/table/database) zitten wat niet is toegestaan.\nGelieven je steam naam te veranderen.', setKickReason, deferrals)
        CancelEvent()
        return false
	end
	Wait(1500)
	deferrals.update("Checking identifiers...")
	Wait(1500)
    local identifiers = GetPlayerIdentifiers(src)
	local steamid = identifiers[1]
	local license = identifiers[2]
    if (Config.IdentifierType == "steam" and (steamid:sub(1,6) == "steam:") == false) then
        Framework.Functions.Kick(src, 'Je moet steam aan hebben staan om te spelen.', setKickReason, deferrals)
        CancelEvent()
		return false
	elseif (Config.IdentifierType == "license" and (steamid:sub(1,6) == "license:") == false) then
		Framework.Functions.Kick(src, 'Geen socialclub license gevonden.', setKickReason, deferrals)
        CancelEvent()
		return false
	end
	Wait(2500)
	deferrals.update("Checking ban status...")
	Wait(2500)
	local isBanned, Message = Framework.Functions.IsPlayerBanned(src)
    if (isBanned) then
		deferrals.update(Message)
        CancelEvent()
        return false
    end
	TriggerEvent("fw-logs:server:SendLog", "joinleave", "Queue", "orange", "**"..name .. "** ("..json.encode(GetPlayerIdentifiers(src))..") in queue..")
	TriggerEvent("connectqueue:playerConnect", src, setKickReason, deferrals)
end)

RegisterServerEvent("Framework:Server:TriggerCallback")
AddEventHandler('Framework:Server:TriggerCallback', function(name, ...)
	local src = source
	Framework.Functions.TriggerCallback(name, src, function(...)
		TriggerClientEvent("Framework:Client:TriggerCallback", src, name, ...)
	end, ...)
end)

RegisterServerEvent("Framework:UpdatePlayer")
AddEventHandler('Framework:UpdatePlayer', function(data)
	local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil then
		local newHunger = Player.PlayerData.metadata["hunger"] - 4.3
		local newThirst = Player.PlayerData.metadata["thirst"] - 4.3
		if newHunger <= 0 then newHunger = 0 end
		if newThirst <= 0 then newThirst = 0 end
		Player.PlayerData.position = data.position
		Player.Functions.SetMetaData("thirst", newThirst)
		Player.Functions.SetMetaData("hunger", newHunger)
		TriggerClientEvent("fw-hud:client:update:needs", source, newHunger, newThirst)
		Player.Functions.Save()
	end
end)

RegisterServerEvent("Framework:Salary")
AddEventHandler('Framework:Salary', function(data)
	local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil then
	 Player.Functions.AddMoney("bank", Player.PlayerData.job.payment)
	end
end)

RegisterServerEvent("Framework:UpdatePlayerPosition")
AddEventHandler("Framework:UpdatePlayerPosition", function(position)
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	if Player ~= nil then
		Player.PlayerData.position = position
	end
end)

RegisterServerEvent('Framework:Server:SetMetaData')
AddEventHandler('Framework:Server:SetMetaData', function(Meta, Data)
	local Player = Framework.Functions.GetPlayer(source)
	if Meta == 'hunger' or Meta == 'thirst' then
		if Data >= 100 then
			Data = 100
		end
	end
	if Player ~= nil then 
		Player.Functions.SetMetaData(Meta, Data)
	end
	TriggerClientEvent("fw-hud:client:update:needs", source, Player.PlayerData.metadata["hunger"], Player.PlayerData.metadata["thirst"])
end)

AddEventHandler('chatMessage', function(source, n, message)
	if string.sub(message, 1, 1) == "/" then
		local args = Framework.Shared.SplitStr(message, " ")
		local command = string.gsub(args[1]:lower(), "/", "")
		CancelEvent()
		if Framework.Commands.List[command] ~= nil then
			local Player = Framework.Functions.GetPlayer(tonumber(source))
			if Player ~= nil then
				table.remove(args, 1)
				if (Framework.Functions.HasPermission(source, "god") or Framework.Functions.HasPermission(source, Framework.Commands.List[command].permission)) then
					if (Framework.Commands.List[command].argsrequired and #Framework.Commands.List[command].arguments ~= 0 and args[#Framework.Commands.List[command].arguments] == nil) then
					    TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Alle argumenten moeten ingevuld worden!")
					    local agus = ""
					    for name, help in pairs(Framework.Commands.List[command].arguments) do
					    	agus = agus .. " ["..help.name.."]"
					    end
				        TriggerClientEvent('chatMessage', source, "/"..command, false, agus)
					else
						Framework.Commands.List[command].callback(source, args)
					end
				else
					TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je hebt geen toegang tot dit commando..")
				end
			end
		end
	end
end)

RegisterServerEvent('Framework:CallCommand')
AddEventHandler('Framework:CallCommand', function(command, args)
	if Framework.Commands.List[command] ~= nil then
		local Player = Framework.Functions.GetPlayer(tonumber(source))
		if Player ~= nil then
			if (Framework.Functions.HasPermission(source, "god")) or (Framework.Functions.HasPermission(source, Framework.Commands.List[command].permission)) or (Framework.Commands.List[command].permission == Player.PlayerData.job.name) then
				if (Framework.Commands.List[command].argsrequired and #Framework.Commands.List[command].arguments ~= 0 and args[#Framework.Commands.List[command].arguments] == nil) then
					TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Alle argumenten moeten ingevuld worden!")
					local agus = ""
					for name, help in pairs(Framework.Commands.List[command].arguments) do
						agus = agus .. " ["..help.name.."]"
					end
					TriggerClientEvent('chatMessage', source, "/"..command, false, agus)
				else
					Framework.Commands.List[command].callback(source, args)
				end
			else
				TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je hebt geen toegang tot dit commando..")
			end
		end
	end
end)

RegisterServerEvent("Framework:AddCommand")
AddEventHandler('Framework:AddCommand', function(name, help, arguments, argsrequired, callback, persmission)
	Framework.Commands.Add(name, help, arguments, argsrequired, callback, persmission)
end)

RegisterServerEvent("Framework:ToggleDuty")
AddEventHandler('Framework:ToggleDuty', function()
	local Player = Framework.Functions.GetPlayer(source)
	if not Player.PlayerData.job.onduty then
		Player.Functions.SetJobDuty(true)
		TriggerClientEvent('Framework:Notify', source, "Je bent nu in dienst!")
		TriggerClientEvent("Framework:Client:SetDuty", source, true)
		if Player.PlayerData.job.name == 'police' then
			TriggerEvent("fw-police:server:UpdateCurrentCops")
			TriggerClientEvent('fw-radialmenu:client:update:duty:vehicles', source)
		end
	else
		Player.Functions.SetJobDuty(false)
		TriggerClientEvent('Framework:Notify', source, "Je bent nu uit dienst!")
		TriggerClientEvent("Framework:Client:SetDuty", source, false)
		if Player.PlayerData.job.name == 'police' then
			TriggerEvent("fw-police:server:UpdateCurrentCops")
			TriggerClientEvent('fw-radialmenu:client:update:duty:vehicles', source)
		end
 	end
end)

Citizen.CreateThread(function()
	Framework.Functions.ExecuteSql(true, "SELECT * FROM `server_extra`", function(result)
		if result[1] ~= nil then
		 for k, v in pairs(result) do
		 	Framework.Config.Server.PermissionList[v.steam] = {
		 		steam = v.steam,
		 		license = v.license,
		 		permission = v.permission,
		 		optin = true,
		 	}
		 end
	  end
	end)
end)

RegisterServerEvent("Framework:Server:UseItem")
AddEventHandler('Framework:Server:UseItem', function(item)
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	if item ~= nil and item.amount > 0 then
		if Framework.Functions.CanUseItem(item.name) then
			Framework.Functions.UseItem(src, item)
		end
	end
end)

RegisterServerEvent("Framework:Server:RemoveItem")
AddEventHandler('Framework:Server:RemoveItem', function(itemName, amount, slot)
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	Player.Functions.RemoveItem(itemName, amount, slot)
end)

Framework.Functions.CreateCallback('Framework:HasItem', function(source, cb, itemName)
	local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil then
		if Player.Functions.GetItemByName(itemName) ~= nil then
			cb(true)
		else
			cb(false)
		end
	end
end)	