local DutyBlips = {}
local ShopItems = {}
local ObjectList = {}
local NearPoliceGarage = false
local CurrentGarage = nil
local Locaties = {["Politie"] = {[1] = {["x"] = 473.78, ["y"] = -992.64, ["z"] = 26.27, ["h"] = 0.0}, [2] = {["x"] = -445.87, ["y"] = 6013.88, ["z"] = 31.71, ["h"] = 0.0}}}
local FingerPrintSession = nil
PlayerJob = {}
isLoggedIn = false
onDuty = false

Framework = nil

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(500, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
      Citizen.Wait(450)
      Framework.Functions.GetPlayerData(function(PlayerData)
      PlayerJob, onDuty = PlayerData.job, PlayerData.job.onduty 
      if PlayerJob.name == 'police' and PlayerData.job.onduty then
       TriggerEvent('fw-radialmenu:client:update:duty:vehicles')
       TriggerEvent('fw-police:client:set:radio')
       TriggerServerEvent("fw-police:server:UpdateBlips")
       TriggerServerEvent("fw-police:server:UpdateCurrentCops")
      end
      isLoggedIn = true 
      SpawnIncheckProp()
      end)
    end)
end)

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(500, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)  
     Citizen.Wait(3500)
     Framework.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.metadata['tracker'] then
          TriggerEvent('fw-police:client:set:tracker', true)
        end
        if PlayerData.metadata['ishandcuffed'] then
            TriggerServerEvent('fw-sound:server:play:distance', 2.0, 'handcuff', 0.2)
            Config.IsHandCuffed = true
        end
        isLoggedIn = true 
     end)
    end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    isLoggedIn = false
    if PlayerJob.name == 'police' then
      TriggerServerEvent("Framework:ToggleDuty", false)
      TriggerServerEvent("fw-police:server:UpdateCurrentCops")
      if DutyBlips ~= nil then 
        for k, v in pairs(DutyBlips) do
            RemoveBlip(v)
        end
        DutyBlips = {}
      end
    end
    ClearPedTasks(GetPlayerPed(-1))
    DetachEntity(GetPlayerPed(-1), true, false)
end)

RegisterNetEvent('Framework:Client:OnJobUpdate')
AddEventHandler('Framework:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    TriggerServerEvent("fw-police:server:UpdateBlips")
    if (PlayerJob ~= nil) and PlayerJob.name ~= "police" or PlayerJob.name ~= 'ambulance' then
        if DutyBlips ~= nil then
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
    end
end)

