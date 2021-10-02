local LoggedIn = false
Framework = nil

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
        Citizen.Wait(250)
		Framework.Functions.TriggerCallback('fw-crafting:server:get:config', function(ConfigData)
			Config.Locations = ConfigData
		end)
		SetupWeaponInfo()
		ItemsToItemInfo()
        LoggedIn = true
    end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LoggedIn then
			NearLocation = false
			local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
			local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['X'], Config.Locations['Y'], Config.Locations['Z'], true)
			if Distance < 2 then
				NearLocation = true
				DrawMarker(2, Config.Locations['X'], Config.Locations['Y'], Config.Locations['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
				if IsControlJustReleased(0, 38) then
					local Crating = {}
					Crating.label = "Wapen Workbench"
					Crating.items = GetThresholdWeapons()
					TriggerServerEvent('fw-inventory:server:set:inventory:disabled', true)
					TriggerServerEvent("fw-inventory:server:OpenInventory", "crafting_weapon", math.random(1, 99), Crating)
				end
			end
			if not NearLocation then
				Citizen.Wait(1500)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LoggedIn then
		    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1)), true
		    local CraftObject = GetClosestObjectOfType(PlayerCoords, 2.0, -573669520, false, false, false)
		    if CraftObject ~= 0 then
		    	NearObject = false
		    	local ObjectCoords = GetEntityCoords(CraftObject)
		    	if GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, ObjectCoords.x, ObjectCoords.y, ObjectCoords.z, true) < 1.5 then
		    		NearObject = true
		    		DrawText3D(ObjectCoords.x, ObjectCoords.y, ObjectCoords.z + 1.0, "~g~E~w~ - Craft")
		    		if IsControlJustReleased(0, 38) then
						SetupWeaponInfo()
						ItemsToItemInfo()
		    			local Crating = {}
		    			Crating.label = "Crating Workbench"
		    			Crating.items = GetThresholdItems()
						TriggerServerEvent('fw-inventory:server:set:inventory:disabled', true)
		    			TriggerServerEvent("fw-inventory:server:OpenInventory", "crafting", math.random(1, 99), Crating)
		    		end
		    	end
		    end
		    if not NearObject then
		    	Citizen.Wait(1000)
			end
		end
	end
end)

-- // Function \\ --

function GetThresholdItems()
	local items = {}
	for k, item in pairs(Config.CraftingItems) do
		if Framework.Functions.GetPlayerData().metadata["craftingrep"] >= Config.CraftingItems[k].threshold then
			items[k] = Config.CraftingItems[k]
		end
	end
	return items
end

function GetThresholdWeapons()
	local items = {}
	for k, item in pairs(Config.CraftingWeapons) do
		items[k] = Config.CraftingWeapons[k]
	end
	return items
end

function ItemsToItemInfo()
	itemInfos = {
		[1] = {costs = Framework.Shared.Items["metalscrap"]["label"] .. ": 22x, " ..Framework.Shared.Items["plastic"]["label"] .. ": 32x."},
		[2] = {costs = Framework.Shared.Items["metalscrap"]["label"] .. ": 30x, " ..Framework.Shared.Items["plastic"]["label"] .. ": 42x."},
		[3] = {costs = Framework.Shared.Items["metalscrap"]["label"] .. ": 30x, " ..Framework.Shared.Items["plastic"]["label"] .. ": 45x, "..Framework.Shared.Items["aluminum"]["label"] .. ": 28x."},
		[4] = {costs = Framework.Shared.Items["plastic"]["label"] .. ": 16x."},
		[5] = {costs = Framework.Shared.Items["metalscrap"]["label"] .. ": 36x, " ..Framework.Shared.Items["steel"]["label"] .. ": 24x, "..Framework.Shared.Items["aluminum"]["label"] .. ": 28x."},
		[6] = {costs = Framework.Shared.Items["metalscrap"]["label"] .. ": 50x, " ..Framework.Shared.Items["steel"]["label"] .. ": 37x, "..Framework.Shared.Items["copper"]["label"] .. ": 26x."},
		[7] = {costs = Framework.Shared.Items["iron"]["label"] .. ": 33x, " ..Framework.Shared.Items["steel"]["label"] .. ": 44x, "..Framework.Shared.Items["plastic"]["label"] .. ": 55x, "..Framework.Shared.Items["aluminum"]["label"] .. ": 22x."},
		[8] = {costs = Framework.Shared.Items["metalscrap"]["label"] .. ": 32x, " ..Framework.Shared.Items["steel"]["label"] .. ": 43x, "..Framework.Shared.Items["plastic"]["label"] .. ": 61x."},
		[9] = {costs = Framework.Shared.Items["iron"]["label"] .. ": 60x, " ..Framework.Shared.Items["glass"]["label"] .. ": 30x."},
		[10] = {costs = Framework.Shared.Items["aluminum"]["label"] .. ": 60x, " ..Framework.Shared.Items["glass"]["label"] .. ": 30x."},
	}
	local items = {}
	for k, item in pairs(Config.CraftingItems) do
		local itemInfo = Framework.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.CraftingItems = items
end

function SetupWeaponInfo()
	local items = {}
	for k, item in pairs(Config.CraftingWeapons) do
		local itemInfo = Framework.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = item.info,
			label = itemInfo["label"],
			description = item.description,
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.CraftingWeapons = items
end

function DrawText3D(x, y, z, text)
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  SetDrawOrigin(x,y,z, 0)
  DrawText(0.0, 0.0)
  ClearDrawOrigin()
end