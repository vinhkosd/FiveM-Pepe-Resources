Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Commands.Add("addammo", "Geef kogels voor het wapen wat je vast hebt", {{name="Hoeveelheid", help="hoeveel kogels?"}}, true, function(source, args)
    if args[1] ~= nil then
      TriggerClientEvent('fw-weapons:client:set:ammo', source, args[1])
    end
end, "admin")

Framework.Functions.CreateUseableItem("pistol-ammo", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('fw-weapons:client:reload:ammo', source, 'AMMO_PISTOL', 'pistol-ammo')
    end
end)

Framework.Functions.CreateUseableItem("rifle-ammo", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('fw-weapons:client:reload:ammo', source, 'AMMO_RIFLE', 'rifle-ammo')
    end
end)

Framework.Functions.CreateUseableItem("smg-ammo", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('fw-weapons:client:reload:ammo', source, 'AMMO_SMG', 'smg-ammo')
    end
end)

Framework.Functions.CreateUseableItem("shotgun-ammo", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('fw-weapons:client:reload:ammo', source, 'AMMO_SHOTGUN', 'shotgun-ammo')
    end
end)

Framework.Functions.CreateUseableItem("taser-ammo", function(source, item)
	local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('fw-weapons:client:reload:ammo', source, 'AMMO_TAZER', 'taser-ammo')
    end
end)

Framework.Functions.CreateUseableItem("pistol_suppressor", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
    TriggerClientEvent("fw-weapons:client:EquipAttachment", source, item, "suppressor")
end)

Framework.Functions.CreateUseableItem("pistol_extendedclip", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
    TriggerClientEvent("fw-weapons:client:EquipAttachment", source, item, "extendedclip")
end)

Framework.Functions.CreateUseableItem("rifle_suppressor", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
    TriggerClientEvent("fw-weapons:client:EquipAttachment", source, item, "suppressor")
end)

Framework.Functions.CreateUseableItem("rifle_extendedclip", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
    TriggerClientEvent("fw-weapons:client:EquipAttachment", source, item, "extendedclip")
end)

Framework.Functions.CreateUseableItem("rifle_flashlight", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
    TriggerClientEvent("fw-weapons:client:EquipAttachment", source, item, "flashlight")
end)

Framework.Functions.CreateUseableItem("rifle_grip", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
    TriggerClientEvent("fw-weapons:client:EquipAttachment", source, item, "grip")
end)

Framework.Functions.CreateUseableItem("rifle_scope", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
    TriggerClientEvent("fw-weapons:client:EquipAttachment", source, item, "scope")
end)

RegisterServerEvent('fw-weapons:server:UpdateWeaponQuality')
AddEventHandler('fw-weapons:server:UpdateWeaponQuality', function(data, RepeatAmount)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local WeaponData = Config.WeaponsList[GetHashKey(data.name)]
    local WeaponSlot = Player.PlayerData.items[data.slot]
    local DecreaseAmount = Config.DurabilityMultiplier[data.name]
    if WeaponSlot ~= nil then
        if not IsWeaponBlocked(WeaponData['IdName']) then
            if WeaponSlot.info.quality ~= nil then
                for i = 1, RepeatAmount, 1 do
                    if WeaponSlot.info.quality - DecreaseAmount > 0 then
                        WeaponSlot.info.quality = WeaponSlot.info.quality - DecreaseAmount
                    else
                        WeaponSlot.info.quality = 0
                        TriggerClientEvent('fw-inventory:client:UseWeapon', src, data)
                        TriggerClientEvent('Framework:Notify', src, "Jouw wapen is gebroken.", "error")
                        break
                    end
                end
            else
                WeaponSlot.info.quality = 100
                for i = 1, RepeatAmount, 1 do
                    if WeaponSlot.info.quality - DecreaseAmount > 0 then
                        WeaponSlot.info.quality = WeaponSlot.info.quality - DecreaseAmount
                    else
                        WeaponSlot.info.quality = 0
                        TriggerClientEvent('fw-inventory:client:UseWeapon', src, data)
                        TriggerClientEvent('Framework:Notify', src, "Jouw wapen is gebroken.", "error")
                        break
                    end
                end
            end
        end
    end
    Player.Functions.SetInventory(Player.PlayerData.items)
end)

