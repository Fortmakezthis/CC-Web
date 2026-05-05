local web = {}
web.currentUrl = nil
web.currentDomain = nil
web.currentID = nil
web.dnsId = 2
web.sites = {}

rednet.send(web.dnsId, "siteList")
local _, sites = rednet.receive(nil, 0.1)
if sites == nil then
    print("DNS SERVER TIMED OUT! OH MY GOD! WHO THE HELL TOUCHED THE DNS SERVER?!?!?\nOh yeah, make sure dnsId is a valid DNS... and make sure the DNS server is approved by Tozik LLC.")
else
    web.sites = sites
end

function web.splitUrl(url)
    local domain, path = string.match(url, "([^/]+)/(.*)")
    if path == nil then domain = url end
    return {
        domain = domain,
        path = path
    }
end

function web.getID(siteUrl)
    siteUrl = web.splitUrl(siteUrl).domain
    for i, site in ipairs(web.sites) do
        if site["url"] == siteUrl then
            return site["id"]
        end
    end
    return nil
end

function web.GET(url)
    local host, path = web.splitUrl(url)
    rednet.send(web.getID(host), path, "GET")
    local _, response = rednet.receive("RESPONSE", 5)
    if response == nil then
        return nil
    elseif response == false then
        return false
    else
        return response
    end
end

function web.POST(url, body)
    local host, path = web.splitUrl(url)
    rednet.send(web.getID(host), {path = path, body = body}, "POST")
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
    local ID, message, request = rednet.receive()
    if request == "PING" then
        rednet.send(ID, "PONG", "PING")
        return "PING"
    elseif request == "GET" then
        local file = fs.open(message, "r")
        if file == nil then
            rednet.send(ID, false, "RESPONSE")
            return {
                ID = ID,
                path = message,
                success = true
            }
        end
        local content = file.readAll()
        rednet.send(ID, content, "RESPONSE")
        file.close()
    elseif request == "POST" then
        local file = fs.open(message.path, "w")
        if file == nil then
            rednet.send(ID, false, "RESPONSE")
            return {
                ID = ID,
                success = false
            }
        else
            file.write(message.body)
            rednet.send(ID, true, "RESPONSE")
            file.close()
            return {
                ID = ID,
                path = message.path,
                body = message.body,
                success = true
            }
        end
    end
end

function web.writeFile(path, content)
    local file = fs.open(path, "w")
    file.write(content)
    file.close()
end

function web.getPage(path)
    local host, filePath = string.match(path, "([^/]+)/(.*)")
    local ID = web.getID(host)
    if ID == nil then
        return nil
    end
    local response = web.GET(path)
    if response == nil then
        return nil
    elseif response == false then
        return false
    else
        web.writeFile("/web/webCache/" .. ID .. "/" .. filePath, response)
        return true
    end
end

return web
