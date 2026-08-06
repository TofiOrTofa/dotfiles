{ config, ... }:

let
  sway = {
    ".config/sway/config".source = ./dots/configs/sway/config_mods;
    ".config/sway/config.d".source = ./dots/configs/sway/config.d;
  };
  river = {
    ".config/river".source = ./dots/configs/river;
  };

  vim = {
    ".vim/autoload" = {
      source =  ./dots/configs/vim/runtime/autoload;
      recursive = true;
    };
    ".vim/ftplugin".source = ./dots/configs/vim/runtime/ftplugin;
    ".vim/after".source = ./dots/configs/vim/runtime/after;
    ".vim/templates".source = ./dots/configs/vim/runtime/templates;
  };
  VSCodium = {
    ".config/VSCodium/User/extensions".source = ./dots/configs/VSCodium/User/extensions;
    ".config/VSCodium/User/snippets".source = ./dots/configs/VSCodium/User/snippets;

    ".config/VSCodium/User/extensions.txt".source = ./dots/configs/VSCodium/User/extensions.txt;
    ".config/VSCodium/User/keybindings.json".source = ./dots/configs/VSCodium/User/keybindings.json;
    ".config/VSCodium/User/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/comu/.config/home-manager/dots/configs/VSCodium/User/settings.json";
    };
  };


  waybar = {
    ".config/waybar/config.jsonc".source = ./dots/configs/waybar/river/monitor_2k/FlatPowerline/config.jsonc;
    ".config/waybar/style.css".source = ./dots/configs/waybar/river/monitor_2k/FlatPowerline/style.css;
    ".config/waybar/colors.css".source = ./dots/configs/waybar/color_themes/nord/transparent-background.css;
};


  wofi = {
    ".config/wofi".source = ./dots/configs/wofi;
  };


  zram = {
    ".config/zram".source = ./dots/configs/zram;
  };
  psd = {
    ".config/psd/psd.conf".source = ./dots/configs/psd/psd.conf;
  };


  zsh = {
    ".zshrc".source = ./dots/configs/zsh/config.sh;
  };
  tmux = {
    ".config/tmux".source = ./dots/configs/tmux;
  };
in

{
  imports = [
    ./dots/configs/fastfetch/config.nix
    ./dots/configs/foot/config.nix
    ./dots/configs/fuzzel/fuzzel.nix
  ];


  home.file = river // vim // zram // waybar // wofi // tmux;
}
