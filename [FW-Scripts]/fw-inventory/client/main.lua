local Framework = nil
local LoggedIn = true

local currentWeapon = nil
local CurrentWeaponData = {}
local currentOtherInventory = nil

local Drops = {}
local CurrentDrop = 0
local DropsNear = {}

local CurrentVehicle = nil
local CurrentGlovebox = nil
local CurrentStash = nil
local CurrentTrash = false   

TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)  

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
     Citizen.Wait(250)
     Config.InventoryBusy = false
     LoggedIn = true
 end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    Config.InventoryBusy = false
    LoggedIn = false
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        DisableControlAction(0, Config.Keys["TAB"], true)
        DisableControlAction(0, Config.Keys["1"], true)
        DisableControlAction(0, Config.Keys["2"], true)
        DisableControlAction(0, Config.Keys["3"], true)
        DisableControlAction(0, Config.Keys["4"], true)
        DisableControlAction(0, Config.Keys["5"], true)
        if LoggedIn then
           if IsDisabledControlJustPressed(0, Config.Keys["TAB"]) and not Config.InventoryBusy then
               local DumpsterFound = ClosestContainer()
               local JailContainerFound = ClosestJailContainer()
               Framework.Functions.GetPlayerData(function(PlayerData)
                   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["ishandcuffed"] then
                       local curVeh = nil
                       if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                           local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                           CurrentGlovebox = GetVehicleNumberPlateText(vehicle)
                           curVeh = vehicle
                           CurrentVehicle = nil
                       else
                           local vehicle = Framework.Functions.GetClosestVehicle()
                           if vehicle ~= 0 and vehicle ~= nil then
                               local pos = GetEntityCoords(GetPlayerPed(-1))
                               local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                               if (IsBackEngine(GetEntityModel(vehicle))) then
                                   trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                               end
                               if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, trunkpos) < 1.0) and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                                   if GetVehicleDoorLockStatus(vehicle) < 2 then
                                       CurrentVehicle = GetVehicleNumberPlateText(vehicle)
                                       curVeh = vehicle
                                       CurrentGlovebox = nil
                                   else
                                       Framework.Functions.Notify("Cốp xe đã khóa..", "error")
                                       return
                                   end
                               else
                                   CurrentVehicle = nil
                               end
                           else
                               CurrentVehicle = nil
                           end
                       end
                       if CurrentVehicle ~= nil then
                           local other = {maxweight = Config.TrunkClasses[GetVehicleClass(curVeh)]['MaxWeight'], slots = Config.TrunkClasses[GetVehicleClass(curVeh)]['MaxSlots']}
                           TriggerServerEvent("fw-inventory:server:OpenInventory", "trunk", CurrentVehicle, other)
                           OpenTrunk()
                       elseif CurrentGlovebox ~= nil then
                           TriggerServerEvent("fw-inventory:server:OpenInventory", "glovebox", CurrentGlovebox)
                       elseif DumpsterFound then
                           local Dumpster = 'Container | '..math.floor(DumpsterFound.x).. ' | '..math.floor(DumpsterFound.y)..' |'
                           TriggerServerEvent("fw-inventory:server:OpenInventory", "stash", Dumpster, {maxweight = 1000000, slots = 15})
                           TriggerEvent("fw-inventory:client:SetCurrentStash", Dumpster)
                           TriggerEvent('fw-inventory:client:open:anim')   
                       elseif JailContainerFound and exports['fw-prison']:GetInJailStatus() then
                           local Container = 'Jail~Container | '..math.floor(JailContainerFound.x).. ' | '..math.floor(JailContainerFound.y)..' |'
                           TriggerServerEvent("fw-inventory:server:OpenInventory", "stash", Container, {maxweight = 1000000, slots = 15})
                           TriggerEvent("fw-inventory:client:SetCurrentStash", Container)
                           TriggerEvent('fw-inventory:client:open:anim')
                       elseif CurrentDrop ~= 0 then
                           TriggerServerEvent("fw-inventory:server:OpenInventory", "drop", CurrentDrop)
                       else                       
                           TriggerServerEvent("fw-inventory:server:OpenInventory")
                           TriggerEvent('fw-inventory:client:open:anim')
                       end
                   end
               end)
           end
            
           if IsControlJustPressed(0, Config.Keys["Z"]) then
               ToggleHotbar(true)
           end
   
           if IsControlJustReleased(0, Config.Keys["Z"]) then
               ToggleHotbar(false)
           end
   
           if IsDisabledControlJustReleased(0, Config.Keys["1"]) then
               Framework.Functions.GetPlayerData(function(PlayerData)
                   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                       TriggerServerEvent("fw-inventory:server:UseItemSlot", 1)
                   end
               end)
           end
   
           if IsDisabledControlJustReleased(0, Config.Keys["2"]) then
               Framework.Functions.GetPlayerData(function(PlayerData)
                   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                       TriggerServerEvent("fw-inventory:server:UseItemSlot", 2)
                   end
               end)
           end
   
           if IsDisabledControlJustReleased(0, Config.Keys["3"]) then
               Framework.Functions.GetPlayerData(function(PlayerData)
                   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                       TriggerServerEvent("fw-inventory:server:UseItemSlot", 3)
                   end
               end)
           end
   
           if IsDisabledControlJustReleased(0, Config.Keys["4"]) then
               Framework.Functions.GetPlayerData(function(PlayerData)
                   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                       TriggerServerEvent("fw-inventory:server:UseItemSlot", 4)
                   end
               end)
           end
   
           if IsDisabledControlJustReleased(0, Config.Keys["5"]) then
               Framework.Functions.GetPlayerData(function(PlayerData)
                   if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                       TriggerServerEvent("fw-inventory:server:UseItemSlot", 5)
                   end
               end)
           end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if DropsNear ~= nil then
            for k, v in pairs(DropsNear) do
                if DropsNear[k] ~= nil then
                    DrawMarker(2, v.coords.x, v.coords.y, v.coords.z -0.5, 0, 0, 0, 0, 0, 0, 0.35, 0.5, 0.15, 252, 255, 255, 91, 0, 0, 0, 0)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if Drops ~= nil and next(Drops) ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1), true)
            for k, v in pairs(Drops) do
                if Drops[k] ~= nil then 
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 7.5 then
                        DropsNear[k] = v
                        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 2 then
                            CurrentDrop = k
                        else
                            CurrentDrop = nil
                        end
                    else
                        DropsNear[k] = nil
                    end
                end
            end
        else
            DropsNear = {}
        end
        Citizen.Wait(500)
    end
