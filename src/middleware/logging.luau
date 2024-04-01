local fs = require("@lune/fs")
local dateTime = require("@lune/datetime")

local types = require("../types")

return function (request: types.Request, logToFile: boolean, logFilePath: string?)
    local a = ""
    for i,v in pairs(request.headers["user-agent"]) do 
        a = a .. string.char(v)
    end

    local log = dateTime.now():toIsoDate() .. " " .. request.method .. " " .. request.path .. " " .. a .. "\n"
    if logToFile and logFilePath then 
        if not fs.isFile(logFilePath) then
            fs.writeFile(logFilePath, "")
        end
        local logFile = fs.readFile(logFilePath)
        log = logFile .. log
        fs.writeFile(logFilePath, log)
        return
    else
        print(log)
    end
end