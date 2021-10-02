local NearSmelt = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearSmelt = false
            local Playercoords = GetEntityCoords(GetPlayerPed(-1))
            if GetDistanceBetweenCoords(Playercoords.x, Playercoords.y, Playercoords.z, Config.Locations['Smeltery'][1]['X'], Config.Locations['Smeltery'][1]['Y'], Config.Locations['Smeltery'][1]['Z'], true) <= 1.5 then
                NearSmelt = true
                if not Config.Smelting then
                    if Config.CanTake then
                        DrawMarker(2, Config.Locations['Smeltery'][1]['X'], Config.Locations['Smeltery'][1]['Y'], Config.Locations['Smeltery'][1]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                        DrawText3D(Config.Locations['Smeltery'][1]['X'], Config.Locations['Smeltery'][1]['Y'], Config.Locations['Smeltery'][1]['Z'] + 0.15, "~g~E~w~ - Goud Claimen")
                        if IsControlJustReleased(0, 38) then
                            Config.Smelting = false
                            Config.CanTake = false
                            Config.MeltTime = 300
                            TriggerServerEvent('fw-pawnshop:server:redeem:gold:bars')
                        end
                    else
                        DrawMarker(2, Config.Locations['Smeltery'][1]['X'], Config.Locations['Smeltery'][1]['Y'], Config.Locations['Smeltery'][1]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 39, 196, 27, 255, false, false, false, 1, false, false, false)
                        DrawText3D(Config.Locations['Smeltery'][1]['X'], Config.Locations['Smeltery'][1]['Y'], Config.Locations['Smeltery'][1]['Z'] + 0.15, "~g~E~w~ - Goud Smelten")
                        if IsControlJustReleased(0, 38) then
                            Framework.Functions.Progressbar("sell-gold", "Goud Smelten..", math.random(10000, 15000), false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                TriggerServerEvent('fw-pawnshop:server:smelt:gold')
                            end, function() -- Cancel
                                Framework.Functions.Notify("Đã hủy..", "error")
                            end)
                        end
                    end
                elseif Config.Smelting and Config.SmeltTime > 0 then
                    DrawMarker(2, Config.Locations['Smeltery'][1]['X'], Config.Locations['Smeltery'][1]['Y'], Config.Locations['Smeltery'][1]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 227, 142, 39, 255, false, false, false, 1, false, false, false)
                    DrawText3D(Config.Locations['Smeltery'][1]['X'], Config.Locations['Smeltery'][1]['Y'], Config.Locations['Smeltery'][1]['Z'] + 0.15, "~o~Smelten: ~s~"..Config.SmeltTime..'s')
                end
            end
            if not NearSmelt then
                Citizen.Wait(2500)
            end
        end
    end
end)

RegisterNetEvent('fw-pawnshop:client:start:process')
AddEventHandler('fw-pawnshop:client:start:process', function()
    if not Config.Smelting then
        Config.Smelting = true
        while Config.Smelting do
          if Config.SmeltTime > 0 then
            Config.SmeltTime = Config.SmeltTime - 1
          end
          if Config.SmeltTime <= 0 then
            Config.CanTake = true
            Config.Smelting = false
          end
          Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent('fw-pawnshop:server:reset:smelter')
AddEventHandler('fw-pawnshop:server:reset:smelter', function()
    Config.Smelting = false
    Config.CanTake = false
    Config.SmeltTime = 300
end)