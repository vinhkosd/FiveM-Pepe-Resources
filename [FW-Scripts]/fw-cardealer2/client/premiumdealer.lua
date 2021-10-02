local PremiumCars = {}
local CurrentVehicle = nil
local SpawnedPremium = false
local CurrentBuyVehicle = nil
local NearCardealer, NearCar = false, false

RegisterNetEvent('fw-cardealer2:client:sync:premium:dealer')
AddEventHandler('fw-cardealer2:client:sync:premium:dealer', function(Slot, ConfigData)
    Config.PremiumDealerSpots[Slot] = ConfigData
    RefreshCars()
end)

RegisterNetEvent('fw-cardealer2:client:set:premium:details')
AddEventHandler('fw-cardealer2:client:set:premium:details', function(Vehicle, Price, Display, Stock)
    Config.PremiumVehicleDetails[Vehicle] = {['Price'] = Price, ['Display'] = Display, ['Stock'] = Stock}
end)

RegisterNetEvent('fw-cardealer2:client:can:buy:vehicle')
AddEventHandler('fw-cardealer2:client:can:buy:vehicle', function(VehicleSlot)
    CurrentBuyVehicle = VehicleSlot
end)

RegisterNetEvent('fw-cardealer2:client:set:stock')
AddEventHandler('fw-cardealer2:client:set:stock', function(StockData, Slot)
    Config.PremiumDealerSpots[Slot]['Stock'] = StockData
end)

RegisterNetEvent('fw-cardealer2:client:spawn:car:premium')
AddEventHandler('fw-cardealer2:client:spawn:car:premium', function(VehicleName, Plate)
    local CoordTable = {x = -773.07, y = -235.32, z = 37.07, a = 205.67}
    Framework.Functions.SpawnVehicle(VehicleName, function(Vehicle)
      TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vehicle, -1)
      SetVehicleNumberPlateText(Vehicle, Plate)
      Citizen.Wait(25)
      exports['fw-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
      exports['fw-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100.0, false)
     end, CoordTable, true, true)
end)

RegisterNetEvent('fw-cardealer2:client:sell:closest:vehicle')
AddEventHandler('fw-cardealer2:client:sell:closest:vehicle', function()
    if CurrentVehicle ~= nil then
        local Player, Distance = Framework.Functions.GetClosestPlayer()
        if Player ~= -1 and Distance < 2.5 then
            Framework.Functions.Progressbar("lockpick-door", "Voertuig Verkopen..", 5500, false, false, {
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
                TriggerServerEvent('fw-cardealer2:server:sell:closest', GetPlayerServerId(Player), CurrentVehicle)
                StopAnimTask(GetPlayerPed(-1), "missheistdockssetup1clipboard@base", "base", 1.0)
            end, function()
                Framework.Functions.Notify("Đã hủy bỏ..", "error")
                StopAnimTask(GetPlayerPed(-1), "missheistdockssetup1clipboard@base", "base", 1.0)
            end)
        else
            Framework.Functions.Notify("Không có ai xung quanh!", "error")
        end
    else
        Framework.Functions.Notify("Đây không phải phương tiện được bán..", "error")
    end
end)

-- // Functions \\ --

RegisterNUICallback('SetCarInSlot', function(data)
    TriggerServerEvent('fw-cardealer2:server:set:premium:data', data.slot, data.price, data.model, data.stock)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearCardealer = false
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations[1]['Coords']['X'], Config.Locations[1]['Coords']['Y'], Config.Locations[1]['Coords']['Z'], true)
            if Distance < 75.0 then
                NearCardealer = true
                if not SpawnedPremium then
                    SpawnedPremium = true
                    SpawnPremiumCars()
                end
            end
            if not NearCardealer then
                Citizen.Wait(1000)
                if SpawnedPremium then
                    SpawnedPremium = false
                    DespawnPremiumCars()
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearCar = false
            if NearCardealer then
                NearCar = false
                for k, v in pairs(Config.PremiumDealerSpots) do
                    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                    local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
                    if Distance < 2.0 then
                        if v['Model'] ~= nil then
                            NearCar = true
                            CurrentVehicle = k
                            DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'] + 0.75, 'Model: ~g~'..v['DisplayName']..'~s~ \nPrijs: ~g~€'..v['Price']..',-~s~\nVoorraad: ~g~'..v['Stock']..'x')
                        end
                    end
                end

                if CurrentBuyVehicle ~= nil and NearCar then
                    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                    local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.PremiumDealerSpots[CurrentBuyVehicle]['Coords']['X'], Config.PremiumDealerSpots[CurrentBuyVehicle]['Coords']['Y'], Config.PremiumDealerSpots[CurrentBuyVehicle]['Coords']['Z'], true)
                    if Distance <= 2.0 then
                        DrawText3D(Config.PremiumDealerSpots[CurrentBuyVehicle]['Coords']['X'], Config.PremiumDealerSpots[CurrentBuyVehicle]['Coords']['Y'], Config.PremiumDealerSpots[CurrentBuyVehicle]['Coords']['Z'] + 0.5, '~g~E~s~ - Kopen / ~g~H~s~ - Weigeren')
                        if IsControlJustReleased(0, 38) then
                            TriggerServerEvent('fw-cardealer2:server:buy:current:vehicle', CurrentBuyVehicle)
                            CurrentBuyVehicle = nil
                        end
                        if IsControlJustReleased(0, 74) then
                            CurrentBuyVehicle = nil
                        end
                    end
                end

                if not NearCar then
                    Citizen.Wait(1000)
                    CurrentVehicle = nil
                end

            end
        end
    end
end)

function RefreshCars()
    if NearCardealer then
        DespawnPremiumCars()
        Citizen.SetTimeout(750, function()
            SpawnPremiumCars()
        end)
    end
end

function SpawnPremiumCars()
    for k, v in pairs(Config.PremiumDealerSpots) do
        if v['Model'] ~= nil then
            exports['fw-assets']:RequestModelHash(v['Model'])
            local ShowroomCar = CreateVehicle(GetHashKey(v['Model']), v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], false, false)
            SetModelAsNoLongerNeeded(ShowroomCar)
            SetVehicleOnGroundProperly(ShowroomCar)
            SetEntityInvincible(ShowroomCar, true)
            SetEntityHeading(ShowroomCar, v['Coords']['H'])
            SetVehicleDoorsLocked(ShowroomCar, 3)
            FreezeEntityPosition(ShowroomCar, true)
            SetVehicleNumberPlateText(ShowroomCar, k .. "CARSALE")
            table.insert(PremiumCars, ShowroomCar)
        end
    end
end

function DespawnPremiumCars()
    for k, v in pairs(PremiumCars) do
        DeleteVehicle(v)
    end
    PremiumCars = {}
end

RegisterNUICallback('SetSlotVehicle', function(data)
    if Config.PremiumVehicleDetails[data.model] ~= nil then
        TriggerServerEvent('fw-cardealer2:server:set:premium:data', data.slot, Config.PremiumVehicleDetails[data.model]['Price'], data.model, Config.PremiumVehicleDetails[data.model]['Display'], Config.PremiumVehicleDetails[data.model]['Stock'])
    end
end)

RegisterNUICallback('GetDisplayVehicles', function(data, cb)
    cb(Config.PremiumDealerSpots)
end)