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
          pacman = true;
          nix = true;
          #nix = "/home/comu/.nix-profile/bin";
          #format = "{1} (pacman), {4} (nix)";
        }
        {
          type = "command";
          key = " └─ emerge"; # Красивый отступ под строкой Packages
          # Считаем количество установленных пакетов в базе данных Portage
          text = "ls -d /home/comu/gentoo/var/db/pkg/*/* 2>/dev/null | wc -l";
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
