resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
	"config.lua",
	"shared.lua",
	"server/main.lua",
	"server/functions.lua",
	"server/player.lua",
	"server/events.lua",
	"server/commands.lua",
}

client_scripts {
	"config.lua",
	"shared.lua",
	"client/main.lua",
	"client/functions.lua",
	"client/loops.lua",
	"client/events.lua",
}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/css/main.css',
	'html/js/app.js',
}

