--- Lightweight console logger with severity levels and a consistent prefix.
--- Registers itself as the global `Logger`.

Logger = {}

local levels = {
    info  = "^7",
    ok    = "^2",
    warn  = "^3",
    error = "^1",
    trace = "^5",
}

function Logger.log(level, msg)
    local color = levels[level] or "^7"
    print(color .. msg .. "^7")
end

function Logger.info(msg)  Logger.log("info",  msg) end
function Logger.ok(msg)    Logger.log("ok",    msg) end
function Logger.warn(msg)  Logger.log("warn",  msg) end
function Logger.error(msg) Logger.log("error", msg) end
function Logger.trace(msg) Logger.log("trace", msg) end