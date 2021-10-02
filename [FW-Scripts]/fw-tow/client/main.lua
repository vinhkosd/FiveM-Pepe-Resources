Framework = nil

local HasOwnTowVehicle = false
local HasVehicleSpawned = false
local PlayerJob = {}
local JobBlip = nil

local LoggedIn = false

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1000, function()
     TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)
     Citizen.Wait(150)
     Framework.Functions.TriggerCallback("fw-tow:server:get:config", function(config)
        Config = config
     end)
     PlayerJob = Framework.Functions.GetPlayerData().job
     LoggedIn = true
    end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

RegisterNetEvent('Framework:Client:OnJobUpdate')
AddEventHandler('Framework:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then 
            if PlayerJob.name == 'tow' then
               NearAnything = false
               local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
               if Config.CurrentNpc ~= nil then
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations[Config.CurrentNpc]['Coords']['X'], Config.Locations[Config.CurrentNpc]['Coords']['Y'], Config.Locations[Config.CurrentNpc]['Coords']['Z'], true)
                if Distance <= 100.0 and not HasVehicleSpawned then
                   NearAnything = true
                   HasVehicleSpawned = true
                   SpawnTowVehicle(Config.Locations[Config.CurrentNpc]['Coords'], Config.Locations[Config.CurrentNpc]['Model'])
                end
               end
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.JobLocations['Laptop']['X'], Config.JobLocations['Laptop']['Y'], Config.JobLocations['Laptop']['Z'], true)
                if Config.JobData[Framework.Functions.GetPlayerData().citizenid] ~= nil then
                  if Distance <= 2.0 and Config.JobData[Framework.Functions.GetPlayerData().citizenid]['Payment'] > 0 then
                     NearAnything = true
                     DrawText3D(Config.JobLocations['Laptop']['X'], Config.JobLocations['Laptop']['Y'], Config.JobLocations['Laptop']['Z'], '~g~E~s~ - Salaris Ophalen')
                     if IsControlJustReleased(0, 38) then
                         TriggerServerEvent('fw-tow:server:recieve:payment')
                     end
                  end
                end
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.JobLocations['Flatbed']['X'], Config.JobLocations['Flatbed']['Y'], Config.JobLocations['Flatbed']['Z'], true)
                  if Distance <= 6.0 then
                   NearAnything = true
                   DrawMarker(2, Config.JobLocations['Flatbed']['X'], Config.JobLocations['Flatbed']['Y'], Config.JobLocations['Flatbed']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 207, 43, 37, 255, false, false, false, 1, false, false, false)
                   if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                     DrawText3D(Config.JobLocations['Flatbed']['X'], Config.JobLocations['Flatbed']['Y'], Config.JobLocations['Flatbed']['Z'] + 0.2, '~g~E~s~ - Voertuig Opbergen')
                     if IsControlJustReleased(0, 38) then
                       if HasOwnTowVehicle then
                           if GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1))) == GetHashKey(Config.TowVehicle) then
                               Framework.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                               TriggerServerEvent('fw-tow:server:return:bail:fee')
                           else
                                Framework.Functions.Notify('Dit is geen flatbed..', 'error', 5500)
                           end
                       end
                     end
                   else
                     DrawText3D(Config.JobLocations['Flatbed']['X'], Config.JobLocations['Flatbed']['Y'], Config.JobLocations['Flatbed']['Z'] + 0.2, '~g~E~s~ - Voertuig Huren')
                     if IsControlJustReleased(0, 38) then
                       Framework.Functions.TriggerCallback("fw-tow:server:do:bail", function(DidBail)
                           if DidBail then
                               GetTowVehicle()
                           else
                             Framework.Functions.Notify('Bạn không có đủ tiền mặt..', 'error', 5500)
                           end
                        end)
                     end
                  end
                end
                if not NearAnything then
                    Citizen.Wait(1500)
                end
            else
                Citizen.Wait(1500)
            end
        else
            Citizen.Wait(1500)
        end 
    end
end)

