# Добавляем pkgs и inputs в аргументы
{ stable-pkgs, unstable-pkgs, lib, ... }:

{
  imports = [
    ./files.nix
  ];
  
  home.username = "comu";
  home.homeDirectory = "/home/comu";
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
  manual.manpages.enable = false;
  targets.genericLinux.enable = true;

  home.packages = 
    (with stable-pkgs; [


      waybar
      python3
      lua
      gcc
    ])
    ++
    (with unstable-pkgs; [
      glibcLocales
    ]);
  
  home.sessionVariables = {
    LOCALE_ARCHIVE = "${unstable-pkgs.glibcLocales}/lib/locale/locale-archive";
    TZ = "Asia/Yekaterinburg"; 
  };

  home.activation = {
    linkDesktopApplications = lib.hm.dag.entryAfter ["writeBoundary"] ''
      unset PATH
      export PATH="/usr/bin:/bin"
      if [ -d "$HOME/.nix-profile/share/applications" ]; then
        rm -rf "$HOME/.local/share/applications/home-manager"
        mkdir -p "$HOME/.local/share/applications/home-manager"
        ln -sf "$HOME/.nix-profile/share/applications"/* "$HOME/.local/share/applications/home-manager/"
      fi
    '';
  };

  nixpkgs.config.allowUnfree = true; # Zed и некоторые драйверы могут быть несвободными
  nixpkgs.config.allowCollisions = true;
}
