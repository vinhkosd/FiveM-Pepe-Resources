local NearAction = false
local Cooking = false
local MethCrafting = {['X'] = 1015.04, ['Y'] = -3194.87, ['Z'] = -38.99}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearAction = false
            if InsideLab and Config.Labs[CurrentLab]['Name'] == 'Methlab' then
                local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Labs[CurrentLab]['Coords']['Action']['X'], Config.Labs[CurrentLab]['Coords']['Action']['Y'], Config.Labs[CurrentLab]['Coords']['Action']['Z'], true)
                if Distance < 2.0 then
                    NearAction = true
                    if not Config.Labs[CurrentLab]['Cooking'] then
                       DrawText3D(Config.Labs[CurrentLab]['Coords']['Action']['X'], Config.Labs[CurrentLab]['Coords']['Action']['Y'], Config.Labs[CurrentLab]['Coords']['Action']['Z'] + 0.1, '~g~E~s~ - Actie')
                       DrawText3D(Config.Labs[CurrentLab]['Coords']['Action']['X'], Config.Labs[CurrentLab]['Coords']['Action']['Y'], Config.Labs[CurrentLab]['Coords']['Action']['Z'] + 0.3, '~g~Ingredienten nodig:~s~ '..Config.Labs[CurrentLab]['Ingredient-Count']..'/2')
                       DrawMarker(2, Config.Labs[CurrentLab]['Coords']['Action']['X'], Config.Labs[CurrentLab]['Coords']['Action']['Y'], Config.Labs[CurrentLab]['Coords']['Action']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 82, 186, 34, 255, false, false, false, 1, false, false, false)
                       if IsControlJustReleased(0, 38) then
                         AddIngredient()
                       end
                    else
                        if Config.CookTimer > 0 then
                            DrawText3D(Config.Labs[CurrentLab]['Coords']['Action']['X'], Config.Labs[CurrentLab]['Coords']['Action']['Y'], Config.Labs[CurrentLab]['Coords']['Action']['Z'] + 0.1, '~p~Meth~s~ aan het koken..')
                            DrawText3D(Config.Labs[CurrentLab]['Coords']['Action']['X'], Config.Labs[CurrentLab]['Coords']['Action']['Y'], Config.Labs[CurrentLab]['Coords']['Action']['Z'] + 0.2, '~r~'..Config.CookTimer..'~s~ Seconden..')
                            DrawMarker(2, Config.Labs[CurrentLab]['Coords']['Action']['X'], Config.Labs[CurrentLab]['Coords']['Action']['Y'], Config.Labs[CurrentLab]['Coords']['Action']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 207, 140, 39, 255, false, false, false, 1, false, false, false)
                        else
                            DrawText3D(Config.Labs[CurrentLab]['Coords']['Action']['X'], Config.Labs[CurrentLab]['Coords']['Action']['Y'], Config.Labs[CurrentLab]['Coords']['Action']['Z'] + 0.1, '~g~E~s~ - Poeder Verzamelen')
                            DrawMarker(2, Config.Labs[CurrentLab]['Coords']['Action']['X'], Config.Labs[CurrentLab]['Coords']['Action']['Y'], Config.Labs[CurrentLab]['Coords']['Action']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 83, 184, 46, 255, false, false, false, 1, false, false, false)
                            if IsControlJustReleased(0, 38) then
                                GetMeth()
                             end
                        end
                    end
                end
                if not NearAction then
                    Citizen.Wait(1500)
                end
            else
                Citizen.Wait(1000)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if InsideLab and Config.Labs[CurrentLab]['Name'] == 'Methlab' then
                local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, MethCrafting['X'], MethCrafting['Y'], MethCrafting['Z'], true)
                NearCraft = false
                if Distance < 1.2 then
                    NearCraft = true
                    DrawText3D(MethCrafting['X'], MethCrafting['Y'], MethCrafting['Z'] + 0.1, '~g~E~s~ - Verpakken')
                    DrawMarker(2, MethCrafting['X'], MethCrafting['Y'], MethCrafting['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                    if IsControlJustReleased(0, 38) then
                        local MethCrafting = {}
		    			MethCrafting.label = "Verpakken"
		    			MethCrafting.items = GetMethCraftingItems()
                        TriggerServerEvent('fw-inventory:server:set:inventory:disabled', true)
		    			TriggerServerEvent("fw-inventory:server:OpenInventory", "methcrafting", math.random(1, 99), MethCrafting)
                    end
                end
                if not NearCraft then
                    Citizen.Wait(1500)
                end
            end
        end
    end
end)

RegisterNetEvent('fw-illegal:client:start:cooking')
AddEventHandler('fw-illegal:client:start:cooking', function()
    Cooking = true
    while Cooking do
        Citizen.Wait(0)
        if Config.CookTimer > 0 then
          Config.CookTimer = Config.CookTimer - 1
        end
        if Config.CookTimer == 0 then
            local Random = math.random(1, 100)
            if Random <= Config.ExplosionChance then
                if CurrentLab ~= nil then
                    TriggerServerEvent('fw-illegal:server:reset:meth', CurrentLab)
                    ExplosionMethFail()
                end
            end
            Cooking = false
        end
        Citizen.Wait(1000)
    end
end)

RegisterNetEvent('fw-illegal:client:sync:meth')
AddEventHandler('fw-illegal:client:sync:meth', function(ConfigData, LabId, Reset)
    Config.Labs[LabId] = ConfigData
    if Reset then
        Config.CookTimer = 250
    end
end)

function AddIngredient()
    if not Config.Labs[CurrentLab]['Ingredients']['meth-ingredient-1'] then
        Framework.Functions.TriggerCallback('Framework:HasItem', function(HasItem)
            if HasItem then
                TriggerServerEvent('Framework:Server:RemoveItem', 'meth-ingredient-1', 1)
                TriggerEvent("fw-inventory:client:ItemBox", Framework.Shared.Items['meth-ingredient-1'], "remove")
                TriggerServerEvent('fw-illegal:server:add:ingredient', CurrentLab, 'meth-ingredient-1', true, 1)
            else
                Framework.Functions.Notify('Je mist iets..', 'error')
            end
        end, "meth-ingredient-1")
    elseif not Config.Labs[CurrentLab]['Ingredients']['meth-ingredient-2'] then
        Framework.Functions.TriggerCallback('Framework:HasItem', function(HasItem)
            if HasItem then
                TriggerServerEvent('Framework:Server:RemoveItem', 'meth-ingredient-2', 1)
                TriggerEvent("fw-inventory:client:ItemBox", Framework.Shared.Items['meth-ingredient-2'], "remove")
                TriggerServerEvent('fw-illegal:server:add:ingredient', CurrentLab, 'meth-ingredient-2', true, 1)
            else
                Framework.Functions.Notify('Je mist iets..', 'error')
            end
        end, "meth-ingredient-2")
    end
end

function ExplosionMethFail()
    local Time = 3
    repeat
        Time = Time - 1
        AddExplosion(Config.Labs[CurrentLab]['Coords']['Action']['X'], Config.Labs[CurrentLab]['Coords']['Action']['Y'], Config.Labs[CurrentLab]['Coords']['Action']['Z'], EXPLOSION_CAR, 4.0, true, false, 20.0)
        Citizen.Wait(5000)
    until Time == 0
end

function GetMethCraftingItems()
 local items = {}
 SetupMethCrafting()
 for k, item in pairs(Config.MethCrafting) do
     items[k] = Config.MethCrafting[k]
 end
 return items
end
  
function SetupMethCrafting()
 local items = {}
 for k, item in pairs(Config.MethCrafting) do
     local itemInfo = Framework.Shared.Items[item.name:lower()]
     items[item.slot] = {
      name = itemInfo["name"],
      amount = tonumber(item.amount),
      info = item.info,
      label = itemInfo["label"],
      description = item.description,
      weight = itemInfo["weight"], 
      type = itemInfo["type"], 
      unique = itemInfo["unique"], 
      useable = itemInfo["useable"], 
      image = itemInfo["image"],
      slot = item.slot,
      costs = item.costs,
     }
 end
 Config.MethCrafting = items
end

function GetMeth()
    TriggerServerEvent('fw-illegal:server:get:meth', math.random(25, 30), CurrentLab)
end