local ClosestVehicle = 1
local inMenu = false
local modelLoaded = true

local fakecar = {model = '', car = nil}

vehshop = {
	opened = false,
	title = "Vehicle Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 250, type = 1 },
	menu = {
		x = 0.14,
		y = 0.15,
		width = 0.12,
		height = 0.03,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.29,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Voertuigen", description = ""},
			}
		},
		["vehicles"] = {
			title = "VEHICLES",
			name = "vehicles",
			buttons = {}
		},	
	}
}

Citizen.CreateThread(function()
    Citizen.Wait(1500)

    for k, v in pairs(vehicleCategorys) do
        table.insert(vehshop.menu["vehicles"].buttons, {
            menu = k,
            name = v.label,
            description = {}
        })

        vehshop.menu[k] = {
            title = k,
            name = v.label,
            buttons = v.vehicles
        }
    end
end)

function isValidMenu(menu)
    local retval = false
    for k, v in pairs(vehshop.menu["vehicles"].buttons) do
        if menu == v.menu then
            retval = true
        end
    end
    return retval
end

function drawMenuButton(button,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0, 0, 0,220)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuInfo(text)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,250)
	DrawText(0.255, 0.254)
end

function drawMenuRight(txt,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.2, 0.2)
	--SetTextRightJustify(1)
	if selected then
		SetTextColour(0,0,0, 255)
	else
		SetTextColour(255, 255, 255, 255)
		
	end
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 + 0.025, y - menu.height/3 + 0.0002)

	if selected then
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,255, 255, 255,250)
	else
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,0, 0, 0,250) 
	end
end

function drawMenuTitle(txt,x,y)
	local menu = vehshop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)

	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,250)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function ButtonSelected(button)
	local ped = GetPlayerPed(-1)
	local this = vehshop.currentmenu
    local btn = button.name

	if this == "main" then
		if btn == "Voertuigen" then
			OpenMenu('vehicles')
		end
	elseif this == "vehicles" then
		if btn == "Sports" then
			OpenMenu('sports')
		elseif btn == "Sedans" then
			OpenMenu('sedans')
		elseif btn == "Compacts" then
			OpenMenu('compacts')
		elseif btn == "Coupes" then
			OpenMenu('coupes')
		elseif btn == "Sports Classics" then
			OpenMenu("sportsclassics")
		elseif btn == "Super" then
			OpenMenu('super')
		elseif btn == "Muscle" then
			OpenMenu('muscle')
		elseif btn == "Offroad" then
			OpenMenu('offroad')
		elseif btn == "SUVs" then
			OpenMenu('suvs')
		elseif btn == "Motoren" then
			OpenMenu('motorcycles')
		elseif btn == "Vans" then
			OpenMenu('vans')
		end
	end
end

function OpenMenu(menu)
    vehshop.lastmenu = vehshop.currentmenu
    fakecar = {model = '', car = nil}
	if menu == "vehicles" then
		vehshop.lastmenu = "main"
	end
	vehshop.menu.from = 1
	vehshop.menu.to = 10
	vehshop.selectedbutton = 0
	vehshop.currentmenu = menu
end

function Back()
	if backlock then
		return
	end
	backlock = true
	if vehshop.currentmenu == "main" then
		CloseCreator()
	elseif isValidMenu(vehshop.currentmenu) then
		if DoesEntityExist(fakecar.car) then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
		end
		fakecar = {model = '', car = nil}
		OpenMenu(vehshop.lastmenu)
	else
		OpenMenu(vehshop.lastmenu)
	end
end

function CloseCreator(name, veh, price, financed)
	Citizen.CreateThread(function()
		local ped = GetPlayerPed(-1)
		vehshop.opened = false
		vehshop.menu.from = 1
        vehshop.menu.to = 10
        QB.ShowroomVehicles2[ClosestVehicle].inUse = false
        TriggerServerEvent('fw-sjperformance:server:setShowroomCarInUse', ClosestVehicle, false)
	end)
