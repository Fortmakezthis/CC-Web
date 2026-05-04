local modem = peripheral.find("modem")
peripheral.find("modem", rednet.open)

term.clear()
term.setCursorPos(1, 1)
if fs.exists("/web/basalt.lua") == false then
    print("Basalt is not installed!!!\nDo you wish to install from the internet? Y/N")
    if string.lower(read()) == "y" then
        print("Downloading...")
        shell.run("wget run https://raw.githubusercontent.com/Pyroxenium/Basalt2/main/install.lua -r /web/basalt.lua")
    else
        print("Proceeding, some servers may not work without basalt!")
    end
end

if modem then
    print("Wireless modem found!")
else
    print("No modem found!")
end

local web = require("/web/webUtils")

print("Only authorized servers will be listed, if you want to add a server, contact Tozik LLC. to add it to the list!")
print("Site list:")
for i, site in ipairs(web.sites) do
    local status = web.PING(site["id"])
    if status == true then
        print(site["url"] .. " - Online")
    else
        print(site["url"] .. " - Offline")
    end
end

while true do
    print("Enter server url (Domain).(TLD) example: obama.tz")
    web.currentUrl = read():lower()
    web.currentId = web.getID(web.currentUrl)
    if web.currentId == nil then
        print("Not a valid server!")
    else
        print("Requesting index...")
        web.getPage("/server/index.lua", web.currentId)
        shell.run("/web/webCache/" .. web.currentId .. "/server/index.lua")
    end
end
