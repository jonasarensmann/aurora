local types = require("types.luau")
local errorPage = require("errorPage.luau")

local function buildInMiddleware(request: types.Request)
    if _G.config.logging and _G.config.logging.enabled then 
        local log = require("middleware/logging.luau")
        
        log(request, _G.config.logging.logToFile, _G.config.logging.logFilePath)
    end
end

local middlewares: types.Middlewares = {}

local function findMiddleware(name: string): types.Middleware | nil
    for _, middleware in ipairs(middlewares) do
        if middleware.name == name then
            return middleware
        end
    end

    return nil
end

local function middleware(name: string,handler: (request: types.Request) -> types.Response)
    table.insert(middlewares, {
        name = name,
        handler = handler
    })
end

local function runRouteMiddleware(request: types.Request, route: types.Route): types.Response | nil
    local middlewareResponse: types.Response | nil = nil

    if route.middleware then
        for _, middlewareName in ipairs(route.middleware) do
            local middleware = findMiddleware(middlewareName)

            if middleware then
                middlewareResponse = middleware.handler(request)
            else
                if _G.config.debug then
                    return errorPage(500, "Middleware " .. middlewareName .. " not found for route " .. route.method .. " " .. route.path)
                else
                    return errorPage(500, "Internal Server Error")
                end
            end
        end
    end

    return middlewareResponse
end

return {
    buildInMiddleware = buildInMiddleware,
    runRouteMiddleware = runRouteMiddleware,
    middleware = middleware
}