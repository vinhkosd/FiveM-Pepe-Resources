resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "html/index.html"

client_scripts {
 'config.lua',
 'client/client.lua',
}

server_scripts {
 'config.lua',
 'server/server.lua',
}

files {
 'html/*.html',
 'html/*.js',
 'html/*.css',
}