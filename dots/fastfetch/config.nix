{ pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      display = {
        separator = "  ➜   ";
      };
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "uptime"
        {
          type = "packages";
          key = "Packages";
          nix = true;
          #nix = "/home/comu/.nix-profile/bin";
          #format = "{1} (pacman), {4} (nix)";
        }
        "display"
        "wm"
        "cpu"
        "gpu"
        "memory"
        "swap"
        "disk"
        "localip"
        "battery"
        "break"
        "colors"
      ];
    };
  };
}
