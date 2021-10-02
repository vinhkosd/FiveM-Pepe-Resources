Framework.Players = {}
Framework.Player = {}

Framework.Player.Login = function(Source, IsCharNew, CitizenId, newData)
	if Source ~= nil then
		if IsCharNew then
			local PlayerData = {}
			PlayerData.cid = newData.cid
			PlayerData.charinfo = {
			  firstname = newData.firstname,
			  lastname = newData.lastname,
			  birthdate = newData.birthdate,
			  gender = newData.gender,
			  nationality = newData.nationality,
			}
		  Framework.Player.CheckPlayerData(Source, PlayerData)
		  return true
		else
		 Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_metadata` WHERE `citizenid` = '"..CitizenId.."'", function(result)
		 	local PlayerData = result[1]
		 	if PlayerData ~= nil then
		 		PlayerData.money = json.decode(PlayerData.money)
				PlayerData.position = json.decode(PlayerData.position)
				PlayerData.job = json.decode(PlayerData.job)
		 		PlayerData.metadata = json.decode(PlayerData.globals)
		 		PlayerData.charinfo = json.decode(PlayerData.charinfo)
			 end	
			 Framework.Player.CheckPlayerData(Source, PlayerData)		
		 end)
		 return true
		end
	end
end

Framework.Player.CheckPlayerData = function(source, PlayerData)
	PlayerData = PlayerData ~= nil and PlayerData or {}
	PlayerData.source = source
	PlayerData.citizenid = PlayerData.citizenid ~= nil and PlayerData.citizenid or Framework.Player.CreateCitizenId()
	PlayerData.steam = PlayerData.steam ~= nil and PlayerData.steam or Framework.Functions.GetIdentifier(source, "steam")
	PlayerData.license = PlayerData.license ~= nil and PlayerData.license or Framework.Functions.GetIdentifier(source, "license")
	PlayerData.name = GetPlayerName(source)
	PlayerData.cid = PlayerData.cid ~= nil and PlayerData.cid or 1

	PlayerData.money = PlayerData.money ~= nil and PlayerData.money or {}
	for moneytype, startamount in pairs(Framework.Config.Money.MoneyTypes) do
		PlayerData.money[moneytype] = PlayerData.money[moneytype] ~= nil and PlayerData.money[moneytype] or startamount
	end

	PlayerData.charinfo = PlayerData.charinfo ~= nil and PlayerData.charinfo or {}
	PlayerData.charinfo.firstname = PlayerData.charinfo.firstname ~= nil and PlayerData.charinfo.firstname or "Firstname"
	PlayerData.charinfo.lastname = PlayerData.charinfo.lastname ~= nil and PlayerData.charinfo.lastname or "Lastname"
	PlayerData.charinfo.birthdate = PlayerData.charinfo.birthdate ~= nil and PlayerData.charinfo.birthdate or "00-00-0000"
	PlayerData.charinfo.gender = PlayerData.charinfo.gender ~= nil and PlayerData.charinfo.gender or 0
	PlayerData.charinfo.nationality = PlayerData.charinfo.nationality ~= nil and PlayerData.charinfo.nationality or "Nederlands"
	PlayerData.charinfo.phone = PlayerData.charinfo.phone ~= nil and PlayerData.charinfo.phone or "06"..math.random(11111111, 99999999)
	PlayerData.charinfo.account = PlayerData.charinfo.account ~= nil and PlayerData.charinfo.account or "NL0"..math.random(1,9)..Framework.Shared.RandomInt(3):upper()..math.random(1111,9999)..math.random(1111,9999)..math.random(11,99)
    PlayerData.metadata = PlayerData.metadata ~= nil and PlayerData.metadata or {}
    -- // Health Shit \\ --
    PlayerData.metadata["health"]  = PlayerData.metadata["health"]  ~= nil and PlayerData.metadata["health"] or 200
    PlayerData.metadata["armor"]  = PlayerData.metadata["armor"]  ~= nil and PlayerData.metadata["armor"] or 0
	PlayerData.metadata["hunger"] = PlayerData.metadata["hunger"] ~= nil and PlayerData.metadata["hunger"] or 100
	PlayerData.metadata["thirst"] = PlayerData.metadata["thirst"] ~= nil and PlayerData.metadata["thirst"] or 100
    PlayerData.metadata["stamina"] = PlayerData.metadata["stamina"] ~= nil and PlayerData.metadata["stamina"] or 100
    PlayerData.metadata["stress"] = PlayerData.metadata["stress"] ~= nil and PlayerData.metadata["stress"] or 0
	PlayerData.metadata["adrenaline"] = PlayerData.metadata["adrenaline"] ~= nil and PlayerData.metadata["adrenaline"] or 0
	PlayerData.metadata["isdead"] = PlayerData.metadata["isdead"] ~= nil and PlayerData.metadata["isdead"] or false
	PlayerData.metadata["medicalstate"] = PlayerData.metadata["medicalstate"] ~= nil and PlayerData.metadata["medicalstate"] or false
	PlayerData.metadata["inventorydisabled"] = PlayerData.metadata["inventorydisabled"] ~= nil and PlayerData.metadata["inventorydisabled"] or false
	-- // DNA \\ --
	PlayerData.metadata["bloodtype"] = PlayerData.metadata["bloodtype"] ~= nil and PlayerData.metadata["bloodtype"] or Framework.Config.Player.Bloodtypes[math.random(1, #Framework.Config.Player.Bloodtypes)]
	PlayerData.metadata["fingerprint"] = PlayerData.metadata["fingerprint"] ~= nil and PlayerData.metadata["fingerprint"] or Framework.Player.CreateDnaId('finger')
	PlayerData.metadata["slimecode"] = PlayerData.metadata["slimecode"] ~= nil and PlayerData.metadata["slimecode"] or Framework.Player.CreateDnaId('slime')
    PlayerData.metadata["haircode"] = PlayerData.metadata["haircode"] ~= nil and PlayerData.metadata["haircode"] or Framework.Player.CreateDnaId('hair')
    -- // Reputations \\ --
    PlayerData.metadata["dealerrep"] = PlayerData.metadata["dealerrep"] ~= nil and PlayerData.metadata["dealerrep"] or 0
	PlayerData.metadata["craftingrep"] = PlayerData.metadata["craftingrep"] ~= nil and PlayerData.metadata["craftingrep"] or 0
	PlayerData.metadata["attachmentcraftingrep"] = PlayerData.metadata["attachmentcraftingrep"] ~= nil and PlayerData.metadata["attachmentcraftingrep"] or 0
	-- // Work Shizzle \\ --
	PlayerData.metadata["jailitems"] = PlayerData.metadata["jailitems"] ~= nil and PlayerData.metadata["jailitems"] or {}
	PlayerData.metadata["callsign"] = PlayerData.metadata["callsign"] ~= nil and PlayerData.metadata["callsign"] or "NO CALLSIGN"
	PlayerData.metadata["duty-vehicles"] = PlayerData.metadata["duty-vehicles"] ~= nil and PlayerData.metadata["duty-vehicles"] or {Standard = false, Audi = false, Unmarked = false, Motor = false, Heli = false}
	PlayerData.metadata["ishighcommand"] = PlayerData.metadata["ishighcommand"] ~= nil and PlayerData.metadata["ishighcommand"] or false
	-- // Appartment \\ 
	PlayerData.metadata["appartment-tier"] = PlayerData.metadata["appartment-tier"] ~= nil and PlayerData.metadata["appartment-tier"] or math.random(1,2)
	PlayerData.metadata["appartment-data"] = PlayerData.metadata["appartment-data"] ~= nil and PlayerData.metadata["appartment-data"] or {Id = Framework.Player.CreateAppartmentId(), Name = nil}
	PlayerData.metadata["phone"] = PlayerData.metadata["phone"] ~= nil and PlayerData.metadata["phone"] or {}

	PlayerData.job = PlayerData.job ~= nil and PlayerData.job or {}
	PlayerData.job.name = PlayerData.job.name ~= nil and PlayerData.job.name or "unemployed"
	PlayerData.job.label = PlayerData.job.label ~= nil and PlayerData.job.label or "Werkloos"
	PlayerData.job.payment = PlayerData.job.payment ~= nil and PlayerData.job.payment or 10
	PlayerData.job.plate = PlayerData.job.plate ~= nil and PlayerData.job.plate or 'none'
	PlayerData.job.serial = PlayerData.job.serial ~= nil and PlayerData.job.serial or Framework.Player.CreateWeaponSerial()
    PlayerData.job.onduty = PlayerData.job.onduty ~= nil and PlayerData.job.onduty or true
	-- // Miscs \\ --
	PlayerData.metadata["tracker"] = PlayerData.metadata["tracker"] ~= nil and PlayerData.metadata["tracker"] or false
    PlayerData.metadata["ishandcuffed"] = PlayerData.metadata["ishandcuffed"] ~= nil and PlayerData.metadata["ishandcuffed"] or false
    PlayerData.metadata["jailtime"] = PlayerData.metadata["jailtime"] ~= nil and PlayerData.metadata["jailtime"] or 0
    PlayerData.metadata["commandbinds"] = PlayerData.metadata["commandbinds"] ~= nil and PlayerData.metadata["commandbinds"] or {}
    PlayerData.metadata["licences"] = PlayerData.metadata["licences"] ~= nil and PlayerData.metadata["licences"] or {["driver"] = true}
    -- // Position \\ --
	PlayerData.position = PlayerData.position ~= nil and PlayerData.position or {}
	PlayerData = Framework.Player.LoadInventory(PlayerData)
	Framework.Player.CreatePlayer(PlayerData)
end

Framework.Player.CreatePlayer = function(PlayerData)
	local self = {}
	self.Functions = {}
	self.PlayerData = PlayerData

	self.Functions.UpdatePlayerData = function()
		TriggerClientEvent("Framework:Player:SetPlayerData", self.PlayerData.source, self.PlayerData)
		Framework.Commands.Refresh(self.PlayerData.source)
	end

	self.Functions.SetJob = function(job)
		local job = job:lower()
		if Framework.Shared.Jobs[job] ~= nil then
			self.PlayerData.job.name = job
			self.PlayerData.job.label = Framework.Shared.Jobs[job].label
			self.PlayerData.job.payment = Framework.Shared.Jobs[job].payment
			self.PlayerData.job.onduty = Framework.Shared.Jobs[job].defaultDuty
			self.Functions.UpdatePlayerData()
			TriggerClientEvent("Framework:Client:OnJobUpdate", self.PlayerData.source, self.PlayerData.job)
		end
	end

	self.Functions.SetJobDuty = function(onDuty)
		self.PlayerData.job.onduty = onDuty
		self.Functions.UpdatePlayerData()
	end

	self.Functions.SetDutyPlate = function(Plate)
		self.PlayerData.job.plate = Plate
		self.Functions.UpdatePlayerData()
	end

	self.Functions.SetMetaData = function(meta, val)
		local meta = meta:lower()
		if val ~= nil then
			self.PlayerData.metadata[meta] = val
			self.Functions.UpdatePlayerData()
		end
	end

	self.Functions.AddMoney = function(moneytype, amount, reason)
		reason = reason ~= nil and reason or "unkown"
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if amount < 0 then return end
		if self.PlayerData.money[moneytype] ~= nil then
			self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype]+amount
			self.Functions.UpdatePlayerData()
			if amount > 100000 then
				TriggerEvent("fw-logs:server:SendLog", "playermoney", "AddMoney", "lightgreen", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** €"..amount .. " ("..moneytype..") erbij, nieuw "..moneytype.." balans: "..self.PlayerData.money[moneytype], true)
			else
				TriggerEvent("fw-logs:server:SendLog", "playermoney", "AddMoney", "lightgreen", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** €"..amount .. " ("..moneytype..") erbij, nieuw "..moneytype.." balans: "..self.PlayerData.money[moneytype])
			end
			if moneytype == 'cash' then
				TriggerClientEvent("fw-hud:client:money:change", self.PlayerData.source, amount, 'Plus')
			end
			return true
		end
		return false
	end

	self.Functions.RemoveMoney = function(moneytype, amount, reason)
		reason = reason ~= nil and reason or "unkown"
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if amount < 0 then return end
		if self.PlayerData.money[moneytype] ~= nil then
			for _, mtype in pairs(Framework.Config.Money.DontAllowMinus) do
				if mtype == moneytype then
					if self.PlayerData.money[moneytype] - amount < 0 then return false end
				end
			end
			self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount
			self.Functions.UpdatePlayerData()
			if amount > 100000 then
				TriggerEvent("fw-logs:server:SendLog", "playermoney", "RemoveMoney", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** €"..amount .. " ("..moneytype..") eraf, nieuw "..moneytype.." balans: "..self.PlayerData.money[moneytype], true)
			else
				TriggerEvent("fw-logs:server:SendLog", "playermoney", "RemoveMoney", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** €"..amount .. " ("..moneytype..") eraf, nieuw "..moneytype.." balans: "..self.PlayerData.money[moneytype])
			end
			if moneytype == 'cash' then
				TriggerClientEvent("fw-hud:client:money:change", self.PlayerData.source, amount, 'Minus')
			end
			return true
		end
		return false
	end

	self.Functions.SetMoney = function(moneytype, amount, reason)
		reason = reason ~= nil and reason or "unkown"
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if amount < 0 then return end
		if self.PlayerData.money[moneytype] ~= nil then
			self.PlayerData.money[moneytype] = amount
			self.Functions.UpdatePlayerData()
			TriggerEvent("fw-logs:server:SendLog", "playermoney", "SetMoney", "green", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** €"..amount .. " ("..moneytype..") gezet, nieuw "..moneytype.." balans: "..self.PlayerData.money[moneytype])
			return true
		end
		return false
	end

	self.Functions.AddItem = function(item, amount, slot, info)
		local totalWeight = Framework.Player.GetTotalWeight(self.PlayerData.items)
		local itemInfo = Framework.Shared.Items[item:lower()]
		if itemInfo == nil then TriggerClientEvent('chatMessage', -1, "SYSTEM",  "warning", "No item found??") return end
		local amount = tonumber(amount)
		local slot = tonumber(slot) ~= nil and tonumber(slot) or Framework.Player.GetFirstSlotByItem(self.PlayerData.items, item)
		if itemInfo["type"] == "weapon" and info == nil then
			info = {
				serie = tostring(Framework.Shared.RandomInt(2) .. Framework.Shared.RandomStr(3) .. Framework.Shared.RandomInt(1) .. Framework.Shared.RandomStr(2) .. Framework.Shared.RandomInt(3) .. Framework.Shared.RandomStr(4)),
			}
		end
		if (totalWeight + (itemInfo["weight"] * amount)) <= Framework.Config.Player.MaxWeight then
			if (slot ~= nil and self.PlayerData.items[slot] ~= nil) and (self.PlayerData.items[slot].name:lower() == item:lower()) and (itemInfo["type"] == "item" and not itemInfo["unique"]) then
				self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount + amount
				self.Functions.UpdatePlayerData()
				TriggerEvent("fw-logs:server:SendLog", "playerinventory", "AddItem", "green", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** krijgt item: [slot:" ..slot.."], itemname: " .. self.PlayerData.items[slot].name .. ", added amount: " .. amount ..", new total amount: ".. self.PlayerData.items[slot].amount)
				return true
			elseif (not itemInfo["unique"] and slot or slot ~= nil and self.PlayerData.items[slot] == nil) then
				self.PlayerData.items[slot] = {name = itemInfo["name"], amount = amount, info = info ~= nil and info or "", label = itemInfo["label"], description = itemInfo["description"] ~= nil and itemInfo["description"] or "", weight = itemInfo["weight"], type = itemInfo["type"], unique = itemInfo["unique"], useable = itemInfo["useable"], image = itemInfo["image"], shouldClose = itemInfo["shouldClose"], slot = slot, combinable = itemInfo["combinable"]}
				self.Functions.UpdatePlayerData()
				TriggerEvent("fw-logs:server:SendLog", "playerinventory", "AddItem", "green", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** krijgt item: [slot:" ..slot.."], itemname: " .. self.PlayerData.items[slot].name .. ", added amount: " .. amount ..", new total amount: ".. self.PlayerData.items[slot].amount)
				return true
			elseif (itemInfo["unique"]) or (not slot or slot == nil) or (itemInfo["type"] == "weapon") then
				for i = 1, Config.Player.MaxInvSlots , 1 do
					if self.PlayerData.items[i] == nil then
						self.PlayerData.items[i] = {name = itemInfo["name"], amount = amount, info = info ~= nil and info or "", label = itemInfo["label"], description = itemInfo["description"] ~= nil and itemInfo["description"] or "", weight = itemInfo["weight"], type = itemInfo["type"], unique = itemInfo["unique"], useable = itemInfo["useable"], image = itemInfo["image"], shouldClose = itemInfo["shouldClose"], slot = i, combinable = itemInfo["combinable"]}
						self.Functions.UpdatePlayerData()
						TriggerEvent("fw-logs:server:SendLog", "playerinventory", "AddItem", "green", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** krijgt item: [slot:" ..i.."], itemname: " .. self.PlayerData.items[i].name .. ", added amount: " .. amount ..", new total amount: ".. self.PlayerData.items[i].amount)
						return true
					end
				end
			end
		end
		return false
	end

	self.Functions.RemoveItem = function(item, amount, slot)
		local itemInfo = Framework.Shared.Items[item:lower()]
		local amount = tonumber(amount)
		local slot = tonumber(slot)
		if slot ~= nil then
			if self.PlayerData.items[slot].amount > amount then
				self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount - amount
				self.Functions.UpdatePlayerData()
				TriggerEvent("fw-logs:server:SendLog", "playerinventory", "RemoveItem", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** verliest item: [slot:" ..slot.."], itemname: " .. self.PlayerData.items[slot].name .. ", removed amount: " .. amount ..", new total amount: ".. self.PlayerData.items[slot].amount)
				return true
			else
				self.PlayerData.items[slot] = nil
				self.Functions.UpdatePlayerData()
				TriggerEvent("fw-logs:server:SendLog", "playerinventory", "RemoveItem", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** verliest item: [slot:" ..slot.."], itemname: " .. item .. ", removed amount: " .. amount ..", item removed")
				return true
			end
		else
			local slots = Framework.Player.GetSlotsByItem(self.PlayerData.items, item)
			local amountToRemove = amount
			if slots ~= nil then
				for _, slot in pairs(slots) do
					if self.PlayerData.items[slot].amount > amountToRemove then
						self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount - amountToRemove
						self.Functions.UpdatePlayerData()
						TriggerEvent("fw-logs:server:SendLog", "playerinventory", "RemoveItem", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** verliest item: [slot:" ..slot.."], itemname: " .. self.PlayerData.items[slot].name .. ", removed amount: " .. amount ..", new total amount: ".. self.PlayerData.items[slot].amount)
						return true
					elseif self.PlayerData.items[slot].amount == amountToRemove then
						self.PlayerData.items[slot] = nil
						self.Functions.UpdatePlayerData()
						TriggerEvent("fw-logs:server:SendLog", "playerinventory", "RemoveItem", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** verliest item: [slot:" ..slot.."], itemname: " .. item .. ", removed amount: " .. amount ..", item removed")
						return true
					end
				end
			end
		end
		return false
	end

	self.Functions.SetInventory = function(items)
		self.PlayerData.items = items
		self.Functions.UpdatePlayerData()
		TriggerEvent("fw-logs:server:SendLog", "playerinventory", "SetInventory", "blue", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** items set: " .. json.encode(items))
	end

	self.Functions.ClearInventory = function()
		self.PlayerData.items = {}
		self.Functions.UpdatePlayerData()
		Framework.Player.Save(self.PlayerData.source)
		TriggerEvent("fw-logs:server:SendLog", "playerinventory", "ClearInventory", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** inventory cleared")
	end

	self.Functions.GetItemByName = function(item)
		local item = tostring(item):lower()
		local slot = Framework.Player.GetFirstSlotByItem(self.PlayerData.items, item)
		if slot ~= nil then
			return self.PlayerData.items[slot]
		end
		return nil
	end

	self.Functions.GetItemBySlot = function(slot)
		local slot = tonumber(slot)
		if self.PlayerData.items[slot] ~= nil then
			return self.PlayerData.items[slot]
		end
		return nil
	end

	self.Functions.Save = function()
		Framework.Player.Save(self.PlayerData.source)
	end
	
	Framework.Players[self.PlayerData.source] = self
	Framework.Player.Save(self.PlayerData.source)
	self.Functions.UpdatePlayerData()
end

Framework.Player.Save = function(source)
	local PlayerData = Framework.Players[source].PlayerData
	if PlayerData ~= nil then
		Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_metadata` WHERE `citizenid` = '"..PlayerData.citizenid.."'", function(result)
			if result[1] == nil then
				Framework.Functions.ExecuteSql(true, "INSERT INTO `characters_metadata` (`citizenid`, `cid`, `steam`, `license`, `name`, `money`, `charinfo`, `position`, `job`, `globals`) VALUES ('"..PlayerData.citizenid.."', '"..tonumber(PlayerData.cid).."', '"..PlayerData.steam.."', '"..PlayerData.license.."', '"..PlayerData.name.."', '"..json.encode(PlayerData.money).."', '"..Framework.EscapeSqli(json.encode(PlayerData.charinfo)).."', '"..json.encode(PlayerData.position).."', '"..json.encode(PlayerData.job).."' ,'"..json.encode(PlayerData.metadata).."')")
			else
				Framework.Functions.ExecuteSql(true, "UPDATE `characters_metadata` SET steam='"..PlayerData.steam.."', name='"..Framework.EscapeSqli(PlayerData.name).."', money='"..Framework.EscapeSqli(json.encode(PlayerData.money)).."',charinfo='"..Framework.EscapeSqli(json.encode(PlayerData.charinfo)).."',position='"..Framework.EscapeSqli(json.encode(PlayerData.position)).."',job='"..Framework.EscapeSqli(json.encode(PlayerData.job)).."' ,globals='"..Framework.EscapeSqli(json.encode(PlayerData.metadata)).."' WHERE `citizenid` = '"..PlayerData.citizenid.."'")
			end
			Framework.Player.SaveInventory(source)
		end)
		print(PlayerData.name .." ^2PLAYER SAVED!^0")
	else
		print('SAVE DATA ERROR - NILL - FW-CORE')
	end
