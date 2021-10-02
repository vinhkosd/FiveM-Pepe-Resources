Framework.Commands = {}
Framework.Commands.List = {}

Framework.Commands.Add = function(name, help, arguments, argsrequired, callback, permission) -- [name] = command name (ex. /givemoney), [help] = help text, [arguments] = arguments that need to be passed (ex. {{name="id", help="ID of a player"}, {name="amount", help="amount of money"}}), [argsrequired] = set arguments required (true or false), [callback] = function(source, args) callback, [permission] = rank or job of a player
	Framework.Commands.List[name:lower()] = {
		name = name:lower(),
		permission = permission ~= nil and permission:lower() or "user",
		help = help,
		arguments = arguments,
		argsrequired = argsrequired,
		callback = callback,
	}
end

Framework.Commands.Refresh = function(source)
	local Player = Framework.Functions.GetPlayer(tonumber(source))
	if Player ~= nil then
		for command, info in pairs(Framework.Commands.List) do
			if Framework.Functions.HasPermission(source, "god") or Framework.Functions.HasPermission(source, Framework.Commands.List[command].permission) or true then
				TriggerClientEvent('chat:addSuggestion', source, "/"..command, info.help, info.arguments)
			end
		end
	end
end

Framework.Commands.Add("tp", "Dịch chuyển đến một người chơi hoặc tọa độ", {{name="id/x", help="ID van een Player of X positie"}, {name="y", help="Y positie"}, {name="z", help="Z positie"}}, false, function(source, args)
	if (args[1] ~= nil and (args[2] == nil and args[3] == nil)) then
		-- tp to player
		local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('Framework:Command:TeleportToPlayer', source, Player.PlayerData.source)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Người chơi không online!")
		end
	else
		-- tp to location
		if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
			local x = tonumber(args[1])
			local y = tonumber(args[2])
			local z = tonumber(args[3])
			TriggerClientEvent('Framework:Command:TeleportToCoords', source, x, y, z)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Nhập đúng định dạng (x, y, z)")
		end
	end
end, "admin")

Framework.Commands.Add("addpermission", "Give permission to someone (god/admin)", {{name="id", help="ID Player"}, {name="permission", help="Permission level"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
	local permission = tostring(args[2]):lower()
	if Player ~= nil then
		Framework.Functions.AddPermission(Player.PlayerData.source, permission)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Người chơi không online!")	
	end
end, "god")

Framework.Commands.Add("removepermission", "Remove permission from someone", {{name="id", help="ID Player"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Framework.Functions.RemovePermission(Player.PlayerData.source)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Người chơi không online!")	
	end
end, "god")

Framework.Commands.Add("sv", "Spawn xe", {{name="model", help="Vehicle model name"}}, true, function(source, args)
	TriggerClientEvent('Framework:Command:SpawnVehicle', source, args[1])
end, "admin")

Framework.Commands.Add("debug", "Turn on/off debug mode", {}, false, function(source, args)
	TriggerClientEvent('koil-debug:toggle', source)
end, "admin")

Framework.Commands.Add("closenui", "Turn off a nui screen", {}, false, function(source, args)
	TriggerClientEvent('fw-core:client:closenui', source)
end)

Framework.Commands.Add("opennui", "Open a nui screen", {}, false, function(source, args)
	TriggerClientEvent('fw-core:client:opennui', source)
end)

Framework.Commands.Add("dv", "Delete a vehicle", {}, false, function(source, args)
	TriggerClientEvent('Framework:Command:DeleteVehicle', source)
end, "admin")

Framework.Commands.Add("tpm", "Teleport to waypoint", {}, false, function(source, args)
	TriggerClientEvent('Framework:Command:GoToMarker', source)
end, "admin")

Framework.Commands.Add("givemoney", "Give money to a Player", {{name="id", help="Player ID"},{name="moneytype", help="Type geld (cash, bank, crypto)"}, {name="amount", help="Money amount"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Người chơi không online!")
	end
end, "admin")

Framework.Commands.Add("setmoney", "Set Player Money", {{name="id", help="Player ID"},{name="moneytype", help="Type geld (cash, bank, crypto)"}, {name="amount", help="Money amount"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetMoney(tostring(args[2]), tonumber(args[3]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Người chơi không online!")
	end
end, "admin")

Framework.Commands.Add("setjob", "Give a job to a Player", {{name="id", help="Player ID"}, {name="job", help="Job name"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetJob(tostring(args[2]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Người chơi không online!")
	end
end, "admin")

Framework.Commands.Add("job", "Xem job của bạn là gì", {}, false, function(source, args)
	local Player = Framework.Functions.GetPlayer(source)
	TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Nghề nghiệp: "..Player.PlayerData.job.label)
end)

Framework.Commands.Add("clearinv", "Clear Player Inventory", {{name="id", help="Player ID"}}, false, function(source, args)
	local playerId = args[1] ~= nil and args[1] or source 
	local Player = Framework.Functions.GetPlayer(tonumber(playerId))
	if Player ~= nil then
		Player.Functions.ClearInventory()
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Người chơi không online!")
	end
end, "admin")

Framework.Commands.Add("ooc", "Out Of Character chat bericht (alleen gebruiken wanneer nodig)", {}, false, function(source, args)
	local message = table.concat(args, " ")
	TriggerClientEvent("Framework:Client:LocalOutOfCharacter", -1, source, GetPlayerName(source), message)
	local Players = Framework.Functions.GetPlayers()

	for k, v in pairs(Framework.Functions.GetPlayers()) do
		if Framework.Functions.HasPermission(v, "admin") then
			if Framework.Functions.IsOptin(v) then
				TriggerClientEvent('chatMessage', v, "OOC | " .. GetPlayerName(source), "normal", message)
			end
		end
	end
end)

Framework.Commands.Add("me", "Xem ID cá nhân", {}, false, function(source, args)
	TriggerClientEvent('chatMessage', v, "ID: " .. (source), "normal")
end)