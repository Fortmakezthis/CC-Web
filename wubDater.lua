local webUtilsNEW = http.get("https://raw.githubusercontent.com/Fortmakezthis/CC-Web/refs/heads/main/web/webUtils.lua").readAll()
local webNEW = http.get("https://raw.githubusercontent.com/Fortmakezthis/CC-Web/refs/heads/main/web.lua").readAll()
local pageUtilsNEW = http.get("https://raw.githubusercontent.com/Fortmakezthis/CC-Web/refs/heads/main/web/pageUtils.lua").readAll()
local miteNEW = http.get("https://raw.githubusercontent.com/Fortmakezthis/CC-Web/refs/heads/main/web/mite.lua").readAll()
local webUtils = fs.open("/web/webUtils.lua", "r")
local web = fs.open("/web.lua", "r")
local pageUtils = fs.open("/web/pageUtils.lua", "r")
local mite = fs.open("/web/mite.lua", "r")
local webUtilsContent, webContent, pageUtilsContent, miteContent
if webUtils then
    webUtilsContent = webUtils.readAll()
    webUtils.close()
else
    print("WebUtils not found, creating new one...")
    webUtils = fs.open("/web/webUtils.lua", "w")
    webUtils.write(webUtilsNEW)
end
if web then
    webContent = web.readAll()
    web.close()
else
    print("Web not found, creating new one...")
    web = fs.open("/web.lua", "w")
    web.write(webNEW)
    web.close()
end
if pageUtils then
    pageUtilsContent = pageUtils.readAll()
    pageUtils.close()
else
    print("PageUtils not found, creating new one...")
    pageUtils = fs.open("/web/pageUtils.lua", "w")
    pageUtils.write(pageUtilsNEW)
    pageUtils.close()
end
if mite then
    miteContent = mite.readAll()
else
    print("Mite not found, creating new one...")
    mite = fs.open("/web/mite.lua", "w")
    mite.write(miteNEW)
    mite.close()
end

if webNEW == webContent then
    print("Web is up to date!")
else
    print("Web is not up to date!")
    local file = fs.open("/web.lua", "w")
    file.write(webNEW)
    file.close()
end

if webUtilsNEW == webUtilsContent then
    print("WebUtils is up to date!")
else
    print("WebUtils is not up to date!")
    local file = fs.open("/web/webUtils.lua", "w")
    file.write(webUtilsNEW)
    file.close()
end

if pageUtilsNEW == pageUtilsContent then
    print("PageUtils is up to date!")
else
    print("PageUtils is not up to date!")
    local file = fs.open("/web/pageUtils.lua", "w")
    file.write(pageUtilsNEW)
    file.close()
end

if miteNEW == miteContent then
    print("Mite is up to date!")
else
    print("Mite is not up to date!")
    local file = fs.open("/web/mite.lua", "w")
    file.write(miteNEW)
    file.close()
end
