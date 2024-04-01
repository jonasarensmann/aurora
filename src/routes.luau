local fs = require("@lune/fs")
local process = require("@lune/process")
local types = require("types.luau")

local routes: types.Routes = {}

local workingDirectory = string.gsub(process.spawn("pwd").stdout, "\n", "")

local function get(path: string, handler: (request: types.Request) -> types.Response, middleware: { string }?)
    table.insert(routes, {path = path, method = "GET", middleware = middleware, handler = handler})
end

local function post(path: string, handler: (request: types.Request) -> types.Response, middleware: { string }?)
    table.insert(routes, {path = path, method = "POST", middleware = middleware, handler = handler})
end

local function put(path: string, handler: (request: types.Request) -> types.Response, middleware: { string }?)
    table.insert(routes, {path = path, method = "PUT", middleware = middleware, handler = handler})
end

local function patch(path: string, handler: (request: types.Request) -> types.Response, middleware: { string }?)
    table.insert(routes, {path = path, method = "PATCH", middleware = middleware, handler = handler})
end

local function delete(path: string, handler: (request: types.Request) -> types.Response, middleware: { string }?)
    table.insert(routes, {path = path, method = "DELETE", middleware = middleware, handler = handler})
end

local function static(path: string, directory: string)
    local function handler(request)
        local file
        local status = 200
        local body = ""

        local directory = directory

        directory = workingDirectory .. "/" .. directory

        if request.path == path then
            file = directory .. "index.html"
        else
            local path = string.gsub(request.path, path, "")
            file = directory .. path
        end

        if fs.isFile(file) then 
            body = fs.readFile(file)
        else
            local res: types.Response = {status = 404, body = "Not Found"}
            return res
        end

        local headers = {}

        -- add the content type
        if string.find(file, ".html") then
            headers["Content-Type"] = "text/html"
        elseif string.find(file, ".css") then
            headers["Content-Type"] = "text/css"
        elseif string.find(file, ".js") then
            headers["Content-Type"] = "application/javascript"
        elseif string.find(file, ".json") then
            headers["Content-Type"] = "application/json"
        elseif string.find(file, ".png") then
            headers["Content-Type"] = "image/png"
        elseif string.find(file, ".jpg") then
            headers["Content-Type"] = "image/jpeg"
        elseif string.find(file, ".jpeg") then
            headers["Content-Type"] = "image/jpeg"
        elseif string.find(file, ".gif") then
            headers["Content-Type"] = "image/gif"
        elseif string.find(file, ".svg") then
            headers["Content-Type"] = "image/svg+xml"
        elseif string.find(file, ".ico") then
            headers["Content-Type"] = "image/x-icon"
        else
            headers["Content-Type"] = "text/plain"
        end
       
        local res: types.Response = {status = status, body = body, headers = headers}

        return res

    end

    table.insert(routes, {path = path, method = "GET", handler = handler, static = true})

end

local function findRoute(path: string, method: string)
    for _, route in ipairs(routes) do
        if route.static and string.find(path, route.path) then
            return route
        end

        if route.path == path and route.method == method then
            return route
        end
    end

    return nil
end

return {
    get = get,
    post = post,
    put = put,
    patch = patch,
    delete = delete,
    static = static,
    findRoute = findRoute
}