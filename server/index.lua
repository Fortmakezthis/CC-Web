local web = require("/web/webUtils")
print("Hello! Would you like to redirect to page2? Y/N")
term.write("> ")
if string.lower(read()) == "y" then
    web.getPage("/server/page2.lua", 3)
    shell.run("/web/webCache/3/server/page2.lua")
    return
else
    print("Okay, goodbye!")
end
