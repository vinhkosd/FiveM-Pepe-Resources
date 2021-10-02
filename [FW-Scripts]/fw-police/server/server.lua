Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

local Casings = {}
local HairDrops = {}
local BloodDrops = {}
local SlimeDrops = {}
local FingerDrops = {}
local PlayerStatus = {}
local Objects = {}

RegisterServerEvent('fw-police:server:UpdateBlips')
AddEventHandler('fw-police:server:UpdateBlips', function()
    local src = source
    local dutyPlayers = {}
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then 
            if ((Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty) then
                table.insert(dutyPlayers, {
                    source = Player.PlayerData.source,
                    label = Player.PlayerData.metadata["callsign"]..' | '..Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname,
                    job = Player.PlayerData.job.name,
                })
            end
        end
    end
    TriggerClientEvent("fw-police:client:UpdateBlips", -1, dutyPlayers)
end)

-- // Loops \\ --

Citizen.CreateThread(function()
  while true do 
    Citizen.Wait(0)
    local CurrentCops = GetCurrentCops()
    TriggerClientEvent("fw-police:SetCopCount", -1, CurrentCops)
    Citizen.Wait(1000 * 60 * 3)
  end
end)

-- // Functions \\ --

function GetCurrentCops()
    local amount = 0
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    return amount
end

-- // Evidence Events \\ --

RegisterServerEvent('fw-police:server:CreateCasing')
AddEventHandler('fw-police:server:CreateCasing', function(weapon, coords)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local casingId = CreateIdType('casing')
    local weaponInfo = exports['fw-weapons']:GetWeaponList(weapon)
    local serieNumber = nil
    if weaponInfo ~= nil then 
        local weaponItem = Player.Functions.GetItemByName(weaponInfo["IdName"])
        if weaponItem ~= nil then
            if weaponItem.info ~= nil and weaponItem.info ~= "" then 
                serieNumber = weaponItem.info.serie
            end
        end
    end
    TriggerClientEvent("fw-police:client:AddCasing", -1, casingId, weapon, coords, serieNumber)
end)

RegisterServerEvent('fw-police:server:CreateBloodDrop')
AddEventHandler('fw-police:server:CreateBloodDrop', function(coords)
 local src = source
 local Player = Framework.Functions.GetPlayer(src)
 local bloodId = CreateIdType('blood')
 BloodDrops[bloodId] = Player.PlayerData.metadata["bloodtype"]
 TriggerClientEvent("fw-police:client:AddBlooddrop", -1, bloodId, Player.PlayerData.metadata["bloodtype"], coords)
end)

RegisterServerEvent('fw-police:server:CreateFingerDrop')
AddEventHandler('fw-police:server:CreateFingerDrop', function(coords)
 local src = source
 local Player = Framework.Functions.GetPlayer(src)
 local fingerId = CreateIdType('finger')
 FingerDrops[fingerId] = Player.PlayerData.metadata["fingerprint"]
 TriggerClientEvent("fw-police:client:AddFingerPrint", -1, fingerId, Player.PlayerData.metadata["fingerprint"], coords)
end)

RegisterServerEvent('fw-police:server:CreateHairDrop')
AddEventHandler('fw-police:server:CreateHairDrop', function(coords)
 local src = source
 local Player = Framework.Functions.GetPlayer(src)
 local HairId = CreateIdType('hair')
 HairDrops[HairId] = Player.PlayerData.metadata["haircode"]
 TriggerClientEvent("fw-police:client:AddHair", -1, HairId, Player.PlayerData.metadata["haircode"], coords)
end)

RegisterServerEvent('fw-police:server:CreateSlimeDrop')
AddEventHandler('fw-police:server:CreateSlimeDrop', function(coords)
 local src = source
 local Player = Framework.Functions.GetPlayer(src)
 local SlimeId = CreateIdType('slime')
 SlimeDrops[SlimeId] = Player.PlayerData.metadata["slimecode"]
 TriggerClientEvent("fw-police:client:AddSlime", -1, SlimeId, Player.PlayerData.metadata["slimecode"], coords)
end)

RegisterServerEvent('fw-police:server:AddEvidenceToInventory')
AddEventHandler('fw-police:server:AddEvidenceToInventory', function(EvidenceType, EvidenceId, EvidenceInfo)
 local src = source
 local Player = Framework.Functions.GetPlayer(src)
 if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
    if Player.Functions.AddItem("filled_evidence_bag", 1, false, EvidenceInfo) then
        RemoveDna(EvidenceType, EvidenceId)
        TriggerClientEvent("fw-police:client:RemoveDnaId", -1, EvidenceType, EvidenceId)
        TriggerClientEvent("fw-inventory:client:ItemBox", src, Framework.Shared.Items["filled_evidence_bag"], "add")
    end
 else
    TriggerClientEvent('Framework:Notify', src, "Je moet een leeg bewijszakje bij je hebben", "error")
 end
end)

-- // Finger Scanner \\ --

RegisterServerEvent('fw-police:server:show:machine')
AddEventHandler('fw-police:server:show:machine', function(PlayerId)
    local Player = Framework.Functions.GetPlayer(PlayerId)
    TriggerClientEvent('fw-police:client:show:machine', PlayerId, source)
    TriggerClientEvent('fw-police:client:show:machine', source, PlayerId)
end)

RegisterServerEvent('fw-police:server:showFingerId')
AddEventHandler('fw-police:server:showFingerId', function(FingerPrintSession)
 local Player = Framework.Functions.GetPlayer(source)
 local FingerId = Player.PlayerData.metadata["fingerprint"] 
 if math.random(1,25)  <= 15 then
 TriggerClientEvent('fw-police:client:show:fingerprint:id', FingerPrintSession, FingerId)
 TriggerClientEvent('fw-police:client:show:fingerprint:id', source, FingerId)
 end
end)

RegisterServerEvent('fw-police:server:set:tracker')
AddEventHandler('fw-police:server:set:tracker', function(TargetId)
    local Target = Framework.Functions.GetPlayer(TargetId)
    local TrackerMeta = Target.PlayerData.metadata["tracker"]
    if TrackerMeta then
        Target.Functions.SetMetaData("tracker", false)
        TriggerClientEvent('Framework:Notify', TargetId, 'Je enkelband is afgedaan.', 'error', 5000)
        TriggerClientEvent('Framework:Notify', source, 'Je hebt een enkelband afgedaan van '..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('fw-police:client:set:tracker', TargetId, false)
    else
        Target.Functions.SetMetaData("tracker", true)
        TriggerClientEvent('Framework:Notify', TargetId, 'Je hebt een enkelband omgekregen.', 'error', 5000)
        TriggerClientEvent('Framework:Notify', source, 'Je hebt een enkelband omgedaan bij '..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('fw-police:client:set:tracker', TargetId, true)
    end
end)

RegisterServerEvent('fw-police:server:send:tracker:location')
AddEventHandler('fw-police:server:send:tracker:location', function(Coords, RequestId)
    local Target = Framework.Functions.GetPlayer(RequestId)
    local AlertData = {title = "Enkelband Locatie", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "De enkelband locatie van: "..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname}
    TriggerClientEvent("fw-phone:client:addPoliceAlert", -1, AlertData)
    TriggerClientEvent('fw-police:client:send:tracker:alert', -1, Coords, Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname)
end)

-- // Update Cops \\ --
RegisterServerEvent('fw-police:server:UpdateCurrentCops')
AddEventHandler('fw-police:server:UpdateCurrentCops', function()
    local amount = 0
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    TriggerClientEvent("fw-police:SetCopCount", -1, amount)
end)

RegisterServerEvent('fw-police:server:UpdateStatus')
AddEventHandler('fw-police:server:UpdateStatus', function(data)
    local src = source
    PlayerStatus[src] = data
end)

RegisterServerEvent('fw-police:server:ClearDrops')
AddEventHandler('fw-police:server:ClearDrops', function(Type, List)
    local src = source
    if Type == 'casing' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("fw-police:client:RemoveDnaId", -1, 'casing', v)
                Casings[v] = nil
            end
        end
    elseif Type == 'finger' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("fw-police:client:RemoveDnaId", -1, 'finger', v)
                FingerDrops[v] = nil
            end
        end
    elseif Type == 'blood' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("fw-police:client:RemoveDnaId", -1, 'blood', v)
                BloodDrops[v] = nil
            end
        end
    elseif Type == 'Hair' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("fw-police:client:RemoveDnaId", -1, 'hair', v)
                HairDrops[v] = nil
            end
        end
    elseif Type == 'Slime' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("fw-police:client:RemoveDnaId", -1, 'slime', v)
                HairDrops[v] = nil
            end
        end
    end
end)

function RemoveDna(EvidenceType, EvidenceId)
 if EvidenceType == 'hair' then
     HairDrops[EvidenceId] = nil
 elseif EvidenceType == 'blood' then
     BloodDrops[EvidenceId] = nil
 elseif EvidenceType == 'finger' then
     FingerDrops[EvidenceId] = nil
 elseif EvidenceType == 'slime' then
     SlimeDrops[EvidenceId] = nil
 elseif EvidenceType == 'casing' then
     Casings[EvidenceId] = nil
 end
end

-- // Functions \\ --

function CreateIdType(Type)
    if Type == 'casing' then
        if Casings ~= nil then
	    	local caseId = math.random(10000, 99999)
	    	while Casings[caseId] ~= nil do
	    		caseId = math.random(10000, 99999)
	    	end
	    	return caseId
	    else
	    	local caseId = math.random(10000, 99999)
	    	return caseId
        end
    elseif Type == 'finger' then
        if FingerDrops ~= nil then
            local fingerId = math.random(10000, 99999)
            while FingerDrops[fingerId] ~= nil do
                fingerId = math.random(10000, 99999)
            end
            return fingerId
        else
            local fingerId = math.random(10000, 99999)
            return fingerId
        end
    elseif Type == 'blood' then
        if BloodDrops ~= nil then
            local bloodId = math.random(10000, 99999)
            while BloodDrops[bloodId] ~= nil do
                bloodId = math.random(10000, 99999)
            end
            return bloodId
        else
            local bloodId = math.random(10000, 99999)
            return bloodId
        end
    elseif Type == 'hair' then
        if HairDrops ~= nil then
            local hairId = math.random(10000, 99999)
            while HairDrops[hairId] ~= nil do
                hairId = math.random(10000, 99999)
            end
            return hairId
        else
            local hairId = math.random(10000, 99999)
            return hairId
        end
    elseif Type == 'slime' then
        if SlimeDrops ~= nil then
            local slimeId = math.random(10000, 99999)
            while SlimeDrops[slimeId] ~= nil do
                slimeId = math.random(10000, 99999)
            end
            return slimeId
        else
            local slimeId = math.random(10000, 99999)
            return slimeId
        end
   end
end

-- // Commands \\ --

Framework.Commands.Add("cuff", "toggle handboeien (Admin)", {{name="ID", help="PlayerId"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if args ~= nil then
     local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
       if TargetPlayer ~= nil then
         TriggerClientEvent("fw-police:client:get:cuffed", TargetPlayer.PlayerData.source, Player.PlayerData.source)
       end
    end
end, "admin")

Framework.Commands.Add("sethighcommand", "Zet iemand zijn high command status", {{name="ID", help="PlayerId"}, {name="Status", help="True/False"}}, true, function(source, args)
  if args ~= nil then
    local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    if TargetPlayer ~= nil then
      if args[2]:lower() == 'true' then
          TargetPlayer.Functions.SetMetaData("ishighcommand", true)
          TriggerClientEvent('Framework:Notify', TargetPlayer.PlayerData.source, 'Je bent nu een leiding gevende!', 'success')
          TriggerClientEvent('Framework:Notify', source, 'Speler is nu een leiding gevende!', 'success')
      else
          TargetPlayer.Functions.SetMetaData("ishighcommand", false)
          TriggerClientEvent('Framework:Notify', TargetPlayer.PlayerData.source, 'Je bent geen leiding gevende meer!', 'error')
          TriggerClientEvent('Framework:Notify', source, 'Speler is GEEN leiding gevende meer!', 'error')
      end
    end
  end
end, "god")

Framework.Commands.Add("setpolice", "Neem neen agent aan", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
      if TargetPlayer ~= nil then
          TriggerClientEvent('Framework:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen als agent! gefeliciteerd!', 'success')
          TriggerClientEvent('Framework:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' aangenomen als agent!', 'success')
          TargetPlayer.Functions.SetJob('police')
      end
    end
end)

Framework.Commands.Add("firepolice", "Ontsla een agent", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
      if TargetPlayer ~= nil then
          TriggerClientEvent('Framework:Notify', TargetPlayer.PlayerData.source, 'Je bent ontslagen!', 'error')
          TriggerClientEvent('Framework:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' ontslagen!', 'success')
          TargetPlayer.Functions.SetJob('unemployed')
      end
    end
end)

Framework.Commands.Add("callsign", "Verander je dienstnummer", {{name="Nummer", help="Dienstnummer"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if args[1] ~= nil then
        if Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'ambulance' and Player.PlayerData.job.onduty then
         Player.Functions.SetMetaData("callsign", args[1])
         TriggerClientEvent('Framework:Notify', source, 'Dienstnummer succesvol aangepast. U bent nu de: ' ..args[1], 'success')
        else
            TriggerClientEvent('Framework:Notify', source, 'Dit is alleen voor hulp diensten..', 'error')
        end
    end
end)

Framework.Commands.Add("setplate", "Verander je dienst kenteken", {{name="Nummer", help="Dienstnummer"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if args[1] ~= nil then
        if Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'ambulance' and Player.PlayerData.job.onduty then
           if args[1]:len() == 8 then
             Player.Functions.SetDutyPlate(args[1])
             TriggerClientEvent('Framework:Notify', source, 'Kenteken succesvol aangepast. U dienst kenteken is nu: ' ..args[1], 'success')
           else
               TriggerClientEvent('Framework:Notify', source, 'Het moet exact 8 karakters lang zijn..', 'error')
           end
        else
            TriggerClientEvent('Framework:Notify', source, 'Dit is alleen voor hulp diensten..', 'error')
        end
    end
end)

Framework.Commands.Add("kluis", "Open bewijs kluis", {{"bsn", "BSN Nummer"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if args[1] ~= nil then 
    if ((Player.PlayerData.job.name == "police") and Player.PlayerData.job.onduty) then
        TriggerClientEvent("fw-police:client:open:evidence", source, args[1])
    else
        TriggerClientEvent('Framework:Notify', source, "Je moet een hulpdienst zijn hiervoor..", "error")
    end
  else
    TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je moet alle argumenten invoeren.")
 end
end)

Framework.Commands.Add("setdutyvehicle", "Geef een werk voertuig aan een werknemer", {{name="Id", help="Werknemer Server ID"}, {name="Vehicle", help="Standaard / Audi / Heli / Motor / Unmarked"}, {name="state", help="True / False"}}, true, function(source, args)
    local SelfPlayerData = Framework.Functions.GetPlayer(source)
    local TargetPlayerData = Framework.Functions.GetPlayer(tonumber(args[1]))
    if TargetPlayerData ~= nil then
        local TargetPlayerVehicleData = TargetPlayerData.PlayerData.metadata['duty-vehicles']
        if SelfPlayerData.PlayerData.metadata['ishighcommand'] then
           if args[2]:upper() == 'STANDAARD' then
               if args[3] == 'true' then
                   VehicleList = {Standard = true, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked}
               else
                   VehicleList = {Standard = false, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked}
               end
           elseif args[2]:upper() == 'AUDI' then
               if args[3] == 'true' then
                   VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = true, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked}
               else
                   VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = false, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked}
               end
           elseif args[2]:upper() == 'UNMARKED' then
               if args[3] == 'true' then
                   VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = true}
               else
                   VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = false}
               end 
            elseif args[2]:upper() == 'MOTOR' then
                if args[3] == 'true' then
                    VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = true, Unmarked = TargetPlayerVehicleData.Unmarked}
                else
                    VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = false, Unmarked = TargetPlayerVehicleData.Unmarked}
                end 
           elseif args[2]:upper() == 'HELI' then
               if args[3] == 'true' then
                   VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = true, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked}
               else
                   VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = false, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked}
               end 
           end
           local PlayerCredentials = TargetPlayerData.PlayerData.metadata['callsign']..' | '..TargetPlayerData.PlayerData.charinfo.firstname..' '..TargetPlayerData.PlayerData.charinfo.lastname
           TargetPlayerData.Functions.SetMetaData("duty-vehicles", VehicleList)
           TriggerClientEvent('fw-radialmenu:client:update:duty:vehicles', TargetPlayerData.PlayerData.source)
           if args[3] == 'true' then
               TriggerClientEvent('Framework:Notify', TargetPlayerData.PlayerData.source, 'Je hebt een voertuig specialisatie ontvangen ('..args[2]:upper()..')', 'success')
               TriggerClientEvent('Framework:Notify', SelfPlayerData.PlayerData.source, 'Je hebt succesvol de voertuig specialisatie ('..args[2]:upper()..') gegeven aan '..PlayerCredentials, 'success')
           else
               TriggerClientEvent('Framework:Notify', TargetPlayerData.PlayerData.source, 'Je ('..args[2]:upper()..') specialisatie is afgenomen nerd..', 'error')
               TriggerClientEvent('Framework:Notify', SelfPlayerData.PlayerData.source, 'Je hebt succesvol de voertuig specialisatie ('..args[2]:upper()..') afgenomen van '..PlayerCredentials, 'error')
           end
        end
    end
end)

Framework.Commands.Add("bill", "Factuur uitschrijven", {{name="id", help="Speler ID"},{name="geld", help="Hoeveel"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    local TargetPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    local Amount = tonumber(args[2])
    if TargetPlayer ~= nil then
       if Player.PlayerData.job.name == "police" then
         if Amount > 0 then
          TriggerClientEvent("fw-police:client:bill:player", TargetPlayer.PlayerData.source, Amount)
	   	  TriggerEvent('fw-phone:server:add:invoice', TargetPlayer.PlayerData.citizenid, Amount, 'Politie', 'invoice')  
         else
             TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Het bedrag moet hoger zijn dan 0")
         end
       elseif Player.PlayerData.job.name == "realestate" then
        if Amount > 0 then
               TriggerEvent('fw-phone:server:add:invoice', TargetPlayer.PlayerData.citizenid, Amount, 'Makelaar', 'realestate')  
           else
               TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Het bedrag moet hoger zijn dan 0")
           end
       else
           TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
       end
    end
end)

Framework.Commands.Add("paylaw", "Betaal een advocaat", {{name="id", help="ID van een speler"}, {name="amount", help="Hoeveel?"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "judge" then
        local playerId = tonumber(args[1])
        local Amount = tonumber(args[2])
        local OtherPlayer = Framework.Functions.GetPlayer(playerId)
        if OtherPlayer ~= nil then
            if OtherPlayer.PlayerData.job.name == "lawyer" then
                OtherPlayer.Functions.AddMoney("bank", Amount, "police-lawyer-paid")
                TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "SYSTEM", "warning", "Je hebt €"..Amount..",- ontvangen voor je gegeven diensten!")
                TriggerClientEvent('Framework:Notify', source, 'Je hebt een advocaat betaald')
            else
                TriggerClientEvent('Framework:Notify', source, 'Persoon is geen advocaat', "error")
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

Framework.Commands.Add("112", "Stuur een melding naar hulpdiensten", {{name="bericht", help="Bericht die je wilt sturen naar de hulpdiensten"}}, true, function(source, args)
    local Message = table.concat(args, " ")
    local Player = Framework.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName("phone") ~= nil then
        TriggerClientEvent('fw-police:client:send:alert', source, Message, false)
    else
        TriggerClientEvent('Framework:Notify', source, 'Je hebt geen telefoon..', 'error')
    end
end)

Framework.Commands.Add("112a", "Stuur een anonieme melding naar hulpdiensten (geeft geen locatie)", {{name="bericht", help="Bericht die je wilt sturen naar de hulpdiensten"}}, true, function(source, args)
    local Message = table.concat(args, " ")
    local Player = Framework.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName("phone") ~= nil then
        TriggerClientEvent("fw-police:client:call:anim", source)
        TriggerClientEvent('fw-police:client:send:alert', -1, Message, true)
    else
        TriggerClientEvent('Framework:Notify', source, 'Je hebt geen telefoon..', 'error')
    end
end)

Framework.Commands.Add("enkelbandlocatie", "Haal locatie van persoon met enkelband", {{name="bsn", help="BSN van de burger"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        if args[1] ~= nil then
            local citizenid = args[1]
            local Target = Framework.Functions.GetPlayerByCitizenId(citizenid)
            local Tracking = false
            if Target ~= nil then
                if Target.PlayerData.metadata["tracker"] and not Tracking then
                    Tracking = true
                    TriggerClientEvent("fw-police:client:send:tracker:location", Target.PlayerData.source, Target.PlayerData.source)
                else
                    TriggerClientEvent('Framework:Notify', source, 'Deze persoon heeft geen enkelband.', 'error')
                end
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

Framework.Functions.CreateUseableItem("handcuffs", function(source, item)
    local Player = Framework.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("fw-police:client:cuff:closest", source)
    end
end)

-- // HandCuffs \\ --
RegisterServerEvent('fw-police:server:cuff:closest')
AddEventHandler('fw-police:server:cuff:closest', function(SeverId)
    local Player = Framework.Functions.GetPlayer(source)
    local CuffedPlayer = Framework.Functions.GetPlayer(SeverId)
    if CuffedPlayer ~= nil then
        --TriggerEvent("fw-logs:server:SendLog", "cuffing", "Handcuffs", "pink", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."*) heeft zijn boeien gebruikt op: **".. GetPlayerName(SeverId) .."** (citizenid: *" ..CuffedPlayer.PlayerData.citizenid.."*)")
        TriggerClientEvent("fw-police:client:get:cuffed", CuffedPlayer.PlayerData.source, Player.PlayerData.source)
    end
end)

RegisterServerEvent('fw-police:server:set:handcuff:status')
AddEventHandler('fw-police:server:set:handcuff:status', function(Cuffed)
	local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil then
		Player.Functions.SetMetaData("ishandcuffed", Cuffed)
	end
end)

RegisterServerEvent('fw-police:server:escort:closest')
AddEventHandler('fw-police:server:escort:closest', function(SeverId)
    local Player = Framework.Functions.GetPlayer(source)
    local EscortPlayer = Framework.Functions.GetPlayer(SeverId)
    if EscortPlayer ~= nil then
        if (EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"]) then
            TriggerClientEvent("fw-police:client:get:escorted", EscortPlayer.PlayerData.source, Player.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Persoon is niet dood of geboeid!")
        end
    end
end)

RegisterServerEvent('fw-police:server:set:out:veh')
AddEventHandler('fw-police:server:set:out:veh', function(ServerId)
    local Player = Framework.Functions.GetPlayer(source)
    local EscortPlayer = Framework.Functions.GetPlayer(ServerId)
    if EscortPlayer ~= nil then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
            TriggerClientEvent("fw-police:client:set:out:veh", EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Persoon is niet dood of geboeid!")
        end
    end
end)

RegisterServerEvent('fw-police:server:set:in:veh')
AddEventHandler('fw-police:server:set:in:veh', function(ServerId)
    local Player = Framework.Functions.GetPlayer(source)
    local EscortPlayer = Framework.Functions.GetPlayer(ServerId)
    if EscortPlayer ~= nil then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
            TriggerClientEvent("fw-police:client:set:in:veh", EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Persoon is niet dood of geboeid!")
        end
    end
end)

Framework.Functions.CreateCallback('fw-police:server:is:player:dead', function(source, cb, playerId)
    local Player = Framework.Functions.GetPlayer(playerId)
    cb(Player.PlayerData.metadata["isdead"])
end)

Framework.Functions.CreateCallback('fw-police:server:is:inventory:disabled', function(source, cb, playerId)
    local Player = Framework.Functions.GetPlayer(playerId)
    cb(Player.PlayerData.metadata["inventorydisabled"])
end)

RegisterServerEvent('fw-police:server:SearchPlayer')
AddEventHandler('fw-police:server:SearchPlayer', function(playerId)
    local src = source
    local SearchedPlayer = Framework.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then 
        TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Persoon heeft €"..SearchedPlayer.PlayerData.money["cash"]..",- op zak..")
        TriggerClientEvent('Framework:Notify', SearchedPlayer.PlayerData.source, "Je wordt gefouilleerd..")
    end
end)

RegisterServerEvent('fw-police:server:rob:player')
AddEventHandler('fw-police:server:rob:player', function(playerId)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local SearchedPlayer = Framework.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then 
        local money = SearchedPlayer.PlayerData.money["cash"]
        Player.Functions.AddMoney("cash", money, "police-player-robbed")
        SearchedPlayer.Functions.RemoveMoney("cash", money, "police-player-robbed")
        TriggerClientEvent('Framework:Notify', SearchedPlayer.PlayerData.source, "Je bent van €"..money.." beroofd")
    end
end)

RegisterServerEvent('fw-police:server:send:call:alert')
AddEventHandler('fw-police:server:send:call:alert', function(Coords, Message)
 local Player = Framework.Functions.GetPlayer(source)
 local Name = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname
 local AlertData = {title = "112 Melding - "..Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. " ("..source..")", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = Message}
 TriggerClientEvent("fw-phone:client:addPoliceAlert", -1, AlertData)
 TriggerClientEvent('fw-police:client:send:message', -1, Coords, Message, Name)
end)

RegisterServerEvent('fw-police:server:spawn:object')
AddEventHandler('fw-police:server:spawn:object', function(type)
    local src = source
    local objectId = CreateIdType('casing')
    Objects[objectId] = type
    TriggerClientEvent("fw-police:client:place:object", -1, objectId, type, src)
end)

RegisterServerEvent('fw-police:server:delete:object')
AddEventHandler('fw-police:server:delete:object', function(objectId)
    local src = source
    TriggerClientEvent('fw-police:client:remove:object', -1, objectId)
end)

-- // Police Alerts Events \\ --

RegisterServerEvent('fw-police:server:send:alert:officer:down')
AddEventHandler('fw-police:server:send:alert:officer:down', function(Coords, StreetName, Info, Priority)
   TriggerClientEvent('fw-police:client:send:officer:down', -1, Coords, StreetName, Info, Priority)
end)

RegisterServerEvent('fw-police:server:send:alert:panic:button')
AddEventHandler('fw-police:server:send:alert:panic:button', function(Coords, StreetName, Info)
    local AlertData = {title = "Assistentie collega", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Noodknop ingedrukt door "..Info['Callsign'].." "..Info['Firstname']..' '..Info['Lastname'].." bij "..StreetName}
    TriggerClientEvent("fw-phone:client:addPoliceAlert", -1, AlertData)
    TriggerClientEvent('fw-police:client:send:alert:panic:button', -1, Coords, StreetName, Info)
end)

RegisterServerEvent('fw-police:server:send:alert:gunshots')
AddEventHandler('fw-police:server:send:alert:gunshots', function(Coords, GunType, StreetName, InVeh)
    local AlertData = {title = "Schoten Gelost",coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = 'Schoten gelost nabij ' ..StreetName}
    if InVeh then
      AlertData = {title = "Schoten Gelost",coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = 'Schoten gelost vanuit een voertuig, nabij ' ..StreetName}
    end
   TriggerClientEvent("fw-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('fw-police:client:send:alert:gunshots', -1, Coords, GunType, StreetName, InVeh)
end)

RegisterServerEvent('fw-police:server:send:alert:dead')
AddEventHandler('fw-police:server:send:alert:dead', function(Coords, StreetName)
   local AlertData = {title = "Gewonde Burger", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Er is een gewonde burger gemeld nabij "..StreetName}
   TriggerClientEvent("fw-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('fw-police:client:send:alert:dead', -1, Coords, StreetName)
end)

RegisterServerEvent('fw-police:server:send:bank:alert')
AddEventHandler('fw-police:server:send:bank:alert', function(Coords, StreetName, CamId)
   local AlertData = {title = "Bank Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Een fleeca bank alarm is afgegaan nabij "..StreetName}
   TriggerClientEvent("fw-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('fw-police:client:send:bank:alert', -1, Coords, StreetName, CamId)
end)

RegisterServerEvent('fw-police:server:send:big:bank:alert')
AddEventHandler('fw-police:server:send:big:bank:alert', function(Coords, StreetName)
   local AlertData = {title = "Bank Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "De pacific bank alarm is afgegaan nabij "..StreetName}
   TriggerClientEvent("fw-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('fw-police:client:send:big:bank:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('fw-police:server:send:alert:jewellery')
AddEventHandler('fw-police:server:send:alert:jewellery', function(Coords, StreetName)
   local AlertData = {title = "Juwelier Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Het vangelico juwelier alarm is zojuist afgegaan nabij "..StreetName}
   TriggerClientEvent("fw-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('fw-police:client:send:alert:jewellery', -1, Coords, StreetName)
end)

RegisterServerEvent('fw-police:server:send:alert:store')
AddEventHandler('fw-police:server:send:alert:store', function(Coords, StreetName, StoreNumber)
   local AlertData = {title = "Winkel Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Het alarm van winkel: "..StoreNumber..' is afgegaan nabij '..StreetName}
   TriggerClientEvent("fw-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('fw-police:client:send:alert:store', -1, Coords, StreetName, StoreNumber)
end)

RegisterServerEvent('fw-police:server:send:house:alert')
AddEventHandler('fw-police:server:send:house:alert', function(Coords, StreetName)
   local AlertData = {title = "Huis Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Er is een huis alarm systeem afgegaan nabij "..StreetName}
   TriggerClientEvent("fw-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('fw-police:client:send:house:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('fw-police:server:send:banktruck:alert')
AddEventHandler('fw-police:server:send:banktruck:alert', function(Coords, Plate, StreetName)
   local AlertData = {title = "Bank Truck Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Er is een bank truck alarm systeem afgegaan met het kenteken: "..Plate..'. nabij '..StreetName}
   TriggerClientEvent("fw-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('fw-police:client:send:banktruck:alert', -1, Coords, Plate, StreetName)
end)

RegisterServerEvent('fw-police:server:alert:explosion')
AddEventHandler('fw-police:server:alert:explosion', function(Coords, StreetName)
   local AlertData = {title = "Explosie Melding", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Er is een explosie melding nabij: "..StreetName.."."}
   TriggerClientEvent("fw-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('fw-police:client:send:explosion:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('fw-police:server:alert:cornerselling')
AddEventHandler('fw-police:server:alert:cornerselling', function(Coords, StreetName)
   local AlertData = {title = "Verdachte Situatie", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Er is een verdachte situatie nabij: "..StreetName.."."}
   TriggerClientEvent("fw-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('fw-police:client:send:cornerselling:alert', -1, Coords, StreetName)
end)

