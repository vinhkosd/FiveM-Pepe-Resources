Framework.Functions = {}

Framework.Functions.ExecuteSql = function(wait, query, cb)
	local rtndata = {}
	local waiting = true
	exports['ghmattimysql']:execute(query, {}, function(data)
		if cb ~= nil and wait == false then
			cb(data)
		end
		rtndata = data
		waiting = false
	end)
	if wait then
		while waiting do
			Citizen.Wait(5)
		end
		if cb ~= nil and wait == true then
			cb(rtndata)
		end
	end
	return rtndata
end

Framework.Functions.GetIdentifier = function(source, idtype)
	local idtype = idtype ~=nil and idtype or Config.IdentifierType
	for _, identifier in pairs(GetPlayerIdentifiers(source)) do
		if string.find(identifier, idtype) then
			return identifier
		end
	end
	return nil
end

Framework.Functions.GetSource = function(identifier)
	for src, player in pairs(Framework.Players) do
		local idens = GetPlayerIdentifiers(src)
		for _, id in pairs(idens) do
			if identifier == id then
				return src
			end
		end
	end
	return 0
end

Framework.Functions.GetPlayer = function(source)
	if type(source) == "number" then
		return Framework.Players[source]
	else
		return Framework.Players[Framework.Functions.GetSource(source)]
	end
end

Framework.Functions.GetPlayerByCitizenId = function(citizenid)
	for src, player in pairs(Framework.Players) do
		local cid = citizenid
		if Framework.Players[src].PlayerData.citizenid == cid then
			return Framework.Players[src]
		end
	end
	return nil
end

Framework.Functions.GetPlayerByPhone = function(number)
	for src, player in pairs(Framework.Players) do
		local cid = citizenid
		if Framework.Players[src].PlayerData.charinfo.phone == number then
			return Framework.Players[src]
		end
	end
	return nil
end

Framework.Functions.GetPlayers = function()
	local sources = {}
	for k, v in pairs(Framework.Players) do
		table.insert(sources, k)
	end
	return sources
end

Framework.Functions.CreateCallback = function(name, cb)
	Framework.ServerCallbacks[name] = cb
end

Framework.Functions.TriggerCallback = function(name, source, cb, ...)
	if Framework.ServerCallbacks[name] ~= nil then
		Framework.ServerCallbacks[name](source, cb, ...)
	end
end

Framework.Functions.CreateUseableItem = function(item, cb)
	Framework.UseableItems[item] = cb
end

Framework.Functions.CanUseItem = function(item)
	return Framework.UseableItems[item] ~= nil
end

Framework.Functions.UseItem = function(source, item)
	Framework.UseableItems[item.name](source, item)
end

Framework.Functions.Kick = function(source, reason, setKickReason, deferrals)
	local src = source
	reason = "\n"..reason.."\n🔸 Kijk op onze discord voor meer informatie: "..Framework.Config.Server.discord
	if(setKickReason ~=nil) then
		setKickReason(reason)
	end
	Citizen.CreateThread(function()
		if(deferrals ~= nil)then
			deferrals.update(reason)
			Citizen.Wait(2500)
		end
		if src ~= nil then
			DropPlayer(src, reason)
		end
		local i = 0
		while (i <= 4) do
			i = i + 1
			while true do
				if src ~= nil then
					if(GetPlayerPing(src) >= 0) then
						break
					end
					Citizen.Wait(100)
					Citizen.CreateThread(function() 
						DropPlayer(src, reason)
					end)
				end
			end
			Citizen.Wait(5000)
		end
	end)
end

Framework.Functions.AddPermission = function(source, permission)
	local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil then 
		Framework.Config.Server.PermissionList[GetPlayerIdentifiers(source)[1]] = {
			steam = GetPlayerIdentifiers(source)[1],
			license = GetPlayerIdentifiers(source)[2],
			permission = permission:lower(),
		}
		Framework.Functions.ExecuteSql(true, "UPDATE `server_extra` SET permission='"..permission:lower().."' WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."'")
		Player.Functions.UpdatePlayerData()
	end
end

Framework.Functions.RemovePermission = function(source)
	local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil then 
		Framework.Config.Server.PermissionList[GetPlayerIdentifiers(source)[1]] = nil
		Framework.Functions.ExecuteSql(true, "UPDATE `server_extra` SET permission='user' WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."'")
		Player.Functions.UpdatePlayerData()
	end
end

Framework.Functions.HasPermission = function(source, permission)
	local retval = false
	local steamid = GetPlayerIdentifiers(source)[1]
	local licenseid = GetPlayerIdentifiers(source)[2]
	local permission = tostring(permission:lower())
	if permission == "user" then
		retval = true
	else
		if Framework.Config.Server.PermissionList[steamid] ~= nil then 
			if Framework.Config.Server.PermissionList[steamid].steam == steamid and Framework.Config.Server.PermissionList[steamid].license == licenseid then
				if Framework.Config.Server.PermissionList[steamid].permission == permission or Framework.Config.Server.PermissionList[steamid].permission == "god" then
					retval = true
				end
			end
		end
	end
	return retval
end

Framework.Functions.GetPermission = function(source)
	local retval = "user"
	Player = Framework.Functions.GetPlayer(source)
	local steamid = GetPlayerIdentifiers(source)[1]
	local licenseid = GetPlayerIdentifiers(source)[2]
	if Player ~= nil then
		if Framework.Config.Server.PermissionList[Player.PlayerData.steam] ~= nil then 
			if Framework.Config.Server.PermissionList[Player.PlayerData.steam].steam == steamid and Framework.Config.Server.PermissionList[Player.PlayerData.steam].license == licenseid then
				retval = Framework.Config.Server.PermissionList[Player.PlayerData.steam].permission
			end
		end
	end
	return retval
end

Framework.Functions.IsOptin = function(source)
	local retval = false
	local steamid = GetPlayerIdentifiers(source)[1]
	if Framework.Functions.HasPermission(source, "admin") then
		retval = Framework.Config.Server.PermissionList[steamid].optin
	end
	return retval
end

Framework.Functions.ToggleOptin = function(source)
	local steamid = GetPlayerIdentifiers(source)[1]
	if Framework.Functions.HasPermission(source, "admin") then
		Framework.Config.Server.PermissionList[steamid].optin = not Framework.Config.Server.PermissionList[steamid].optin
	end
end


Framework.Functions.RefreshPerms = function()
 Framework.Config.Server.PermissionList = {}
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
end

Framework.Functions.IsPlayerBanned = function(source)
	local IsBanned = nil
	local Message = nil
	Framework.Functions.ExecuteSql(true, "SELECT * FROM `server_bans` WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."' OR `license` = '"..GetPlayerIdentifiers(source)[2].."'", function(result)
		if result[1] ~= nil then
			Message = "\n🔰 Je bent verbannen van de server. \n🛑 Reden: " ..result[1].reason.. '\n Ban ID: '..result[1].banid..' \n🛑 Verbannen Door: ' ..result[1].bannedby.. '\n\n Voor een unban kan je een ticket openen in de discord.'
			IsBanned = true
		else
			IsBanned = false
		end
	end)
	return IsBanned, Message
end