end)

RegisterNUICallback('RobMoney', function(data, cb)
    TriggerServerEvent("fw-police:server:rob:player", data.TargetId)
end)

RegisterNUICallback('Notify', function(data, cb)
    Framework.Functions.Notify(data.message, data.type)
end)

RegisterNUICallback('UseItemShiftClick', function(slot)
    Framework.Functions.GetPlayerData(function(PlayerData)
        if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
            SendNUIMessage({
                action = "close",
            })
            SetNuiFocus(false, false)
            Config.HasInventoryOpen = false
            Citizen.Wait(250)
            TriggerServerEvent("fw-inventory:server:UseItemSlot", slot.slot)
        end
    end)
end)

RegisterNUICallback('GetWeaponData', function(data, cb)
    local data = {
        WeaponData = Framework.Shared.Items[data.weapon],
        AttachmentData = FormatWeaponAttachments(data.ItemData)
    }
    cb(data)
end)

RegisterNUICallback('RemoveAttachment', function(data, cb)
    local WeaponData = Framework.Shared.Items[data.WeaponData.name]
    local Attachment = Config.WeaponAttachments[WeaponData.name:upper()][data.AttachmentData.attachment]
    Framework.Functions.TriggerCallback('fw-weapons:server:RemoveAttachment', function(NewAttachments)
        if NewAttachments ~= false then
            local Attachies = {}
            RemoveWeaponComponentFromPed(GetPlayerPed(-1), GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            for k, v in pairs(NewAttachments) do
                for wep, pew in pairs(Config.WeaponAttachments[WeaponData.name:upper()]) do
                    if v.component == pew.component then
                        table.insert(Attachies, {
                            attachment = pew.item,
                            label = pew.label,
                        })
                    end
                end
            end
            local DJATA = {
                Attachments = Attachies,
                WeaponData = WeaponData,
            }
            cb(DJATA)
        else
            RemoveWeaponComponentFromPed(GetPlayerPed(-1), GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            cb({})
        end
    end, data.AttachmentData, data.WeaponData)
end)

RegisterNUICallback('getCombineItem', function(data, cb)
    cb(Framework.Shared.Items[data.item])
end)

RegisterNUICallback("CloseInventory", function(data, cb)
    if currentOtherInventory == "none-inv" then
        CurrentDrop = 0
        CurrentVehicle = nil
        CurrentGlovebox = nil
        CurrentStash = nil
        SetNuiFocus(false, false)
        Config.HasInventoryOpen = false
        ClearPedTasks(GetPlayerPed(-1))
        return
    end
    if CurrentVehicle ~= nil then
        CloseTrunk()
        TriggerServerEvent("fw-inventory:server:SaveInventory", "trunk", CurrentVehicle)
        TriggerEvent('fw-inventory:client:open:anim')
        CurrentVehicle = nil
    elseif CurrentGlovebox ~= nil then
        TriggerServerEvent("fw-inventory:server:SaveInventory", "glovebox", CurrentGlovebox)
        CurrentGlovebox = nil
    elseif CurrentStash ~= nil then
        TriggerServerEvent("fw-inventory:server:SaveInventory", "stash", CurrentStash)
        TriggerEvent('fw-inventory:client:open:anim')
        CurrentStash = nil
    else
        TriggerServerEvent("fw-inventory:server:SaveInventory", "drop", CurrentDrop)
        TriggerEvent('fw-inventory:client:open:anim')
        CurrentDrop = 0
    end
    SetNuiFocus(false, false)
    Config.HasInventoryOpen = false
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    TriggerServerEvent('fw-inventory:server:set:inventory:disabled', false)
end)

RegisterNUICallback("UseItem", function(data, cb)
    TriggerServerEvent("fw-inventory:server:UseItem", data.inventory, data.item)
end)

RegisterNUICallback("UpdateStash", function(data, cb)
    if CurrentVehicle ~= nil then
        TriggerServerEvent("fw-inventory:server:SaveInventory", "trunk", CurrentVehicle)
    elseif CurrentGlovebox ~= nil then
        TriggerServerEvent("fw-inventory:server:SaveInventory", "glovebox", CurrentGlovebox)
    elseif CurrentStash ~= nil then
        TriggerServerEvent("fw-inventory:server:SaveInventory", "stash", CurrentStash)
    else
        TriggerServerEvent("fw-inventory:server:SaveInventory", "drop", CurrentDrop)
    end
end)

RegisterNUICallback("combineItem", function(data)
 Citizen.Wait(150)
 TriggerServerEvent('fw-inventory:server:combineItem', data.reward, data.fromItem, data.toItem)
 TriggerEvent('fw-inventory:client:ItemBox', Framework.Shared.Items[data.reward], 'add')
end)

RegisterNUICallback('combineWithAnim', function(data)
    local combineData = data.combineData
    local aDict = combineData.anim.dict
    local aLib = combineData.anim.lib
    local animText = combineData.anim.text
    local animTimeout = combineData.anim.timeOut
    TriggerServerEvent('fw-inventory:server:set:inventory:disabled', true)
    Citizen.SetTimeout(1250, function()
        Config.InventoryBusy = true
        Framework.Functions.Progressbar("combine_anim", animText, animTimeout, false, true, {
            disableMovement = false,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = aDict,
            anim = aLib,
            flags = 49,
        }, {}, {}, function() -- Done
            Config.InventoryBusy = false
            StopAnimTask(GetPlayerPed(-1), aDict, aLib, 1.0)
            TriggerServerEvent('fw-inventory:server:combineItem', combineData.reward, data.requiredItem, data.usedItem, combineData.RemoveToItem)
        end, function() -- Cancel
            Config.InventoryBusy = false
            StopAnimTask(GetPlayerPed(-1), aDict, aLib, 1.0)
            Framework.Functions.Notify("Thất bại!", "error")
        end)
    end)
    
end)

RegisterNUICallback("SetInventoryData", function(data, cb)
    TriggerServerEvent("fw-inventory:server:SetInventoryData", data.fromInventory, data.toInventory, data.fromSlot, data.toSlot, data.fromAmount, data.toAmount)
end)

RegisterNUICallback("PlayDropSound", function(data, cb)
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback("PlayDropFail", function(data, cb)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

-- // Events \\ --
RegisterNetEvent('fw-inventory:client:close:inventory')
AddEventHandler('fw-inventory:client:close:inventory', function()
    TriggerServerEvent('fw-inventory:server:set:inventory:disabled', false)
    Citizen.SetTimeout(150, function()
        SendNUIMessage({
            action = "close",
        })
        SetNuiFocus(false, false)
        Config.HasInventoryOpen = false
    end)
end)

RegisterNetEvent('fw-inventory:client:set:busy')
AddEventHandler('fw-inventory:client:set:busy', function(bool)
    Config.InventoryBusy = bool
end)

RegisterNetEvent('fw-inventory:client:CheckOpenState')
AddEventHandler('fw-inventory:client:CheckOpenState', function(type, id, label)
    local name = Framework.Shared.SplitStr(label, "-")[2]
    if type == "stash" then
        if name ~= CurrentStash or CurrentStash == nil then
            TriggerServerEvent('fw-inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "trunk" then
        if name ~= CurrentVehicle or CurrentVehicle == nil then
            TriggerServerEvent('fw-inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "glovebox" then
        if name ~= CurrentGlovebox or CurrentGlovebox == nil then
            TriggerServerEvent('fw-inventory:server:SetIsOpenState', false, type, id)
        end
    end
end)

RegisterNetEvent('fw-weapons:client:set:current:weapon')
AddEventHandler('fw-weapons:client:set:current:weapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
end)

RegisterNetEvent('fw-inventory:client:ItemBox')
AddEventHandler('fw-inventory:client:ItemBox', function(itemData, type)
    SendNUIMessage({
        action = "itemBox",
        item = itemData,
        type = type
    })
end)

RegisterNetEvent('fw-inventory:client:busy:status')
AddEventHandler('fw-inventory:client:busy:status', function(bool)
    CanOpenInventory = bool
end)

RegisterNetEvent('fw-inventory:client:requiredItems')
AddEventHandler('fw-inventory:client:requiredItems', function(items, bool)
    local itemTable = {}
    if bool then
        for k, v in pairs(items) do
            table.insert(itemTable, {
                item = items[k].name,
                label = Framework.Shared.Items[items[k].name]["label"],
                image = items[k].image,
            })
        end
    end
    SendNUIMessage({
        action = "requiredItem",
        items = itemTable,
        toggle = bool
    })
end)

RegisterNetEvent('fw-inventory:server:RobPlayer')
AddEventHandler('fw-inventory:server:RobPlayer', function(TargetId)
    SendNUIMessage({
        action = "RobMoney",
        TargetId = TargetId,
    })
end)

RegisterNetEvent("fw-inventory:client:OpenInventory")
AddEventHandler("fw-inventory:client:OpenInventory", function(inventory, other)
    if not IsEntityDead(GetPlayerPed(-1)) then
        ToggleHotbar(false)
        SetNuiFocus(true, true)
        if other ~= nil then
            currentOtherInventory = other.name
        end
        SendNUIMessage({
            action = "open",
            inventory = inventory,
            slots = Config.MaxInventorySlots,
            other = other,
            maxweight = Framework.Config.Player.MaxWeight,
        })
        Config.HasInventoryOpen = true
    end
end)

RegisterNetEvent("fw-inventory:client:UpdatePlayerInventory")
AddEventHandler("fw-inventory:client:UpdatePlayerInventory", function(isError)
    SendNUIMessage({
        action = "update",
        inventory = Framework.Functions.GetPlayerData().items,
        maxweight = Framework.Config.Player.MaxWeight,
        slots = Config.MaxInventorySlots,
        error = isError,
    })
end)

RegisterNetEvent("fw-inventory:client:CraftItems")
AddEventHandler("fw-inventory:client:CraftItems", function(itemName, itemCosts, amount, toSlot, points)
    SendNUIMessage({
        action = "close",
    })
    Config.InventoryBusy = true
    Framework.Functions.Progressbar("repair_vehicle", "Đang chế tạo..", (math.random(2000, 5000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("fw-inventory:server:CraftItems", itemName, itemCosts, amount, toSlot, points)
        TriggerEvent('fw-inventory:client:ItemBox', Framework.Shared.Items[itemName], 'add')
        Config.InventoryBusy = false
	end, function() -- Cancel
		StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
        Framework.Functions.Notify("Thất bại!", "error")
        Config.InventoryBusy = false
	end)
end)

RegisterNetEvent("fw-inventory:client:CraftWeapon")
AddEventHandler("fw-inventory:client:CraftWeapon", function(itemName, itemCosts, amount, toSlot, ItemType)
    SendNUIMessage({
        action = "close",
    })
    Config.InventoryBusy = true
    Framework.Functions.Progressbar("repair_vehicle", "Đang chế tạo..", (math.random(10000, 12000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("fw-inventory:server:CraftWeapon", itemName, itemCosts, amount, toSlot, ItemType)
        TriggerEvent('fw-inventory:client:ItemBox', Framework.Shared.Items[itemName], 'add')
        Config.InventoryBusy = false
	end, function() -- Cancel
		StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
        Framework.Functions.Notify("Thất bại!", "error")
        Config.InventoryBusy = false
	end)
end)

RegisterNetEvent("fw-inventory:client:UseWeapon")
AddEventHandler("fw-inventory:client:UseWeapon", function(weaponData)
    local weaponName = tostring(weaponData.name)
    if currentWeapon == weaponName then
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(GetPlayerPed(-1), true)
        TriggerEvent('fw-weapons:client:set:current:weapon', nil)
        currentWeapon = nil
    elseif weaponName == "weapon_stickybomb" then
        GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weaponName), 1, false, false)
        SetPedAmmo(GetPlayerPed(-1), GetHashKey(weaponName), 1)
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey(weaponName), true)
        TriggerServerEvent('Framework:Server:RemoveItem', weaponName, 1)
        TriggerEvent('fw-weapons:client:set:current:weapon', weaponData)
        currentWeapon = weaponName
    elseif weaponName == "weapon_molotov" then
        GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weaponName), 1, false, false)
        SetPedAmmo(GetPlayerPed(-1), GetHashKey(weaponName), 1)
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey(weaponName), true)
        TriggerEvent('fw-weapons:client:set:current:weapon', weaponData)
        currentWeapon = weaponName
    else    
        TriggerEvent('fw-weapons:client:set:current:weapon', weaponData)
        Framework.Functions.TriggerCallback("fw-weapon:server:GetWeaponAmmo", function(result)
            local ammo = tonumber(result)
            if weaponName == "weapon_petrolcan" or weaponName == "weapon_fireextinguisher" then 
                ammo = 4000 
            end
            GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weaponName), ammo, false, false)
            SetPedAmmo(GetPlayerPed(-1), GetHashKey(weaponName), ammo)
            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey(weaponName), true)
            if weaponData.info.attachments ~= nil then
                for _, attachment in pairs(weaponData.info.attachments) do
                    GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(weaponName), GetHashKey(attachment.component))
                end
            end
            currentWeapon = weaponName
        end, CurrentWeaponData)
    end
end)

