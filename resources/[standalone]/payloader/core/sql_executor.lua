SqlExecutor = {}

local function detectDriver()
    if exports["oxmysql"] then
        return "oxmysql"
    elseif MySQL and MySQL.query then
        return "mysql-async"
    end
    return nil
end

local function execOne(driver, stmt, cb)
    if driver == "oxmysql" then
        exports["oxmysql"]:query(stmt, {}, function(result)
            cb(result ~= nil)
        end)
    elseif driver == "mysql-async" then
        MySQL.query(stmt, {}, function(result)
            cb(result ~= nil)
        end)
    else
        cb(false)
    end
end

function SqlExecutor.fetchChecksums(onDone)
    local driver = detectDriver()
    if not driver then onDone({}) return end

    local create = [[
        CREATE TABLE IF NOT EXISTS `payloader_checksums` (
            `file` VARCHAR(255) NOT NULL,
            `hash` CHAR(8)      NOT NULL,
            PRIMARY KEY (`file`)
        )
    ]]
    local select = "SELECT `file`, `hash` FROM `payloader_checksums`"

    local function parseRows(rows)
        local map = {}
        for _, row in ipairs(rows or {}) do map[row.file] = row.hash end
        onDone(map)
    end

    if driver == "oxmysql" then
        exports["oxmysql"]:query(create, {}, function()
            exports["oxmysql"]:query(select, {}, parseRows)
        end)
    else
        MySQL.query(create, {}, function()
            MySQL.query(select, {}, parseRows)
        end)
    end
end

function SqlExecutor.saveChecksum(file, hash)
    local driver = detectDriver()
    if not driver then return end

    local sql = "INSERT INTO `payloader_checksums` (`file`, `hash`) VALUES (?, ?) ON DUPLICATE KEY UPDATE `hash` = VALUES(`hash`)"
    if driver == "oxmysql" then
        exports["oxmysql"]:query(sql, { file, hash }, nil)
    else
        MySQL.query(sql, { file, hash }, nil)
    end
end

function SqlExecutor.runStatements(fileName, stmts, onDone)
    local driver = detectDriver()

    if not driver then
        Logger.error("No MySQL driver found (oxmysql / mysql-async). Cannot execute: " .. fileName)
        if onDone then onDone(false) end
        return
    end

    if #stmts == 0 then
        if onDone then onDone(true) end
        return
    end

    local index = 0
    local allOk = true

    local function next()
        index = index + 1

        if index > #stmts then
            if onDone then onDone(allOk) end
            return
        end

        execOne(driver, stmts[index], function(ok)
            if not ok then
                allOk = false
                Logger.warn("  Statement " .. index .. "/" .. #stmts .. " failed in " .. fileName)
            end
            next()
        end)
    end

    next()
end