end

Framework.Player.Logout = function(source)
	local Player = Framework.Functions.GetPlayer(source)
	TriggerClientEvent('Framework:Client:OnPlayerUnload', source)
	TriggerClientEvent("Framework:Player:UpdatePlayerData", source)
	Player.Functions.Save()
	Citizen.Wait(200)
	Framework.Players[source] = nil
end

Framework.Player.DeleteCharacter = function(source, citizenid)
  Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_metadata` WHERE `citizenid` = '"..Framework.EscapeSqli(citizenid).."'", function(result)
	if result[1] ~= nil then
		if result[1].steam == GetPlayerIdentifiers(source)[1] then
		   Framework.Functions.ExecuteSql(true, "DELETE FROM `characters_skins` WHERE `citizenid` = '"..citizenid.."'")
		   Framework.Functions.ExecuteSql(true, "DELETE FROM `characters_metadata` WHERE `citizenid` = '"..citizenid.."'")
		   TriggerClientEvent('fw-multichar:client:open:select', source)
	       TriggerEvent("fw-logs:server:SendLog", "joinleave", "Character Deleted", "red", "**".. GetPlayerName(source) .. "** ("..GetPlayerIdentifiers(source)[1]..") deleted **"..citizenid.."**..")
		else
			TriggerClientEvent('fw-multichar:client:open:select', source)
			TriggerEvent("fw-logs:server:SendLog", "joinleave", "Character Cheats", "red", GetPlayerName(source) .." probeerd "..citizenid.." te verwijderen die niet van hem is..", true)
		end
	else
		TriggerClientEvent('fw-multichar:client:open:select', source)
	    TriggerEvent("fw-logs:server:SendLog", "joinleave", "Character Cheats", "red", GetPlayerName(source) .." probeerd "..citizenid.." te verwijderen die niet van hem is..", true)
	end
  end)
end

Framework.Player.LoadInventory = function(PlayerData)
	PlayerData.items = {}
		Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_metadata` WHERE `citizenid` = '"..PlayerData.citizenid.."'", function(result)
			if result[1] ~= nil then 
				if result[1].inventory ~= nil then
					plyInventory = json.decode(result[1].inventory)
					if next(plyInventory) ~= nil then 
						for _, item in pairs(plyInventory) do
							if item ~= nil then
								local itemInfo = Framework.Shared.Items[item.name:lower()]
								PlayerData.items[item.slot] = {
									name = itemInfo["name"], 
									amount = item.amount, 
									info = item.info ~= nil and item.info or "", 
									label = itemInfo["label"], 
									description = itemInfo["description"] ~= nil and itemInfo["description"] or "", 
									weight = itemInfo["weight"], 
									type = itemInfo["type"], 
									unique = itemInfo["unique"], 
									useable = itemInfo["useable"], 
									image = itemInfo["image"], 
									shouldClose = itemInfo["shouldClose"], 
									slot = item.slot, 
									combinable = itemInfo["combinable"]
								}
							end
						end
					end
				end
			end
		end)
	return PlayerData
