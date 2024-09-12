# IMPERIO DANCES

ESX Dancing Contest Script integrated with [cs-hall](https://tebex.criticalscripts.shop/package/4517971).

## Dependencies
- [ES Extended](https://github.com/esx-framework/esx_core/releases/latest)
- [oxmysql](https://github.com/overextended/oxmysql/releases/latest)
- [ox_lib](https://github.com/overextended/ox_lib/releases/latest)
- [cs-hall](https://tebex.criticalscripts.shop/package/4517971)
- [xsound](https://github.com/Xogy/xsound/releases/latest) (used to preview the songs locally in the management menu)
- [YouTube Data API v3 Key](https://console.cloud.google.com)

## Installation
1. Extract `imperio_dances` inside your resources folder
2. Execute `tables.sql` in your database
3. Obtain your YouTube Data API v3 Key and provide it in `server.lua`
4. Edit `config.lua` wiuth your dancing contest nightclubs
5. Add `ensure imperio_dances` in your `server.cfg`

## Usage
You can open the Dancing Contest Management menu with the command `/dances`, triggering the client event `imperio_dances:menu` or the client export `openMenu`.
Both event and export can receive a param with an ox_lib context menu name to enable the previous menu option