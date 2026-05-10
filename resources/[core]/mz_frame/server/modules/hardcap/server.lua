local playerCount = 0
local list = {}

RegisterServerEvent('hardcap:playerActivated')

AddEventHandler('hardcap:playerActivated', function()
  if not list[source] then
    playerCount = playerCount + 1
    list[source] = true
  end
end)

AddEventHandler('playerDropped', function()
  if list[source] then
    playerCount = playerCount - 1
    list[source] = nil
  end
end)

AddEventHandler('playerConnecting', function(name, setReason)
  local cv = GetConvarInt('sv_maxclients', 32)

  if playerCount >= cv then
    print('Sorry your Server is full of players, to increase the player limit, change sv_maxclients in your server.cfg for a higher value consider upgrading to a premium CFX license for more slots at https://portal.cfx.re/subscriptions/element-club')

    setReason('This server is full (past ' .. tostring(cv) .. ' players).')
    CancelEvent()
  end
end)