RegisterNetEvent('Framework:Client:SetDuty')
AddEventHandler('Framework:Client:SetDuty', function(Onduty)
TriggerServerEvent("fw-police:server:UpdateBlips")
 if not Onduty then
    if PlayerJob.name == 'police' or PlayerJob.name == 'ambulance' then
     for k, v in pairs(DutyBlips) do
         RemoveBlip(v)
     end
     DutyBlips = {}
    end
 end
 onDuty = Onduty
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if isLoggedIn then
            if PlayerJob.name == "police" then
               NearAnything = false
               local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))

               if onDuty then

                for k, v in pairs(Config.Locations['fingerprint']) do 
                    local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                    if Area < 3.3 then
                        NearAnything = true
                        DrawMarker(2, v['X'], v['Y'], v['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 50, 107, 168, 255, false, false, false, 1, false, false, false)
                    end
                    if Area < 2.0 then
                        NearAnything = true
                         DrawText3D(v['X'], v['Y'], v['Z'] + 0.15, '~b~E~w~ - Vinger Scanner')
                         if IsControlJustReleased(0, Config.Keys['E']) then
                            local Player, Distance = Framework.Functions.GetClosestPlayer()
                            if Player ~= -1 and Distance < 2.5 then
                                 TriggerServerEvent("fw-police:server:show:machine", GetPlayerServerId(Player))
                            else
                                Framework.Functions.Notify("Không có ai xung quanh!", "error")
                            end
                        end
                    end
                end
                NearPoliceGarage = false
                for k, v in pairs(Config.Locations['garage']) do 
                    local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                    if Area < 5.5 then
                        NearAnything = true
                        NearPoliceGarage = true
                        CurrentGarage = k
                    end
                end

                for k, v in pairs(Config.Locations['personal-safe']) do 
                    local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                    if Area < 1.5 then
                        NearAnything = true
                        DrawText3D(v['X'], v['Y'], v['Z'] + 0.15, "~g~E~w~ - Persoonlijke kluis")
                        DrawMarker(2, v['X'], v['Y'], v['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                        if IsControlJustReleased(0, Config.Keys["E"]) then
                          TriggerServerEvent("fw-inventory:server:OpenInventory", "stash", "personalsafe_"..Framework.Functions.GetPlayerData().citizenid)
                          TriggerEvent("fw-inventory:client:SetCurrentStash", "personalsafe_"..Framework.Functions.GetPlayerData().citizenid)
                        end
                    end
                end

                for k, v in pairs(Config.Locations['work-shops']) do 
                    local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                    if Area < 1.5 then
                        NearAnything = true
                        DrawText3D(v['X'], v['Y'], v['Z'] + 0.15, "~g~E~w~ - Politie Kluis")
                        DrawMarker(2, v['X'], v['Y'], v['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                        if IsControlJustReleased(0, Config.Keys["E"]) then
                            SetWeaponSeries()
                            TriggerServerEvent("fw-inventory:server:OpenInventory", "shop", "police", Config.Items)
                        end
                    end
                end
              end
              if not NearAnything then 
                  Citizen.Wait(1500)
                  CurrentGarage = nil
              end
            else
                Citizen.Wait(1000)
            end
        end 
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if Config.IsEscorted then
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true)
			EnableControlAction(0, 2, true)
            EnableControlAction(0, 245, true)
            EnableControlAction(0, 38, true)
            EnableControlAction(0, 322, true)
        end
        if Config.IsHandCuffed then
            DisableControlAction(0, 24, true) 
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 25, true) 
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 45, true)
			DisableControlAction(0, 22, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(1, 37, true)
			DisableControlAction(0, 23, true)
			DisableControlAction(0, 288, true)
            DisableControlAction(2, 199, true)
            DisableControlAction(2, 244, true)
            DisableControlAction(0, 137, true)
			DisableControlAction(0, 59, true) 
			DisableControlAction(0, 71, true) 
			DisableControlAction(0, 72, true) 
			DisableControlAction(0, 73, true) 
			DisableControlAction(2, 36, true) 
			DisableControlAction(0, 264, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 143, true)
			DisableControlAction(0, 75, true) 
            DisableControlAction(27, 75, true)
            DisableControlAction(0, 245, true)
            if (not IsEntityPlayingAnim(GetPlayerPed(-1), "mp_arresting", "idle", 3) and not IsEntityPlayingAnim(GetPlayerPed(-1), "mp_arrest_paired", "crook_p2_back_right", 3)) and not Framework.Functions.GetPlayerData().metadata["isdead"] then
                exports['fw-assets']:RequestAnimationDict("mp_arresting")
                TaskPlayAnim(GetPlayerPed(-1), "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
            end
        end
        if not Config.IsEscorted and not Config.IsHandCuffed then
            Citizen.Wait(2000)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('fw-police:client:UpdateBlips')
AddEventHandler('fw-police:client:UpdateBlips', function(players)
    if PlayerJob ~= nil and (PlayerJob.name == 'police' or PlayerJob.name == 'ambulance') and onDuty then
        if DutyBlips ~= nil then 
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
        if players ~= nil then
            for k, data in pairs(players) do
                local id = GetPlayerFromServerId(data.source)
                if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
                    CreateDutyBlips(id, data.label, data.job)
                end
            end
        end
	end
end)

RegisterNetEvent('fw-police:client:bill:player')
AddEventHandler('fw-police:client:bill:player', function(price)
    SetTimeout(math.random(2500, 3000), function()
        local gender = "meneer"
        if Framework.Functions.GetPlayerData().charinfo.gender == 1 then
            gender = "mevrouw"
        end
        local charinfo = Framework.Functions.GetPlayerData().charinfo
        TriggerServerEvent('fw-phone:server:sendNewMail', {
            sender = "Politie Los Santos",
            subject = "Boete Kosten",
            message = "Beste " .. gender .. " " .. charinfo.lastname .. ",<br/><br />Het Centraal Justitieel Incassobureau (CJIB) heeft de boetes die u heeft ontvangen van de politie in rekening gebracht.<br /><br />De boete bedraagd: <strong>€"..price.."</strong> <br><br>Gelieve dit bedrag binnen <strong>14</strong> werk dagen te betalen.<br/><br/>Met vriendelijke groet,<br />Frank B. (Rechter)",
            button = {}
        })
    end)
end)

-- // Cuff & Escort Event \\ --
RegisterNetEvent('fw-police:client:cuff:closest')
AddEventHandler('fw-police:client:cuff:closest', function()
if not IsPedRagdoll(GetPlayerPed(-1)) then
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 1.5 then
        local ServerId = GetPlayerServerId(Player)
        if not IsPedInAnyVehicle(GetPlayerPed(Player)) and not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            TriggerServerEvent("fw-police:server:cuff:closest", ServerId, true)
            HandCuffAnimation()
        else
            Framework.Functions.Notify("Je kunt niet boeien in een voertuig", "error")
        end
    else
        Framework.Functions.Notify("Không có ai xung quanh..", "error")
    end
  else
      Citizen.Wait(2000)
  end
end)

RegisterNetEvent('fw-police:client:get:cuffed')
AddEventHandler('fw-police:client:get:cuffed', function()
    local Skillbar = exports['fw-skillbar']:GetSkillbarObject()
    local NotifySend = false
    local SucceededAttempts = 0
    local NeededAttempts = 1
    if not Config.IsHandCuffed then
        GetCuffedAnimation()
        if math.random(1,3) == 2 then
            Skillbar.Start({
                duration = math.random(360, 375),
                pos = math.random(10, 30),
                width = math.random(10, 20),
            }, function()
                if SucceededAttempts + 1 >= NeededAttempts then
                    -- Finish
                    SucceededAttempts = 0
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    Framework.Functions.Notify("Je bent los gebroken")
                else
                    -- Repeat
                    Skillbar.Repeat({
                        duration = math.random(500, 1300),
                        pos = math.random(10, 40),
                        width = math.random(5, 13),
                    })
                    SucceededAttempts = SucceededAttempts + 1
                end
            end, function()
                -- Fail
                Config.IsHandCuffed = true
                TriggerServerEvent("fw-police:server:set:handcuff:status", true)
                SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("weapon_unarmed"), 1)
                ClearPedTasksImmediately(GetPlayerPed(-1))
                SucceededAttempts = 0
                if not NotifySend then
                    NotifySend = true
                    Framework.Functions.Notify("Je bent geboeid, maar je kan lopen")
                    Citizen.Wait(100)
                    NotifySend = false
                end
            end)
        else
            Config.IsHandCuffed = true
            TriggerServerEvent("fw-police:server:set:handcuff:status", true)
            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("weapon_unarmed"), 1)
            ClearPedTasksImmediately(GetPlayerPed(-1))
        end
    else
        Config.IsEscorted = false
        Config.IsHandCuffed = false
        DetachEntity(GetPlayerPed(-1), true, false)
        TriggerServerEvent("fw-police:server:set:handcuff:status", false)
        ClearPedTasksImmediately(GetPlayerPed(-1))
        Framework.Functions.Notify("Je bent ontboeid!")
    end
end)

RegisterNetEvent('fw-police:client:set:escort:status:false')
AddEventHandler('fw-police:client:set:escort:status:false', function()
 if Config.IsEscorted then
  Config.IsEscorted = false
  DetachEntity(GetPlayerPed(-1), true, false)
  ClearPedTasks(GetPlayerPed(-1))
 end
end)

RegisterNetEvent('fw-police:client:escort:closest')
AddEventHandler('fw-police:client:escort:closest', function()
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local ServerId = GetPlayerServerId(Player)
        if not Config.IsHandCuffed and not Config.IsEscorted then
          if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
            TriggerServerEvent("fw-police:server:escort:closest", ServerId)
        else
         Framework.Functions.Notify("Je kan niet iemand escorteren in een auto..", "error")
       end
     end
    else
        Framework.Functions.Notify("Không có ai xung quanh..", "error")
    end
end)

RegisterNetEvent('fw-police:client:get:escorted')
AddEventHandler('fw-police:client:get:escorted', function(PlayerId)
    if not Config.IsEscorted then
        Config.IsEscorted = true
        local dragger = GetPlayerPed(GetPlayerFromServerId(PlayerId))
        local heading = GetEntityHeading(dragger)
        SetEntityCoords(GetPlayerPed(-1), GetOffsetFromEntityInWorldCoords(dragger, 0.0, 0.45, 0.0))
        AttachEntityToEntity(GetPlayerPed(-1), dragger, 11816, 0.45, 0.45, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    else
        Config.IsEscorted = false
        DetachEntity(GetPlayerPed(-1), true, false)
    end
end)

RegisterNetEvent('fw-police:client:PutPlayerInVehicle')
AddEventHandler('fw-police:client:PutPlayerInVehicle', function()
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local ServerId = GetPlayerServerId(Player)
        if not Config.IsHandCuffed and not Config.IsEscorted  then
            TriggerServerEvent("fw-police:server:set:in:veh", ServerId)
        end
    else
        Framework.Functions.Notify("Không có ai xung quanh..", "error")
    end
end)

RegisterNetEvent('fw-police:client:SetPlayerOutVehicle')
AddEventHandler('fw-police:client:SetPlayerOutVehicle', function()
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local ServerId = GetPlayerServerId(Player)
        if not Config.IsHandCuffed and not Config.IsEscorted then
            TriggerServerEvent("fw-police:server:set:out:veh", ServerId)
        end
    else
        Framework.Functions.Notify("Không có ai xung quanh..", "error")
    end
end)

RegisterNetEvent('fw-police:client:set:out:veh')
AddEventHandler('fw-police:client:set:out:veh', function()
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        TaskLeaveVehicle(GetPlayerPed(-1), vehicle, 16)
    end
end)

RegisterNetEvent('fw-police:client:set:in:veh')
AddEventHandler('fw-police:client:set:in:veh', function()
    if Config.IsHandCuffed or Config.IsEscorted then
        local vehicle = Framework.Functions.GetClosestVehicle()
        if DoesEntityExist(vehicle) then
			for i = GetVehicleMaxNumberOfPassengers(vehicle), -1, -1 do
                if IsVehicleSeatFree(vehicle, i) then
                    Config.IsEscorted = false
                    ClearPedTasks(GetPlayerPed(-1))
                    DetachEntity(GetPlayerPed(-1), true, false)
                    Citizen.Wait(100)
                    SetPedIntoVehicle(GetPlayerPed(-1), vehicle, i)
                    return
                end
            end
		end
    end
end)

RegisterNetEvent('fw-police:client:steal:closest')
AddEventHandler('fw-police:client:steal:closest', function()
    local player, distance = Framework.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerPed = GetPlayerPed(player)
        local playerId = GetPlayerServerId(player)
        if IsEntityPlayingAnim(playerPed, "missminuteman_1ig_2", "handsup_base", 3) or IsEntityPlayingAnim(playerPed, "mp_arresting", "idle", 3) or IsTargetDead(playerId) then
            Framework.Functions.TriggerCallback('fw-police:server:is:inventory:disabled', function(IsDisabled)
                if not IsDisabled then
                    Framework.Functions.Progressbar("robbing_player", "Spullen stelen..", math.random(5000, 7000), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "random@shop_robbery",
                        anim = "robbery_action_b",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        local plyCoords = GetEntityCoords(playerPed)
                        local pos = GetEntityCoords(GetPlayerPed(-1))
                        local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, plyCoords.x, plyCoords.y, plyCoords.z, true)
                        if dist < 2.5 then
                            StopAnimTask(GetPlayerPed(-1), "random@shop_robbery", "robbery_action_b", 1.0)
                            TriggerServerEvent("fw-inventory:server:OpenInventory", "otherplayer", playerId)
                            TriggerEvent("fw-inventory:server:RobPlayer", playerId)
                        else
                            StopAnimTask(GetPlayerPed(-1), "random@shop_robbery", "robbery_action_b", 1.0)
                            Framework.Functions.Notify("Không có ai xung quanh!", "error")
                        end
                    end, function() -- Cancel
                        StopAnimTask(GetPlayerPed(-1), "random@shop_robbery", "robbery_action_b", 1.0)
                        Framework.Functions.Notify("Đã hủy..", "error")
                    end)
                else
                    Framework.Functions.Notify("Jah kut he dat je hem niet kan beroven..", "error")
                end
            end, playerId)
        end
    else
        Framework.Functions.Notify("Không có ai xung quanh!", "error")
    end
end)

RegisterNetEvent('fw-police:client:search:closest')
AddEventHandler('fw-police:client:search:closest', function()
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local playerId = GetPlayerServerId(Player)
        TriggerServerEvent("fw-inventory:server:OpenInventory", "otherplayer", playerId)
        TriggerServerEvent("fw-police:server:SearchPlayer", playerId)
    else
        Framework.Functions.Notify("Không có ai xung quanh!", "error")
    end
end)

RegisterNetEvent('fw-police:client:impound:closest')
AddEventHandler('fw-police:client:impound:closest', function() 
    local Vehicle, Distance = Framework.Functions.GetClosestVehicle()
    if Vehicle ~= 0 and Distance < 1.7 then
        Framework.Functions.Progressbar("impound-vehicle", "Đang tịch thu xe..", math.random(10000, 15000), false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "random@mugging4",
            anim = "struggle_loop_b_thief",
            flags = 49,
        }, {}, {}, function() -- Done
             Framework.Functions.DeleteVehicle(Vehicle)
             Framework.Functions.Notify("Thành công", "success")
        end, function()
            Framework.Functions.Notify("Đã hủy..", "error")
        end)
    else
        Framework.Functions.Notify("Không tìm thấy phương tiện nào xung quanh..", "error")
    end
end)

RegisterNetEvent('fw-police:client:enkelband:closest')
AddEventHandler('fw-police:client:enkelband:closest', function()
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent("fw-police:server:set:tracker",  GetPlayerServerId(Player))
    else
        Framework.Functions.Notify("Không có ai xung quanh!", "error")
    end
end)

RegisterNetEvent('fw-police:client:set:tracker')
AddEventHandler('fw-police:client:set:tracker', function(bool)
    local trackerClothingData = {}
    if bool then
        trackerClothingData.outfitData = {["accessory"] = { item = 13, texture = 0}}
        TriggerEvent('fw-clothing:client:loadOutfit', trackerClothingData)
    else
        trackerClothingData.outfitData = {["accessory"] = { item = -1, texture = 0}}
        TriggerEvent('fw-clothing:client:loadOutfit', trackerClothingData)
    end
end)

RegisterNetEvent('fw-police:client:send:tracker:location')
AddEventHandler('fw-police:client:send:tracker:location', function(RequestId)
    local Coords = GetEntityCoords(GetPlayerPed(-1))
    TriggerServerEvent('fw-police:server:send:tracker:location', Coords, RequestId)
end)

RegisterNetEvent('fw-police:client:show:machine')
AddEventHandler('fw-police:client:show:machine', function(PlayerId)
    FingerPrintSession = PlayerId
    SendNUIMessage({
        type = "OpenFinger"
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent('fw-police:client:show:fingerprint:id')
AddEventHandler('fw-police:client:show:fingerprint:id', function(FingerPrintId)
 SendNUIMessage({
     type = "UpdateFingerId",
     fingerprintId = FingerPrintId
 })
 PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
end)

RegisterNetEvent('fw-police:client:show:tablet')
AddEventHandler('fw-police:client:show:tablet', function()
    exports['fw-assets']:AddProp('Tablet')
    exports['fw-assets']:RequestAnimationDict('amb@code_human_in_bus_passenger_idles@female@tablet@base')
    TaskPlayAnim(GetPlayerPed(-1), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(500)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "databank",
    })
end)

RegisterNUICallback('ScanFinger', function(data)
    TriggerServerEvent('fw-police:server:showFingerId', FingerPrintSession)
end)

RegisterNetEvent('fw-police:client:spawn:vehicle')
AddEventHandler('fw-police:client:spawn:vehicle', function(VehicleName)
    if VehicleName ~= 'PolitieZulu' then
        local RandomCoords = Config.Locations['garage'][CurrentGarage]['Spawns'][math.random(1, #Config.Locations['garage'][CurrentGarage]['Spawns'])]
        local CoordTable = {x = RandomCoords['X'], y = RandomCoords['Y'], z = RandomCoords['Z'], a = RandomCoords['H']}    
        local CanSpawn = Framework.Functions.IsSpawnPointClear(CoordTable, 2.0)
        if CanSpawn then
            Framework.Functions.SpawnVehicle(VehicleName, function(Vehicle)
              SetVehicleNumberPlateText(Vehicle, Framework.Functions.GetPlayerData().job.plate)
              Citizen.Wait(25)
              exports['fw-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
              exports['fw-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
              exports['fw-emergencylights']:SetupEmergencyVehicle(Vehicle)
              Framework.Functions.Notify('Uw dienst voertuig staat op een parkeervak', 'info')
            end, CoordTable, true, false)
        else
            Framework.Functions.Notify('Er staat al iets hier probeer het nog eens..', 'info')
        end
    else
        local CoordTable = {x = 449.76, y = -980.87, z = 43.69, a = 90.57}
        local CanSpawn = Framework.Functions.IsSpawnPointClear(CoordTable, 3.0)
        if CanSpawn then
            Framework.Functions.SpawnVehicle('PolitieZulu', function(Vehicle)
             SetVehicleNumberPlateText(Vehicle, Framework.Functions.GetPlayerData().job.plate)
             Citizen.Wait(25)
             exports['fw-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
             exports['fw-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
             Framework.Functions.Notify('Politie zulu staat op het dak klaar..', 'info')
            end, CoordTable, true, false)
        else
            Framework.Functions.Notify('Er staat al iets hier..', 'info')
        end
    end
end)

RegisterNetEvent('fw-police:client:open:evidence')
AddEventHandler('fw-police:client:open:evidence', function(args)
 local Coords = GetEntityCoords(GetPlayerPed(-1))
 NearPolice = false
 for k, v in pairs(Locaties['Politie']) do
 local Gebied = GetDistanceBetweenCoords(Coords.x, Coords.y, Coords.z, v["x"], v["y"], v["z"], true)
   if Gebied <= 45.0 then
    NearPolice = true
     TriggerServerEvent("fw-inventory:server:OpenInventory", "stash", "evidencestash_"..args, {
         maxweight = 2500000,
         slots = 50,
     })
     TriggerEvent("fw-inventory:client:SetCurrentStash", "evidencestash_"..args)
   end
 end
 if not NearPolice then
    Framework.Functions.Notify("Je moet in de buurt zijn van een politie bureau..", "error")
 end
end)

RegisterNetEvent('fw-police:client:send:alert')
AddEventHandler('fw-police:client:send:alert', function(Message, Anoniem)
    local PlayerData = Framework.Functions.GetPlayerData()
      if Anoniem then
        if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then
         TriggerEvent('chatMessage', "ANONIEME MELDING", "warning", Message)
         PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
        end
      else
        local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
        TriggerServerEvent("fw-police:server:send:call:alert", PlayerCoords, Message)
        TriggerEvent("fw-police:client:call:anim")
      end
end)

RegisterNetEvent('fw-police:client:send:message')
AddEventHandler('fw-police:client:send:message', function(Coords, Message, Name)
    if (Framework.Functions.GetPlayerData().job.name == "police" or Framework.Functions.GetPlayerData().job.name == "ambulance") and Framework.Functions.GetPlayerData().job.onduty then
        TriggerEvent('chatMessage', "112 MELDING - " ..Name, "warning", Message)
        PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
        AddAlert('112', 66, 250, Coords)
    end
end)

RegisterNetEvent('fw-police:client:call:anim')
AddEventHandler('fw-police:client:call:anim', function()
    local isCalling = true
    local callCount = 5
    exports['fw-assets']:RequestAnimationDict("cellphone@")
    TaskPlayAnim(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 3.0, -1, -1, 49, 0, false, false, false)
    Citizen.Wait(1000)
    Citizen.CreateThread(function()
        while isCalling do
            Citizen.Wait(1000)
            callCount = callCount - 1
            if callCount <= 0 then
                isCalling = false
                StopAnimTask(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 1.0)
            end
        end
    end)
end)

RegisterNetEvent('fw-police:client:spawn:object')
AddEventHandler('fw-police:client:spawn:object', function(Type)
    Framework.Functions.Progressbar("spawn-object", "Object plaatsen..", 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        TriggerServerEvent("fw-police:server:spawn:object", Type)
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        Framework.Functions.Notify("Đã hủy..", "error")
    end)
end)

RegisterNetEvent('fw-police:client:delete:object')
AddEventHandler('fw-police:client:delete:object', function()
    local objectId, dist = GetClosestPoliceObject()
    if dist < 5.0 then
        Framework.Functions.Progressbar("remove-object", "Object verwijderen..", 2500, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
            anim = "plant_floor",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(GetPlayerPed(-1), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 1.0)
            TriggerServerEvent("fw-police:server:delete:object", objectId)
        end, function() -- Cancel
            StopAnimTask(GetPlayerPed(-1), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 1.0)
            Framework.Functions.Notify("Đã hủy..", "error")
        end)
    end
end)

RegisterNetEvent('fw-police:client:place:object')
AddEventHandler('fw-police:client:place:object', function(objectId, type, player)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player)))
    local heading = GetEntityHeading(GetPlayerPed(GetPlayerFromServerId(player)))
    local forward = GetEntityForwardVector(GetPlayerPed(-1))
    local x, y, z = table.unpack(coords + forward * 0.5)
    local spawnedObj = CreateObject(Config.Objects[type].model, x, y, z, false, false, false)
    PlaceObjectOnGroundProperly(spawnedObj)
    SetEntityHeading(spawnedObj, heading)
    FreezeEntityPosition(spawnedObj, Config.Objects[type].freeze)
    ObjectList[objectId] = {
        id = objectId,
        object = spawnedObj,
        coords = {
            x = x,
            y = y,
            z = z - 0.3,
        },
    }
end)

RegisterNetEvent('fw-police:client:remove:object')
AddEventHandler('fw-police:client:remove:object', function(objectId)
    NetworkRequestControlOfEntity(ObjectList[objectId].object)
    DeleteObject(ObjectList[objectId].object)
    ObjectList[objectId] = nil
end)

RegisterNetEvent('fw-police:client:set:radio')
AddEventHandler('fw-police:client:set:radio', function()
 Framework.Functions.TriggerCallback('Framework:HasItem', function(HasItem)
    if HasItem then
        exports['fw-radio']:SetRadioState(true)
        exports['fw-radio']:JoinRadio(1, 1)
        Framework.Functions.Notify("Verbonden met OC-01", "info", 8500)
    end
 end, "radio")
end)

-- // Functions \\ --

function CreateDutyBlips(playerId, playerLabel, playerJob)
	local ped = GetPlayerPed(playerId)
    local blip = GetBlipFromEntity(ped)
	if not DoesBlipExist(blip) then
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 480)
        SetBlipScale(blip, 1.0)
        if playerJob == "police" then
            SetBlipColour(blip, 38)
        else
            SetBlipColour(blip, 35)
        end
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(playerLabel)
        EndTextCommandSetBlipName(blip)
		table.insert(DutyBlips, blip)
	end
end

function HandCuffAnimation()
 exports['fw-assets']:RequestAnimationDict("mp_arrest_paired")
 Citizen.Wait(100)
 TaskPlayAnim(GetPlayerPed(-1), "mp_arrest_paired", "cop_p2_back_right", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
 Citizen.Wait(3500)
 TaskPlayAnim(GetPlayerPed(-1), "mp_arrest_paired", "exit", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
end

function GetCuffedAnimation(playerId)
 local cuffer = GetPlayerPed(GetPlayerFromServerId(playerId))
 local heading = GetEntityHeading(cuffer)
 exports['fw-assets']:RequestAnimationDict("mp_arrest_paired")
 TriggerServerEvent('fw-sound:server:play:distance', 2.0, 'handcuff', 0.2)
 SetEntityCoords(GetPlayerPed(-1), GetOffsetFromEntityInWorldCoords(cuffer, 0.0, 0.45, 0.0))
 Citizen.Wait(100)
 SetEntityHeading(GetPlayerPed(-1), heading)
 TaskPlayAnim(GetPlayerPed(-1), "mp_arrest_paired", "crook_p2_back_right", 3.0, 3.0, -1, 32, 0, 0, 0, 0)
 Citizen.Wait(2500)
end

function GetClosestPoliceObject()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil
    for id, data in pairs(ObjectList) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, ObjectList[id].coords.x, ObjectList[id].coords.y, ObjectList[id].coords.z, true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, ObjectList[id].coords.x, ObjectList[id].coords.y, ObjectList[id].coords.z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, ObjectList[id].coords.x, ObjectList[id].coords.y, ObjectList[id].coords.z, true)
            current = id
        end
    end
    return current, dist
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

function IsTargetDead(playerId)
 local IsDead = false
  Framework.Functions.TriggerCallback('fw-police:server:is:player:dead', function(result)
    IsDead = result
  end, playerId)
  Citizen.Wait(100)
  return IsDead
end

function GetVehicleList()
    local VehicleData = Framework.Functions.GetPlayerData().metadata['duty-vehicles']
    local Vehicles = {}
    if VehicleData.Standard then
        table.insert(Vehicles, "police:vehicle:touran")
        table.insert(Vehicles, "police:vehicle:klasse")
        table.insert(Vehicles, "police:vehicle:vito")
        table.insert(Vehicles, "vehicle:delete")
    end
    if VehicleData.Audi then
        table.insert(Vehicles, "police:vehicle:audi")
    end
    if VehicleData.Unmarked then
        table.insert(Vehicles, "police:vehicle:velar")
        table.insert(Vehicles, "police:vehicle:bmw")
        table.insert(Vehicles, "police:vehicle:unmaked:audi")
    end
    if VehicleData.Heli then 
        table.insert(Vehicles, "police:vehicle:heli")
    end
    if VehicleData.Motor then
        table.insert(Vehicles, "police:vehicle:motor")
    end
    return Vehicles
end

function SetWeaponSeries()
 Config.Items.items[1].info.serie = Framework.Functions.GetPlayerData().job.serial
 Config.Items.items[2].info.serie = Framework.Functions.GetPlayerData().job.serial
 Config.Items.items[3].info.serie = Framework.Functions.GetPlayerData().job.serial
end

function GetGarageStatus()
    return NearPoliceGarage
end

function GetEscortStatus()
    return Config.IsEscorted
end

function SpawnIncheckProp()
    local SpawnModel = GetHashKey('v_ind_cs_bucket')
    exports['fw-assets']:RequestModelHash(SpawnModel)
    local Object = CreateObject(SpawnModel, 441.80, -982.02, 30.4, false, false, false)
    SetEntityHeading(Object, 265.15)
    FreezeEntityPosition(Object, true)
    SetEntityInvincible(Object, true)
    SetEntityVisible(Object, false)
end

RegisterNUICallback('CloseNui', function()
 SetNuiFocus(false, false)
 if exports['fw-assets']:GetPropStatus() then
    exports['fw-assets']:RemoveProp()
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    TaskPlayAnim(GetPlayerPed(-1), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "exit", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
 end
end)