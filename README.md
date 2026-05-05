# CC-Web
This is a repository to store files for my Web project for CC: Tweaked, a programmable computer Minecraft mod.

# How to install web
There are two ways to install web and webUtils. The first is downloading wubDater.lua from here, dragging it onto a computer in Minecraft, and running it.
The second is running:
```lua
wget https://raw.githubusercontent.com/Fortmakezthis/CC-Web/refs/heads/main/wubDater.lua /wubDater.lua
```
To download the installer (And updater), then running it.

# How to install server
Same as first. Either download the files manually, or download and run this:
```lua
wget https://raw.githubusercontent.com/Fortmakezthis/CC-Web/refs/heads/main/serverInstaller.lua /serverInstaller.lua
```

# How to set up DNS server
Try to guess. Honestly. Yep, you guessed it. Either download the files manually, or download and run this:
```lua
wget https://raw.githubusercontent.com/Fortmakezthis/CC-Web/refs/heads/main/dnsInstaller.lua /dnsInstaller.lua
```
You *do* need to add sites to /dns/sites.json. Remember, only add sites that *you trust,* especially if you're on a server with other programmers.
Also, I *just* realized, the default DNS is ID 26, so uhm... yeah... I'll have to add a config thing. Because, since it auto updates, It'll reflect the DNS ID I put in webUtils on the repo.

# How to use webUtils.lua
At the top of every script, write:
```lua
local web = require("/web/webUtils") -- MAKE SURE TO NOT FORGET THE / AT THE BEGINNING, VERY IMPORTANT.
```
This will load all functions and variables to your script. (Reminder: You will have to do that again in every script that uses webUtils.)
To use functions and variables in webUtils, you'd be indexing web.
Example:
```lua
local web = require("/web/webUtils")
web.getPage("/server/index.lua", web.getID("obama.tz"))
shell.run("/web/webCache/4/server/index.lua") -- 4 Being the ID of obama.tz
```

# web.GET(path, ID)