RegisterNetEvent("fw-inventory:client:CheckWeapon")
AddEventHandler("fw-inventory:client:CheckWeapon", function(weaponName)
    if currentWeapon == weaponName then 
        TriggerEvent('fw-assets:ResetHolster')
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(GetPlayerPed(-1), true)
        currentWeapon = nil
    end
end)

RegisterNetEvent("fw-inventory:client:AddDropItem")
AddEventHandler("fw-inventory:client:AddDropItem", function(dropId, player)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player)))
    local forward = GetEntityForwardVector(GetPlayerPed(GetPlayerFromServerId(player)))
	local x, y, z = table.unpack(coords + forward * 0.5)
    Drops[dropId] = {
        id = dropId,
        coords = {
            x = x,
            y = y,
            z = z - 0.3,
        },
    }
end)

RegisterNetEvent("fw-inventory:client:RemoveDropItem")
AddEventHandler("fw-inventory:client:RemoveDropItem", function(dropId)
    Drops[dropId] = nil
end)

RegisterNetEvent("fw-inventory:client:DropItemAnim")
AddEventHandler("fw-inventory:client:DropItemAnim", function()
    SendNUIMessage({
        action = "close",
    })
    RequestAnimDict("pickup_object")
    while not HasAnimDictLoaded("pickup_object") do
        Citizen.Wait(7)
    end
    TaskPlayAnim(GetPlayerPed(-1), "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
    Citizen.Wait(2000)
    ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent("fw-inventory:client:ShowId")
AddEventHandler("fw-inventory:client:ShowId", function(sourceId, citizenid, character)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then
        local gender = "Man"
        if character.gender == 1 then
            gender = "Vrouw"
        end
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>BSN:</strong> {1} <br><strong>Tên:</strong> {2} <br><strong>Họ:</strong> {3} <br><strong>Ngày sinh:</strong> {4} <br><strong>Giới tính:</strong> {5} <br><strong>Quốc tịch:</strong> {6}</div></div>',
            args = {'ID-kaart', character.citizenid, character.firstname, character.lastname, character.birthdate, gender, character.nationality}
        })
    end
end)

