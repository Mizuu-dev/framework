DB = {}

local defaultLocation = '{"x":0.0,"y":0.0,"z":72.0}'

function DB.fetchPlayer(identifier, cb)
    exports.oxmysql:single(
        'SELECT `id`, `ingame_id` FROM `players` WHERE `identifier` = ? LIMIT 1',
        { identifier },
        cb
    )
end

function DB.fetchNextIngameId(cb)
    exports.oxmysql:scalar(
        'SELECT COALESCE(MAX(`ingame_id`), 0) + 1 FROM `players`',
        {},
        cb
    )
end

function DB.insertPlayer(identifier, ingame_id, cb)
    exports.oxmysql:insert(
        'INSERT IGNORE INTO `players` (`identifier`, `first_name`, `last_name`, `ingame_id`, `last_location`, `sex`, `role`) VALUES (?, ?, ?, ?, ?, ?, ?)',
        { identifier, 'Unset', 'Unset', ingame_id, defaultLocation, 'male', 'user' },
        cb
    )
end

function DB.touchPlayer(identifier)
    exports.oxmysql:execute(
        'UPDATE `players` SET `last_seen` = CURRENT_TIMESTAMP WHERE `identifier` = ?',
        { identifier }
    )
end