end

Framework.Player.SaveInventory = function(source)
	if Framework.Players[source] ~= nil then 
		local PlayerData = Framework.Players[source].PlayerData
		local items = PlayerData.items
		local ItemsJson = {}
		if items ~= nil and next(items) ~= nil then
			for slot, item in pairs(items) do
				if items[slot] ~= nil then
					table.insert(ItemsJson, {
						name = item.name,
						amount = item.amount,
						info = item.info,
						type = item.type,
						slot = slot,
					})
				end
			end
			Framework.Functions.ExecuteSql(true, "UPDATE `characters_metadata` SET `inventory` = '"..json.encode(ItemsJson).."' WHERE `citizenid` = '"..PlayerData.citizenid.."'")
		else
			Framework.Functions.ExecuteSql(true, "UPDATE `characters_metadata` SET `inventory` = '{}' WHERE `citizenid` = '"..PlayerData.citizenid.."'")
		end
	end
end

Framework.Player.GetTotalWeight = function(items)
	local weight = 0
	if items ~= nil then
		for slot, item in pairs(items) do
			weight = weight + (item.weight * item.amount)
		end
	end
	return tonumber(weight)
end

Framework.Player.GetSlotsByItem = function(items, itemName)
	local slotsFound = {}
	if items ~= nil then
		for slot, item in pairs(items) do
			if item.name:lower() == itemName:lower() then
				table.insert(slotsFound, slot)
			end
		end
	end
	return slotsFound
