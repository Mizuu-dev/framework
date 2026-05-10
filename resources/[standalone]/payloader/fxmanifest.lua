fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Mizuu Framework - Lennox'
description 'Mizuu Framework - Scans all resources for payloader_file(s) declarations and executes them on server start.'
version '1.0.0'

-- Files
server_scripts {
    -- 1. Config first - everything else reads from it
    'core/config.lua',
 
    -- 2. Logger - used by all components below
    'core/logger.lua',
 
    -- 3. Core components
    'core/file_scanner.lua',
    'core/sql_parser.lua',
    'core/sql_executor.lua',
 
    -- 4. Orchestrator - depends on all of the above
    'core/loader.lua',
 
    -- 5. Entry point - depends on everything
    'server/bootstrap.lua',
}
 
dependencies {
    'oxmysql',  -- swap for 'mysql-async' if needed; sql_executor.lua handles both
}