end

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
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

function MenuVehicleList()
    ped = GetPlayerPed(-1);
    MenuTitle = "Dealer"
    ClearMenu()
    Menu.addButton("Assortiment Bekijken", "VehicleCategories", nil)
    Menu.addButton("Sluit Menu", "close", nil) 
end

function VehicleCategories()
    ped = GetPlayerPed(-1);
    MenuTitle = "Veh Cats"
    ClearMenu()
    for k, v in pairs(QB.VehicleMenuCategories2) do
        Menu.addButton(QB.VehicleMenuCategories2[k].label, "GetCatVehicles", k)
    end
    
    Menu.addButton("Sluit Menu", "close", nil) 
end

function GetCatVehicles(catergory)
    ped = GetPlayerPed(-1)
    MenuTitle = "Cat Vehs"
    ClearMenu()
    Menu.addButton("Sluit Menu", "close", nil) 
    for k, v in pairs(shopVehicles[catergory]) do
        Menu.addButton(shopVehicles[catergory][k].name, "SelectVehicle", v, catergory, "€"..shopVehicles[catergory][k]["price"])
    end
end

function SelectVehicle(vehicleData)
    TriggerServerEvent('fw-sjperformance:server:setShowroomVehicle', vehicleData, ClosestVehicle)
    close()
end

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    for i = 1, #QB.ShowroomVehicles2, 1 do
        local oldVehicle = GetClosestVehicle(QB.ShowroomVehicles2[i].coords.x, QB.ShowroomVehicles2[i].coords.y, QB.ShowroomVehicles2[i].coords.z, 3.0, 0, 70)
        if oldVehicle ~= 0 then
            Framework.Functions.DeleteVehicle(oldVehicle)
        end

		local model = GetHashKey(QB.ShowroomVehicles2[i].chosenVehicle)
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local veh = CreateVehicle(model, QB.ShowroomVehicles2[i].coords.x, QB.ShowroomVehicles2[i].coords.y, QB.ShowroomVehicles2[i].coords.z, false, false)
		SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)
		SetEntityInvincible(veh,true)
        SetEntityHeading(veh, QB.ShowroomVehicles2[i].coords.h)
        SetVehicleDoorsLocked(veh, 3)

		FreezeEntityPosition(veh,true)
		SetVehicleNumberPlateText(veh, i .. "SJPERF")
    end
end)

function OpenCreator()
	vehshop.currentmenu = "main"
	vehshop.opened = true
    vehshop.selectedbutton = 0
    TriggerServerEvent('fw-sjperformance:server:setShowroomCarInUse', ClosestVehicle, false)
end

function setClosestShowroomVehicle()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil

    for id, veh in pairs(QB.ShowroomVehicles2) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, QB.ShowroomVehicles2[id].coords.x, QB.ShowroomVehicles2[id].coords.y, QB.ShowroomVehicles2[id].coords.z, true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, QB.ShowroomVehicles2[id].coords.x, QB.ShowroomVehicles2[id].coords.y, QB.ShowroomVehicles2[id].coords.z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, QB.ShowroomVehicles2[id].coords.x, QB.ShowroomVehicles2[id].coords.y, QB.ShowroomVehicles2[id].coords.z, true)
            current = id
        end
    end
    if current ~= ClosestVehicle then
        ClosestVehicle = current
    end
end

Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        local shopDist = GetDistanceBetweenCoords(pos, QB.VehicleShops2[1].x, QB.VehicleShops2[1].y, QB.VehicleShops2[1].z, false)
        if isLoggedIn then
            if shopDist <= 50 then
                setClosestShowroomVehicle()
            end
        end
        Citizen.Wait(1000)
    end
end)

local SellStarted = false



