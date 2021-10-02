resource_manifest_version "77731fab-63ca-442c-a67b-abc70f28dfa5"

ui_page "html/index.html"

client_scripts {
 'config.lua',
 'client/client.lua',
}

server_scripts {
 'config.lua',
 'server/server.lua'
}

exports {
 'SetSeatbelt',
}

files {
 "html/index.html",
 "html/js/script.js",
 "html/css/style.css",
 "html/css/pdown.ttf",
 'html/img/belt.png',
}