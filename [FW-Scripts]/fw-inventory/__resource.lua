resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description 'Framework Inventory'

ui_page {'html/ui.html'}

server_scripts {
 "config.lua",
 "server/main.lua",
}

client_scripts {
 "config.lua",
 "client/main.lua",
}

server_exports {
 'AddToStash',
}

files {
 'html/ui.html',
 'html/css/main.css',
 'html/js/app.js',
 'html/images/*.png',
 'html/images/*.jpg',
 'html/ammo_images/*.png',
 'html/attachment_images/*.png',
 'html/*.ttf',
}