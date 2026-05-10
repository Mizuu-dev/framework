SqlParser = {}

local function stripComments(sql)
    sql = sql:gsub("/%*.-%*/", "")   -- block comments
    sql = sql:gsub("%-%-[^\n]*", "") -- line comments
    return sql
end

local function trim(s)
    return s:match("^%s*(.-)%s*$")
end

function SqlParser.parse(content)
    local cleaned = stripComments(content)
    local stmts   = {}

    for raw in cleaned:gmatch("([^;]+)") do
        local stmt = trim(raw)
        if #stmt > 0 then
            stmts[#stmts + 1] = stmt
        end
    end

    return stmts
end