shell.run("wget https://raw.githubusercontent.com/Fortmakezthis/CC-Web/refs/heads/main/dns/dns.lua /dns/dns.lua")
shell.run("wget https://raw.githubusercontent.com/Fortmakezthis/CC-Web/refs/heads/main/dns/sites.json /dns/sites.json")
shell.run("wget https://raw.githubusercontent.com/Fortmakezthis/CC-Web/refs/heads/main/web/webUtils.lua /web/webUtils.lua")

local web = require("/web/webUtils")

web.writeFile("/startup.lua", [[
print("Starting DNS...")
shell.run("/dns/dns.lua")
]])

print("DNS installed! Please restart the computer to start the DNS.")
