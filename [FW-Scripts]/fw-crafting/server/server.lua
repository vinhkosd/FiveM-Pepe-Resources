Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Citizen.CreateThread(function()
    Config.Locations = {['X'] = -1108.57, ['Y'] = -1643.51, ['Z'] = 4.64}
end)

Framework.Functions.CreateCallback("fw-crafting:server:get:config", function(source, cb)
    cb(Config.Locations)
end)

function GetCraftingConfig(ItemId)
    return Config.CraftingItems[ItemId]
end

function GetWeaponCraftingConfig(ItemId)
    return Config.CraftingWeapons[ItemId]
end