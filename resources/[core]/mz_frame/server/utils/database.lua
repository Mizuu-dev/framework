DB = DB or {}

DB.Fetch = function(query, params, cb)
    exports.oxmysql:fetch(query, params, cb)
end

DB.Execute = function(query, params, cb)
    exports.oxmysql:execute(query, params, cb)
end

DB.Insert = function(query, params, cb)
    exports.oxmysql:insert(query, params, cb)
end
