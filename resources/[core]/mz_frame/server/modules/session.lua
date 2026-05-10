MZ = MZ or {}
MZ.Players = {}

MZ.GetPlayer = function(source)
    return MZ.Players[source]
end

MZ.GetPlayers = function()
    return MZ.Players
end

MZ.AddPlayer = function(source, data)
    MZ.Players[source] = data
end

MZ.RemovePlayer = function(source)
    MZ.Players[source] = nil
end
