resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

server_scripts {
 "config.lua",
 "server/server.lua",
}

client_scripts {
 "config.lua",
 "client/labs.lua",
 "client/client.lua",
 "client/methlab.lua",
 "client/cokelab.lua",
 "client/moneylab.lua",
 "client/interactions.lua",
 "client/cornerselling.lua",
}

server_exports {
 "AddProduct",
 "RemoveProduct",
 "CanItemBePlaced",
 "GetInventoryData",
 "GetCokeCrafting",
 "GetMethCrafting",
}

exports {
 'isNearByNPC',
}