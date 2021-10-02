Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Functions.CreateCallback('fw-radio:server:HasItem', function(source, cb, itemName)
  local Player = Framework.Functions.GetPlayer(source)
  if Player ~= nil then
  local Item = Player.Functions.GetItemByName(itemName)
     if Item ~= nil then
       cb(true)
     else
        cb(false)
     end
   end
end)

Framework.Functions.CreateUseableItem("radio", function(source, item)
  local Player = Framework.Functions.GetPlayer(source)
  TriggerClientEvent('fw-radio:use:radio', source)
end)