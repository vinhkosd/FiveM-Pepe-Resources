resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page {'html/index.html'}

server_scripts {
 "config.lua",
 "server/server.lua",
}

client_scripts {
 "config.lua",
 "client/client.lua",
 'client/premiumdealer.lua'
}

files {
 'html/index.html',
 'html/css/style.css',
 'html/js/script.js',
 'html/img/*.png',
 'html/img/cars/small/*.jpg',
 'html/img/cars/big/*.jpg',
}