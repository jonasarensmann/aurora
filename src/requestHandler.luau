local routes = require("routes")
local middleware = require("middleware.luau")
local types = require("types.luau")
local errorPage = require("errorPage.luau")

return function(request: types.Request): types.Response
    local path = request.path
    local route = routes.findRoute(path, request.method)

    if route == nil then
        return {
            status = 404,
            body = errorPage(404, "Not Found"),
            headers = {["Content-Type"] = "text/html"}
        }
    end

    middleware.buildInMiddleware(request)
    local middlewareResponse = middleware.runRouteMiddleware(request, route)

    if middlewareResponse and middlewareResponse.status ~= 200 then 
        return middlewareResponse
    end

    local obj = { body = "", status = 200, headers = {}}
    local RouteResponseObj = routes.createRouteResponse(obj)
    route.handler(request, RouteResponseObj)
    
    return {
        status = obj.status,
        body = obj.body,
        headers = obj.headers
    }
end