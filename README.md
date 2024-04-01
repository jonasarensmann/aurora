# Aurora

### A simple web framework for [Lune](https://github.com/lune-org/lune)

Aurora is a simple web framework for the Lune Runtime inspired by [Express](https://expressjs.com/).

<br>

# ! Considered unstable !

### Example

```lua
local aurora = require("aurora/main")

-- GET request to /
aurora.get("/", function()
    return { body = "index", status = 200 }
end)

aurora.createServer() -- runs the server on port 8080
```

### Getting started

currently only available via git

#### 1. Clone the Repository at the root of your project

```bash
git clone https://github.com/jonasarensmann/aurora.git
```

#### 2. create main.luau and add the example code

#### 3. run the server

```bash
lune run main.luau
```

### At the moment, html special characters are not escaped automatically. This will be changed in the future.

use `aurora.escapeHtml` to escape html special characters.