RegisterNetEvent('fw-tow:client:add:towed')
AddEventHandler('fw-tow:client:add:towed', function(CitizenId, Payment, Type)
    if Type == 'Add' then
      if Config.JobData[CitizenId] ~= nil then
          Config.JobData[CitizenId]['Payment'] = Config.JobData[CitizenId]['Payment'] + Payment
      else
          Config.JobData[CitizenId] = {['Payment'] = 0 + Payment}
      end
    elseif Type == 'Set' then
      Config.JobData[CitizenId]['Payment'] = Payment
    end
end)

RegisterNetEvent('fw-tow:client:toggle:npc')
AddEventHandler('fw-tow:client:toggle:npc', function()
   if not Config.IsDoingNpc then
     Config.IsDoingNpc = true
     SetRandomPickupVehicle()
     Framework.Functions.Notify('Vui lòng di chuyển tới điểm đến..', 'success', 5500)
   else
    if Config.CurrentTowedVehicle ~= nil then
        Framework.Functions.Notify('Bạn vẫn đang vận chuyển trên phương tiện khác..', 'error', 5500)
    else
        DeleteWaypoint()
        RemoveBlip(JobBlip)
        ResetAll()
        Framework.Functions.Notify('Bạn đã dừng nhiệm vụ vận chuyển..', 'error', 5500)
    end
   end
end)

RegisterNetEvent('fw-tow:client:hook:car')
AddEventHandler('fw-tow:client:hook:car', function()
    local TowVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
    if IsVehicleValid(TowVehicle) then
      if Config.IsDoingNpc then
        local Vehicle, Distance = Framework.Functions.GetClosestVehicle()
        if Config.CurrentTowedVehicle == nil then
            if Distance <= 4.0 then
               if Vehicle ~= TowVehicle then
                   if GetHashKey(Config.Locations[Config.CurrentNpc]['Model']) == GetEntityModel(Vehicle) then
                       Framework.Functions.Progressbar("towing-vehicle", "Voertuig erop zetten..", 5000, false, true, {
                           disableMovement = true,
                           disableCarMovement = true,
                           disableMouse = false,
                           disableCombat = true,
                       }, {
                           animDict = "mini@repair",
                           anim = "fixing_a_ped",
                           flags = 16,
                       }, {}, {}, function() -- Done
                           Config.CurrentTowedVehicle = Vehicle
                           StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                           AttachEntityToEntity(Vehicle, TowVehicle, GetEntityBoneIndexByName(TowVehicle, 'bodyshell'), 0.0, -1.5 + -0.85, 0.0 + 1.15, 0, 0, 0, 1, 1, 0, 1, 0, 1)
                           Citizen.Wait(150)
                           RemoveBlip(JobBlip)
                           SetNewWaypoint(491.03, -1313.82)
                           FreezeEntityPosition(Vehicle, true)
                           Framework.Functions.Notify("Vận chuyển thành công, vui lòng di chuyển tới Harold's Depot", "success")
                       end, function() -- Cancel
                           Config.CurrentTowedVehicle = nil
                           StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                           Framework.Functions.Notify("Thất bại!", "error")
                       end)
                   else
                        Framework.Functions.Notify('Phương tiện không hợp lệ..', 'error', 5500)
                   end
               else
                   Framework.Functions.Notify('Bạn không thể vận chuyển cho xe chính mình?!?', 'error', 5500)
               end
            else
                Framework.Functions.Notify('Không tìm thấy phương tiện?', 'error', 5500)
            end
        else
            Framework.Functions.Progressbar("untowing_vehicle", "Đang xóa xe..", 5000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "mini@repair",
                anim = "fixing_a_ped",
                flags = 16,
            }, {}, {}, function() -- Done
                StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                FreezeEntityPosition(Config.CurrentTowedVehicle, false)
                Citizen.Wait(250)
                AttachEntityToEntity(Config.CurrentTowedVehicle, TowVehicle, 20, -0.0, -15.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                DetachEntity(Config.CurrentTowedVehicle, true, true)
                if exports['fw-garages']:IsNearDepot() then
                    Framework.Functions.Notify("Đã trả xe!", 'success')
                    Framework.Functions.DeleteVehicle(Config.CurrentTowedVehicle)
                    TriggerServerEvent('fw-tow:server:add:towed', math.random(650, 850))
                    ResetAll()
                end
                Config.CurrentTowedVehicle = nil
                Framework.Functions.Notify("Phương tiện đã bị xóa!")
            end, function() -- Cancel
                StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                Framework.Functions.Notify("Thất bại!", "error")
            end)
        end
      end
    else
        Framework.Functions.Notify('Xe không hợp lệ', 'error', 5500)
    end
end)

