peripheral.find("modem", rednet.open)
local web = require("/web/webUtils")

while true do
    web.getRequests()
end