end

Framework.Player.GetFirstSlotByItem = function(items, itemName)
	if items ~= nil then
		for slot, item in pairs(items) do
			if item.name:lower() == itemName:lower() then
				return tonumber(slot)
			end
		end
	end
	return nil
end

Framework.Player.CreateCitizenId = function()
	local UniqueFound = false
	local CitizenId = nil
	while not UniqueFound do
		CitizenId = tostring(Framework.Shared.RandomStr(3) .. Framework.Shared.RandomInt(5)):upper()
		Framework.Functions.ExecuteSql(true, "SELECT COUNT(*) as count FROM `characters_metadata` WHERE `citizenid` = '"..CitizenId.."'", function(result)
            if result[1].count == 0 then
				UniqueFound = true
			end
		end)
	end
	return CitizenId
end

Framework.Player.CreateDnaId = function(Type)
    local DnaId = {}
    if Type == 'finger' then
        DnaId = tostring('F'..Framework.Shared.RandomStr(3) .. Framework.Shared.RandomInt(3):upper() .. Framework.Shared.RandomStr(1) .. Framework.Shared.RandomInt(2) .. Framework.Shared.RandomStr(3) .. Framework.Shared.RandomInt(4):upper())
    elseif Type == 'slime' then
        DnaId = tostring('S'..Framework.Shared.RandomStr(2) .. Framework.Shared.RandomInt(3) .. Framework.Shared.RandomStr(2) .. Framework.Shared.RandomInt(2):upper() .. Framework.Shared.RandomStr(3) .. Framework.Shared.RandomInt(4))
    elseif Type == 'hair' then
        DnaId = tostring('H'..Framework.Shared.RandomStr(2) .. Framework.Shared.RandomInt(3) .. Framework.Shared.RandomStr(3) .. Framework.Shared.RandomInt(2) .. Framework.Shared.RandomStr(3) .. Framework.Shared.RandomInt(4):upper())
    end 
    return DnaId
end

Framework.Player.CreateWeaponSerial = function()
	local Serial =  Framework.Shared.RandomStr(2)..Framework.Shared.RandomInt(3):upper()..Framework.Shared.RandomStr(3)..Framework.Shared.RandomInt(3):upper()..Framework.Shared.RandomStr(2)..Framework.Shared.RandomInt(3):upper()
	return Serial
end

Framework.Player.CreateAppartmentId = function()
	local AppartmentId =  Framework.Shared.RandomStr(2)..Framework.Shared.RandomInt(2):upper()..'Appartment'..Framework.Shared.RandomStr(2)..Framework.Shared.RandomInt(2):lower()
	return AppartmentId
end

Framework.EscapeSqli = function(str)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return str:gsub( "['\"]", replacements)
end