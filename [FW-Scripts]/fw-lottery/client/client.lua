local Framework = nil

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
     Citizen.Wait(250)
     LoggedIn = true
 end)
end)

-- Code

function generateSerial(id)
  local randFour = ""
  for i=1,4 do
    randFour = randFour .. math.random(1,9)
  end
  return string.format("KRAS-%s-%s%s%s", randFour, math.random(1,9),id,math.random(1,9))
end

function getRandomEntryOfTable(table)
  return table[math.random(1, tablelength(table))]
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function tableCopy(obj)
  if type(obj) ~= 'table' then return obj end
  local res = {}
  for k, v in pairs(obj) do res[tableCopy(k)] = tableCopy(v) end
  return res
end

function generateBlocks(prize)
  local blocks = {}
  local possiblePrizes = {}
	for i=1, #Config.Prizes, 1 do
    table.insert(possiblePrizes, math.floor(Config.TopPrize/Config.Prizes[i].divide))
  end
  if prize > 0 then
    blocks = {
      ['block1'] = prize,
      ['block2'] = prize,
      ['block3'] = prize
    }
  else
    blocks = {
      ['block1'] = getRandomEntryOfTable(possiblePrizes),
      ['block2'] = getRandomEntryOfTable(possiblePrizes),
      ['block3'] = getRandomEntryOfTable(possiblePrizes)
    }
    while blocks.block1 == blocks.block3 and blocks.block2 == blocks.block3 do
      blocks['block3'] = getRandomEntryOfTable(possiblePrizes)
    end
  end
  return blocks
end


-- // Loops \\ -- 
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		   local Positie = GetEntityCoords(GetPlayerPed(-1), false)
		   local Gebied = GetDistanceBetweenCoords(Positie.x, Positie.y, Positie.z, Config.Location['Coords']['X'], Config.Location['Coords']['Y'], Config.Location['Coords']['Z'], true)
		   NearSelling = false
       if Gebied <= 1.1 then
           NearSelling = true
		 	     DrawText3D(Config.Location['Coords']['X'], Config.Location['Coords']['Y'], Config.Location['Coords']['Z'] + 0.15, '~g~E~s~ - Kaarten Inleveren')
		 	     DrawMarker(2, Config.Location['Coords']['X'], Config.Location['Coords']['Y'], Config.Location['Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 44, 194, 33, 255, false, false, false, 1, false, false, false)
		 	     if IsControlJustPressed(0, 38) then
               TriggerServerEvent('fw-lottery:server:sell:card')
		 	     end
		   end
       if not NearSelling then
          Citizen.Wait(1500)
       end
	  end
end)

-- // Einde Loops \\ --

RegisterNetEvent('fw-lottery:client:open:card')
AddEventHandler('fw-lottery:client:open:card', function(id, prize)
  local blocks = generateBlocks(prize)
  SetNuiFocus(true, true)
  SendNUIMessage({
    event = 'OpenCard',
    serial = generateSerial(id),
    block1 = blocks.block1,
    block2 = blocks.block2,
    block3 = blocks.block3
  })
 end)

RegisterNUICallback('cs:cardClosed', function(data, cb)
  SetNuiFocus(false, false)
  cb("{}")
end)

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