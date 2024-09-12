fx_version 'cerulean'

game "gta5"

lua54 'yes'

client_script 'client.lua'

server_scripts{
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

shared_scripts{
    '@es_extended/imports.lua',
    '@es_extended/locale.lua',
    '@ox_lib/init.lua',
    'config.lua',
    'locales/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
	'html/fontGTA.ttf',
    'html/styles.css',
    'html/img/*.png',
}

dependencies {
    'es_extended',
    'oxmysql',
    'ox_lib',
    'cs-hall',
    'xsound'
}