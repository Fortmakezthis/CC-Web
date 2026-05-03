peripheral.find("modem", rednet.open)

while true do
    local id, message, request = rednet.receive()
    if request == "PING" then 
        rednet.send(id, "PONG", "PING")
    end
    if message == "siteList" then
        local file = fs.open("dns/sites.json", "r")
        local content = file.readAll()
        local data = textutils.unserializeJSON(content)
        rednet.send(id, data, "siteList")
    end
end
