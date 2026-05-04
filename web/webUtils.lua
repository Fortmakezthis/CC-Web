local web = {}
web.currentUrl = nil
web.currentId = nil
web.dnsId = 2
web.sites = {}

rednet.send(web.dnsId, "siteList")
local _, sites = rednet.receive(nil, 5)
if sites == nil then
    print("DNS SERVER TIMED OUT! OH MY GOD! WHO THE HELL TOUCHED THE DNS SERVER?!?!?\nOh yeah, make sure dnsId is a valid DNS... and make sure the DNS server is approved by Tozik LLC.")
else
    web.sites = sites
end

function web.splitUrl(url) return string.match(url, "([^/]+)/(.*)")

function web.getID(siteUrl)
    for i, site in ipairs(web.sites) do
        if site["url"] == siteUrl then
            return site["id"]
        end
    end
    return nil
end

function web.GET(path, ID)
    rednet.send(ID, path, "GET")
    local _, response = rednet.receive("RESPONSE", 5)
    if response == nil then
        return nil
    elseif response == false then
        return false
    else
        return response
    end
end

function web.POST(path, body, ID)
    rednet.send(ID, {path = path, body = body}, "POST")
    local _, response = rednet.receive("RESPONSE", 0.1)
    if response == nil then
        return nil
    else
        return response
    end
end

function web.PING(ID)
    rednet.send(ID, "PING", "PING")
    local _, response = rednet.receive("PING", 0.1)
    if response == "PONG" then
        return true
    else
        return false
    end
end

function web.getRequests()
    local id, message, request = rednet.receive()
    if request == "PING" then
        rednet.send(id, "PONG", "PING")
    elseif request == "GET" then
        local file = fs.open(message, "r")
        if file == nil then
            rednet.send(id, false, "RESPONSE")
            return
        end
        local content = file.readAll()
        rednet.send(id, content, "RESPONSE")
        file.close()
    elseif request == "POST" then
        local file = fs.open(message.path, "w")
        if file == nil then
            rednet.send(id, false, "RESPONSE")
            return
        else
            file.write(message.body)
            rednet.send(id, true, "RESPONSE")
            file.close()
        end
    end
end

function web.writeFile(path, content)
    local file = fs.open(path, "w")
    file.write(content)
    file.close()
end

function web.getPage(path, ID)
    local cacheFile = "/web/webCache/" .. ID .. "/" .. path
    if fs.exists(cacheFile) then
        return true
    end
    rednet.send(ID, path, "GET")
    local _, response = rednet.receive("RESPONSE", 5)
    if response == nil then
        return nil
    elseif response == false then
        return false
    else
        web.writeFile("/web/webCache/" .. ID .. "/" .. path, response)
        return true
    end
end
return web
