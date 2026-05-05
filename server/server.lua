peripheral.find("modem", rednet.open)
local web = require("/web/webUtils")

shell.run("/wubDater")

while true do
    web.getRequests()
end
