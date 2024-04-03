local net = require("@lune/net")
local stdio = require("@lune/stdio")
local task = require("@lune/task")

local requestHandler = require("requestHandler.luau")
local routes = require("routes.luau")
local middleware = require("middleware.luau")
local html = require("html.luau")

local version = "0.1.0"

type Config = {
    port: number?,
    debug: boolean?,
    title: string?,
    logging: {
        enabled: boolean,
        logToFile: boolean?,
        logFilePath: string?
    }?
}

local function createServer(config: Config?)
    _G.config = config or {}
    
    local _server = net.serve(_G.config.port or 8080, function(request)
        return requestHandler(request)
    end)
    stdio.write(stdio.style("bold"))
    stdio.write(stdio.color("cyan"))
    print("Aurora v" .. version)
    stdio.write(stdio.color("reset"))
    print("Server is running on port " .. (_G.config.port or 8080))
    stdio.write(stdio.style("reset"))

    while true do 
        task.wait(1)
    end
end

return {
    createServer = createServer,
    get = routes.get,
    post = routes.post,
    put = routes.put,
    patch = routes.patch,
    delete = routes.delete,
    static = routes.static,
    middleware = middleware.middleware,
    sendHtml = html.sendHtml
}
