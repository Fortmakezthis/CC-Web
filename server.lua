peripheral.find("modem", rednet.open)
local web = require("/webUtils")

while true do
    web.getRequests()
end