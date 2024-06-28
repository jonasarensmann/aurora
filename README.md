<img align="right" width="200" src="https://aurora.jonas-arensmann.com/logo.svg" alt="Aurora logo" />

<h1 align="left">Aurora</h1>

<br/>

A Web Framework for [Luau](https://luau-lang.org) using the [Lune](https://github.com/lune-org/lune) Runtime

It is inspired by [Express](https://expressjs.com)

#### Example

Install Aurora using [Farmer](https://github.com/jonasarensmann/farmer)

```bash
farmer init aurora-example
farmer add aurora
```

```lua
local aurora = require("../crops/aurora")

-- GET request to /
aurora.get("/", function(req, res)
    res.send("Hello World")
end)

aurora.createServer() -- runs the server on port 8080
```

<br />

## Getting Started

Head over to the [Getting Started](https://docs.page/jonasarensmann/aurora/getting-started) page to get started with Aurora

🛈 Aurora is still in Development and not ready for Production
