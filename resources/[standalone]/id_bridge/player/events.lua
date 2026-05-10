-- playerConnecting
-- Ensures every connecting player has a mz_frame players row and state ID.
-- deferrals hold the connection open while the async DB chain runs.
AddEventHandler('playerConnecting', function(_, _setKickReason, deferrals)
    local source = source  -- must capture before any Citizen.Wait()

    deferrals.defer()
    Citizen.Wait(0)   -- yield once so the deferral activates
 
    local license = Identity.getLicense(source)

    if not license then
        deferrals.done()
        return
    end

    Identity.resolve(source, license, function()
        deferrals.done()
    end)
end)

-- playerJoining
-- Safety net in case another resource cleared state after playerConnecting.
AddEventHandler('playerJoining', function()
    local source  = source
    local license = Identity.getLicense(source)
    if not license then return end

    -- Already prefixed by playerConnecting (returning player), skip
    if Player(source).state.ingame_id then return end

    Identity.resolve(source, license, function() end)
end)

-- playerDropped
-- Remove from cache so a re-connect after e.g. a DB edit
-- picks up fresh data instead of a stale value.
AddEventHandler('playerDropped', function()
    local source  = source
    local license = Identity.getLicense(source)
    if license then
        Cache.remove(license)
    end
end)