RegisterNetEvent("fw-inventory:client:ShowDriverLicense")
AddEventHandler("fw-inventory:client:ShowDriverLicense", function(sourceId, citizenid, character)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Tên:</strong> {1} <br><strong>Họ:</strong> {2} <br><strong>Ngày sinh:</strong> {3} <br><strong>Giấy phép lái xe:</strong> {4}</div></div>',
            args = {'Rijbewijs', character.firstname, character.lastname, character.birthdate, character.type}
        })
    end
end)

RegisterNetEvent("fw-inventory:client:SetCurrentStash")
AddEventHandler("fw-inventory:client:SetCurrentStash", function(stash)
    CurrentStash = stash
end)

RegisterNetEvent('fw-inventory:client:open:anim')
AddEventHandler('fw-inventory:client:open:anim', function()
  exports['fw-assets']:RequestAnimationDict('pickup_object')
  TaskPlayAnim(GetPlayerPed(-1), 'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
  Citizen.Wait(1000)
  ClearPedSecondaryTask(GetPlayerPed(-1))
end)


-- // Functions \\ --

function ClosestContainer()
    for k, v in pairs(Config.Dumpsters) do
        local StartShape = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 0.1, 0)
        local EndShape = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 1.8, -0.4)
        local RayCast = StartShapeTestRay(StartShape.x, StartShape.y, StartShape.z, EndShape.x, EndShape.y, EndShape.z, 16, GetPlayerPed(-1), 0)
        local Retval, Hit, Coords, Surface, EntityHit = GetShapeTestResult(RayCast)
        local BinModel = 0
        if EntityHit then
          BinModel = GetEntityModel(EntityHit)
        end
        if v['Model'] == BinModel then
         local EntityHitCoords = GetEntityCoords(EntityHit)
         if EntityHitCoords.x < 0 or EntityHitCoords.y < 0 then
             EntityHitCoords = {x = EntityHitCoords.x + 5000,y = EntityHitCoords.y + 5000}
         end
         return EntityHitCoords
        end
    end