RegisterServerEvent("fw-weapons:server:EquipAttachment")
AddEventHandler("fw-weapons:server:EquipAttachment", function(ItemData, CurrentWeaponData, AttachmentData)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local Inventory = Player.PlayerData.items
    local GiveBackItem = nil
    if Inventory[CurrentWeaponData.slot] ~= nil then
        if Inventory[CurrentWeaponData.slot].info.attachments ~= nil and next(Inventory[CurrentWeaponData.slot].info.attachments) ~= nil then
            local HasAttach, key = HasAttachment(AttachmentData.component, Inventory[CurrentWeaponData.slot].info.attachments)
            if not HasAttach then
                if CurrentWeaponData.name == "weapon_compactrifle" then
                    local component = "COMPONENT_COMPACTRIFLE_CLIP_03"
                    if AttachmentData.component == "COMPONENT_COMPACTRIFLE_CLIP_03" then
                        component = "COMPONENT_COMPACTRIFLE_CLIP_02"
                    end
                    for k, v in pairs(Inventory[CurrentWeaponData.slot].info.attachments) do
                        if v.component == component then
                            local has, key = HasAttachment(component, Inventory[CurrentWeaponData.slot].info.attachments)
                            local item = GetAttachmentItem(CurrentWeaponData.name:upper(), component)
                            GiveBackItem = tostring(item):lower()
                            table.remove(Inventory[CurrentWeaponData.slot].info.attachments, key)
                            TriggerClientEvent('fw-inventory:client:ItemBox', src, Framework.Shared.Items[item], "add")
                        end
                    end
                end
                table.insert(Inventory[CurrentWeaponData.slot].info.attachments, {
                    component = AttachmentData.component,
                    label = AttachmentData.label,
                })
                TriggerClientEvent("fw-weapons:client:addAttachment", src, AttachmentData.component)
                Player.Functions.SetInventory(Player.PlayerData.items)
                Player.Functions.RemoveItem(ItemData.name, 1)
                SetTimeout(1000, function()
                    TriggerClientEvent('fw-inventory:client:ItemBox', src, ItemData, "remove")
                end)
            else
                TriggerClientEvent("Framework:Notify", src, "Je hebt al een "..AttachmentData.label:lower().." op jouw wapen zitten.", "error", 3500)
            end
        else
            Inventory[CurrentWeaponData.slot].info.attachments = {}
            table.insert(Inventory[CurrentWeaponData.slot].info.attachments, {
                component = AttachmentData.component,
                label = AttachmentData.label,
            })
            TriggerClientEvent("fw-weapons:client:addAttachment", src, AttachmentData.component)
            Player.Functions.SetInventory(Player.PlayerData.items)
            Player.Functions.RemoveItem(ItemData.name, 1)
            SetTimeout(1000, function()
                TriggerClientEvent('fw-inventory:client:ItemBox', src, ItemData, "remove")
            end)
        end
    end
    if GiveBackItem ~= nil then
        Player.Functions.AddItem(GiveBackItem, 1, false)
        GiveBackItem = nil
    end
end)

RegisterServerEvent("fw-weapons:server:SetWeaponQuality")
AddEventHandler("fw-weapons:server:SetWeaponQuality", function(data, hp)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local WeaponData = Framework.Shared.Weapons[GetHashKey(data.name)]
    local WeaponSlot = Player.PlayerData.items[data.slot]
    local DecreaseAmount = Config.DurabilityMultiplier[data.name]
    WeaponSlot.info.quality = hp
    Player.Functions.SetInventory(Player.PlayerData.items)
end)

RegisterServerEvent("fw-weapons:server:UpdateWeaponAmmo")
AddEventHandler('fw-weapons:server:UpdateWeaponAmmo', function(CurrentWeaponData, amount)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local amount = tonumber(amount)
    if CurrentWeaponData ~= nil then
        if Player.PlayerData.items[CurrentWeaponData.slot] ~= nil then
            Player.PlayerData.items[CurrentWeaponData.slot].info.ammo = amount
        end
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

Framework.Functions.CreateCallback("fw-weapon:server:GetWeaponAmmo", function(source, cb, WeaponData)
    local Player = Framework.Functions.GetPlayer(source)
    local retval = 0
    if WeaponData ~= nil then
        if Player ~= nil then
            local ItemData = Player.Functions.GetItemBySlot(WeaponData.slot)
            if ItemData ~= nil then
                retval = ItemData.info.ammo ~= nil and ItemData.info.ammo or 0
            end
        end
    end
    cb(retval)
end)

Framework.Functions.CreateCallback('fw-weapons:server:RemoveAttachment', function(source, cb, AttachmentData, ItemData)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local Inventory = Player.PlayerData.items
    local AttachmentComponent = Config.WeaponAttachments[ItemData.name:upper()][AttachmentData.attachment]
    if Inventory[ItemData.slot] ~= nil then
        if Inventory[ItemData.slot].info.attachments ~= nil and next(Inventory[ItemData.slot].info.attachments) ~= nil then
            local HasAttach, key = HasAttachment(AttachmentComponent.component, Inventory[ItemData.slot].info.attachments)
            if HasAttach then
                table.remove(Inventory[ItemData.slot].info.attachments, key)
                Player.Functions.SetInventory(Player.PlayerData.items)
                Player.Functions.AddItem(AttachmentComponent.item, 1)
                TriggerClientEvent('fw-inventory:client:ItemBox', src, Framework.Shared.Items[AttachmentComponent.item], "add")
                cb(Inventory[ItemData.slot].info.attachments)
            else
                cb(false)
            end
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

-- // Functions \\ --

function IsWeaponBlocked(WeaponName)
  local retval = false
  for _, name in pairs(Config.DurabilityBlockedWeapons) do
      if name == WeaponName then
          retval = true
          break
      end 
  end
  return retval
end

function HasAttachment(component, attachments)
    local retval = false
    local key = nil
    for k, v in pairs(attachments) do
        if v.component == component then
            key = k
            retval = true
        end
    end
    return retval, key
end

function GetWeaponList(Weapon)
    return Config.WeaponsList[Weapon]
end