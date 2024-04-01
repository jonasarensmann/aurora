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
    handler: (Request) -> {status: number, body: string, headers: { any: any }?}
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