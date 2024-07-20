local aurora = require("../../src")
local fs = require("@lune/fs")
local process = require("@lune/process")

local function randomString(length)
    local str = ""
    for i = 1, length do
        str = str .. string.char(math.random(97, 122))
    end
    return str
end

local function getFileName()
    local fileName = randomString(10)
    if fs.isFile(process.cwd .. "uploads/" .. fileName) then
      return getFileName()
    end
    return fileName
end

aurora.get("/", function(req, res)
    local fileName = req.query.id 

    if not fileName then 
        res.html("index.html")
        return
    end

    if not fs.isFile(process.cwd .. "uploads/" .. fileName) then
        res.setStatus(404)
        res.send("File not found")
        return
    end

    local file = fs.readFile(process.cwd .. "uploads/" .. fileName)

    res.send(file)
end)

aurora.post("/upload", function(req, res)
    local fileName = getFileName()

    if not req.body then
        res.status(400)
        res.send("Body is required")
        return
    end

    local content = string.gsub(req.body, "content=", "")

    fs.writeFile(process.cwd .. "uploads/" .. fileName, content)

    res.redirect("/?id=" .. fileName)
end)

aurora.serve({
    port = 8080,
})
