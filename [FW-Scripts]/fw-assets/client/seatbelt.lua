local SeatbeltStatus = false
local IsEjected = false
local NewBodyHealth = 0
local NewEngineHealth = 0
local CurrentVehicleHealth = 0
local CurrentBodyHealth = 0
local FrameBodyChange = 0
local FrameEngineChange = 0
local LastFrameVehicleSpeed = 0
local SecondLastFrameVehicleSpeed = 0
local ThisFrameVehicleSpeed = 0
local Ticks = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if LoggedIn then

        if SeatbeltStatus and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
            SeatbeltStatus = false
            exports['fw-hud']:SetSeatbelt(false)
        end

         if IsControlJustReleased(0, Config.Keys['G']) and IsPedInAnyVehicle(GetPlayerPed(-1)) then
          if GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 8 and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 13 and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 14 then
             if SeatbeltStatus then
                TriggerEvent("fw-sound:client:play", "car-unbuckle", 0.25)
                exports['fw-hud']:SetSeatbelt(false)
                SeatbeltStatus = false
             else
                TriggerEvent("fw-sound:client:play", "car-buckle", 0.25)
                exports['fw-hud']:SetSeatbelt(true)
                SeatbeltStatus = true
            end
         end
      end
    end  
 end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        Citizen.Wait(5)
        local PlayerPed = GetPlayerPed(-1)
        local currentVehicle = GetVehiclePedIsIn(PlayerPed, false)
        local driverPed = GetPedInVehicleSeat(currentVehicle, -1)
        if currentVehicle ~= nil and currentVehicle ~= false and currentVehicle ~= 0 then
            SetPedHelmet(PlayerPed, false)
            lastVehicle = GetVehiclePedIsIn(PlayerPed, false)
            if GetVehicleEngineHealth(currentVehicle) < 0.0 then
                SetVehicleEngineHealth(currentVehicle,0.0)
            end
            ThisFrameVehicleSpeed = GetEntitySpeed(currentVehicle) * 3.6
            CurrentBodyHealth = GetVehicleBodyHealth(currentVehicle)
            if CurrentBodyHealth == 1000 and FrameBodyChange ~= 0 then
                FrameBodyChange = 0
            end
            if FrameBodyChange ~= 0 then
                if LastFrameVehicleSpeed > math.random(175, 185) and ThisFrameVehicleSpeed < (LastFrameVehicleSpeed * 0.75) and not IsEjected then
                    if FrameBodyChange > 18.0 then
                        if not SeatbeltStatus and not IsThisModelABike(currentVehicle) then
                            if math.random(math.ceil(LastFrameVehicleSpeed)) > 60 then
                                EjectFromVehicle(vels)
                            end
                        elseif (SeatbeltStatus or harnessOn) and not IsThisModelABike(currentVehicle) then
                            if LastFrameVehicleSpeed > 150 then
                                if math.random(math.ceil(LastFrameVehicleSpeed)) > 150 then
                                    EjectFromVehicle(vels)                   
                                end
                            end
                        end
                    else
                        if not SeatbeltStatus and not IsThisModelABike(currentVehicle) then
                            if math.random(math.ceil(LastFrameVehicleSpeed)) > 60 then
                                EjectFromVehicle(vels)                      
                            end
                        elseif (SeatbeltStatus or harnessOn) and not IsThisModelABike(currentVehicle) then
                            if LastFrameVehicleSpeed > 120 then
                                if math.random(math.ceil(LastFrameVehicleSpeed)) > 200 then
                                    EjectFromVehicle(vels)                   
                                end
                            end
                        end
                    end
                    IsEjected = true
                    Citizen.Wait(15)
                    DoWheelDamage(currentVehicle)
                    SetVehicleEngineHealth(currentVehicle, 0)
                    SetVehicleEngineOn(currentVehicle, false, true, true)
                end
                if CurrentBodyHealth < 350.0 and not IsEjected then
                    IsEjected = true
                    Citizen.Wait(15)
                    DoWheelDamage(currentVehicle)
                    SetVehicleBodyHealth(targetVehicle, 945.0)
                    SetVehicleEngineHealth(currentVehicle, 0)
                    SetVehicleEngineOn(currentVehicle, false, true, true)
                    Citizen.Wait(1000)
                end
            end
            if LastFrameVehicleSpeed < 100 then
                Wait(100)
                Ticks = 0
            end
            FrameBodyChange = NewBodyHealth - CurrentBodyHealth
            if Ticks > 0 then 
                Ticks = Ticks - 1
                if Ticks == 1 then
                    LastFrameVehicleSpeed = GetEntitySpeed(currentVehicle) * 3.6
                end
            else
                if IsEjected then
                    IsEjected = false
                    FrameBodyChange = 0
                    LastFrameVehicleSpeed = GetEntitySpeed(currentVehicle) * 3.6
                end
                SecondLastFrameVehicleSpeed = GetEntitySpeed(currentVehicle) * 3.6
                if SecondLastFrameVehicleSpeed > LastFrameVehicleSpeed then
                    LastFrameVehicleSpeed = GetEntitySpeed(currentVehicle) * 3.6
                end
                if SecondLastFrameVehicleSpeed < LastFrameVehicleSpeed then
                    Ticks = 25
                end
            end
            vels = GetEntityVelocity(currentVehicle)
            if Ticks < 0 then 
                Ticks = 0
            end     
            NewBodyHealth = GetVehicleBodyHealth(currentVehicle)
            veloc = GetEntityVelocity(currentVehicle)
        else
            if lastVehicle ~= nil then
                SetPedHelmet(PlayerPed, true)
                Citizen.Wait(200)
                NewBodyHealth = GetVehicleBodyHealth(lastVehicle)
                if not IsEjected and NewBodyHealth < CurrentBodyHealth then
                    IsEjected = true
                    SetVehicleEngineHealth(lastVehicle, 0)
                    SetVehicleEngineOn(lastVehicle, false, true, true)
                    Citizen.Wait(1000)
                end
                lastVehicle = nil
            end
            SecondLastFrameVehicleSpeed = 0
            LastFrameVehicleSpeed = 0
            NewBodyHealth = 0
            CurrentBodyHealth = 0
            FrameBodyChange = 0
            Citizen.Wait(2000)
        end
    end
end)

-- // Functions \\ --

function EjectFromVehicle(VehicleVelocity)
 local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1),false)
 local Coords = GetOffsetFromEntityInWorldCoords(Vehicle, 1.0, 0.0, 1.0)
 local EjectSpeed = math.ceil(GetEntitySpeed(GetPlayerPed(-1)) * 8)
 SetEntityCoords(GetPlayerPed(-1), Coords)
 Citizen.Wait(1)
 SetPedToRagdoll(GetPlayerPed(-1), 5511, 5511, 0, 0, 0, 0)
 SetEntityVelocity(GetPlayerPed(-1), VehicleVelocity.x*4, VehicleVelocity.y*4, VehicleVelocity.z*4)
 SetEntityHealth( GetPlayerPed(-1), (GetEntityHealth(GetPlayerPed(-1)) - EjectSpeed))
 Citizen.SetTimeout(2500, function()
    IsEjected = false
 end)
end

function DoWheelDamage(Vehicle)
 local wheels = {0,1,4,5}
 for i=1, math.random(4) do
     local wheel = math.random(#wheels)
     SetVehicleTyreBurst(Vehicle, wheels[wheel], true, 1000)
     table.remove(wheels, wheel)
 end
end