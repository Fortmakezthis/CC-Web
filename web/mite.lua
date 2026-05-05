local args = {...}
local fe = require("/web/pageUtils")

local buttons = {}

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
        elseif line:sub(1, 9) == "rediText(" then
            local text, x, y, url, mite = line:match('rediText%("([^"]+)"%s*,%s*(%d+)%s*,%s*(%d+)%s*,%s*"([^"]+)"%s*,%s*(%a+)%s*%)')
            if text and x and y and url and mite then
                mite = mite == "true"
                fe.cText(text, tonumber(x), tonumber(y), colors.blue)
                table.insert(buttons, {x = tonumber(x), y = tonumber(y), w = #text, h = 1, type = "url", url = url, mite = mite})
            end
        end
    end
end

function getButtons()
    while true do
        local event, mb, x, y = os.pullEventRaw()
        if event == "terminate" then
            fe.display.clear()
            return
        elseif event == "mouse_click" then
            if mb == 1 then
                for i, button in ipairs(buttons) do
                    if x >= button.x and x <= button.x + button.w and y >= button.y and y <= button.y + button.h - 1 then
                        if button.type == "url" then
                            fe.pageRedirect(button.url, false, button.mite)
                            break
                        end
                    end
                end
            end
        end
        sleep(0)
    end
end

if #args > 0 then
    if #args > 1 then
        if args[2]:lower() == "path" then
            local file = fs.open(args[1], "r")
            local code = file.readAll()
            file.close()
            parallel.waitForAll(getButtons, parse(code))
        else
            print("Invalid argument: " .. args[2])
            return
        end
    else
        local code = args[1]
        parallel.waitForAll(getButtons, parse(code))
    end
end
