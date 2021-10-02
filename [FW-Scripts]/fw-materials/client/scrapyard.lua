local NearScrapYard = false
local CurrentScrapYard = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
         local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
         NearScrapYard = false
         for k, v in pairs(Config.ScrapyardLocations) do 
             local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
             if Area < 7.5 then
                CurrentScrapYard = k
                NearScrapYard = true
             end
         end
         if not NearScrapYard then
            Citizen.Wait(2500)
            CurrentScrapYard = false
         end
        end
    end
end)

RegisterNetEvent('fw-materials:client:scrap:vehicle')
AddEventHandler('fw-materials:client:scrap:vehicle', function()
    local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
    if Config.CanScrap then
        Config.CanScrap = false
	    Framework.Functions.TriggerCallback('fw-materials:server:is:vehicle:owned', function(IsOwned)
        if not IsOwned then
            local Time = math.random(30000, 40000)
	        ScrapVehicleAnim(Time)
	    	Framework.Functions.Progressbar("scrap-vehicle", "Voertuig slopen..", Time, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                Framework.Functions.DeleteVehicle(Vehicle)
                StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                TriggerServerEvent('fw-materials:server:scrap:reward')
                Citizen.SetTimeout((1000 * 60) * 10, function()
                   Config.CanScrap = true
                end)
            end, function() -- Cancel
                StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                Framework.Functions.Notify("Đã hủy..", "error")
            end)				
	    else
	    	Framework.Functions.Notify("Dit voertuig kan niet worden gesloopt hij is van iemand..", "error")									
        end
        end, GetVehicleNumberPlateText(Vehicle))
    else
      Framework.Functions.Notify("Je moet nog even wachten..", "error")	
    end								
end)

function IsNearScrapYard()
  if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
      return NearScrapYard
  else
      return false
  end
end

function ScrapVehicleAnim(time)
    time = (time / 1000)
    exports['fw-assets']:RequestAnimationDict("mp_car_bomb")
    TaskPlayAnim(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    Scrapping = true
    Citizen.CreateThread(function()
        while Scrapping do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(2000)
			time = time - 2
            if time <= 0 then
                Scrapping = false
                StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
            end
        end
    end)
end