Citizen.CreateThread(function()
    Wait(1000)
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local inRange = false
        local SellDistance = GetDistanceBetweenCoords(pos, QB.QuickSell2.x, QB.QuickSell2.y, QB.QuickSell2.z, true)

        if SellDistance < 20 then
            if IsPedInAnyVehicle(ped) then
                local VehicleData = Framework.Shared.VehicleModels[GetEntityModel(GetVehiclePedIsIn(ped))]
                if VehicleData["shop"] == "pdm" then
                    DrawMarker(2, QB.QuickSell2.x, QB.QuickSell2.y, QB.QuickSell2.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 55, 155, 255, 0, 0, 0, 1, 0, 0, 0)
                    inRange = true
                    if SellDistance < 1 then
                        if not SellStarted then
                            DrawText3Ds(QB.QuickSell2.x, QB.QuickSell2.y, QB.QuickSell2.z, '~b~E~w~ - Bán xe ~g~€'..math.ceil(VehicleData["price"] / 100 * 60))
                            if IsControlJustPressed(0, Keys["E"]) then
                                SellStarted = true
                            end
                        else
                            DrawText3Ds(QB.QuickSell2.x, QB.QuickSell2.y, QB.QuickSell2.z, '~b~7~w~ - Xác nhận / ~b~8~w~ - Hủy')
                            if IsControlJustPressed(0, Keys["7"]) or IsDisabledControlJustPressed(0, Keys["7"]) then
                                SellStarted = false
                                Framework.Functions.TriggerCallback('fw-sjperformance:server:SellVehicle', function(SoldVehicle)
                                    if SoldVehicle then
                                        TriggerEvent("fw-phone-new:client:BankNotify", "Bạn nhận được €"..math.ceil(VehicleData["price"] / 100 * 60).." bijgeschreven")
                                        local veh = GetVehiclePedIsIn(ped)
                                        Framework.Functions.DeleteVehicle(veh)
                                    else
                                        Framework.Functions.Notify('Đây không phải xe của bạn..', 'error')
                                    end
                                end, GetEntityModel(GetVehiclePedIsIn(ped)), GetVehicleNumberPlateText(GetVehiclePedIsIn(ped)))
                            end

                            if IsControlJustPressed(0, Keys["8"]) or IsDisabledControlJustPressed(0, Keys["8"]) then
                                SellStarted = false
                            end
                        end
                    else
                        if SellStarted then
                            SellStarted = false
                        end
                    end
                end
            end
        end

        if not inRange then
            Citizen.Wait(1000)
        end

        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local dist = GetDistanceBetweenCoords(pos, QB.ShowroomVehicles2[ClosestVehicle].coords.x, QB.ShowroomVehicles2[ClosestVehicle].coords.y, QB.ShowroomVehicles2[ClosestVehicle].coords.z)

        if ClosestVehicle ~= nil then
            if dist < 1.5 then
                if not QB.ShowroomVehicles2[ClosestVehicle].inUse then
                    local vehicleHash = GetHashKey(QB.ShowroomVehicles2[ClosestVehicle].chosenVehicle)
                    local displayName = Framework.Shared.Vehicles[QB.ShowroomVehicles2[ClosestVehicle].chosenVehicle]["name"]
                    local vehPrice = Framework.Shared.Vehicles[QB.ShowroomVehicles2[ClosestVehicle].chosenVehicle]["price"]

                    if not QB.ShowroomVehicles2[ClosestVehicle].inUse then
                        if not vehshop.opened then
                            if not buySure then
                                DrawText3Ds(QB.ShowroomVehicles2[ClosestVehicle].coords.x, QB.ShowroomVehicles2[ClosestVehicle].coords.y, QB.ShowroomVehicles2[ClosestVehicle].coords.z + 1.8, '~g~G~w~ - Verander voertuig (~g~'..displayName..'~w~)')
                            end
                            if not buySure then
                                DrawText3Ds(QB.ShowroomVehicles2[ClosestVehicle].coords.x, QB.ShowroomVehicles2[ClosestVehicle].coords.y, QB.ShowroomVehicles2[ClosestVehicle].coords.z + 1.70, '~g~E~w~ - Koop voertuig (~g~€'..vehPrice..'~w~)')
                            elseif buySure then
                                DrawText3Ds(QB.ShowroomVehicles2[ClosestVehicle].coords.x, QB.ShowroomVehicles2[ClosestVehicle].coords.y, QB.ShowroomVehicles2[ClosestVehicle].coords.z + 1.65, 'Weet je het zeker? | ~g~[7]~w~ Ja -/- ~r~[8]~w~ Nee')
                            end
                        elseif vehshop.opened then
                            if modelLoaded then
                                DrawText3Ds(QB.ShowroomVehicles2[ClosestVehicle].coords.x, QB.ShowroomVehicles2[ClosestVehicle].coords.y, QB.ShowroomVehicles2[ClosestVehicle].coords.z + 1.65, 'Voertuig aan het kiezen')
                            else
                                DrawText3Ds(QB.ShowroomVehicles2[ClosestVehicle].coords.x, QB.ShowroomVehicles2[ClosestVehicle].coords.y, QB.ShowroomVehicles2[ClosestVehicle].coords.z + 1.65, 'Voertuig wordt opgehaald..')
                            end
                        end
                    else
                        DrawText3Ds(QB.ShowroomVehicles2[ClosestVehicle].coords.x, QB.ShowroomVehicles2[ClosestVehicle].coords.y, QB.ShowroomVehicles2[ClosestVehicle].coords.z + 1.65, 'Voertuig is in gebruik door een klant...')
                    end

                    if not vehshop.opened then
                        if IsControlJustPressed(0, Keys["G"]) then
                            if vehshop.opened then
                                CloseCreator()
                            else
                                OpenCreator()
                            end
                        end
                    end

                    if vehshop.opened then

                        local ped = GetPlayerPed(-1)
                        local menu = vehshop.menu[vehshop.currentmenu]
                        local y = vehshop.menu.y + 0.12
                        buttoncount = tablelength(menu.buttons)
                        local selected = false

                        for i,button in pairs(menu.buttons) do
                            if i >= vehshop.menu.from and i <= vehshop.menu.to then

                                if i == vehshop.selectedbutton then
                                    selected = true
                                else
                                    selected = false
                                end
                                drawMenuButton(button,vehshop.menu.x,y,selected)
                                if button.price ~= nil then

                                    drawMenuRight("€"..button.price,vehshop.menu.x,y,selected)

                                end
                                y = y + 0.04
                                if isValidMenu(vehshop.currentmenu) then
                                    if selected then
                                        if IsControlJustPressed(1, 18) then
                                            if modelLoaded then
                                                TriggerServerEvent('fw-sjperformance:server:setShowroomVehicle', button.model, ClosestVehicle)
                                            end
                                        end
                                    end
                                end
                                if selected and ( IsControlJustPressed(1,38) or IsControlJustPressed(1, 18) ) then
                                    ButtonSelected(button)
                                end
                            end
                        end
                    end

                    if vehshop.opened then
                        if IsControlJustPressed(1,202) then
                            Back()
                        end
                        if IsControlJustReleased(1,202) then
                            backlock = false
                        end
                        if IsControlJustPressed(1,188) then
                            if modelLoaded then
                                if vehshop.selectedbutton > 1 then
                                    vehshop.selectedbutton = vehshop.selectedbutton -1
                                    if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
                                        vehshop.menu.from = vehshop.menu.from -1
                                        vehshop.menu.to = vehshop.menu.to - 1
                                    end
                                end
                            end
                        end
                        if IsControlJustPressed(1,187)then
                            if modelLoaded then
                                if vehshop.selectedbutton < buttoncount then
                                    vehshop.selectedbutton = vehshop.selectedbutton +1
                                    if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
                                        vehshop.menu.to = vehshop.menu.to + 1
                                        vehshop.menu.from = vehshop.menu.from + 1
                                    end
                                end
                            end
                        end
                    end

                    if GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) ~= nil and GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) ~= 0 then
                        ClearPedTasksImmediately(GetPlayerPed(-1))
                    end

                    if IsControlJustPressed(0, Keys["E"]) then
                        if not vehshop.opened then
                            if not buySure then
                                buySure = true
                            end
                        end
                    end

                    if IsDisabledControlJustPressed(0, Keys["7"]) then
                        if buySure then
                            local class = Framework.Shared.Vehicles[QB.ShowroomVehicles2[ClosestVehicle].chosenVehicle]["category"]
                            TriggerServerEvent('fw-sjperformance:server:buyShowroomVehicle', QB.ShowroomVehicles2[ClosestVehicle].chosenVehicle, class)
                            buySure = false
                        end
                    end
                    if IsDisabledControlJustPressed(0, Keys["8"]) then
                        Framework.Functions.Notify('Bạn đã hủy giao dịch', 'error', 3500)
                        buySure = false
                    end
                    DisableControlAction(0, Keys["7"], true)
                    DisableControlAction(0, Keys["8"], true)
                elseif QB.ShowroomVehicles[ClosestVehicle].inUse then
                    DrawText3Ds(QB.ShowroomVehicles[ClosestVehicle].coords.x, QB.ShowroomVehicles2[ClosestVehicle].coords.y, QB.ShowroomVehicles2[ClosestVehicle].coords.z + 0.5, 'Voertuig is in gebruik')
                end
            elseif dist > 1.5 then
                if vehshop.opened then
                    CloseCreator()
                end
            end
        end

        Citizen.Wait(3)
    end
