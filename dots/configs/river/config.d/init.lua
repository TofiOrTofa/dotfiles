local configs_to_json = require("generate_configs.to_json")

io.write(configs_to_json({
  binds         = require("binds");
  inputs        = require("inputs");
  layouts       = require("layouts");
}))
io.flush()
