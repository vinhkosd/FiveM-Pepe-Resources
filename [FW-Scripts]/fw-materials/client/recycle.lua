local carryPackage = nil
local packagePos = nil
local onDuty = false

Citizen.CreateThread(function()
    for k, pickuploc in pairs(Config['delivery'].pickupLocations) do
        local model = GetHashKey(Config['delivery'].warehouseObjects[math.random(1, #Config['delivery'].warehouseObjects)])
        exports['fw-assets']:RequestModelHash(model)
        local obj = CreateObject(model, pickuploc.x, pickuploc.y, pickuploc.z, false, true, true)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
    end
end)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local pos = GetEntityCoords(GetPlayerPed(-1), true)
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config['delivery'].outsideLocation.x, Config['delivery'].outsideLocation.y, Config['delivery'].outsideLocation.z, true) < 1.3 then
                DrawMarker(2, Config['delivery'].outsideLocation.x, Config['delivery'].outsideLocation.y, Config['delivery'].outsideLocation.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                DrawText3D(Config['delivery'].outsideLocation.x, Config['delivery'].outsideLocation.y, Config['delivery'].outsideLocation.z + 0.15, "~g~E~w~ - Om naar binnen te gaan")
                if IsControlJustReleased(0, 38) then
                    DoScreenFadeOut(500)
                    while not IsScreenFadedOut() do
                        Citizen.Wait(10)
                    end
                    SetEntityCoords(GetPlayerPed(-1), Config['delivery'].insideLocation.x, Config['delivery'].insideLocation.y, Config['delivery'].insideLocation.z)
                    DoScreenFadeIn(500)
                end
            end
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config['delivery'].insideLocation.x, Config['delivery'].insideLocation.y, Config['delivery'].insideLocation.z, true) < 15 and not IsPedInAnyVehicle(GetPlayerPed(-1), false) and not onDuty then
                DrawMarker(2, Config['delivery'].insideLocation.x, Config['delivery'].insideLocation.y, Config['delivery'].insideLocation.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config['delivery'].insideLocation.x, Config['delivery'].insideLocation.y, Config['delivery'].insideLocation.z, true) < 1.3 then
                    DrawText3D(Config['delivery'].insideLocation.x, Config['delivery'].insideLocation.y, Config['delivery'].insideLocation.z + 0.15, "~g~E~w~ - Om naar buiten te gaan")
                    if IsControlJustReleased(0, 38) then
                        DoScreenFadeOut(500)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(10)
                        end
                        SetEntityCoords(GetPlayerPed(-1), Config['delivery'].outsideLocation.x, Config['delivery'].outsideLocation.y, Config['delivery'].outsideLocation.z + 1)
                        DoScreenFadeIn(500)
                    end
                end
            end
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, 1049.15,-3100.63,-39.95, true) < 15 and not IsPedInAnyVehicle(GetPlayerPed(-1), false) and carryPackage == nil then
                DrawMarker(2, 1049.15,-3100.63,-38.99, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, 1049.15,-3100.63,-39.95, true) < 1.3 then
                    if onDuty then
                        DrawText3D(1049.15,-3100.63,-39.95 + 1.15, "~g~E~w~ - Om uit te klokken")
                    else
                        DrawText3D(1049.15,-3100.63,-39.95 + 1.15, "~g~E~w~ -  Om in te klokken")
                    end
                    if IsControlJustReleased(0, 38) then
                        onDuty = not onDuty
                        if onDuty then
                            Framework.Functions.Notify("Je bent ingeklokt")
                        else
                            Framework.Functions.Notify("Je bent uitgeklokt!", "error")
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if onDuty then
                if packagePos ~= nil then
                    local pos = GetEntityCoords(GetPlayerPed(-1), true)
                    if carryPackage == nil then
                        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, packagePos.x,packagePos.y,packagePos.z, true) < 2.3 then
                            DrawText3D(packagePos.x,packagePos.y,packagePos.z+ 1, "~g~E~w~ - Pakket pakken")
                            if IsControlJustReleased(0, 38) then
                                TaskStartScenarioInPlace(GetPlayerPed(-1), "PROP_HUMAN_BUM_BIN", 0, true)
                                Framework.Functions.Progressbar("pickup_reycle_package", "Pakket oppakken..", 5000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = false,
                                    disableMouse = false,
                                    disableCombat = false,
                                }, {}, {}, {}, function() -- Done
                                    ClearPedTasksImmediately(GetPlayerPed(-1))
                                    PickupPackage()
                                end, function()
                                    Framework.Functions.Notify("Đã hủy..", "error")
                                    ClearPedTasksImmediately(GetPlayerPed(-1))
                                end)
                            end
                        else
                            DrawText3D(packagePos.x, packagePos.y, packagePos.z + 1, "Pakketje")
                        end
                    else
                        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config['delivery'].dropLocation.x, Config['delivery'].dropLocation.y, Config['delivery'].dropLocation.z, true) < 2.0 then
                            DrawText3D(Config['delivery'].dropLocation.x, Config['delivery'].dropLocation.y, Config['delivery'].dropLocation.z, "~g~E~w~ - Pakket inleveren")
                            if IsControlJustReleased(0,38) then
                                DropPackage()
                                ScrapAnim()
                                Framework.Functions.Progressbar("deliver_reycle_package", "Pakket uitpakken..", 5000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {}, {}, {}, function() -- Done
                                    StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                                    TriggerServerEvent('fw-materials:server:recycle:reward')
                                    GetRandomPackage()
                                end)
                            end
                        else
                            DrawText3D(Config['delivery'].dropLocation.x, Config['delivery'].dropLocation.y, Config['delivery'].dropLocation.z, "Inleveren")
                        end
                    end
                else
                    GetRandomPackage()
                end
            end
        end
    end
end)

function ScrapAnim()
    local time = 5
    exports['fw-assets']:RequestAnimationDict("mp_car_bomb")
    TaskPlayAnim(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(1000)
            time = time - 1
            if time <= 0 then
                openingDoor = false
                StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
            end
        end
    end)
end

function GetRandomPackage()
    local randSeed = math.random(1, #Config["delivery"].pickupLocations)
    packagePos = {}
    packagePos.x = Config["delivery"].pickupLocations[randSeed].x
    packagePos.y = Config["delivery"].pickupLocations[randSeed].y
    packagePos.z = Config["delivery"].pickupLocations[randSeed].z
end

function PickupPackage()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    RequestAnimDict("anim@heists@box_carry@")
    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do
        Citizen.Wait(7)
    end
    TaskPlayAnim(GetPlayerPed(-1), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    local model = GetHashKey("prop_cs_cardbox_01")
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)
    AttachEntityToEntity(object, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.05, 0.1, -0.3, 300.0, 250.0, 20.0, true, true, false, true, 1, true)
    carryPackage = object
end

function DropPackage()
    ClearPedTasks(GetPlayerPed(-1))
    DetachEntity(carryPackage, true, true)
    DeleteObject(carryPackage)
    carryPackage = nil
end