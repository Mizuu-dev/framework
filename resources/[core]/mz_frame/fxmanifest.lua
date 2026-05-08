fx_version 'cerulean'
game 'gta5'

author 'Mizuu Framework - Lennox'
description 'Mizuu Framework - The Most Essential Resource for the Mizuu Framework'
version '1.0.0'

-- Credits

-- Hard cap — Optimized by Lennox, original by Cfx.re <root@cfx.re>
-- Map Manager — Optimized by Lennox, original by Cfx.re <root@cfx.re>
-- Session Manager — Optimized by Lennox, original by Cfx.re <root@cfx.re>
-- Basic Gamemode — Optimized by Lennox, original by Cfx.re <root@cfx.re>
-- repository 'https://github.com/citizenfx/cfx-server-data'

-- Files

shared_scripts { 'shared/mapmanager/shared.mapmanager.lua' }

client_script {

    'client/modules/gamemode/client.lua', -- Client-side gamemode logic

    'client/modules/hardcap/client.lua', -- Client-side hardcap logic (disables player controls when server is full)

    'client/modules/mapmanager/client.lua', -- Client-side map manager (handles map/gametype association, events, etc.)

    'client/modules/spawnmanager/client.lua', -- Client-side spawn manager (handles player spawning, spawn points, etc.)
    
    -- Config
    'shared/client/client.config.lua', -- Client-side configuration (keybinds, etc.)

    -- Utils
    'client/utils/tables.lua',         -- Table helpers (deep copy, merge, contains)

    -- Modules
    'client/modules/callback.lua',     -- Client-side callback system
    'client/modules/player.lua',       -- Local player state cache + getters (GetPlayerData, etc.)

}

server_script {

    'server/modules/hardcap/server.lua', -- Server-side hardcap logic (tracks player count, kicks connecting players when full)

    'server/modules/mapmanager/server.lua', -- Server-side map manager (handles map/gametype association, events, etc.)

    'server/modules/sessionmanager/server.lua', -- Server-side session manager (handles player session state, host lock for non-OneSync servers, etc.)

    -- Config
    'shared/server/server.config.lua', -- Server-side configuration (keybinds, etc.)

    -- Utils
    'server/utils/database.lua',       -- DB abstraction (Fetch, Execute, Insert wrappers)
    'server/utils/tables.lua',         -- Same table helpers mirrored server-side
    'server/utils/commands.lua',       -- Command registration and handling (RegisterCommand wrapper)


    -- Modules
    'server/modules/callback.lua',     -- Server-side callback handler
    'server/modules/session.lua',      -- Active player session map (source → playerObject)
    'server/modules/player.lua',       -- Player load/save/kick, DB read-write

    -- Commands
    'server/commands/ban.lua',         -- Bans a player by license, or identifier
    'server/commands/goto.lua',        -- Teleports you to a player's location (by ID)
    'server/commands/kick.lua',        -- Kicks a player by ID from the Server but they can rejoin
    'server/commands/bring.lua',       -- Brings a player to your location by ID

}

-- Exports

server_export "getCurrentGameType"
server_export "getCurrentMap"
server_export "changeGameType"
server_export "changeMap"
server_export "doesMapSupportGameType"
server_export "getMaps"
server_export "roundEnded"