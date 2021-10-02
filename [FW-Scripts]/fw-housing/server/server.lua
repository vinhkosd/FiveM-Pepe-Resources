Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Functions.CreateCallback("fw-housing:server:get:config", function(source, cb)
    cb(Config)
end)

Citizen.CreateThread(function()
    Citizen.SetTimeout(450, function()
        Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_houses`", function(result)
            if result[1] ~= nil then
                for k, v in pairs(result) do
                    if v.owned == 'true' then
                        Owned = true
                    else
                        Owned = false
                    end
                    Config.Houses[v.name] = {
                        ['Coords'] = json.decode(v.coords),
                        ['Owned'] = Owned,
                        ['Owner'] = v.citizenid,
                        ['Tier'] = v.tier,
                        ['Price'] = v.price,
                        ['Door-Lock'] = true,
                        ['Adres'] = v.label,
                        ['Garage'] = json.decode(v.garage),
                        ['Key-Holders'] = json.decode(v.keyholders),
                        ['Decorations'] = {}
                    }
                    Citizen.Wait(150)
                    TriggerClientEvent("fw-housing:client:add:to:config", -1, v.name, v.citizenid, json.decode(v.coords), Owned, v.tier, v.price, true, json.decode(v.keyholders), v.label, json.decode(v.garage))
                end
            end
        end)
    end)
end)

Framework.Functions.CreateCallback('fw-housing:server:has:house:key', function(source, cb, HouseId)
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	local retval = false
	if Player ~= nil then 
        for key, housekey in pairs(Config.Houses[HouseId]['Key-Holders']) do
            if housekey == Player.PlayerData.citizenid then
                cb(true)
            end
        end
    end
	cb(false)
end)

Framework.Functions.CreateCallback('fw-housing:server:get:decorations', function(source, cb, house)
	local retval = nil
	Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_houses` WHERE `name` = '"..house.."'", function(result)
		if result[1] ~= nil then
			if result[1].decorations ~= nil then
				retval = json.decode(result[1].decorations)
			end
		end
		cb(retval)
	end)
end)

Framework.Functions.CreateCallback('fw-housing:server:get:locations', function(source, cb, HouseId)
	local retval = nil
	Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_houses` WHERE `name` = '"..HouseId.."'", function(result)
		if result[1] ~= nil then
			retval = result[1]
		end
		cb(retval)
	end)
end)

Framework.Functions.CreateCallback('fw-phone:server:GetPlayerHouses', function(source, cb)
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
    local MyHouses = {}
	Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_houses` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
            table.insert(MyHouses, {
                name = v.name,
                keyholders = {},
                owner = Player.PlayerData.citizenid,
                price = Config.Houses[v.name]['Price'],
                label = Config.Houses[v.name]['Adres'],
                tier = Config.Houses[v.name]['Tier'],
                garage = v.hasgarage,
            })
            if v.keyholders ~= nil then
             local KeyHolders = json.decode(v.keyholders)
             for key, keyholder in pairs(KeyHolders) do
	           Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_metadata` WHERE `citizenid` = '"..keyholder.."'", function(result)   
                    if result ~= nil then
                        result[1].charinfo = json.decode(result[1].charinfo )
                        table.insert(MyHouses[k].keyholders, result[1])
                    end
               end)
             end
            end
          end
        else
        table.insert(MyHouses, {})
      end
      SetTimeout(100, function()
        cb(MyHouses)
    end)
    end)
end)

Framework.Functions.CreateCallback('fw-phone:server:GetHouseKeys', function(source, cb)
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	local MyKeys = {}
	Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_houses`", function(result)
		for k, v in pairs(result) do
			if v.keyholders ~= "null" then
				v.keyholders = json.decode(v.keyholders)
				for s, p in pairs(v.keyholders) do
					if p == Player.PlayerData.citizenid and (v.citizenid ~= Player.PlayerData.citizenid) then
						table.insert(MyKeys, {
							HouseData = Config.Houses[v.name]
						})
					end
				end
			end

			if v.citizenid == Player.PlayerData.citizenid then
				table.insert(MyKeys, {
					HouseData = Config.Houses[v.name]
				})
			end
		end
		cb(MyKeys)
	end)