end

function ClosestJailContainer()
  for k, v in pairs(Config.JailContainers) do
      local StartShape = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 0.1, 0)
      local EndShape = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 1.8, -0.4)
      local RayCast = StartShapeTestRay(StartShape.x, StartShape.y, StartShape.z, EndShape.x, EndShape.y, EndShape.z, 16, GetPlayerPed(-1), 0)
      local Retval, Hit, Coords, Surface, EntityHit = GetShapeTestResult(RayCast)
      local BinModel = 0
      if EntityHit then
        BinModel = GetEntityModel(EntityHit)
      end
      if v['Model'] == BinModel then
       local EntityHitCoords = GetEntityCoords(EntityHit)
       if EntityHitCoords.x < 0 or EntityHitCoords.y < 0 then
           EntityHitCoords = {x = EntityHitCoords.x + 5000,y = EntityHitCoords.y + 5000}
       end
       return EntityHitCoords
      end
  end
end

function OpenTrunk()
    local vehicle = Framework.Functions.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "idle_d", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorOpen(vehicle, 4, false, false)
    else
        SetVehicleDoorOpen(vehicle, 5, false, false)
    end
end

function CloseTrunk()
    local vehicle = Framework.Functions.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "exit", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorShut(vehicle, 4, false)
    else
        SetVehicleDoorShut(vehicle, 5, false)
    end