end)

RegisterNetEvent('fw-sjperformance:client:setShowroomCarInUse')
AddEventHandler('fw-sjperformance:client:setShowroomCarInUse', function(showroomVehicle, inUse)
    QB.ShowroomVehicles[showroomVehicle].inUse = inUse
end)

RegisterNetEvent('fw-sjperformance:client:setShowroomVehicle')
AddEventHandler('fw-sjperformance:client:setShowroomVehicle', function(showroomVehicle, k)
    if QB.ShowroomVehicles[k].chosenVehicle ~= showroomVehicle then
        Framework.Functions.DeleteVehicle(GetClosestVehicle(QB.ShowroomVehicles2[k].coords.x, QB.ShowroomVehicles2[k].coords.y, QB.ShowroomVehicles2[k].coords.z, 3.0, 0, 70))
        modelLoaded = false
        Wait(250)
        local model = GetHashKey(showroomVehicle)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(250)
        end
        local veh = CreateVehicle(model, QB.ShowroomVehicles2[k].coords.x, QB.ShowroomVehicles2[k].coords.y, QB.ShowroomVehicles2[k].coords.z, false, false)
        SetModelAsNoLongerNeeded(model)
        SetVehicleOnGroundProperly(veh)
        SetEntityInvincible(veh,true)
        SetEntityHeading(veh, QB.ShowroomVehicles2[k].coords.h)
        SetVehicleDoorsLocked(veh, 3)
        FreezeEntityPosition(veh, true)
        SetVehicleNumberPlateText(veh, k .. "CARSALE")
        modelLoaded = true
        QB.ShowroomVehicles2[k].chosenVehicle = showroomVehicle
    end
end)

RegisterNetEvent('fw-sjperformance:client:buyShowroomVehicle')
AddEventHandler('fw-sjperformance:client:buyShowroomVehicle', function(vehicle, plate)
    Framework.Functions.SpawnVehicle(vehicle, function(veh)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        exports['LegacyFuel']:SetFuel(veh, 100)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, QB.DefaultBuySpawn2.h)
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        TriggerServerEvent("vehicletuning:server:SaveVehicleProps", Framework.Functions.GetVehicleProperties(veh))
        SetEntityAsMissionEntity(veh, true, true)
    end, QB.DefaultBuySpawn2, false)
end)