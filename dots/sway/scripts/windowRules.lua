#!/usr/bin/env lua

local home = os.getenv("HOME")
package.path = home .. "/.config/sway/providers/?.lua;" .. package.path

local socket = require("socket.unix");
local json = require("cjson");
local swaySock = require("swaySocket");

swaySock:__init__();


local app = {
    ["focus"] = {
        ["Alacritty"] = function()
            swaySock:write("input type:keyboard xkb_switch_layout 0")
        end,
        ["codium"] = function()end,
    },
    ["lastFocus"] = {
        ["Alacritty"] = function()end,
        ["codium"] = function()end,
    }
};

local main = function ()
    swaySock:read({"window"});

    while true do
        -- Читаем заголовок (14 байт)
        local header = swaySock.client:receive(14);
        //print(header);
        if not header then break end;
        
        local len = string.unpack("I4", header:sub(7, 10));
        //print(len);
        local payload = swaySock.client:receive(len);
        //print(payload);
        local data = json.decode(payload);
        //print(data);
        local change = app[data.change];
        //print(change);

        if change then
            if change[lastApp] then
                change[lastApp]();
            end;
            if change[data.container.app_id] then
                change[data.container.app_id]();
            end;
            local lastApp = data.container.app_id;
        end;
    end;
end;main();