end

function IsBackEngine(vehModel)
    for _, model in pairs(Config.BackEngineVehicles) do
        if GetHashKey(model) == vehModel then
            return true
        end
    end
    return false
end

function ToggleHotbar(toggle)
 local HotbarItems = {
  [1] = Framework.Functions.GetPlayerData().items[1],
  [2] = Framework.Functions.GetPlayerData().items[2],
  [3] = Framework.Functions.GetPlayerData().items[3],
  [4] = Framework.Functions.GetPlayerData().items[4],
  [5] = Framework.Functions.GetPlayerData().items[5],
 } 
 if toggle then
     SendNUIMessage({
         action = "toggleHotbar",
         open = true,
         items = HotbarItems
     })
 else
     SendNUIMessage({
         action = "toggleHotbar",
         open = false,
     })
 end
end

function FormatWeaponAttachments(itemdata)
    local attachments = {}
    itemdata.name = itemdata.name:upper()
    if itemdata.info.attachments ~= nil and next(itemdata.info.attachments) ~= nil then
        for k, v in pairs(itemdata.info.attachments) do
            if Config.WeaponAttachments[itemdata.name] ~= nil then
                for key, value in pairs(Config.WeaponAttachments[itemdata.name]) do
                    if value.component == v.component then
                        table.insert(attachments, {
                            attachment = key,
                            label = value.label
                        })
                    end
                end
            end
        end
    end
    return attachments
end