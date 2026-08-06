#!usr/bin/env lua

local json = require("cjson");
local socket = require("socket.unix");

local home = os.getenv("HOME");
package.path = home .. "/.config/sway/providers/?.lua;" .. package.path;
local swaySock = require("swaySocket");

swaySock:__init__();



local main = function ()
  swaySock:read({"window"});

  while true do
    local header = swaySock.client:receive(14);
    if not header then break end;
        
    local len = string.unpack("I4", header:sub(7, 10));
    local payload = swaySock.client:receive(len);
    local data = json.decode(payload);

    
    if data.change == "focus" then
      if data.container.rect.x>0 then
        print(string.format('{"text": " ", "class": "with-gaps"}'))
        io.stdout:flush()
      else
        print(string.format('{"text": " ", "class": "no-gaps"}'))
      end
      
    end
  end;
end;

if true then
  main();
end;