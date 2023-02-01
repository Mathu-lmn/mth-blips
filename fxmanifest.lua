fx_version 'adamant'
game 'gta5'

name "mth-blips"
description "Developer script to show every GTA blips and set the scale / color"
author "Mathu_lmn"
version "1.0.0"

shared_script {'config.lua'}

client_scripts {
    'RageUI/RMenu.lua',
    'RageUI/menu/RageUI.lua',
    'RageUI/menu/Menu.lua',
    'RageUI/menu/MenuController.lua',
    'RageUI/components/*.lua',
    'RageUI/menu/elements/*.lua',
    'RageUI/menu/items/*.lua',
    'RageUI/menu/panels/*.lua',
    'RageUI/menu/windows/*.lua',
    'client.lua',
}