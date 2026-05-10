AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    SetTimeout(Config.startupDelay, function()
        Loader.run()
    end)
end)