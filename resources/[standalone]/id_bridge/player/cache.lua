Cache = {}

local store = {}

function Cache.get(identifier)
    return store[identifier]
end

function Cache.set(identifier, player)
    store[identifier] = player
end

function Cache.remove(identifier)
    store[identifier] = nil
end
