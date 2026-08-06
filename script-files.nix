{ config, ... }:

let
  river = {
    ".local/bin/layoutmenu".source = ./dots/scripts/river/layoutmenu.lua;
    ".local/bin/combining_tags".source = ./dots/scripts/river/combining_tags.sh;
    ".local/bin/window_add_tags".source = ./dots/scripts/river/window_add_tags.sh;
    ".local/bin/command_center".source = ./dots/scripts/river/commands.lua;
  };
in

{
#  imports = [];


  home.file = river;
}
