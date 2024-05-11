fx_version 'cerulean'
game 'gta5'

description 'y_alcoholism'
authors 'Tonybyn_Mp4'
repository 'https://github.com/TonybynMp4/y_alcoholism'
version '1.1.2'

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    '@qbx_core/modules/lib.lua',
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

files {
    'config/client.lua',
    'config/shared.lua'
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'