end)

Framework.Functions.CreateCallback('fw-phone:server:TransferCid', function(source, cb, NewCid, house)
	Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_metadata` WHERE `citizenid` = '"..NewCid.."'", function(result)
        if result[1] ~= nil then
            local src = source
            local HouseName = house.name
            local Player = Framework.Functions.GetPlayer(src)
            Config.Houses[HouseName]['Owner'] = NewCid
            Config.Houses[HouseName]['Key-Holders'] = {
                [1] = NewCid
            }
			Framework.Functions.ExecuteSql(false, "UPDATE `characters_houses` SET citizenid='"..NewCid.."', keyholders = '[\""..NewCid.."\"]' WHERE `name` = '"..HouseName.."'")
			cb(true)
		else
			cb(false)
		end
	end)
end)

RegisterServerEvent('fw-housing:server:view:house')
AddEventHandler('fw-housing:server:view:house', function(HouseId)
 local src = source
 local Player = Framework.Functions.GetPlayer(src) 
 local houseprice = Config.Houses[HouseId]['Price']
 local brokerfee = (houseprice / 100 * 5)
 local bankfee = (houseprice / 100 * 10) 
 local taxes = (houseprice / 100 * 6) 
 TriggerClientEvent('fw-housing:client:view:house', src, houseprice, brokerfee, bankfee, taxes, Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
end)

RegisterServerEvent('fw-housing:server:buy:house')
AddEventHandler('fw-housing:server:buy:house', function(HouseId)
  local src = source
  local Player = Framework.Functions.GetPlayer(src)
  local HousePrice = math.ceil(Config.Houses[HouseId]['Price'] * 1.21)
  if Player.PlayerData.money['bank'] >= HousePrice then
    Framework.Functions.ExecuteSql(true, "UPDATE `characters_houses` SET citizenid='"..Player.PlayerData.citizenid.."', owned='true', keyholders = '[\""..Player.PlayerData.citizenid.."\"]' WHERE `name` = '"..HouseId.."'")
    Player.Functions.RemoveMoney('bank', HousePrice, "Bought House")
    Config.Houses[HouseId]['Key-Holders'] = {
        [1] = Player.PlayerData.citizenid
    }
    Config.Houses[HouseId]['Owned'] = true
    Config.Houses[HouseId]['Owner'] = Player.PlayerData.citizenid
    TriggerClientEvent('Framework:Notify', src, "Je hebt een huis gekocht: "..Config.Houses[HouseId]['Adres'], 'success', 8500)
    TriggerClientEvent('fw-housing:client:set:owned', -1, HouseId, true, Player.PlayerData.citizenid)
  end
end)

RegisterServerEvent('fw-housing:server:add:new:house')
AddEventHandler('fw-housing:server:add:new:house', function(StreetName, CoordsTable, Price, Tier)
    local src = source
    local Price, Tier = tonumber(Price), tonumber(Tier)
    local Street = StreetName:gsub("%'", "")
    local HouseNumber = GetFreeHouseNumber(Street)
    local Name, Label = Street:lower()..tostring(HouseNumber), Street..' '..tostring(HouseNumber)
    Framework.Functions.ExecuteSql(true, "INSERT INTO `characters_houses` (`name`, `label`, `price`, `tier`, `owned`, `coords`, `keyholders`) VALUES ('"..Name.."', '"..Label.."', "..Price..", "..Tier..", 'false', '"..json.encode(CoordsTable).."', '{}')")
    Config.Houses[Name] = {
        ['Coords'] = CoordsTable,
        ['Owned'] = false,
        ['Owner'] = nil,
        ['Tier'] = Tier,
        ['Price'] = Price,
        ['Door-Lock'] = true,
        ['Adres'] = Label,
        ['Garage'] = {},
        ['Key-Holders'] = {},
        ['Decorations'] = {}
    }
    TriggerClientEvent('fw-housing:client:add:to:config', -1, Name, nil, CoordsTable, false, Tier, Price, true, {}, Label)
    TriggerClientEvent('Framework:Notify', src, "Je hebt een huis toegevoegd: "..Label, 'info', 8500)
end)

RegisterServerEvent('fw-housing:server:add:garage')
AddEventHandler('fw-housing:server:add:garage', function(HouseId, HouseName, Coords)
	local src = source
	Framework.Functions.ExecuteSql(false, "UPDATE `characters_houses` SET `garage` = '"..json.encode(Coords).."', `hasgarage` = 'true' WHERE `name` = '"..HouseId.."'")
    Config.Houses[HouseId]['Garage'] = Coords
    TriggerClientEvent('fw-housing:client:set:garage', -1, HouseId, Coords)
	TriggerClientEvent('Framework:Notify', src, "Je hebt een garage toegevoegd bij: "..HouseName)
end)

RegisterServerEvent('fw-housing:server:save:decorations')
AddEventHandler('fw-housing:server:save:decorations', function(house, decorations)
 Framework.Functions.ExecuteSql(false, "UPDATE `characters_houses` SET `decorations` = '"..json.encode(decorations).."' WHERE `name` = '"..house.."'")
 TriggerClientEvent("fw-housing:server:sethousedecorations", -1, house, decorations)
end)

RegisterServerEvent('fw-housing:server:give:keys')
AddEventHandler('fw-housing:server:give:keys', function(HouseId, Target)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local TargetPlayer = Framework.Functions.GetPlayer(Target)
    if TargetPlayer ~= nil then
        TriggerClientEvent('Framework:Notify', TargetPlayer.PlayerData.source, "Je hebt huis sleutels ontvangen: "..Config.Houses[HouseId]['Adres'], 'success', 8500)
        table.insert(Config.Houses[HouseId]['Key-Holders'], TargetPlayer.PlayerData.citizenid)
        Framework.Functions.ExecuteSql(false, "UPDATE `characters_houses` SET `keyholders` = '"..json.encode(Config.Houses[HouseId]['Key-Holders']).."' WHERE `name` = '"..HouseId.."'")
    end
end)

RegisterServerEvent('fw-housing:server:logout')
AddEventHandler('fw-housing:server:logout', function()
 local src = source
 local Player = Framework.Functions.GetPlayer(src)
 local PlayerItems = Player.PlayerData.items
 TriggerClientEvent('fw-radio:onRadioDrop', src)
 if PlayerItems ~= nil then
    Framework.Functions.ExecuteSql(true, "UPDATE `characters_metadata` SET `inventory` = '"..Framework.EscapeSqli(json.encode(MyItems)).."' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
 else
    Framework.Functions.ExecuteSql(true, "UPDATE `characters_metadata` SET `inventory` = '{}' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
 end
 Framework.Player.Logout(src)
 Citizen.Wait(450)
 TriggerClientEvent('fw-multichar:client:open:select', src)
end)

RegisterServerEvent('fw-housing:server:set:location')
AddEventHandler('fw-housing:server:set:location', function(HouseId, CoordsTable, Type)
    local src = source
	local Player = Framework.Functions.GetPlayer(src)
	if Type == 'stash' then
		Framework.Functions.ExecuteSql(true, "UPDATE `characters_houses` SET `stash` = '"..json.encode(CoordsTable).."' WHERE `name` = '"..HouseId.."'")
	elseif Type == 'clothes' then
		Framework.Functions.ExecuteSql(true, "UPDATE `characters_houses` SET `outfit` = '"..json.encode(CoordsTable).."' WHERE `name` = '"..HouseId.."'")
	elseif Type == 'logout' then
		Framework.Functions.ExecuteSql(true, "UPDATE `characters_houses` SET `logout` = '"..json.encode(CoordsTable).."' WHERE `name` = '"..HouseId.."'")
	end
	TriggerClientEvent('fw-housing:client:refresh:location', -1, HouseId, CoordsTable, Type)
end)

RegisterServerEvent('fw-housing:server:ring:door')
AddEventHandler('fw-housing:server:ring:door', function(HouseId)
    local src = source
    TriggerClientEvent('fw-housing:client:ringdoor', -1, src, HouseId)
end)

RegisterServerEvent('fw-housing:server:open:door')
AddEventHandler('fw-housing:server:open:door', function(Taget, HouseId)
    local OtherPlayer = Framework.Functions.GetPlayer(Taget)
    if OtherPlayer ~= nil then
        TriggerClientEvent('fw-housing:client:set:in:house', OtherPlayer.PlayerData.source, HouseId)
    end
end)

RegisterServerEvent('fw-housing:server:remove:house:key')
AddEventHandler('fw-housing:server:remove:house:key', function(HouseId, CitizenId)
	local src = source
    local NewKeyHolders = {}
    if Config.Houses[HouseId]['Key-Holders'] ~= nil then
        for k, v in pairs(Config.Houses[HouseId]['Key-Holders']) do
            if Config.Houses[HouseId]['Key-Holders'][k] ~= CitizenId then
                table.insert(NewKeyHolders, Config.Houses[HouseId]['Key-Holders'][k])
            end
        end
    end
    Config.Houses[HouseId]['Key-Holders'] = NewKeyHolders
	TriggerClientEvent('fw-housing:client:set:new:key:holders', -1, HouseId, NewKeyHolders)
	TriggerClientEvent('Framework:Notify', src, "sleutels zijn verwijderd..", 'error', 3500)
	Framework.Functions.ExecuteSql(false, "UPDATE `characters_houses` SET `keyholders` = '"..json.encode(NewKeyHolders).."' WHERE `name` = '"..HouseId.."'")
end)

RegisterServerEvent('fw-housing:server:set:house:door')
AddEventHandler('fw-housing:server:set:house:door', function(HouseId, bool)
    Config.Houses[HouseId]['Door-Lock'] = bool
    TriggerClientEvent('fw-housing:client:set:house:door', -1, HouseId, bool)
end)

RegisterServerEvent('fw-housing:server:detlete:house')
AddEventHandler('fw-housing:server:detlete:house', function(HouseId)
    Config.Houses[HouseId] = {}
    Framework.Functions.ExecuteSql(false, "DELETE FROM `characters_houses` WHERE `name` = '"..HouseId.."'")
    TriggerClientEvent('Framework:Notify', source, '['..HouseId.."] Huis is verwijderd.", 'error', 3500)
    TriggerClientEvent('fw-housing:client:delete:successful', -1, HouseId)
end)

Framework.Commands.Add("createhouse", "Maak een huis aan als makelaar", {{name="price", help="Prijs van het huis"}, {name="tier", help="Huizen: [1 / 2 / 3 / 4 / 5 / 6 / 7 / 8 / 9 / 10] Garages: [11 / 12]"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(source)
	local price = tonumber(args[1])
	local tier = tonumber(args[2])
	if Player.PlayerData.job.name == "realestate" then
        if tier <= 12 then
		    TriggerClientEvent("fw-housing:client:create:house", source, price, tier)
        else
            TriggerClientEvent('Framework:Notify', source, "Deze tier bestaat niet..", "error")
        end
	end
end)

Framework.Commands.Add("deletehouse", "Verwijder het huis waar je nu staat", {}, false, function(source, args)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == "realestate" then
		TriggerClientEvent("fw-housing:client:delete:house", source)
    else
        TriggerClientEvent('Framework:Notify', source, "Deze tier bestaat niet..", "error")
	end
end)

Framework.Commands.Add("addgarage", "Garage toevoegen bij het huis waar ", {}, false, function(source, args)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == "realestate" then
		TriggerClientEvent("fw-housing:client:add:garage", source)
	end
end)

Framework.Commands.Add("ring", "Aanbellen bij huis", {}, false, function(source, args)
    TriggerClientEvent('fw-housing:client:ring:door', source)
end)

Framework.Functions.CreateUseableItem("police_stormram", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
		TriggerClientEvent("fw-housing:client:breaking:door", source)
	else
		TriggerClientEvent('Framework:Notify', source, "Dit is alleen mogelijk voor hulpdiensten!", "error")
	end
end)

-- Functions \\ --

function GetFreeHouseNumber(StreetName)
    local count = 1
	Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_houses` WHERE `name` LIKE '%"..StreetName.."%'", function(result)
		if result[1] ~= nil then
			for i = 1, #result, 1 do
				count = count + 1
			end
		end
		return count
	end)
	return count
end


