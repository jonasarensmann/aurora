local fs = require("@lune/fs")

local errorPage = require("errorPage.luau")

local function escapeHtml(str: string)
    str:gsub("&", "&amp;")
    str:gsub("<", "&lt;")
    str:gsub(">", "&gt;")
    str:gsub('"', "&quot;")
    str:gsub("'", "&#39;")
    return str    
end

local function renderHtml(html: string, keys: { [string]: string | {any} | number }?): string
    local template = fs.readFile(html)

    if not template then
        if _G.config.debug then 
            return errorPage(500, "The html file " .. html  .. " does not exist.")
        else
            return errorPage(500, "Internal Server Error")
        end
    end
    
    if keys then 
        for key, value in pairs(keys) do
            template = template:gsub("{{" .. key .. "}}", value)
            template = template:gsub("{{ " .. key .. " }}", value)
        end

        for single, list, innerHtml in string.gmatch(template ,"{{#foreach (.-) in (.-)}}(.-){{#endforeach}}") do
            local listValue
            for index, value in pairs(keys) do 
                if index == list then
                    listValue = value
                end
            end

            if listValue == nil then
                if _G.config.debug then 
                    return errorPage(500, "The list " .. list .. " is not defined in the keys table.")
                else 
                    return errorPage(500, "Internal Server Error")
                end
            end

            local fullHtml = ""
            for _, item in ipairs(listValue) do
                innerHtml = innerHtml:gsub("%s+", "")

                if string.match(innerHtml, "{{" .. single .. "}}") then
                    fullHtml = fullHtml .. string.gsub(innerHtml, "{{" .. single .. "}}", item)
                end

                if string.match(innerHtml, "{{ " .. single .. " }}") then
                    fullHtml = fullHtml .. string.gsub(innerHtml, "{{ " .. single .. " }}", item)
                end
            end

            template = string.gsub(template , "{{#foreach (.-) in (.-)}}(.-){{#endforeach}}", fullHtml, 1)
            
        end
    end

    return template
end

return {
    renderHtml = renderHtml,
    htmlspecialchars = escapeHtml
}