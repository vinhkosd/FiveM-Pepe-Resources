local isLoggedIn = false
local MultiplierAmount = 0
local HasDot = false

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
     Citizen.Wait(100)
     isLoggedIn = true
 end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if isLoggedIn then
            local Weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
            local WeaponBullets = GetAmmoInPedWeapon(GetPlayerPed(-1), Weapon)
            if Config.WeaponsList[Weapon] ~= nil and Config.WeaponsList[Weapon]['AmmoType'] ~= nil then
               if Config.WeaponsList[Weapon]['IdName'] ~= 'weapon_unarmed' then 
                if IsPedShooting(GetPlayerPed(-1)) or IsPedPerformingMeleeAction(GetPlayerPed(-1)) then
                    if Config.WeaponsList[Weapon]['IdName'] == 'weapon_molotov' then
                        TriggerServerEvent('Framework:Server:RemoveItem', 'weapon_molotov', 1)
                        TriggerEvent('fw-weapons:client:set:current:weapon', nil)
                        TriggerEvent('fw-inventory:client:ItemBox', Framework.Shared.Items['weapon_molotov'], 'remove')
                    else
                        TriggerServerEvent("fw-weapons:server:UpdateWeaponQuality", Config.CurrentWeaponData, 1)
                        if WeaponBullets == 1 then
                          TriggerServerEvent("fw-weapons:server:UpdateWeaponAmmo", Config.CurrentWeaponData, 1)
                        else
                          TriggerServerEvent("fw-weapons:server:UpdateWeaponAmmo", Config.CurrentWeaponData, tonumber(WeaponBullets))
                        end
                    end
                end
                if Config.WeaponsList[Weapon]['AmmoType'] ~= 'AMMO_FIRE' then
                  if IsPedArmed(GetPlayerPed(-1), 6) then
                    if WeaponBullets == 1 then
                        DisableControlAction(0, 24, true) 
                        DisableControlAction(0, 257, true)
                        if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                            SetPlayerCanDoDriveBy(PlayerId(), false)
                        end
                    else
                        EnableControlAction(0, 24, true) 
                        EnableControlAction(0, 257, true)
                        if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                            SetPlayerCanDoDriveBy(PlayerId(), true)
                        end
                    end
                  else
                      Citizen.Wait(1000)
                  end
                end
            else
                Citizen.Wait(1000)
            end
          end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if isLoggedIn then
            if IsPedArmed(GetPlayerPed(-1), 6) then
                SendNUIMessage({
                    action = "toggle",
                    show = IsPlayerFreeAiming(PlayerId()),
                })
            else
                SendNUIMessage({
                    action = "toggle",
                    show = false,
                })
                Citizen.Wait(250)
            end
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('fw-weapons:client:set:current:weapon')
AddEventHandler('fw-weapons:client:set:current:weapon', function(data)
    if data ~= false then
        Config.CurrentWeaponData = data
    else
        Config.CurrentWeaponData = {}
    end
end)

RegisterNetEvent('fw-weapons:client:set:quality')
AddEventHandler('fw-weapons:client:set:quality', function(amount)
    if Config.CurrentWeaponData ~= nil and next(Config.CurrentWeaponData) ~= nil then
        TriggerServerEvent("fw-weapons:server:SetWeaponQuality", Config.CurrentWeaponData, amount)
    end
end)

RegisterNetEvent("fw-weapons:client:EquipAttachment")
AddEventHandler("fw-weapons:client:EquipAttachment", function(ItemData, attachment)
    local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
    local WeaponData = Config.WeaponsList[weapon]
    if weapon ~= GetHashKey("WEAPON_UNARMED") then
        WeaponData['IdName'] = WeaponData['IdName']:upper()
        if Config.WeaponAttachments[WeaponData['IdName']] ~= nil then
            if Config.WeaponAttachments[WeaponData['IdName']][attachment] ~= nil then
                TriggerServerEvent("fw-weapons:server:EquipAttachment", ItemData, Config.CurrentWeaponData, Config.WeaponAttachments[WeaponData['IdName']][attachment])
            else
                Framework.Functions.Notify("Dit wapen ondersteunt dit attachment niet..", "error")
            end
        end
    else
        Framework.Functions.Notify("Je hebt geen wapen in je hand..", "error")
    end
end)

RegisterNetEvent('fw-weapons:client:reload:ammo')
AddEventHandler('fw-weapons:client:reload:ammo', function(AmmoType, AmmoName)
 local Weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
 local WeaponBullets = GetAmmoInPedWeapon(GetPlayerPed(-1), Weapon)
 if Config.WeaponsList[Weapon] ~= nil and Config.WeaponsList[Weapon]['AmmoType'] ~= nil then
 local NewAmmo = WeaponBullets + Config.WeaponsList[Weapon]['MaxAmmo']
 if Config.WeaponsList[Weapon]['AmmoType'] == AmmoType then
    if WeaponBullets <= 1 then
        Framework.Functions.Progressbar("taking_bullets", "Kogels inladen..", Config.WeaponsList[Weapon]['Wait'], false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
             -- Remove Item Trigger.
             SetAmmoInClip(GetPlayerPed(-1), Weapon, 0)
             SetPedAmmo(GetPlayerPed(-1), Weapon, NewAmmo)
             TriggerServerEvent('Framework:Server:RemoveItem', AmmoName, 1)
             TriggerServerEvent("fw-weapons:server:UpdateWeaponAmmo", Config.CurrentWeaponData, tonumber(NewAmmo))
	         TriggerEvent("fw-inventory:client:ItemBox", Framework.Shared.Items[AmmoName], "remove")
             Framework.Functions.Notify("+ "..NewAmmo.."x kogels ("..Config.WeaponsList[Weapon]['Name']..")", "success")
        end, function()
            Framework.Functions.Notify("Đã hủy..", "error")
        end)
    else
        Framework.Functions.Notify("Je hebt al kogels in geladen..", "error")
    end
  end
 end
end)

RegisterNetEvent('fw-weapons:client:set:ammo')
AddEventHandler('fw-weapons:client:set:ammo', function(Amount)
 local Weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
 local WeaponBullets = GetAmmoInPedWeapon(GetPlayerPed(-1), Weapon)
 local NewAmmo = WeaponBullets + tonumber(Amount)
 if Config.WeaponsList[Weapon] ~= nil and Config.WeaponsList[Weapon]['AmmoType'] ~= nil then
  SetAmmoInClip(GetPlayerPed(-1), Weapon, 0)
  SetPedAmmo(GetPlayerPed(-1), Weapon, tonumber(NewAmmo))
  TriggerServerEvent("fw-weapons:server:UpdateWeaponAmmo", Config.CurrentWeaponData, tonumber(NewAmmo))
  Framework.Functions.Notify("Succesvol "..Amount..'x kogels ontvangen ('..Config.WeaponsList[Weapon]['Name']..')', "success", 4500)
 end
end)

RegisterNetEvent('fw-weapons:client:remove:dot')
AddEventHandler('fw-weapons:client:remove:dot', function()
 if not IsPlayerFreeAiming(PlayerId()) then
    SendNUIMessage({
        action = "toggle",
        show = false,
    })
 end
end)

RegisterNetEvent("fw-weapons:client:addAttachment")
AddEventHandler("fw-weapons:client:addAttachment", function(component)
 local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
 local WeaponData = Config.WeaponsList[weapon]
 GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(WeaponData['IdName']), GetHashKey(component))
end)

-- // Functions \\ --

function GetAmmoType(Weapon)
 if Config.WeaponsList[Weapon] ~= nil then
     return Config.WeaponsList[Weapon]['AmmoType']
 end
end