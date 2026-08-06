{ pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.foot}/bin/foot"; # Терминал по умолчанию для запуска CLI-приложений
        font = "JetBrainsMono:size=12";
        dpi-aware = "yes";
      };
      colors = {
        background = "1a1b26ff"; # Пример темы (Tokyo Night)
        text = "c0caf5ff";
        match = "f7768eff";
        selection = "33467cff";
        selection-text = "c0caf5ff";
      };
    };
  }; 
}
