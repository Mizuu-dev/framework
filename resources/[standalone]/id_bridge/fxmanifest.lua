fx_version 'cerulean'
game 'gta5'

author      'Mizuu Framework - Lennox'
description 'Resolves and replicates permanent mz_frame ingame_id values for txAdmin and other resources'
version     '1.0.0'

dependency 'oxmysql'

server_scripts {

    'shared/config.lua',      -- must load first

    'sql/queries.lua',        -- DB queries

    'player/cache.lua',       -- in-memory id cache
    'player/identity.lua',    -- name prefix logic
    'player/events.lua',      -- playerConnecting / playerDropped

    'exports/api.lua',        -- exports for other resources
    
}
