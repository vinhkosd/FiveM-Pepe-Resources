local GotHit = false
local CurrentBin = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            local StartShape = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 0.1, 0)
            local EndShape = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 2.0, -0.4)
            local RayCast = StartShapeTestRay(StartShape.x, StartShape.y, StartShape.z, EndShape.x, EndShape.y, EndShape.z, 16, GetPlayerPed(-1), 0)
            local Retval, Hit, Coords, Surface, EntityHit = GetShapeTestResult(RayCast)
            local BinModel = 0
            GotHit = false
            if EntityHit then
            local BinModel = GetEntityModel(EntityHit)
              for k, v in pairs(Config.Dumpsters) do
                  if v['Model'] == BinModel then
                    GotHit = true
                    CurrentBin = GetHashKey(EntityHit)
                  end
              end
            end
            if not GotHit then 
               Citizen.Wait(1500)
               CurrentBin = nil, nil
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

RegisterNetEvent('fw-materials:client:search:trash')
AddEventHandler('fw-materials:client:search:trash', function()
    local BinModel = CurrentBin
    if BinModel ~= nil then
      if not Config.OpenedBins[BinModel] then
        Framework.Functions.Progressbar("search-trash", "Đang lục..", math.random(10000, 12500), false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = 'mini@repair',
            anim = 'fixing_a_ped',
            flags = 16,
        }, {}, {}, function() -- Done
            SetBinUsed(BinModel)
            TriggerServerEvent('fw-materials:server:get:reward')
            StopAnimTask(GetPlayerPed(-1), 'mini@repair', "fixing_a_ped", 1.0)
        end, function() -- Cancel
            StopAnimTask(GetPlayerPed(-1), 'mini@repair', "fixing_a_ped", 1.0)
            Framework.Functions.Notify("Thất bại!", "error")
        end)
       else
        Framework.Functions.Notify("Bạn đã tìm thùng rác này..", "error")
      end
    end
end)

function SetBinUsed(BinNumber)
    Config.OpenedBins[BinNumber] = true
    Citizen.SetTimeout(50000, function()
        Config.OpenedBins[BinNumber] = false
    end)
end