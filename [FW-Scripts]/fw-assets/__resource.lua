resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "html/index.html"

data_file 'HANDLING_FILE' 'misc/handling.meta'
data_file 'FIVEM_LOVES_YOU_4B38E96CC036038F' 'misc/events.meta'
data_file 'FIVEM_LOVES_YOU_341B23A2F0E0F131' 'misc/popgroups.ymt'

client_scripts {
 'config.lua',
 'client/anims.lua',
 'client/holster.lua',
 'client/seatbelt.lua',
 'client/props.lua',
 'client/client.lua',
 'client/loops.lua',
}

server_scripts {
 'config.lua',
 'server/server.lua',
}

files {
 "html/index.html",
 'misc/events.meta',
 'misc/handling.meta',
 'misc/popgroups.ymt',
 'misc/relationships.dat',
 'misc/visualsettings.dat',
}

exports {
 'AddBlipToCoords',
 'AddProp',
 'AddPropWithAnim',
 'RemoveProp',
 'GetPropStatus',
 'RequestAnimationDict',
 'RequestModelHash',
}