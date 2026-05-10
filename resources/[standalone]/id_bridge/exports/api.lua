exports('getIngameId', function(source)
    return Player(source).state.ingame_id
end)

exports('getPermanentId', function(source)
    return Player(source).state.ingame_id
end)

exports('getSourceFromIngameId', function(ingame_id)
    return Identity.resolveSourceByIngameId(ingame_id)
end)

exports('getLicense', function(source)
    return Identity.getLicense(source)
end)
