export type Request = {
    path: string,
    method: string,
    headers: { [string]: string },
    query: { [string]: string },
    body: string
}

export type Response = {
    status: number,
    body: string,
    headers: { [string]: string }?
}

export type Route = {
    path: string,
    method: string,
    static: boolean?,
    middleware: { string }?,
    handler: (Request, RouteResponse) -> RouteResponse
}

export type RouteResponse = {
    setStatus: (number) -> nil,
    setHeader: (string, string) -> nil,
    send: (string, string?) -> nil,
    json: (any) -> nil,
    redirect: (string) -> nil,
    html: (string, { [string]: any }?) -> nil,
}

export type Routes = {
    Route
}

export type Middleware = {
    name: string,
    handler: (Request) -> Response
}

export type Middlewares = {
    Middleware
}

return nil