local fs = require("@lune/fs")
local process = require("@lune/process")
local net = require("@lune/net")

local types = require("types.luau")
local errorPage = require("errorPage.luau")
local html = require("html.luau")

local routes: types.Routes = {}

local workingDirectory = process.cwd

local function createRouteResponse(_self: { body: string, status: number, headers: { [string]: string }}): types.RouteResponse
    local self = _self or {}

    function self.setStatus(status: number)
        self.status = status
    end

    function self.setHeader(key: string, value: string)
        self.headers[key] = value
    end 

    function self.send(body: string, contentType: string?)
        self.body = body
        self.headers["Content-Type"] = contentType or "text/plain"
    end

    function self.json(body: any, pretty: boolean?)
        self.body = net.jsonEncode(body, pretty or false)
        self.headers["Content-Type"] = "application/json"
    end

    function self.download(path: string)
        self.body = fs.readFile(path)
        self.headers["Content-Type"] = "application/octet-stream"
        self.headers["Content-Disposition"] = "attachment; filename=" .. path
    end

    function self.html(path: string, keys: { [string]: string }?)
        self.body = html.renderHtml(path, keys or {})
        self.headers["Content-Type"] = "text/html"
    end

    function self.redirect(url: string)
        self.status = 302
        self.headers["Location"] = url
    end   

    return {
        setStatus = self.setStatus,
        setHeader = self.setHeader,
        send = self.send,
        json = self.json,
        download = self.download,
        html = self.html,
        redirect = self.redirect,
    }
end

local function get(path: string, handler: (request: types.Request, resonse: types.RouteResponse) -> types.RouteResponse, middleware: { string }?)
    table.insert(routes, {path = path, method = "GET", middleware = middleware, handler = handler})
end

local function post(path: string, handler: (request: types.Request, resonse: types.RouteResponse) -> types.RouteResponse, middleware: { string }?)
    table.insert(routes, {path = path, method = "POST", middleware = middleware, handler = handler})
end

local function put(path: string, handler: (request: types.Request, resonse: types.RouteResponse) -> types.RouteResponse, middleware: { string }?)
    table.insert(routes, {path = path, method = "PUT", middleware = middleware, handler = handler})
end

local function patch(path: string, handler: (request: types.Request, resonse: types.RouteResponse) -> types.RouteResponse, middleware: { string }?)
    table.insert(routes, {path = path, method = "PATCH", middleware = middleware, handler = handler})
end

local function delete(path: string, handler: (request: types.Request, resonse: types.RouteResponse) -> types.RouteResponse, middleware: { string }?)
    table.insert(routes, {path = path, method = "DELETE", middleware = middleware, handler = handler})
end

local function static(path: string, directory: string)
    local function handler(request, response)
        local file

        local directory = directory

        directory = workingDirectory .. "/" .. directory

        if request.path == path then
            file = directory .. "index.html"
        else
            local path = string.gsub(request.path, path, "")
            file = directory .. path
        end

        if fs.isFile(file) then 
            response.send(fs.readFile(file))
        else
            response.setStatus(404)
            response.send(errorPage(404, "The requested URL was not found on this server.")) 
        end

        if string.find(file, ".html") then
            response.setHeader("Content-Type", "text/html")
        elseif string.find(file, ".css") then
            response.setHeader("Content-Type", "text/css")
        elseif string.find(file, ".js") then
            response.setHeader("Content-Type", "text/javascript")
        elseif string.find(file, ".json") then
            response.setHeader("Content-Type", "application/json")
        elseif string.find(file, ".png") then
            response.setHeader("Content-Type", "image/png")
        elseif string.find(file, ".jpg") then
            response.setHeader("Content-Type", "image/jpg")
        elseif string.find(file, ".jpeg") then
            response.setHeader("Content-Type", "image/jpeg")
        elseif string.find(file, ".gif") then
            response.setHeader("Content-Type", "image/gif")
        elseif string.find(file, ".svg") then
            response.setHeader("Content-Type", "image/svg+xml")
        elseif string.find(file, ".ico") then
            response.setHeader("Content-Type", "image/x-icon")
        else
            response.setHeader("Content-Type", "text/plain")
        end

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
    findRoute = findRoute,
    createRouteResponse = createRouteResponse
}