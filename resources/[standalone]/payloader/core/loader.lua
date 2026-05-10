Loader = {}

local function djb2(str)
    local h = 5381
    for i = 1, #str do
        h = ((h * 33) ~ str:byte(i)) & 0xFFFFFFFF
    end
    return string.format("%08x", h)
end

function Loader.run(onComplete)
    local tokens = FileScanner.scan()

    if #tokens == 0 then
        if onComplete then onComplete(0) end
        return
    end

    SqlExecutor.fetchChecksums(function(stored)
        local pending = {}

        for _, token in ipairs(tokens) do
            local content = FileScanner.read(token)
            if content then
                local h = djb2(content)
                if stored[token] ~= h then
                    pending[#pending + 1] = { token = token, content = content, hash = h }
                end
            end
        end

        if #pending == 0 then
            if onComplete then onComplete(0) end
            return
        end

        Logger.ok("Found ^3" .. #pending .. "^2 new/changed SQL file(s) — executing …")

        local index    = 0
        local failures = 0

        local function next()
            index = index + 1

            if index > #pending then
                if failures == 0 then
                    Logger.ok("^3" .. #pending .. "^2 SQL file(s) executed successfully.")
                else
                    Logger.warn((index - 1) .. " file(s) done — ^1" .. failures .. " failed.")
                end
                if onComplete then onComplete(#pending) end
                return
            end

            local entry    = pending[index]
            local fileName = FileScanner.basename(entry.token)
            local stmts    = SqlParser.parse(entry.content)

            if #stmts == 0 then
                SqlExecutor.saveChecksum(entry.token, entry.hash)
                next()
                return
            end

            SqlExecutor.runStatements(fileName, stmts, function(success)
                if success then
                    SqlExecutor.saveChecksum(entry.token, entry.hash)
                else
                    Logger.error("Failed to execute '" .. fileName .. "'")
                    failures = failures + 1
                end
                next()
            end)
        end

        next()
    end)
end