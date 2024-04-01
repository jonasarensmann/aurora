local routes = require("routes")
local middleware = require("middleware.luau")
local types = require("types.luau")

return function(request: types.Request): types.Response
    local path = request.path
    local route = routes.findRoute(path, request.method)

    if route == nil then
        return {status = 404, body = "Not Found"}
    end

    middleware.buildInMiddleware(request)
    local middlewareResponse = middleware.runRouteMiddleware(request, route)

    if middlewareResponse and middlewareResponse.status ~= 200 then 
        return middlewareResponse
    end

    return route.handler(request)
end