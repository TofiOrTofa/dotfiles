{ config, pkgs, ... }:

{
  xdg.enable = true;

  xdg.desktopEntries = {
    "org.freesmlauncher.FreesmLauncher" = {
      name = "Freesm Launcher (Wayland)";
      
      # ДОБАВЛЕНО: принудительный запуск lwjgl на нативной платформе wayland через флаг java
      exec = "env WAYLAND_DISPLAY=wayland-0 _JAVA_AWT_WM_NONREPARENTING=1 SDL_VIDEODRIVER=wayland-0_DISABLED forced_platform=wayland /usr/bin/freesmlauncher";
      
      icon = "org.freesmlauncher.FreesmLauncher";
      type = "Application";
      categories = [ "Game" ];
      settings = {
        StartupWMClass = "org.freesmlauncher.FreesmLauncher";
      };
    };
  };
}

