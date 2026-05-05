local args = {...}
local fe = require("/web/pageUtils")

function parse(code)
    for line in string.gmatch(code, "([^\n]+)") do
        if line:sub(1, 5) == "text(" then
            local text, x, y, color = line:match('text%("([^"]+)"%s*,%s*(%d+)%s*,%s*(%d+)%s*,?%s*c?o?l?o?r?s?%.?(%w*)%)')
            if text and x and y then
                if color ~= "" then
                    fe.cText(text, tonumber(x), tonumber(y), colors[color])
                else
                    fe.cText(text, tonumber(x), tonumber(y), colors.white)
                end
            end
        elseif line:sub(1, 4) == "box(" then
            local x, y, w, h, color = line:match('box%(%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)%s*,?%s*c?o?l?o?r?s?%.?(%w*)%)')
            if x and y and w and h then
                if color ~= "" then
                    fe.drawBox(tonumber(x), tonumber(y), tonumber(w), tonumber(h), colors[color])
                else
                    fe.drawBox(tonumber(x), tonumber(y), tonumber(w), tonumber(h), colors.white)
                end
            end
        elseif line:sub(1, 8) == "rediText(" then
            local text, x, y, url = line:match('rediText%("([^"]+)"%s*,%s*(%d+)%s*,%s*(%d+)%s*,%s*"([^"]+)"%)')
            if text and x and y and url then
                fe.cText(text, tonumber(x), tonumber(y), colors.blue)
            end
        end
    end
end

if #args > 0 then
    if #args > 1 then
        if args[2]:lower() == "path" then
            local file = fs.open(args[1], "r")
            local code = file.readAll()
            file.close()
            parse(code)
            while true do
                local event, param1, param2, param3 = os.pullEvent()
                if event == "terminate" then
                    break
                end
            end
        else
            print("Invalid argument: " .. args[2])
            return
        end
    else
        local code = args[1]
        parse(code)
        while true do
            local event, param1, param2, param3 = os.pullEvent()
            if event == "terminate" then
                break
            end
        end
    end
end
