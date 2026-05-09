{ config, ... }:

let
  i3 = {
    ".config/i3".source = ./dots/archive/i3;
  };
  niri = {
    ".config/niri".source = ./dots/archive/niri;
  };
  sway = {
    ".config/sway".source = ./dots/sway;
  };


  nvim = {
    ".config/nvim/lua/config/autocmds.lua".source = ./dots/archive/nvim/lua/config/autocmds.lua;
    ".config/nvim/lua/config/keymaps.lua".source = ./dots/archive/nvim/lua/config/keymaps.lua;
    ".config/nvim/lua/config/lazy.lua".source = ./dots/archive/nvim/lua/config/lazy.lua;
    ".config/nvim/lua/config/options.lua".source = ./dots/archive/nvim/lua/config/options.lua;

    ".config/nvim/plugins/blink.lua".source = ./dots/archive/nvim/lua/plugins/blink.lua;
    ".config/nvim/plugins/cmp.lua".source = ./dots/archive/nvim/lua/plugins/cmp.lua;
    ".config/nvim/plugins/example.lua".source = ./dots/archive/nvim/lua/plugins/example.lua;
    ".config/nvim/plugins/lsp.lua".source = ./dots/archive/nvim/lua/plugins/lsp.lua;
    ".config/nvim/plugins/noice.lua".source = ./dots/archive/nvim/lua/plugins/noice.lua;
    ".config/nvim/plugins/ui.lua".source = ./dots/archive/nvim/lua/plugins/ui.lua;

    ".config/nvim/.neoconf.json".source = ./dots/archive/nvim/.neoconf.json;
    ".config/nvim/init.lua".source = ./dots/archive/nvim/init.lua;
    ".config/nvim/lazy-lock.json".source = ./dots/archive/nvim/lazy-lock.json;
    ".config/nvim/lazyvim.json".source = ./dots/archive/nvim/lazyvim.json;
    ".config/nvim/LICENSE".source = ./dots/archive/nvim/LICENSE;
    ".config/nvim/stylua.toml".source = ./dots/archive/nvim/stylua.toml;
  };
  VSCodium = {
    ".config/VSCodium/User/extensions".source = ./dots/VSCodium/User/extensions;
    ".config/VSCodium/User/snippets".source = ./dots/VSCodium/User/snippets;

    ".config/VSCodium/User/extensions.txt".source = ./dots/VSCodium/User/extensions.txt;
    ".config/VSCodium/User/keybindings.json".source = ./dots/VSCodium/User/keybindings.json;
    ".config/VSCodium/User/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/comu/.config/home-manager/dots/VSCodium/User/settings.json";
    };
  };


  polybar = {
    ".config/polybar".source = ./dots/archive/polybar;
  };
  waybar = {
    ".config/waybar/niri".source = ./dots/waybar/niri;
    ".config/waybar/sway".source = ./dots/waybar/sway;
  };

  rofi = {
    ".config/rofi".source = ./dots/archive/rofi;
  };
  wofi = {
    ".config/wofi".source = ./dots/wofi;
  };


  picom = {
    ".config/picom".source = ./dots/archive/picom;
  };
  zram = {
    ".config/zram".source = ./dots/zram;
  };

  zsh = {
    ".zshrc".source = ./dots/zsh/config.sh;
  };
in

{
  imports = [
    ./dots/fastfetch/config.nix
  ];


  home.file = sway // nvim // VSCodium // waybar // wofi // zram // zsh;
}