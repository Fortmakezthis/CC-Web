local args = {...}
local fe = require("/web/pageUtils")
local web = require("/web/webUtils")

local buttons = {}
local gets = {}

function parse(code)
    for line in string.gmatch(code, "([^\n]+)") do
        if line:sub(1, 5) == "text(" then
            local text, x, y, color = line:match('text%s*%(%s*["\']([^"\']+)["\']%s*,%s*(%d+)%s*,%s*(%d+)%s*,?%s*c?o?l?o?r?s?%.?(%w+)%)')
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
            local text, x, y, url, mite = line:match('rediText%s*%(%s*["\']([^"\']+)["\']%s*,%s*(%d+)%s*,%s*(%d+)%s*,%s*["\']([^"\']+)["\']%s*,%s*(%a+)%s*%)')
            if text and x and y and url and mite then
                mite = mite == "true"
                fe.cText(text, tonumber(x), tonumber(y), colors.blue)
                table.insert(buttons, {x = tonumber(x), y = tonumber(y), w = #text, h = 1, type = "url", url = url, mite = mite})
            end
        elseif line:sub(1, 7) == "exText(" then
            local text, x, y, url, irl, localFile, color = line:match('exText%s*%(%s*["\']([^"\']+)["\']%s*,%s*(%d+)%s*,%s*(%d+)%s*,%s*["\']([^"\']+)["\']%s*,%s*["\']?([^"\',]+)["\']?%s*,%s*(%a+)%s*,?%s*c?o?l?o?r?s?%.?(%w*)%s*%)')
            if text and x and y and url and irl and localFile then
                irl = irl == "true"
                localFile = localFile == "true"
                if color then
                    fe.cText(text, tonumber(x), tonumber(y), colors[color])
                    table.insert(gets, {x = tonumber(x), y = tonumber(y), url = url, gotten = false, irl = irl, localFile = localFile, text = text, color = colors[color]})
                else
                    fe.cText(text, tonumber(x), tonumber(y), colors.white)
                    table.insert(gets, {x = tonumber(x), y = tonumber(y), url = url, gotten = false, irl = irl, localFile = localFile, text = text, color = colors.white})
                end
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
                            fe.pageRedirect(button.url, true, button.mite)
                            break
                        end
                    end
                end
            end
        end
        sleep(0)
    end
end

function getGets()
    while true do
        local event = os.pullEventRaw()
        if event == "terminate" then
            fe.display.clear()
            return
        end
        for i, get in ipairs(gets) do
            sleep(0)
            if get.gotten == false then
                if get.localFile then
                    local file = fs.open(get.url, "r")
                    if fs.exists(get.url) then
                        local content = file.readAll()
                        fe.cText(content, get.x, get.y, get.color)
                        get.gotten = true
                        file.close()
                    end
                end
                if get.irl == false then
                    local result = web.GET(get.url, 0.1)
                    if result then
                        fe.cText(result, get.x, get.y, get.color)
                        get.gotten = true
                    end
                else
                    local request = http.get(get.url)
                    if request then
                        fe.cText(request.readAll(), get.x, get.y, get.color)
                        request.close()
                    end
                end
            end
        end
    end
end

if #args > 0 then
    if args[1]:lower() == "path" then
        if #args > 1 then
            local file = fs.open(args[2], "r")
            local code = file.readAll()
            file.close()
            parallel.waitForAll(getButtons, getGets, function() parse(code) end)
        else
            print("Invalid argument: " .. args[1])
            return
        end
    else
        local code = table.concat(args, " ") .. "\n"
        parallel.waitForAll(getButtons, getGets, function() parse(code) end)
    end
end