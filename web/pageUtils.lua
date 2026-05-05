local fe = {}

fe.display = nil
local monitor = peripheral.find("monitor")
fe.offsetX, fe.offsetY = 0, 0
fe.backgroundColor = colors.black
fe.textColor = colors.white

if monitor then
    fe.display = monitor
    term.redirect(fe.display)
else 
    fe.display = term
end

fe.display.clear()
fe.w, fe.h = fe.display.getSize()

function fe.cText(text, x, y, color)
    fe.display.setCursorPos(x + fe.offsetX, y + fe.offsetY)
    fe.display.setTextColor(color)
    fe.display.write(text)
    fe.display.setCursorPos(1, fe.h)
    fe.display.setTextColor(fe.textColor)
end

function fe.setOffset(x, y)
    fe.offsetX, fe.offsetY = x, y
end

function fe.drawBox(x, y, w, h, color, hollow)
    if hollow then
        paintutils.drawBox(x + fe.offsetX, y + fe.offsetY, x + w + fe.offsetX, y + h + fe.offsetY, color)
    else
        paintutils.drawFilledBox(x + fe.offsetX, y + fe.offsetY, x + w + fe.offsetX, y + h + fe.offsetY, color)
    end
    fe.display.setCursorPos(1, h)
    fe.display.setBackgroundColor(fe.backgroundColor)
end

local web = require("/web/webUtils")

function fe.pageRedirect(url, localFile, mite)
    if url then
        if localFile == true then
            if mite == true then
                shell.run("/web/mite.lua " .. url .. " path")
                return true
            else
                shell.run(url)
                return true
            end
        else
            if mite == true then
                shell.run("/web/mite.lua " .. web.GET(url) .. " path")
                return true
            else
                web.getPage(url)
                shell.run("/web/webCache/" .. web.getID(url) .. web.splitUrl(url).path)
                return true
            end
        end
    end
    return nil
end

return fe