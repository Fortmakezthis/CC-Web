local webUtilsNEW = http.get("https://raw.githubusercontent.com/Fortmakezthis/CC-Web/refs/heads/main/webUtils.lua").readAll()
local webNEW = http.get("https://raw.githubusercontent.com/Fortmakezthis/CC-web/refs/heads/main/web.lua").readAll()
local webUtils = fs.open("/web/webUtils.lua", "r")
local web = fs.open("/web.lua", "r")
if webUtils then
    local webUtilsContent = webUtils.readAll()
    webUtils.close()
else
    print("WebUtils not found, creating new one...")
    webUtils = fs.open("/web/webUtils.lua", "w")
    webUtils.write(webUtilsNEW)
end
if web then
    local webContent = web.readAll()
    web.close()
else
    print("Web not found, creating new one...")
    web = fs.open("/web.lua", "w")
    web.write(webNEW)
    web.close()
end

if webNew == webContent then
    print("Web is up to date!")
else
    print("Web is not up to date!")
    local file = fs.open("/web.lua", "w")
    file.write(webNEW)
    file.close()
end

if webUtilsNew == webUtilsContent then
    print("WebUtils is up to date!")
else
    print("WebUtils is not up to date!")
    local file = fs.open("/web/webUtils.lua", "w")
    file.write(webUtilsNEW)
    file.close()
end