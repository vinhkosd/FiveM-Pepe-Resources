resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page 'html/index.html'

data_file 'WEAPONINFO_FILE_PATCH' 'metas/weaponheavypistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'metas/weapons_snspistol_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'metas/weapons_carbinerifle_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'metas/weapons_assaultrifle_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'metas/weapons_pistol_mk2.meta'

data_file 'WEAPONINFO_FILE_PATCH' 'metas/weapons.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'metas/weaponvintagepistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'metas/weaponmachinepistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'metas/weapons_taser.meta'

client_scripts {
 'config.lua',
 'client/client.lua',
 'client/recoil.lua',
}

server_scripts {
 'config.lua',
 'server/server.lua',
}

files {
 'metas/weapons_taser.meta',
 'metas/weaponheavypistol.meta',
 'metas/weapons_snspistol_mk2.meta',
 'metas/weapons_carbinerifle_mk2.meta',
 'metas/weapons_assaultrifle_mk2.meta',
 'metas/weapons_pistol_mk2.meta',
 'metas/weaponmachinepistol.meta',
 'metas/weaponvintagepistol.meta',
 'metas/weapons.meta',
 'html/index.html',
 'html/js/script.js',
 'html/css/style.css',
}

exports {
 'GetAmmoType',
}

server_exports {
 'GetWeaponList',
}