function IsVehicleValid(TowVehicle)
    if GetEntityModel(TowVehicle) == GetHashKey(Config.TowVehicle) then
        return true
    else
        return false
    end
end

function SetRandomPickupVehicle()
local RandomVehicle = math.random(1, #Config.Locations)
CreateTowBlip(Config.Locations[RandomVehicle]['Coords'])
Config.CurrentNpc = RandomVehicle
end

function SpawnTowVehicle(Coords, Model)
    local CoordsTable = {x = Coords['X'], y = Coords['Y'], z = Coords['Z'], a = Coords['H']}
    Framework.Functions.SpawnVehicle(Model, function(Vehicle)
        Citizen.Wait(150)
        exports['fw-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 0.0, false)
        DoCarDamage(Vehicle)
    end, CoordsTable, true, false)
end

function CreateTowBlip(Coords)
    local TowBlip = AddBlipForCoord(Coords['X'], Coords['Y'], Coords['Z'])
    SetBlipSprite(TowBlip, 595)
    SetBlipDisplay(TowBlip, 4)
    SetBlipScale(TowBlip, 0.48)
    SetBlipAsShortRange(TowBlip, true)
    SetBlipColour(TowBlip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName('Takel Voertuig')
    EndTextCommandSetBlipName(TowBlip)
    SetNewWaypoint(Coords['X'], Coords['Y'])
    JobBlip = TowBlip
end

function ResetAll()
  Config.CurrentNpc = nil
  Config.IsDoingNpc = false
  Config.CurrentTowedVehicle = nil
  HasVehicleSpawned = false
end

function GetTowVehicle()
  HasOwnTowVehicle = true
  Framework.Functions.SpawnVehicle(Config.TowVehicle, function(Vehicle)
    SetVehicleNumberPlateText(Vehicle, "TOWR"..tostring(math.random(1000, 9999)))
    exports['fw-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
    Citizen.Wait(100)
    exports['fw-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
    TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vehicle, -1)
  end, nil, true, true)
end

function DrawText3D(x, y, z, text)
  SetTextScale(0.28, 0.28)
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

function DoCarDamage(Vehicle)
	smash = false
	damageOutside = false
	damageOutside2 = false 
	local engine = 199.0
	local body = 149.0
	if engine < 200.0 then
		engine = 200.0
    end

    if engine  > 1000.0 then
        engine = 950.0
    end
	if body < 150.0 then
		body = 150.0
	end
	if body < 950.0 then
		smash = true
	end
	if body < 920.0 then
		damageOutside = true
	end
	if body < 920.0 then
		damageOutside2 = true
	end
    Citizen.Wait(100)
    SetVehicleEngineHealth(Vehicle, engine)
	if smash then
		SmashVehicleWindow(Vehicle, 0)
		SmashVehicleWindow(Vehicle, 1)
		SmashVehicleWindow(Vehicle, 2)
		SmashVehicleWindow(Vehicle, 3)
		SmashVehicleWindow(Vehicle, 4)
	end
	if damageOutside then
		SetVehicleDoorBroken(Vehicle, 1, true)
		SetVehicleDoorBroken(Vehicle, 6, true)
		SetVehicleDoorBroken(Vehicle, 4, true)
	end
	if damageOutside2 then
		SetVehicleTyreBurst(Vehicle, 1, false, 990.0)
		SetVehicleTyreBurst(Vehicle, 2, false, 990.0)
		SetVehicleTyreBurst(Vehicle, 3, false, 990.0)
		SetVehicleTyreBurst(Vehicle, 4, false, 990.0)
	end
	if body < 1000 then
		SetVehicleBodyHealth(Vehicle, 985.1)
	end
end