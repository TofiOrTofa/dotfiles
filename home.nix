# Добавляем pkgs и inputs в аргументы
{ stable-pkgs, unstable-pkgs, lib, ... }:


let

  stable_pkgs = (with stable-pkgs; [

    neofetch
    khal
    foot

    (python3.withPackages (ps: with ps; [
      autopep8
    ]))
    pipx

    (lua.withPackages (ps: with ps; [
      cjson
    ]))

    gcc

    glibcLocales
    ultimate-oldschool-pc-font-pack


    rivercarro
    stacktile
    river-bsp-layout

    nickel

  ]);
  unstable_pkgs = (with unstable-pkgs; [

    cava
    zellij
    tmux

  ]);

in


{
  imports = [
    ./config-files.nix
    ./script-files.nix
    ./settings-files.nix
    ./applications.nix
  ];
  targets.genericLinux.enable         = true;
  xdg.enable                          = true;
  fonts.fontconfig.enable             = true;
  programs                            = {
    home-manager.enable                 = true;
    fzf                                 = {
      enable                              = true;
      enableZshIntegration                = true;
                                        };
                                      };

  i18n.glibcLocales = unstable-pkgs.glibcLocales.override {
    allLocales = false;
    locales = [ "en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" ];
  };

  home = {
    username                        = "comu";
    homeDirectory                   = "/home/comu";
    stateVersion                    = "23.11";
    preferXdgDirectories = true;
    packages = stable_pkgs ++ unstable_pkgs;
    sessionVariables = {
      TZ = "Asia/Yekaterinburg";
      TZDIR = "${unstable-pkgs.tzdata}/share/zoneinfo";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      LOCALE_ARCHIVE = 
        "${unstable-pkgs.glibcLocales}/lib/locale/locale-archive";
    };
    language = {
      base                          = "en_US.UTF-8";
      time                          = "ru_RU.UTF-8";
      numeric                       = "ru_RU.UTF-8";
      monetary                      = "ru_RU.UTF-8";
    };
    file.".inputrc".text = ''
      set meta-flag on
      set input-meta on
      set output-meta on
      set convert-meta off
    '';
  };
  home.activation = {
    linkDesktopApplications = lib.hm.dag.entryAfter ["writeBoundary"] ''
      unset PATH
      export PATH="/usr/bin:/bin"
      nix_applications="$HOME/.nix-profile/share/applications"
      system_application="$HOME/.local/share/applications"
      if [ -d $nix_applications ]; then
        rm -rf "$HOME/.local/share/applications/home-manager"
        mkdir -p "$HOME/.local/share/applications/home-manager"
        ln -sf "$HOME/.nix-profile/share/applications"/* "$HOME/.local/share/applications/home-manager/"
      fi
    '';
  };

  nixpkgs.config.allowUnfree = true;
}
