local LoggedIn = false

Framework = nil

RegisterNetEvent("Framework:Client:OnPlayerLoaded")
AddEventHandler("Framework:Client:OnPlayerLoaded", function()
  Citizen.SetTimeout(650, function()
      TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)   
      Citizen.Wait(200)
      Framework.Functions.TriggerCallback('fw-field:server:GetConfig', function(config)
          Config = config
      end) 
      LoggedIn = true
  end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

RegisterNetEvent('fw-field:client:set:plant:busy')
AddEventHandler('fw-field:client:set:plant:busy',function(PlantId, bool)
    Config.Plants['planten'][PlantId]['IsBezig'] = bool
end)

RegisterNetEvent('fw-field:client:set:picked:state')
AddEventHandler('fw-field:client:set:picked:state',function(PlantId, bool)
    Config.Plants['planten'][PlantId]['Geplukt'] = bool
end)

RegisterNetEvent('fw-field:client:set:dry:busy')
AddEventHandler('fw-field:client:set:dry:busy',function(DryRackId, bool)
    Config.Plants['drogen'][DryRackId]['IsBezig'] = bool
end)

RegisterNetEvent('fw-field:client:set:pack:busy')
AddEventHandler('fw-field:client:set:pack:busy',function(PackerId, bool)
    Config.Plants['verwerk'][PackerId]['IsBezig'] = bool
end)


Citizen.CreateThread(function()
    RegisterFontFile('arial')
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearAnything = false
            for k, v in pairs(Config.Plants["planten"]) do
                local SpelerCoords = GetEntityCoords(GetPlayerPed(-1))
                local PlantDistance = GetDistanceBetweenCoords(SpelerCoords.x, SpelerCoords.y, SpelerCoords.z, Config.Plants["planten"][k]['x'], Config.Plants["planten"][k]['y'], Config.Plants["planten"][k]['z'], true)
                if PlantDistance < 1.2 then
                    DrawText3D(Config.Plants["planten"][k]['x'], Config.Plants["planten"][k]['y'], Config.Plants["planten"][k]['z'], '~g~E~s~ - Để hái cần sa')
                    NearAnything = true
                    if IsControlJustPressed(0, Config.Keys['E']) then
                        if not Config.Plants['planten'][k]['IsBezig'] then
                            if not Config.Plants['planten'][k]['Geplukt'] then
                              PickPlant(k)
                            else
                              Framework.Functions.Notify("Có vẻ như ai đó đã hái cây này, vui lòng chờ thêm 30 giây để hái...", "error")
                            end
                        else
                           Framework.Functions.Notify("Có vẻ như ai đó đang hái cây này..", "error")
                        end
                    end
                end
            end

            for k, v in pairs(Config.Plants["drogen"]) do
                local SpelerCoords = GetEntityCoords(GetPlayerPed(-1))
                local DryDistance = GetDistanceBetweenCoords(SpelerCoords.x, SpelerCoords.y, SpelerCoords.z, Config.Plants["drogen"][k]['x'], Config.Plants["drogen"][k]['y'], Config.Plants["drogen"][k]['z'], true)
                if DryDistance < 1.2 then
                    NearAnything = true
                    DrawMarker(2, Config.Plants["drogen"][k]['x'], Config.Plants["drogen"][k]['y'], Config.Plants["drogen"][k]['z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 67, 156, 77, 255, false, false, false, 1, false, false, false)
                    DrawText3D(Config.Plants["drogen"][k]['x'], Config.Plants["drogen"][k]['y'], Config.Plants["drogen"][k]['z'], '~g~E~s~ - Để sấy cần sa')
                    if IsControlJustPressed(0, Config.Keys['E']) then
                       if not Config.Plants['drogen'][k]['IsBezig'] then
                             Framework.Functions.TriggerCallback('fw-field:server:has:takken', function(HasTak)
                                 if HasTak then
                                     DryPlant(k)
                                 else
                                     Framework.Functions.Notify("Không đủ lá cần sa tươi..", "error")
                                 end
                             end)
                       else
                           Framework.Functions.Notify("Máy sấy đang bận..", "error")
                       end
                    end
                end
            end

            for k, v in pairs(Config.Plants["verwerk"]) do
                local SpelerCoords = GetEntityCoords(GetPlayerPed(-1))
                local VerwerkDistance = GetDistanceBetweenCoords(SpelerCoords.x, SpelerCoords.y, SpelerCoords.z, Config.Plants["verwerk"][k]['x'], Config.Plants["verwerk"][k]['y'], Config.Plants["verwerk"][k]['z'], true)
                if VerwerkDistance < 1.2 then
                    NearAnything = true
                    DrawMarker(2, Config.Plants["verwerk"][k]['x'], Config.Plants["verwerk"][k]['y'], Config.Plants["verwerk"][k]['z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 67, 156, 77, 255, false, false, false, 1, false, false, false)
                    DrawText3D(Config.Plants["verwerk"][k]['x'], Config.Plants["verwerk"][k]['y'], Config.Plants["verwerk"][k]['z'], '~g~E~s~ - Để đóng gói cần sa')
                    if IsControlJustPressed(0, Config.Keys['E']) then
                       if not Config.Plants['verwerk'][k]['IsBezig'] then
                             Framework.Functions.TriggerCallback('fw-field:server:has:nugget', function(HasNugget)
                                 if HasNugget then
                                     PackagePlant(k)
                                 else
                                     Framework.Functions.Notify("Không đủ lá cần sa khô hoặc túi nhựa..", "error")
                                 end
                             end)
                       else
                           Framework.Functions.Notify("Máy đóng gói đang bận..", "error")
                       end
                    end
                end
            end
            if not NearAnything then
                Citizen.Wait(1500)
            end
        end
    end
end)


-- Functions 

function DrawText3D(x, y, z, text)
    local font = RegisterFontId("arial font")
    SetTextScale(0.35, 0.35)
    -- SetTextFont(4)
    SetTextFont(font)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
  end

function PickPlant(PlantId)
    TriggerServerEvent('fw-field:server:set:plant:busy', PlantId, true)
    Framework.Functions.Progressbar("pick_plant", "Đang hái..", math.random(3500, 6500), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "amb@prop_human_bum_bin@idle_b",
        anim = "idle_d",
        flags = 16,
    }, {}, {}, function() -- Done
        TriggerServerEvent('fw-field:server:set:plant:busy', PlantId, false)
        TriggerServerEvent('fw-field:server:set:picked:state', PlantId, true)
        TriggerServerEvent('fw-field:server:give:tak')
        StopAnimTask(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)
        Framework.Functions.Notify("Thành công", "success")
    end, function() -- Cancel
        TriggerServerEvent('fw-field:server:set:plant:busy', PlantId, false)
        StopAnimTask(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)
        Framework.Functions.Notify("Đã hủy..", "error")
    end)
end

function DryPlant(DryRackId)
    TriggerServerEvent('fw-field:server:remove:item', 'wet-tak', 2)
    TriggerServerEvent('fw-field:server:set:dry:busy', DryRackId, true)
    Framework.Functions.Progressbar("pick_plant", "Đang sấy..", math.random(6000, 11000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        TriggerServerEvent('fw-field:server:add:item', 'wet-bud', math.random(1,3))
        TriggerServerEvent('fw-field:server:set:dry:busy', DryRackId, false)
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        Framework.Functions.Notify("Thành công", "success")
    end, function() -- Cancel
        TriggerServerEvent('fw-field:server:set:dry:busy', DryRackId, false)
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        Framework.Functions.Notify("Đã hủy..", "error")
    end) 
end

function PackagePlant(PackerId)
    local WeedItems = Config.WeedSoorten[math.random(#Config.WeedSoorten)]
    TriggerServerEvent('fw-field:server:remove:item', 'wet-bud', 2)
    TriggerServerEvent('fw-field:server:remove:item', 'plastic-bag', 1)
    TriggerServerEvent('fw-field:server:set:pack:busy', PackerId, true)
    Framework.Functions.Progressbar("pick_plant", "Đang đóng gói..", math.random(3500, 6500), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        TriggerServerEvent('fw-field:server:add:item', WeedItems, 1)
        TriggerServerEvent('fw-field:server:set:pack:busy', PackerId, false)
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        Framework.Functions.Notify("Thành công", "success")
    end, function() -- Cancel
        TriggerServerEvent('fw-field:server:set:pack:busy', PackerId, false)
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        Framework.Functions.Notify("Đã hủy..", "error")
    end) 
end