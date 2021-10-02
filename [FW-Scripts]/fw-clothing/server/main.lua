Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Commands.Add("skin", "Ooohja toch", {}, false, function(source, args)
	TriggerClientEvent("fw-clothing:client:openMenu", source)
end, "admin")

RegisterServerEvent("fw-clothing:saveSkin")
AddEventHandler('fw-clothing:saveSkin', function(model, skin)
    local Player = Framework.Functions.GetPlayer(source)
    if model ~= nil and skin ~= nil then 
        Framework.Functions.ExecuteSql(false, "DELETE FROM `characters_skins` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function()
          Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_skins` (`citizenid`, `model`, `skin`) VALUES ('"..Player.PlayerData.citizenid.."', '"..model.."', '"..skin.."')")
        end)
    end
end)

RegisterServerEvent("fw-clothing:loadPlayerSkin")
AddEventHandler('fw-clothing:loadPlayerSkin', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_skins` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil then
            TriggerClientEvent("fw-clothing:loadSkin", src, false, result[1].model, result[1].skin)
        else
            TriggerClientEvent("fw-clothing:loadSkin", src, true)
        end
    end)
end)

RegisterServerEvent("fw-clothing:saveOutfit")
AddEventHandler("fw-clothing:saveOutfit", function(outfitName, model, skinData)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    if model ~= nil and skinData ~= nil then
        local outfitId = "outfit-"..math.random(1, 10).."-"..math.random(1111, 9999)
        Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_outfits` (`citizenid`, `outfitname`, `model`, `skin`, `outfitId`) VALUES ('"..Player.PlayerData.citizenid.."', '"..outfitName.."', '"..model.."', '"..json.encode(skinData).."', '"..outfitId.."')", function()
            Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
                if result[1] ~= nil then
                    TriggerClientEvent('fw-clothing:client:reloadOutfits', src, result)
                else
                    TriggerClientEvent('fw-clothing:client:reloadOutfits', src, nil)
                end
            end)
        end)
    end
end)

RegisterServerEvent("fw-clothing:server:removeOutfit")
AddEventHandler("fw-clothing:server:removeOutfit", function(outfitName, outfitId)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)

    Framework.Functions.ExecuteSql(false, "DELETE FROM `characters_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `outfitname` = '"..outfitName.."' AND `outfitId` = '"..outfitId.."'", function()
        Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
            if result[1] ~= nil then
                TriggerClientEvent('fw-clothing:client:reloadOutfits', src, result)
            else
                TriggerClientEvent('fw-clothing:client:reloadOutfits', src, nil)
            end
        end)
    end)
end)

Framework.Functions.CreateCallback('fw-clothing:server:getOutfits', function(source, cb)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local anusVal = {}

    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                result[k].skin = json.decode(result[k].skin)
                anusVal[k] = v
            end
            cb(anusVal)
        end
        cb(anusVal)
    end)
end)

Framework.Commands.Add("helm", "Zet je helm/pet/hoed op of af..", {}, false, function(source, args)
    TriggerClientEvent("fw-clothing:client:adjustfacewear", source, 1) -- Hat
end)

Framework.Commands.Add("bril", "Zet je bril op of af..", {}, false, function(source, args)
	TriggerClientEvent("fw-clothing:client:adjustfacewear", source, 2)
end)

Framework.Commands.Add("masker", "Zet je masker op of af..", {}, false, function(source, args)
	TriggerClientEvent("fw-clothing:client:adjustfacewear", source, 4)
end)