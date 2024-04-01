# Aurora

### A simple web framework for [Lune](https://github.com/lune-org/lune)

Aurora is a simple web framework for the Lune Runtime inspired by [Express](https://expressjs.com/).

[docs](https://docs.page/jonasarensmann/aurora)

# ! Considered unstable !

<br>

### Example

```lua
local aurora = require("aurora/main")

-- GET request to /
aurora.get("/", function()
    return { body = "index", status = 200 }
end)

aurora.createServer() -- runs the server on port 8080
```

### [Getting started](https://docs.page/jonasarensmann/aurora/getting-started)

<br>

### At the moment, html special characters are not escaped automatically. This will be changed in the future.

use `aurora.escapeHtml` to escape html special characters.
