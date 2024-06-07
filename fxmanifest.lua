fx_version 'cerulean'
games { 'gta5' }

author 'Created By Taala'
description 'Digarea'
version '1.0.0'

lua54 'yes'

files {
    'locales/*.json',
}

shared_scripts {'@ox_lib/init.lua', 'server/s_config.lua'}

client_scripts {
    'client/c_*.lua',
}
server_scripts {
    'server/s_*.lua',
    '@oxmysql/lib/MySQL.lua',
}

exports(
    "startPan"
)