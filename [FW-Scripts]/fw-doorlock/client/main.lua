local DoorKey, DoorValue = nil, nil
local LoggedIn = false
local NearDoor = nil
local MaxDistance = 1.25

Framework = nil

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1000, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)
	 Citizen.Wait(250)
	 Framework.Functions.TriggerCallback("fw-doorlock:server:get:config", function(config)
		Config = config
	end)
	Citizen.Wait(150)
	LoggedIn = true
 end)
end)

-- Code

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LoggedIn then
		     for key, Door in ipairs(Config.Doors) do
		     	if Door['Doors'] then
		     		for k,v in ipairs(Door['Doors']) do
		     			if not v.object or not DoesEntityExist(v.object) then
		     				v.object = GetClosestObjectOfType(v['ObjCoords'], 1.0, GetHashKey(v['ObjName']), false, false, false)
		     			end
		     		end
		     	else
		     		if not Door.object or not DoesEntityExist(Door.object) then
		     			Door.object = GetClosestObjectOfType(Door['ObjCoords'], 1.0, GetHashKey(Door['ObjName']), false, false, false)
		     		end
		     	end
		     end
		  Citizen.Wait(3500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if LoggedIn then
		    local playerCoords = GetEntityCoords(GetPlayerPed(-1))
		    NearDoorDistance = true
		    NearDoor = true
		    for k, Door in ipairs(Config.Doors) do
		    	local distance
		    	if Door['Doors'] then
		    		distance = #(playerCoords - Door['Doors'][1]['ObjCoords'])
		    	else
		    		distance = #(playerCoords - Door['ObjCoords'])
		    	end
		    	if Door["Distance"] then
		    		MaxDistance = Door["Distance"]
		    	end
		    	if distance < 25.0 then
		    		NearDoorDistance = false
		    		if Door['Doors'] then
		    			for _,v in ipairs(Door['Doors']) do
		    				FreezeEntityPosition(v.object, Door['Locked'])
		    				if Door['Locked'] and v['ObjYaw'] and GetEntityRotation(v.object).z ~= v['ObjYaw'] then
		    					SetEntityRotation(v.object, 0.0, 0.0, v['ObjYaw'], 2, true)
		    				end
		    			end
		    		else
		    			FreezeEntityPosition(Door.object, Door['Locked'])
		    			if Door['Locked'] and Door['ObjYaw'] and GetEntityRotation(Door.object).z ~= Door['ObjYaw'] then
		    				SetEntityRotation(Door.object, 0.0, 0.0, Door['ObjYaw'], 2, true)
		    			end
		    		end
		    	end
		    	if distance < MaxDistance then
		    		NearDoor = false
		    		DoorKey, DoorValue = k, Door
					local isAuthorized = IsAuthorized(DoorValue)
		    		if Door['Locked'] then	
		    			if not Showing then
		    				Showing = true
							if isAuthorized then
		    					SendNUIMessage({
		    						action = "show",
		    						text = 'closed-auth',
		    					})
							else
								SendNUIMessage({
		    						action = "show",
		    						text = 'closed',
		    					})
							end
		    			end
		    		elseif not Door['Locked'] then
		    			if not Showing then
		    				Showing = true
							if isAuthorized then
		    				    SendNUIMessage({
		    				    	action = "show",
		    				    	text = 'open-auth',
		    				    })
							else
								SendNUIMessage({
		    				    	action = "show",
		    				    	text = 'open',
		    				    })
							end
		    			end
		    		end
					if IsControlJustReleased(0, 38) then
						if isAuthorized then
							SetDoorLock(DoorValue, DoorKey)
						end
					end
		    	end
		    end
		    if NearDoor then
		    	SendNUIMessage({
		    		action = "remove",
		    	})
		    	Showing = false
		    	Citizen.Wait(1500)
		    	DoorKey, DoorValue = nil, nil
		    end
		    if NearDoorDistance then
		    	Citizen.Wait(250)
			end
		end
	end
end)

-- // Events \\ --

RegisterNetEvent('fw-items:client:use:lockpick')
AddEventHandler('fw-items:client:use:lockpick', function(IsAdvanced)
	if not NearDoor then
		if DoorValue['Locked'] then
			if DoorValue['Pickable'] then
		    	if IsAdvanced then
		    		exports['fw-lockpick']:OpenLockpickGame(function(Success)
		    			if Success then
		    				LockpickFinish(true)
		    			else
		    				if math.random(1,100) < 15 then
		    					TriggerServerEvent('Framework:Server:RemoveItem', 'advancedlockpick', 1)
		    					TriggerEvent("fw-inventory:client:ItemBox", Framework.Shared.Items['advancedlockpick'], "remove")
		    				end
		    				Framework.Functions.Notify('Het is niet gelukt..', 'error', 2500)
		    			end
					end)
					else
					 Framework.Functions.Notify('Deze lockpick is niet sterk genoeg..', 'error', 2500)
				end
			else
				Framework.Functions.Notify('Deur heeft een te sterk slot..', 'error', 2500)
			end
		end
	end
end)

