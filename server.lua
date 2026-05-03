peripheral.find("modem", rednet.open)

while true do
    local id, message, request = rednet.receive()
    if request == "PING" then
        rednet.send(id, "PONG", "PING")
    end
    if request == "GET" then
        local file = fs.open(message, "r")
        if file == nil then
            print("e")
            rednet.send(id, false, "RESPONSE")
            return
        end
        print("t")
        local content = file.readAll()
        rednet.send(id, content, "RESPONSE")
        file.close()
    end
end