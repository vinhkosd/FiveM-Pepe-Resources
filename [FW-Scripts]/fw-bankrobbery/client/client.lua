local ClosestBank = nil
local ItemsNeeded = {}
CurrentCops = 0
LoggedIn = false

Framework = nil 

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
        Citizen.Wait(250)
        Framework.Functions.TriggerCallback("fw-bankrobbery:server:get:key:config", function(config)
            Config = config
        end)
        PacificItems = {[1] = {name = Framework.Shared.Items["electronickit"]["name"], image = Framework.Shared.Items["electronickit"]["image"]},[2] = {name = Framework.Shared.Items['black-card']["name"], image = Framework.Shared.Items['black-card']["image"]}}
        LoggedIn = true
        CloseBankDoor(6)
    end)
end)

RegisterNetEvent('fw-police:SetCopCount')
AddEventHandler('fw-police:SetCopCount', function(Amount)
    CurrentCops = Amount
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        if LoggedIn then
            IsInBank = false
            for k, v in pairs(Config.BankLocations) do
                local Distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.BankLocations[k]["Coords"]["X"], Config.BankLocations[k]["Coords"]["Y"], Config.BankLocations[k]["Coords"]["Z"])
                if Distance < 15 then
                    ClosestBank = k
                    ItemsNeeded = {
                        [1] = {name = Framework.Shared.Items["electronickit"]["name"], image = Framework.Shared.Items["electronickit"]["image"]},
                        [2] = {name = Framework.Shared.Items[Config.BankLocations[k]['card-type']]["name"], image = Framework.Shared.Items[Config.BankLocations[k]['card-type']]["image"]},
                    }
                    IsInBank = true
                end
            end
            if not IsInBank then
                Citizen.Wait(2000)
                ItemsNeeded = {}
                ClosestBank = nil
            end
        end
        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(4)
      if ClosestBank ~= nil then
        if not Config.BankLocations[ClosestBank]['IsOpened'] then
            local Distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.BankLocations[ClosestBank]["Coords"]["X"], Config.BankLocations[ClosestBank]["Coords"]["Y"], Config.BankLocations[ClosestBank]["Coords"]["Z"])
            if Distance < 1.2 then
                if not ItemsShowed then
                ItemsShowed = true
                TriggerEvent('fw-inventory:client:requiredItems', ItemsNeeded, true)
                end
            else
                if ItemsShowed then
                ItemsShowed = false
                TriggerEvent('fw-inventory:client:requiredItems', ItemsNeeded, false)
                end
            end
        end
        if Config.BankLocations[ClosestBank]['IsOpened'] then
           for k, v in pairs(Config.BankLocations[ClosestBank]['Lockers']) do
            local LockerDistance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.BankLocations[ClosestBank]["Lockers"][k]["X"], Config.BankLocations[ClosestBank]["Lockers"][k]["Y"], Config.BankLocations[ClosestBank]["Lockers"][k]["Z"], true)
            if LockerDistance < 0.5 then
                if Config.BankLocations[ClosestBank]["Lockers"][k]['IsBusy'] then
                    DrawMarker(2, Config.BankLocations[ClosestBank]["Lockers"][k]["X"], Config.BankLocations[ClosestBank]["Lockers"][k]["Y"], Config.BankLocations[ClosestBank]["Lockers"][k]["Z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 242, 148, 41, 255, false, false, false, 1, false, false, false)
                    DrawText3D(Config.BankLocations[ClosestBank]["Lockers"][k]["X"], Config.BankLocations[ClosestBank]["Lockers"][k]["Y"], Config.BankLocations[ClosestBank]["Lockers"][k]["Z"], 'Niets Beschikbaar..')
                elseif Config.BankLocations[ClosestBank]["Lockers"][k]['IsOpend'] then
                    DrawText3D(Config.BankLocations[ClosestBank]["Lockers"][k]["X"], Config.BankLocations[ClosestBank]["Lockers"][k]["Y"], Config.BankLocations[ClosestBank]["Lockers"][k]["Z"], 'Geopend..')
                    DrawMarker(2, Config.BankLocations[ClosestBank]["Lockers"][k]["X"], Config.BankLocations[ClosestBank]["Lockers"][k]["Y"], Config.BankLocations[ClosestBank]["Lockers"][k]["Z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 72, 48, 255, false, false, false, 1, false, false, false)
                else
                    DrawText3D(Config.BankLocations[ClosestBank]["Lockers"][k]["X"], Config.BankLocations[ClosestBank]["Lockers"][k]["Y"], Config.BankLocations[ClosestBank]["Lockers"][k]["Z"], '~g~E~s~ - Kluis Openbreken')
                    DrawMarker(2, Config.BankLocations[ClosestBank]["Lockers"][k]["X"], Config.BankLocations[ClosestBank]["Lockers"][k]["Y"], Config.BankLocations[ClosestBank]["Lockers"][k]["Z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 48, 255, 58, 255, false, false, false, 1, false, false, false)
                    if IsControlJustReleased(0, 38) then
                        LockpickLocker(k)
                    end
                end
            end
           end
        end
     end
    end
end)

-- // Event \\ --

RegisterNetEvent('fw-bankrobbery:client:set:open')
AddEventHandler('fw-bankrobbery:client:set:open', function(BankId, bool)
  Config.BankLocations[BankId]['IsOpened'] = bool
  if bool then
    Citizen.SetTimeout(2500, function()
            OpenBankDoor(BankId)
    end)
  else
    CloseBankDoor(BankId)
  end
end)

RegisterNetEvent('fw-bankrobbery:client:set:cards')
AddEventHandler('fw-bankrobbery:client:set:cards', function(BankId, CardData)
    Config.BankLocations[BankId]['card-type'] = CardData
end)

RegisterNetEvent('fw-bankrobbery:client:set:state')
AddEventHandler('fw-bankrobbery:client:set:state', function(BankId, LockerId, Type, bool)
  Config.BankLocations[BankId]['Lockers'][LockerId][Type] = bool
end)

RegisterNetEvent('fw-bankrobbery:client:use:card')
AddEventHandler('fw-bankrobbery:client:use:card', function(CardType)
    if ClosestBank ~= nil then
      local PlayerCoords = GetEntityCoords(GetPlayerPed(-1), false)
      local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.BankLocations[ClosestBank]["Coords"]["X"], Config.BankLocations[ClosestBank]["Coords"]["Y"], Config.BankLocations[ClosestBank]["Coords"]["Z"], true)
      if Distance < 1.5 then
        if not Config.BankLocations[ClosestBank]['IsOpened'] then
            if Config.BankLocations[ClosestBank]['card-type'] == CardType then
                if CurrentCops >= Config.NeededCops then
                   Framework.Functions.TriggerCallback('fw-bankrobbery:server:HasItem', function(HasItem)
                       if HasItem then
                           Framework.Functions.TriggerCallback("fw-bankrobbery:server:get:status", function(Status)
                               if not Status then
                                   if Config.BankLocations[ClosestBank]['Alarm'] then
                                   TriggerServerEvent('fw-police:server:send:bank:alert', GetEntityCoords(GetPlayerPed(-1)), Framework.Functions.GetStreetLabel(), Config.BankLocations[ClosestBank]['CamId'])
                                   end
                                   TriggerEvent('fw-inventory:client:requiredItems', ItemsNeeded, false)
                                   TriggerEvent('fw-inventory:client:set:busy', true)
                                   if ClosestBank ~= 6 then
                                   TriggerEvent("utk_fingerprint:Start", 4, 6, 2, OnHackEnding)
                                   else
                                    exports['fw-assets']:RequestAnimationDict("anim@heists@prison_heiststation@cop_reactions")
                                    TaskPlayAnim( PlayerPedId(), "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
                                    exports["minigame-datacrack"]:Start(5, function(Success)
                                        if Success then
                                            TriggerEvent("utk_fingerprint:Start", 4, 6, 2, function(Outcome)
                                                if Outcome then
                                                    StopAnimTask(GetPlayerPed(-1), "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
                                                    TriggerEvent('fw-inventory:client:set:busy', false)
                                                    TriggerServerEvent('Framework:Server:RemoveItem', Config.BankLocations[ClosestBank]['card-type'], 1)
                                                    TriggerEvent("fw-inventory:client:ItemBox", Framework.Shared.Items[Config.BankLocations[ClosestBank]['card-type']], "remove")
                                                    TriggerServerEvent('fw-bankrobbery:server:set:open', ClosestBank, true)
                                                else
                                                    StopAnimTask(GetPlayerPed(-1), "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
                                                    Framework.Functions.Notify("Thất bại...", "error")
                                                end
                                            end)
                                        else
                                            StopAnimTask(GetPlayerPed(-1), "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
                                            Framework.Functions.Notify("Thất bại", 'error')
                                        end
                                    end)
                                end   
                               else
                                   Framework.Functions.Notify("Ngân hàng này đang bị cướp!..", "error")
                               end
                           end)
                       else
                           Framework.Functions.Notify("Thiếu electronic kit không thể thực hiện..", "error")
                       end
                   end, "electronickit")  
                else
                    Framework.Functions.Notify("Số lượng cảnh sát online không đủ! ("..Config.NeededCops.." Cảnh sát)", "info")
                end
            else
                Framework.Functions.Notify("Thẻ không hợp lệ...", "error")
            end
        end
      end
    end
end)

-- // Functions \\ --

function OnHackEnding(Outcome)
    if Outcome then
        TriggerEvent('fw-inventory:client:set:busy', false)
        TriggerServerEvent('fw-bankrobbery:server:set:open', ClosestBank, true)
         Citizen.SetTimeout(1250, function()
           TriggerServerEvent('Framework:Server:RemoveItem', Config.BankLocations[ClosestBank]['card-type'], 1)
           TriggerEvent("fw-inventory:client:ItemBox", Framework.Shared.Items[Config.BankLocations[ClosestBank]['card-type']], "remove")    
         end)
        else
        TriggerEvent('fw-inventory:client:set:busy', false)
        Framework.Functions.Notify("Gefaalt...", "error")
    end
end

function OpenBankDoor(BankId)
    local Object = GetClosestObjectOfType(Config.BankLocations[BankId]["Coords"]["X"], Config.BankLocations[BankId]["Coords"]["Y"], Config.BankLocations[BankId]["Coords"]["Z"], 5.0, Config.BankLocations[BankId]['Object']['Hash'], false, false, false)
    local CurrentHeading = Config.BankLocations[BankId]["Object"]['Closed'] 
    if Object ~= 0 then
        Citizen.CreateThread(function()
        while true do
            if BankId ~= 6 then
                if CurrentHeading ~= Config.BankLocations[BankId]['Object']['Opend'] then
                    SetEntityHeading(Object, CurrentHeading - 10)
                    CurrentHeading = CurrentHeading - 0.5
                else
                    break
                end
            else
                if CurrentHeading ~= Config.BankLocations[BankId]['Object']['Opend'] then
                    SetEntityHeading(Object, CurrentHeading + 10)
                    CurrentHeading = CurrentHeading + 0.5
                else
                    break
                end
            end
            Citizen.Wait(10)
        end
     end)
    end
end

function CloseBankDoor(BankId)
    local Object = GetClosestObjectOfType(Config.BankLocations[BankId]["Coords"]["X"], Config.BankLocations[BankId]["Coords"]["Y"], Config.BankLocations[BankId]["Coords"]["Z"], 5.0, Config.BankLocations[BankId]['Object']['Hash'], false, false, false)
    if Object ~= 0 then
        SetEntityHeading(Object, Config.BankLocations[BankId]["Object"]['Closed'])
    end
end

function LockpickLocker(LockerId)
    local Type = Config.BankLocations[ClosestBank]['Lockers'][LockerId]['Type']
    TriggerServerEvent('fw-hud:server:gain:stress', math.random(1, 2))
    if Type == 'lockpick' then
        Framework.Functions.TriggerCallback("fw-bankrobbery:server:HasLockpickItems", function(HasItem)
            if HasItem then
            TriggerServerEvent('fw-bankrobbery:server:set:state', ClosestBank, LockerId, 'IsBusy', true)
              exports['fw-lockpick']:OpenLockpickGame(function(Success)
                  if Success then
                      Framework.Functions.Progressbar("break-safe", "Open breken..", math.random(10000, 15000), false, true, {
                          disableMovement = false,
                          disableCarMovement = false,
                          disableMouse = false,
                          disableCombat = true,
                      }, {
                          animDict = "anim@gangops@facility@servers@",
		                  anim = "hotwire",
		                  flags = 8,
                      }, {}, {}, function() -- Done
                           -- Remove Item Trigger.
                           StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                           TriggerServerEvent('fw-bankrobbery:server:random:reward', math.random(1,3), ClosestBank)
                           TriggerServerEvent('fw-bankrobbery:server:set:state', ClosestBank, LockerId, 'IsBusy', false) 
                           TriggerServerEvent('fw-bankrobbery:server:set:state', ClosestBank, LockerId, 'IsOpend', true) 
                           Framework.Functions.Notify("Gelukt", "success")
                      end, function()
                          StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                          TriggerServerEvent('fw-bankrobbery:server:set:state', ClosestBank, LockerId, 'IsBusy', false)
                          Framework.Functions.Notify("Đã hủy..", "error")
                      end)
                  else
                      Framework.Functions.Notify("Đã hủy..", "error")
                      TriggerServerEvent('fw-bankrobbery:server:set:state', ClosestBank, LockerId, 'IsBusy', false) 
                  end
              end)
            else
                Framework.Functions.Notify("Je hebt geen lockpicks..", "error")
            end
        end)
    elseif Type == 'drill' then
     Framework.Functions.TriggerCallback("fw-bankrobbery:server:HasItem", function(HasItem)
        if HasItem then           
            Framework.Functions.TriggerCallback("Framework:HasItem", function(SHasItem)
                if SHasItem then
                    TriggerServerEvent('Framework:Server:RemoveItem', 'drill-bit', 1)
                    TriggerEvent("fw-inventory:client:ItemBox", Framework.Shared.Items['drill-bit'], "remove")
                    TriggerServerEvent('fw-bankrobbery:server:set:state', ClosestBank, LockerId, 'IsBusy', true)
                    PlaySoundFrontend(-1, "BASE_JUMP_PASSED", "HUD_AWARDS", 1);
                    exports['fw-assets']:RequestAnimationDict("anim@heists@fleeca_bank@drilling")
                    TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
                    exports['fw-assets']:AddProp('Drill')
                    exports['minigame-drill']:StartDrilling(function(Success)
                       if Success then
                           exports['fw-assets']:RemoveProp()
                           Framework.Functions.Notify("Gelukt", "success")
                           StopAnimTask(GetPlayerPed(-1), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                           TriggerServerEvent('fw-bankrobbery:server:random:reward', math.random(1,3))
                           TriggerServerEvent('fw-bankrobbery:server:set:state', ClosestBank, LockerId, 'IsBusy', false) 
                           TriggerServerEvent('fw-bankrobbery:server:set:state', ClosestBank, LockerId, 'IsOpend', true) 
                       else
                           exports['fw-assets']:RemoveProp()
                           Framework.Functions.Notify("Đã hủy..", "error")
                           StopAnimTask(GetPlayerPed(-1), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                           TriggerServerEvent('fw-bankrobbery:server:set:state', ClosestBank, LockerId, 'IsBusy', false) 
                       end
                    end)
                else
                    Framework.Functions.Notify('Je mist iets voor deze boor..', 'error', 2500)
                end
            end, 'drill-bit')
        else
            Framework.Functions.Notify("Je hebt geen boor..", "error")
        end
      end, 'drill')
    end
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