RegisterNetEvent('fw-items:client:use:drill')
AddEventHandler('fw-items:client:use:drill', function()
	Citizen.SetTimeout(450, function()
	  if not NearDoor then
	  	if DoorValue['Locked'] then
	  		if DoorValue['Heavy-Door'] then 
	  			if not DoorValue['Pickable'] then
					Framework.Functions.TriggerCallback("fw-bankrobbery:server:HasItem", function(HasItem)
						if HasItem then
							TriggerServerEvent('Framework:Server:RemoveItem', 'drill-bit', 1)
							TriggerEvent("fw-inventory:client:ItemBox", Framework.Shared.Items['drill-bit'], "remove")
	  						if not exports['fw-assets']:GetPropStatus() then
	  							exports['fw-assets']:AddProp('Drill')
	  						end
	  						exports['fw-assets']:RequestAnimationDict("anim@heists@fleeca_bank@drilling")
	  						TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
	  						exports['minigame-drill']:StartDrilling(function(Success)
	  						   if Success then
	  							   ChangeDoorLooks(DoorValue, 'NaarSmelt')
	  							   exports['fw-assets']:RemoveProp()
	  							   SetDoorLock(DoorValue, DoorKey)
	  							   Framework.Functions.Notify("Gelukt", "success")
	  							   StopAnimTask(GetPlayerPed(-1), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
	  						   else
	  							   exports['fw-assets']:RemoveProp()
	  							   Framework.Functions.Notify("Đã hủy..", "error")
	  							   StopAnimTask(GetPlayerPed(-1), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
	  						   end
	  						end)
						else
							Framework.Functions.Notify('Je mist iets voor deze boor..', 'error', 2500)
						end
					end, 'drill-bit')
	  		    else
	  		    	Framework.Functions.Notify('Deze deur moet je lockpicken..', 'error', 2500)
	  			end
	  		end
	  	end
	  end
	end)
end)

RegisterNetEvent('fw-doorlock:client:change:door:looks')
AddEventHandler('fw-doorlock:client:change:door:looks', function(Door, Type)
	if Type == 'NaarSmelt' then
	  CreateModelSwap(Door['ObjCoords'], 5, GetHashKey(Door['ObjName']), GetHashKey(Door['Molten-Model']), 1)
	else
	  CreateModelSwap(Door['ObjCoords'], 5, GetHashKey(Door['Molten-Model']), GetHashKey(Door['ObjName']), 1)
	end
end)

RegisterNetEvent('fw-doorlock:server:reset:door:looks')
AddEventHandler('fw-doorlock:server:reset:door:looks', function()
	for k, v in pairs(Config.Doors) do
		if v['Heavy-Door'] then
			CreateModelSwap(v['ObjCoords'], 5, GetHashKey(v['Molten-Model']), GetHashKey(v['ObjName']), 1)
		end
	end
end)
RegisterNetEvent('fw-doorlock:client:setState')
AddEventHandler('fw-doorlock:client:setState', function(Door, state)
	Config.Doors[Door]['Locked'] = state
	if not NearDoor then
	   if DoorKey == Door then
	   SendNUIMessage({
	   	action = "remove",
	   })
	   Citizen.Wait(500)
	   Showing = false
	  end
	end
end)

-- // Functions \\ --

function SetDoorLock(Door, key)
 OpenDoorAnimation()
 TriggerServerEvent('fw-sound:server:play:source', 'doorlock-keys', 0.4)
 SetTimeout(1000, function()
   Door['Locked'] = not Door['Locked']
   TriggerServerEvent('fw-doorlock:server:updateState', key, Door['Locked'])
 end)
end

function IsAuthorized(Door)
	local PlayerData = Framework.Functions.GetPlayerData()
	for _, job in pairs(Door['Autorized']) do
		if job == PlayerData.job.name then
			return true
		end
	end
	return false
end

function OpenDoorAnimation()
  exports['fw-assets']:RequestAnimationDict("anim@heists@keycard@")
  TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
  SetTimeout(400, function()
  	ClearPedTasks(GetPlayerPed(-1))
  end)
end

function LockpickFinish(Success)
 if Success then
 	local lockpickTime = math.random(15000, 30000)
     LockpickDoorAnim(lockpickTime)
 	Framework.Functions.Progressbar("lockpick-door", "Deur lockpicken..", lockpickTime, false, true, {
 		disableMovement = true,
 		disableCarMovement = true,
 		disableMouse = false,
 		disableCombat = true,
 	}, {}, {}, {}, function() -- Done
 		ClearPedTasks(GetPlayerPed(-1))
 		Framework.Functions.Notify('Het is gelukt!', 'success', 2500)
 		SetDoorLock(DoorValue, DoorKey)
 	end, function() -- Cancel
 		openingDoor = false
 		ClearPedTasks(GetPlayerPed(-1))
 		Framework.Functions.Notify("Proces Đã hủy..", "error")
 	end)
 else
     Framework.Functions.Notify('Het is niet gelukt..', 'error', 2500)
 end
end

function LockpickDoorAnim(time)
 time = time / 1000
 exports['fw-assets']:RequestAnimationDict("veh@break_in@0h@p_m_one@")
 TaskPlayAnim(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
 openingDoor = true
 Citizen.CreateThread(function()
     while openingDoor do
         TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
         Citizen.Wait(1000)
         time = time - 1
         if time <= 0 then
             openingDoor = false
             StopAnimTask(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
         end
     end
 end)
end

function ChangeDoorLooks(Door, Type)
	TriggerServerEvent('fw-doorlock:server:change:door:looks', Door, Type)
end