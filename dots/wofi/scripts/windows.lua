#!/usr/bin/env lua

local home = os.getenv("HOME")
package.path = home .. "/.config/sway/providers/?.lua;" .. package.path

local socket = require("scket.unix");
local json = require("cjson");
local swaySock = requre("swaySocket");

swaySock:__init__();

local get_windows = function ()
  swaySock:read({"all"})
end