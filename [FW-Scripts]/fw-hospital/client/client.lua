local BedData = nil
local BedCam = nil
local onDuty = false
local CurrentGarage = nil
isLoggedIn = false

Framework = nil  

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
    TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
     Citizen.Wait(250)
      Framework.Functions.GetPlayerData(function(PlayerData)
         if PlayerData.metadata["isdead"] then
          SetState('death', true)
         end
         isLoggedIn = true
         onDuty = PlayerData.job.onduty
         TriggerServerEvent("fw-police:server:UpdateBlips")
     end)
    end) 
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
 TriggerServerEvent('fw-hospital:server:save:health:armor', GetEntityHealth(GetPlayerPed(-1)), GetPedArmour(GetPlayerPed(-1)))
 isLoggedIn = false
end)

RegisterNetEvent('Framework:Client:SetDuty')
AddEventHandler('Framework:Client:SetDuty', function(Onduty)
 TriggerServerEvent("fw-police:server:UpdateBlips")
 onDuty = Onduty
end)

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
            Citizen.Wait(20000)
            TriggerServerEvent('fw-hospital:server:save:health:armor', GetEntityHealth(GetPlayerPed(-1)), GetPedArmour(GetPlayerPed(-1)))
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            NearSomething = false

            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations["Duty"][1]['X'], Config.Locations["Duty"][1]['Y'], Config.Locations["Duty"][1]['Z'], true) < 1.5) then
                if (Framework.Functions.GetPlayerData().job.name == "ambulance") then
                  DrawMarker(2, Config.Locations["Duty"][1]['X'], Config.Locations["Duty"][1]['Y'], Config.Locations["Duty"][1]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                  NearSomething = true
                  if not onDuty then
                    DrawText3D(Config.Locations["Duty"][1]['X'], Config.Locations["Duty"][1]['Y'], Config.Locations["Duty"][1]['Z'] + 0.15, '~g~E~w~ - In dienst gaan')
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent("Framework:ToggleDuty", true)
                    end
                else
                    DrawText3D(Config.Locations["Duty"][1]['X'], Config.Locations["Duty"][1]['Y'], Config.Locations["Duty"][1]['Z'] + 0.15, '~r~E~w~ - Uit dienst gaan')
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent("Framework:ToggleDuty", false)
                    end
                end
                end
            end

            if onDuty then

             if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations["Shop"][1]['X'], Config.Locations["Shop"][1]['Y'], Config.Locations["Shop"][1]['Z'], true) < 1.5) then
                 if (Framework.Functions.GetPlayerData().job.name == "ambulance") and Framework.Functions.GetPlayerData().job.onduty then
                   DrawText3D(Config.Locations["Shop"][1]['X'], Config.Locations["Shop"][1]['Y'], Config.Locations["Shop"][1]['Z'] + 0.15, '~g~E~s~ - Ambulance Kast')
                   DrawMarker(2, Config.Locations["Shop"][1]['X'], Config.Locations["Shop"][1]['Y'], Config.Locations["Shop"][1]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                   NearSomething = true
                   if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("fw-inventory:server:OpenInventory", "shop", "hospital", Config.Items)
                   end
                 end
             end

             if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations["Storage"][1]['X'], Config.Locations["Storage"][1]['Y'], Config.Locations["Storage"][1]['Z'], true) < 1.5) then
                if (Framework.Functions.GetPlayerData().job.name == "ambulance") and Framework.Functions.GetPlayerData().job.onduty then
                  DrawText3D(Config.Locations["Storage"][1]['X'], Config.Locations["Storage"][1]['Y'], Config.Locations["Storage"][1]['Z'] + 0.15, '~g~E~s~ - Ambulance Opslag')
                  DrawMarker(2, Config.Locations["Storage"][1]['X'], Config.Locations["Storage"][1]['Y'], Config.Locations["Storage"][1]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                  NearSomething = true
                  if IsControlJustReleased(0, 38) then
                    local Other = {maxweight = 2000000, slots = 200}
                    TriggerServerEvent("fw-inventory:server:OpenInventory", "stash", "AmbulanceKast", Other)
                    TriggerEvent("fw-inventory:client:SetCurrentStash", "AmbulanceKast")
                  end
                end
             end
             
            end

             if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations["CheckIn"]['X'], Config.Locations["CheckIn"]['Y'], Config.Locations["CheckIn"]['Z'], true) < 1.5) then
              DrawText3D(Config.Locations["CheckIn"]['X'], Config.Locations["CheckIn"]['Y'], Config.Locations["CheckIn"]['Z'] + 0.15, '~g~E~s~ - Inchecken (~g~€~s~500)')
              DrawMarker(2, Config.Locations["CheckIn"]['X'], Config.Locations["CheckIn"]['Y'], Config.Locations["CheckIn"]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
             NearSomething = true
             if IsControlJustReleased(0, 38) then
                local BedSomething = GetAvailableBed()
                if BedSomething ~= nil or BedSomething ~= false then
                    Framework.Functions.TriggerCallback("fw-hospital:server:pay:hospital", function(HasPaid)
                        if HasPaid then
                            DetachEntity(GetPlayerPed(-1), true, false)
                            Framework.Functions.Progressbar("lockpick-door", "Inchecken..", 2500, false, false, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                animDict = "missheistdockssetup1clipboard@base",
                                anim = "base",
                                flags = 49,
                            }, {
                                model = "p_amb_clipboard_01",
                                bone = 18905,
                                coords = { x = 0.10, y = 0.02, z = 0.08 },
                                rotation = { x = -80.0, y = 0.0, z = 0.0 },
                            }, {
                                model = "prop_pencil_01",
                                bone = 58866,
                                coords = { x = 0.12, y = 0.0, z = 0.001 },
                                rotation = { x = -150.0, y = 0.0, z = 0.0 },
                            }, function() -- Done
                                TriggerEvent('fw-hospital:client:send:to:bed', BedSomething)
                            end, function() -- Cancel
                                Framework.Functions.Notify("Quá trình bị hủy..", "error")
                            end)
                        end
                    end)
                else
                    Framework.Functions.Notify("Bedden zijn bezet..", 'error')
                end
             end
            end

            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToHeli']['X'], Config.Locations['Teleporters']['ToHeli']['Y'], Config.Locations['Teleporters']['ToHeli']['Z'], true) < 1.5) then
                DrawText3D(Config.Locations['Teleporters']['ToHeli']['X'], Config.Locations['Teleporters']['ToHeli']['Y'], Config.Locations['Teleporters']['ToHeli']['Z'] + 0.15, '~g~E~s~ - Naar boven')
                DrawMarker(2, Config.Locations['Teleporters']['ToHeli']['X'], Config.Locations['Teleporters']['ToHeli']['Y'], Config.Locations['Teleporters']['ToHeli']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                NearSomething = true
                if IsControlJustReleased(0, 38) then
                    DoScreenFadeOut(450)
                    Citizen.Wait(450)
                    TriggerEvent("fw-sound:client:play", "hospital-elevator", 0.25)
                    SetEntityCoords(GetPlayerPed(-1), Config.Locations['Teleporters']['ToHospitalFirst']['X'], Config.Locations['Teleporters']['ToHospitalFirst']['Y'], Config.Locations['Teleporters']['ToHospitalFirst']['Z'])
                    Citizen.Wait(250)
                    DoScreenFadeIn(450)
                end
            end

            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToHospitalFirst']['X'], Config.Locations['Teleporters']['ToHospitalFirst']['Y'], Config.Locations['Teleporters']['ToHospitalFirst']['Z'], true) < 1.5) then
                DrawText3D(Config.Locations['Teleporters']['ToHospitalFirst']['X'], Config.Locations['Teleporters']['ToHospitalFirst']['Y'], Config.Locations['Teleporters']['ToHospitalFirst']['Z'] + 0.15, '~g~E~s~ - Naar beneden')
                DrawMarker(2, Config.Locations['Teleporters']['ToHospitalFirst']['X'], Config.Locations['Teleporters']['ToHospitalFirst']['Y'], Config.Locations['Teleporters']['ToHospitalFirst']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                NearSomething = true
                if IsControlJustReleased(0, 38) then
                    DoScreenFadeOut(450)
                    Citizen.Wait(450)
                    TriggerEvent("fw-sound:client:play", "hospital-elevator", 0.25)
                    SetEntityCoords(GetPlayerPed(-1), Config.Locations['Teleporters']['ToHeli']['X'], Config.Locations['Teleporters']['ToHeli']['Y'], Config.Locations['Teleporters']['ToHeli']['Z'])
                    Citizen.Wait(250)
                    DoScreenFadeIn(450)
                end
            end

            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToLower']['X'], Config.Locations['Teleporters']['ToLower']['Y'], Config.Locations['Teleporters']['ToLower']['Z'], true) < 1.5) then
                DrawText3D(Config.Locations['Teleporters']['ToLower']['X'], Config.Locations['Teleporters']['ToLower']['Y'], Config.Locations['Teleporters']['ToLower']['Z'] + 0.15, '~g~E~s~ - Naar boven')
                DrawMarker(2, Config.Locations['Teleporters']['ToLower']['X'], Config.Locations['Teleporters']['ToLower']['Y'], Config.Locations['Teleporters']['ToLower']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                NearSomething = true
                if IsControlJustReleased(0, 38) then
                    DoScreenFadeOut(450)
                    Citizen.Wait(450)
                    TriggerEvent("fw-sound:client:play", "hospital-elevator", 0.25)
                    SetEntityCoords(GetPlayerPed(-1), Config.Locations['Teleporters']['ToHospitalSecond']['X'], Config.Locations['Teleporters']['ToHospitalSecond']['Y'], Config.Locations['Teleporters']['ToHospitalSecond']['Z'])
                    Citizen.Wait(250)
                    DoScreenFadeIn(450)
                end
            end
            
            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToHospitalSecond']['X'], Config.Locations['Teleporters']['ToHospitalSecond']['Y'], Config.Locations['Teleporters']['ToHospitalSecond']['Z'], true) < 1.5) then
                DrawText3D(Config.Locations['Teleporters']['ToHospitalSecond']['X'], Config.Locations['Teleporters']['ToHospitalSecond']['Y'], Config.Locations['Teleporters']['ToHospitalSecond']['Z'] + 0.15, '~g~E~s~ - Naar beneden')
                DrawMarker(2, Config.Locations['Teleporters']['ToHospitalSecond']['X'], Config.Locations['Teleporters']['ToHospitalSecond']['Y'], Config.Locations['Teleporters']['ToHospitalSecond']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                NearSomething = true
                if IsControlJustReleased(0, 38) then
                    DoScreenFadeOut(450)
                    Citizen.Wait(450)
                    TriggerEvent("fw-sound:client:play", "hospital-elevator", 0.25)
                    SetEntityCoords(GetPlayerPed(-1), Config.Locations['Teleporters']['ToLower']['X'], Config.Locations['Teleporters']['ToLower']['Y'], Config.Locations['Teleporters']['ToLower']['Z'])
                    Citizen.Wait(250)
                    DoScreenFadeIn(450)
                end
            end

            if not NearSomething then
                Citizen.Wait(1500)
            end

        end
    end
end)

-- // Events \\ --

RegisterNetEvent('fw-hospital:client:revive')
AddEventHandler('fw-hospital:client:revive', function(UseAnim, IsAdmin)
    if Config.IsDeath then
      SetState('death', false)
      SetEntityInvincible(GetPlayerPed(-1), false)
      NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId(), true), true, true, false)   
    end
    ResetBodyHp()
    ResetScreenAndWalk()
    ClearPedTasks(GetPlayerPed(-1))
    SetEntityHealth(GetPlayerPed(-1), 200)
    ClearPedBloodDamage(GetPlayerPed(-1))
    SetPlayerSprint(PlayerId(), true)
    if UseAnim then
     TriggerEvent('fw-hospital:client:revive:anim')
    end
    if IsAdmin then
     TriggerServerEvent("Framework:Server:SetMetaData", "thirst", Framework.Functions.GetPlayerData().metadata["thirst"] + 25)
     TriggerServerEvent("Framework:Server:SetMetaData", "hunger", Framework.Functions.GetPlayerData().metadata["hunger"] + 25)  
    end
    TriggerServerEvent('fw-hud:server:remove:stress', 15)
    TriggerEvent('fw-police:client:set:escort:status:false')
    Framework.Functions.Notify("Je bent weer helemaal top!", 'success')
end)

RegisterNetEvent('fw-hospital:client:heal:closest')
AddEventHandler('fw-hospital:client:heal:closest', function()
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    local RandomTime = math.random(10000, 15000)
    if Player ~= -1 and Distance < 1.5 then
        if not IsTargetDead(GetPlayerServerId(Player)) then
           HealAnim(RandomTime)
           Framework.Functions.Progressbar("healing-citizen", "Persoon verzorgen..", RandomTime, false, true, {
               disableMovement = true,
               disableCarMovement = true,
               disableMouse = false,
               disableCombat = true,
           }, {}, {}, {}, function() -- Done
               TriggerServerEvent('fw-hospital:server:heal:player', GetPlayerServerId(Player))
               Framework.Functions.Notify("Persoon geholpen", "success")
           end, function() -- Cancel
               Framework.Functions.Notify("Proces Đã hủy..", "error")
           end)
        else
            Framework.Functions.Notify("Deze burger is bewusteloos..", "error")
        end
    end
end)

RegisterNetEvent('fw-hospital:client:revive:closest')
AddEventHandler('fw-hospital:client:revive:closest', function()
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    local RandomTime = math.random(10000, 15000)
    if Player ~= -1 and Distance < 1.5 then
      if IsTargetDead(GetPlayerServerId(Player)) then
         exports['fw-assets']:RequestAnimationDict("mini@cpr@char_a@cpr_str")
         TaskPlayAnim( PlayerPedId(), "mini@cpr@char_a@cpr_str", "cpr_pumpchest", 8.0, 1.0, -1, 1, 0, 0, 0, 0)
         Framework.Functions.Progressbar("hospital_revive", "Đang cứu..", RandomTime, false, true, {
             disableMovement = false,
             disableCarMovement = false,
             disableMouse = false,
             disableCombat = true,
         }, {}, {}, {}, function() -- Done
             TriggerServerEvent('fw-hospital:server:revive:player', GetPlayerServerId(Player))
             StopAnimTask(GetPlayerPed(-1), 'mini@cpr@char_a@cpr_str', "exit", 1.0)
             Framework.Functions.Notify("Đã hồi sinh thành công!")
         end, function() -- Cancel
             StopAnimTask(GetPlayerPed(-1), 'mini@cpr@char_a@cpr_str', "exit", 1.0)
             Framework.Functions.Notify("Thất bại!", "error")
         end)
        else
            Framework.Functions.Notify("Người chơi không bất tỉnh..", "error")
        end
    end
end)

RegisterNetEvent('fw-hospital:client:take:blood:closest')
AddEventHandler('fw-hospital:client:take:blood:closest', function()
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    local RandomTime = math.random(7500, 10500)
    if Player ~= -1 and Distance < 1.5 then
      HealAnim(RandomTime)
      Framework.Functions.Progressbar("healing-citizen", "Đang lấy máu..", RandomTime, false, true, {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true,
      }, {}, {}, {}, function() -- Done
          TriggerServerEvent('fw-hospital:server:take:blood:player', GetPlayerServerId(Player))
          Framework.Functions.Notify("Lấy máu thành công", "success")
      end, function() -- Cancel
          Framework.Functions.Notify("Quá trình bị hủy..", "error")
      end)
    end
end)

RegisterNetEvent('fw-hospital:client:heal')
AddEventHandler('fw-hospital:client:heal', function()
    local CurrentHealth = GetEntityHealth(GetPlayerPed(-1))
    local NewHealth = CurrentHealth + 15.0
    if CurrentHealth + 15.0 > 100.0 then
        NewHealth = 100.0
    end
    ResetBodyHp()
    ClearPedTasks(GetPlayerPed(-1))
    ClearPedBloodDamage(GetPlayerPed(-1))
    SetEntityHealth(GetPlayerPed(-1), NewHealth)
end)

RegisterNetEvent('fw-hospital:client:revive:anim')
AddEventHandler('fw-hospital:client:revive:anim', function()
 exports['fw-assets']:RequestAnimationDict("random@crash_rescue@help_victim_up")
 TaskPlayAnim(GetPlayerPed(-1), "random@crash_rescue@help_victim_up", "helping_victim_to_feet_victim", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
 Citizen.Wait(1850)
 ClearPedSecondaryTask(GetPlayerPed(-1))
end)

RegisterNetEvent('fw-hospital:client:set:bed:state')
AddEventHandler('fw-hospital:client:set:bed:state', function(BedData, bool)
  Config.Beds[BedData]['Busy'] = bool
end)

RegisterNetEvent('fw-hospital:client:send:to:bed')
AddEventHandler('fw-hospital:client:send:to:bed', function(BedId)
    Citizen.SetTimeout(50, function()
        EnterBedCam(BedId)
        Framework.Functions.Notify('Bạn đã được hồi sinh..', 'info')
        Citizen.Wait(25000)
        TriggerEvent('fw-hospital:client:revive', false, false)
        LeaveBed()
    end)
end)

RegisterNetEvent('fw-hospital:client:spawn:vehicle')
AddEventHandler('fw-hospital:client:spawn:vehicle', function(VehicleName)
    if VehicleName ~= 'AmbulanceHeli' then
        local RandomCoords = Config.Locations['Garage'][CurrentGarage]['Spawns'][math.random(1, #Config.Locations['Garage'][CurrentGarage]['Spawns'])]
        local CoordTable = {x = RandomCoords['X'], y = RandomCoords['Y'], z = RandomCoords['Z'], a = RandomCoords['H']}    
        local CanSpawn = Framework.Functions.IsSpawnPointClear(CoordTable, 2.0)
        if CanSpawn then
            Framework.Functions.SpawnVehicle(VehicleName, function(Vehicle)
              Citizen.Wait(25)
              exports['fw-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
              exports['fw-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
              exports['fw-emergencylights']:SetupEmergencyVehicle(Vehicle)
              Framework.Functions.Notify('Xe của bạn đã ở bãi đậu xe', 'info')
              CurrentGarage = nil
            end, CoordTable, true, false)
        else
            Framework.Functions.Notify('Khu vực lấy xe bị chặn..', 'error')
        end
      else
        local CoordTable = {x = 352.17, y = -587.87, z = 74.16, a = 90.57}
        local CanSpawn = Framework.Functions.IsSpawnPointClear(CoordTable, 3.0)
        if CanSpawn then
            Framework.Functions.SpawnVehicle('AmbulanceHeli', function(Vehicle)
             Citizen.Wait(25)
             exports['fw-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
             exports['fw-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
             Framework.Functions.Notify('Máy bay của bạn đã được lấy ra!', 'info')
             CurrentGarage = nil
            end, CoordTable, true, false)
        else
            Framework.Functions.Notify('Khu vực lấy máy bay bị chặn..', 'error')
        end
      end
end)

-- // Functions \\ --

function NearGarage()
  for k, v in pairs(Config.Locations['Garage']) do
      local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
      if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true) < 10.0) then
          CurrentGarage = k
          return true
      end
  end
end

function EnterBedCam(BedId)
    Config.IsInBed = true
    BedData = BedId
    TriggerServerEvent('fw-hospital:server:set:bed:state', BedData, true)
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Citizen.Wait(100)
    end
    BedObject = GetClosestObjectOfType(Config.Beds[BedData]['X'], Config.Beds[BedData]['Y'], Config.Beds[BedData]['Z'], 1.0, Config.Beds[BedData]['Hash'], false, false, false)
    SetEntityCoords(GetPlayerPed(-1), Config.Beds[BedData]['X'], Config.Beds[BedData]['Y'], Config.Beds[BedData]['Z'] + 0.02)
    Citizen.Wait(500)
    FreezeEntityPosition(GetPlayerPed(-1), true)
    exports['fw-assets']:RequestAnimationDict("misslamar1dead_body")
    TaskPlayAnim(GetPlayerPed(-1), "misslamar1dead_body", "dead_idle", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
    SetEntityHeading(GetPlayerPed(-1), Config.Beds[BedData]['H'])
    BedCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(BedCam, true)
    RenderScriptCams(true, false, 1, true, true)
    AttachCamToPedBone(BedCam, GetPlayerPed(-1), 31085, 0, 1.0, 1.0 , true)
    SetCamFov(BedCam, 100.0)
    SetCamRot(BedCam, -45.0, 0.0, GetEntityHeading(GetPlayerPed(-1)) + 180, true)
    DoScreenFadeIn(1000)
end

function LeaveBed()
    exports['fw-assets']:RequestAnimationDict('switch@franklin@bed')
    FreezeEntityPosition(GetPlayerPed(-1), false)
    SetEntityInvincible(GetPlayerPed(-1), false)
    SetEntityHeading(GetPlayerPed(-1), Config.Beds[BedData]['H'] + 90)
    TaskPlayAnim(GetPlayerPed(-1), 'switch@franklin@bed', 'sleep_getup_rubeyes', 100.0, 1.0, -1, 8, -1, 0, 0, 0)
    Citizen.Wait(4000)
    ClearPedTasks(GetPlayerPed(-1))
    RenderScriptCams(0, true, 200, true, true)
    DestroyCam(BedCam, false)
    TriggerServerEvent('fw-hospital:server:set:bed:state', BedData, false)
end

function HealAnim(time)
  time = time / 1000
  exports['fw-assets']:RequestAnimationDict("weapons@first_person@aim_rng@generic@projectile@thermal_charge@")
  TaskPlayAnim(GetPlayerPed(-1), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor" ,3.0, 3.0, -1, 16, 0, false, false, false)
  Healing = true
  Citizen.CreateThread(function()
      while Healing do
          TaskPlayAnim(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
          Citizen.Wait(2000)
          time = time - 2
          if time <= 0 then
              Healing = false
              StopAnimTask(GetPlayerPed(-1), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 1.0)
          end
      end
  end)
end

function ResetScreenAndWalk() 
    Citizen.SetTimeout(1500, function()
        SetFlash(false, false, 450, 3000, 450)
        Citizen.Wait(350)
        ClearTimecycleModifier()
        ResetPedMovementClipset(PlayerPedId(), 0)
    end)
end

function GetAvailableBed()
    for k, v in pairs(Config.Beds) do
        if not v['Busy'] then
            return k
        end
    end
end

function IsTargetDead(playerId)
 local IsDead = false
  Framework.Functions.TriggerCallback('fw-police:server:is:player:dead', function(result)
    IsDead = result
  end, playerId)
  Citizen.Wait(100)
  return IsDead
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