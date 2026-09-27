local configs_to_json = require("cjson").encode
local home = os.getenv("HOME") or "/home/comu"
local config_path = home .. "/.dotfiles/configs/river/config.d"
package.path = config_path .. "/?.lua;" .. package.path

io.write(configs_to_json({
  inputs        = require "inputs",
  layouts       = require "layouts",
  keybindings   = require "binds",
  autostart     = require "autostart",
}))
io.flush()
