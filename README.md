# CC-Web
This is a repository to store files for my Web project for CC: Tweaked, a programmable computer Minecraft mod.

# How to install
There are two ways to install web and webUtils. The first is downloading wubDater.lua from here, dragging it onto a computer in Minecraft, and running it.
The second is running
```lua
wget https://raw.githubusercontent.com/Fortmakezthis/CC-Web/refs/heads/main/wubDater.lua
```

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
