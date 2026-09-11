os.execute(require ("DotCF")
  .init ({
    vars = {
      font_size_bar = "14",
      color_utils = require("config_utils"),
      theme = require("theme")
    },
    files = {
      emacs = {src = "configs/emacs/init.el", target = "~/.emacs"},
      yambar = {
        src = "configs/yambar/config.yml", target = "~/.config/yambar/config.yml"},
      foot = {src = "configs/foot/config.ini", target = "~/.config/foot/foot.ini"}
    }
  })
  :read_templates ("yambar", "foot")
  :compile ()
  :chmod_ro ("emacs", "yambar", "foot")
  :to_bash ())
