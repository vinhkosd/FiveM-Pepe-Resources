local DoingSomething = false
local currentVest = nil
local currentVestTexture = nil
Framework = nil

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
	 Citizen.Wait(250)
 end)
end)

-- Code

RegisterNetEvent('fw-items:client:drink')
AddEventHandler('fw-items:client:drink', function(ItemName, PropName)
	if not exports['fw-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
		DoingSomething = true
    	 	Citizen.SetTimeout(1000, function()
    			exports['fw-assets']:AddProp(PropName)
    			TriggerEvent('fw-inventory:client:set:busy', true)
    			exports['fw-assets']:RequestAnimationDict("amb@world_human_drinking@coffee@male@idle_a")
    			TaskPlayAnim(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    	 		Framework.Functions.Progressbar("drink", "Đang uống..", 10000, false, true, {
    	 			disableMovement = false,
    	 			disableCarMovement = false,
    	 			disableMouse = false,
    	 			disableCombat = true,
    			 }, {}, {}, {}, function() -- Done
					 DoingSomething = false
    				 exports['fw-assets']:RemoveProp()
    				 TriggerEvent('fw-inventory:client:set:busy', false)
    				 TriggerServerEvent('Framework:Server:RemoveItem', ItemName, 1)
    				 TriggerEvent("fw-inventory:client:ItemBox", Framework.Shared.Items[ItemName], "remove")
    				 StopAnimTask(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    				 TriggerServerEvent("Framework:Server:SetMetaData", "thirst", Framework.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
    			 end, function()
					DoingSomething = false
    				exports['fw-assets']:RemoveProp()
    				TriggerEvent('fw-inventory:client:set:busy', false)
    	 			Framework.Functions.Notify("Đã hủy..", "error")
    				StopAnimTask(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    	 		end)
    	 	end)
		end
	end
end)

RegisterNetEvent('fw-items:client:drink:slushy')
AddEventHandler('fw-items:client:drink:slushy', function()
	if not exports['fw-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
		DoingSomething = true
    		Citizen.SetTimeout(1000, function()
    			exports['fw-assets']:AddProp('Cup')
    			exports['fw-assets']:RequestAnimationDict("amb@world_human_drinking@coffee@male@idle_a")
    			TaskPlayAnim(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    			TriggerEvent('fw-inventory:client:set:busy', true)
    			Framework.Functions.Progressbar("drink", "Đang uống..", 10000, false, true, {
    				disableMovement = false,
    				disableCarMovement = false,
    				disableMouse = false,
    				disableCombat = true,
    			 }, {}, {}, {}, function() -- Done
					DoingSomething = false
    				 exports['fw-assets']:RemoveProp()
    				 TriggerEvent('fw-inventory:client:set:busy', false)
    				 TriggerServerEvent('fw-hud:server:remove:stress', math.random(12, 20))
    				 TriggerServerEvent('Framework:Server:RemoveItem', 'slushy', 1)
    				 TriggerEvent("fw-inventory:client:ItemBox", Framework.Shared.Items['slushy'], "remove")
    				 StopAnimTask(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    				 TriggerServerEvent("Framework:Server:SetMetaData", "thirst", Framework.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
    			 end, function()
					DoingSomething = false
    				exports['fw-assets']:RemoveProp()
    				TriggerEvent('fw-inventory:client:set:busy', false)
    				Framework.Functions.Notify("Đã hủy..", "error")
    				StopAnimTask(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    			end)
    		end)
		end
	end
end)

RegisterNetEvent('fw-items:client:eat')
AddEventHandler('fw-items:client:eat', function(ItemName, PropName)
	if not exports['fw-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
		DoingSomething = true
 			Citizen.SetTimeout(1000, function()
				exports['fw-assets']:AddProp(PropName)
				TriggerEvent('fw-inventory:client:set:busy', true)
				exports['fw-assets']:RequestAnimationDict("mp_player_inteat@burger")
				TaskPlayAnim(GetPlayerPed(-1), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
 				Framework.Functions.Progressbar("eat", "Đang ăn..", 10000, false, true, {
 					disableMovement = false,
 					disableCarMovement = false,
 					disableMouse = false,
 					disableCombat = true,
				 }, {}, {}, {}, function() -- Done
					 DoingSomething = false
					 exports['fw-assets']:RemoveProp()
					 TriggerEvent('fw-inventory:client:set:busy', false)
					 TriggerServerEvent('fw-hud:server:remove:stress', math.random(6, 10))
					 TriggerServerEvent('Framework:Server:RemoveItem', ItemName, 1)
					 StopAnimTask(GetPlayerPed(-1), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
					 TriggerEvent("fw-inventory:client:ItemBox", Framework.Shared.Items[ItemName], "remove")
					 if ItemName == 'burger-heartstopper' then
						TriggerServerEvent("Framework:Server:SetMetaData", "hunger", Framework.Functions.GetPlayerData().metadata["hunger"] + math.random(40, 50))
					 else
						TriggerServerEvent("Framework:Server:SetMetaData", "hunger", Framework.Functions.GetPlayerData().metadata["hunger"] + math.random(20, 35))
					 end
				 	end, function()
					DoingSomething = false
					exports['fw-assets']:RemoveProp()
					TriggerEvent('fw-inventory:client:set:busy', false)
 					Framework.Functions.Notify("Đã hủy..", "error")
					StopAnimTask(GetPlayerPed(-1), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
 				end)
 			end)
		end
	end
end)

RegisterNetEvent('fw-items:client:use:armor')
AddEventHandler('fw-items:client:use:armor', function()
	if not exports['fw-progressbar']:GetTaskBarStatus() then
 		local CurrentArmor = GetPedArmour(GetPlayerPed(-1))
 		if CurrentArmor <= 100 and CurrentArmor + 50 <= 100 then
			local NewArmor = CurrentArmor + 50
			if CurrentArmor + 33 >= 100 or CurrentArmor >= 100 then NewArmor = 100 end
			 TriggerEvent('fw-inventory:client:set:busy', true)
 		    Framework.Functions.Progressbar("vest", "Đang trang bị..", 10000, false, true, {
 		    	disableMovement = false,
 		    	disableCarMovement = false,
 		    	disableMouse = false,
 		    	disableCombat = true,
 		    }, {}, {}, {}, function() -- Done
 		  	 	 SetPedArmour(GetPlayerPed(-1), NewArmor)
				 TriggerEvent('fw-inventory:client:set:busy', false)
				 TriggerServerEvent('Framework:Server:RemoveItem', 'armor', 1)
 		   	 TriggerEvent("fw-inventory:client:ItemBox", Framework.Shared.Items['armor'], "remove")
				 TriggerServerEvent('fw-hospital:server:save:health:armor', GetEntityHealth(GetPlayerPed(-1)), GetPedArmour(GetPlayerPed(-1)))
 		    	 Framework.Functions.Notify("Gelukt", "success")
 		    end, function()
				TriggerEvent('fw-inventory:client:set:busy', false)
 		    	Framework.Functions.Notify("Đã hủy..", "error")
 		    end)
 		else
			Framework.Functions.Notify("Je hebt al een vest om..", "error")
 		end
	end
end)

RegisterNetEvent("fw-items:client:use:heavy")
AddEventHandler("fw-items:client:use:heavy", function()
	if not exports['fw-progressbar']:GetTaskBarStatus() then
    	local Sex = "Man"
    	if Framework.Functions.GetPlayerData().charinfo.gender == 1 then
    	  Sex = "Vrouw"
    	end
		TriggerEvent('fw-inventory:client:set:busy', true)
    	Framework.Functions.Progressbar("use_heavyarmor", "Đang trang bị..", 5000, false, true, {
    	disableMovement = false,
    	disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function() -- Done
			TriggerEvent('fw-inventory:client:set:busy', false)
			TriggerServerEvent('Framework:Server:RemoveItem', 'heavy-armor', 1)
			TriggerEvent("fw-inventory:client:ItemBox", Framework.Shared.Items['heavy-armor'], "remove")
    	    if Sex == 'Man' then
    	    currentVest = GetPedDrawableVariation(GetPlayerPed(-1), 9)
    	    currentVestTexture = GetPedTextureVariation(GetPlayerPed(-1), 9)
    	    if GetPedDrawableVariation(GetPlayerPed(-1), 9) == 7 then
    	        SetPedComponentVariation(GetPlayerPed(-1), 9, 19, GetPedTextureVariation(GetPlayerPed(-1), 9), 2)
    	    else
    	        SetPedComponentVariation(GetPlayerPed(-1), 9, 5, 0, 2)
    	    end
    	    SetPedArmour(GetPlayerPed(-1), 100)
    	  else
    	    currentVest = GetPedDrawableVariation(GetPlayerPed(-1), 9)
    	    currentVestTexture = GetPedTextureVariation(GetPlayerPed(-1), 9)
    	    if GetPedDrawableVariation(GetPlayerPed(-1), 9) == 7 then
    	        SetPedComponentVariation(GetPlayerPed(-1), 9, 20, GetPedTextureVariation(GetPlayerPed(-1), 9), 2)
    	    else
    	        SetPedComponentVariation(GetPlayerPed(-1), 9, 5, 0, 2)
    	    end
			SetPedArmour(GetPlayerPed(-1), 100)
			TriggerServerEvent('fw-hospital:server:save:health:armor', GetEntityHealth(GetPlayerPed(-1)), GetPedArmour(GetPlayerPed(-1)))
    	  end
		end, function() -- Cancel
    	    TriggerEvent('fw-inventory:client:set:busy', false)
    	    Framework.Functions.Notify("Đã hủy..", "error")
    	end)
	end
end)

RegisterNetEvent("fw-items:client:reset:armor")
AddEventHandler("fw-items:client:reset:armor", function()
	if not exports['fw-progressbar']:GetTaskBarStatus() then
    	local ped = GetPlayerPed(-1)
    	if currentVest ~= nil and currentVestTexture ~= nil then 
    	    Framework.Functions.Progressbar("remove-armor", "Đang cởi áo vest..", 2500, false, false, {
    	        disableMovement = false,
    	        disableCarMovement = false,
    	        disableMouse = false,
    	        disableCombat = true,
    	    }, {}, {}, {}, function() -- Done
    	        SetPedComponentVariation(GetPlayerPed(-1), 9, currentVest, currentVestTexture, 2)
    	        SetPedArmour(GetPlayerPed(-1), 0)
				TriggerServerEvent('fw-items:server:giveitem', 'heavy-armor', 1)
				TriggerServerEvent('fw-hospital:server:save:health:armor', GetEntityHealth(GetPlayerPed(-1)), GetPedArmour(GetPlayerPed(-1)))
				currentVest, currentVestTexture = nil, nil
    	    end)
    	else
    	    Framework.Functions.Notify("Je hebt geen vest aan..", "error")
    	end
	end
end)

RegisterNetEvent('fw-items:client:use:repairkit')
AddEventHandler('fw-items:client:use:repairkit', function()
	if not exports['fw-progressbar']:GetTaskBarStatus() then
		local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
		local Vehicle, Distance = Framework.Functions.GetClosestVehicle()
		if GetVehicleEngineHealth(Vehicle) < 1000.0 then
			NewHealth = GetVehicleEngineHealth(Vehicle) + 250.0
			if GetVehicleEngineHealth(Vehicle) + 250.0 > 1000.0 then 
				NewHealth = 1000.0 
			end
			if Distance < 4.0 and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
				local EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, 2.5, 0)
				if IsBackEngine(GetEntityModel(Vehicle)) then
				  EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, -2.5, 0)
				end
			if GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, EnginePos) < 4.0 then
				local VehicleDoor = nil
				if IsBackEngine(GetEntityModel(Vehicle)) then
					VehicleDoor = 5
				else
					VehicleDoor = 4
				end
				SetVehicleDoorOpen(Vehicle, VehicleDoor, false, false)
				Citizen.Wait(450)
				TriggerEvent('fw-inventory:client:set:busy', true)
				Framework.Functions.Progressbar("repair_vehicle", "Đang sửa..", math.random(10000, 20000), false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mini@repair",
					anim = "fixing_a_player",
					flags = 16,
				}, {}, {}, function() -- Done
					if math.random(1,50) < 10 then
					  TriggerServerEvent('Framework:Server:RemoveItem', 'repairkit', 1)
					  TriggerEvent("fw-inventory:client:ItemBox", Framework.Shared.Items['repairkit'], "remove")
					end
					TriggerEvent('fw-inventory:client:set:busy', false)
					SetVehicleDoorShut(Vehicle, VehicleDoor, false)
					StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
					Framework.Functions.Notify("Voertuig gemaakt!")
					SetVehicleEngineHealth(Vehicle, NewHealth) 
					for i = 1, 6 do
					 SetVehicleTyreFixed(Vehicle, i)
					end
				end, function() -- Cancel
					TriggerEvent('fw-inventory:client:set:busy', false)
					StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
					Framework.Functions.Notify("Thất bại!", "error")
					SetVehicleDoorShut(Vehicle, VehicleDoor, false)
				end)
			end
		 else
			Framework.Functions.Notify("Không tìm thấy xe?!?", "error")
		end
		end	
	end
end)

RegisterNetEvent('fw-items:client:dobbel')
AddEventHandler('fw-items:client:dobbel', function(Amount, Sides)
	local DiceResult = {}
	for i = 1, Amount do
		table.insert(DiceResult, math.random(1, Sides))
	end
	local RollText = CreateRollText(DiceResult, Sides)
	TriggerEvent('fw-items:client:dice:anim')
	Citizen.SetTimeout(1900, function()
		TriggerServerEvent('fw-sound:server:play:distance', 2.0, 'dice', 0.5)
		TriggerServerEvent('fw-assets:server:display:text', RollText)
	end)
end)

RegisterNetEvent('fw-items:client:coinflip')
AddEventHandler('fw-items:client:coinflip', function()
	local CoinFlip = {}
	local Random = math.random(1,2)
     if Random <= 1 then
		CoinFlip = 'Coinflip: ~g~Kop'
     else
		CoinFlip = 'Coinflip: ~y~Munt'
	 end
	 TriggerEvent('fw-items:client:dice:anim')
	 Citizen.SetTimeout(1900, function()
		TriggerServerEvent('fw-sound:server:play:distance', 2.0, 'coin', 0.5)
		TriggerServerEvent('fw-assets:server:display:text', CoinFlip)
	 end)
end)

RegisterNetEvent('fw-items:client:dice:anim')
AddEventHandler('fw-items:client:dice:anim', function()
	exports['fw-assets']:RequestAnimationDict("anim@mp_player_intcelebrationmale@wank")
    TaskPlayAnim(GetPlayerPed(-1), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Citizen.Wait(1500)
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('fw-items:client:use:duffel-bag')
AddEventHandler('fw-items:client:use:duffel-bag', function(BagId)
    TriggerServerEvent("fw-inventory:server:OpenInventory", "stash", 'tas_'..BagId, {maxweight = 25000, slots = 3})
    TriggerEvent("fw-inventory:client:SetCurrentStash", 'tas_'..BagId)
end)

--  // Functions \\ --

function IsBackEngine(Vehicle)
    for _, model in pairs(Config.BackEngineVehicles) do
        if GetHashKey(model) == Vehicle then
            return true
        end
    end
    return false
end

function CreateRollText(rollTable, sides)
    local s = "~g~Gedobbled~s~: "
    local total = 0
    for k, roll in pairs(rollTable, sides) do
        total = total + roll
        if k == 1 then
            s = s .. roll .. "/" .. sides
        else
            s = s .. " | " .. roll .. "/" .. sides
        end
    end
    s = s .. " | (Total: ~g~"..total.."~s~)"
    return s
end