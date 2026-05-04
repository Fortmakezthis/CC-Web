shell.run("wget https://raw.githubusercontent.com/Fortmakezthis/CC-Web/refs/heads/main/wubDater.lua /wubDater.lua")
shell.run("wget https://raw.githubusercontent.com/Fortmakezthis/CC-Web/refs/heads/main/web/webUtils.lua /web/webUtils.lua")
shell.run("wget https://raw.githubusercontent.com/Fortmakezthis/CC-Web/refs/heads/main/server/server.lua /server/server.lua")
shell.run("wget https://raw.githubusercontent.com/Fortmakezthis/CC-Web/refs/heads/main/server/defaultIndex.lua /server/index.lua")

local web = require("/web/webUtils")

web.writeFile("/startup.lua", [[
print("Starting server...")
shell.run("/server/server.lua")
]])

print("Server installed! Please restart the computer to start the server.")
