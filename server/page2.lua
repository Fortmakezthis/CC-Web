local web = require("/web/webUtils")
print("Hi! I'm page2! Would yo like to go back to page 1? Y/N")
term.write("> ")
if string.lower(read()) == "y" then
    web.getPage("/server/index.lua", 3)
    shell.run("/web/webCache/3/server/index.lua")
    return
end
