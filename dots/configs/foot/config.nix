{ pkgs, ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        dpi-aware = true;
        font = "Terminus:size=16";
# "PxPlus IBM VGA 8x16:size=16";
# "Terminus:size=26";
        pad = "8x16";
      };

      cursor = {
        style = "underline";
        blink = "no";
        underline-thickness = "2px";
        color = "e8f5e8 ffffff";
      };

      colors = {
        background = "2e3440";
        foreground = "e8f5e8";

        regular0 = "3b4252";
        regular1 = "bf616a";
        regular2 = "a3be8c";
        regular3 = "ebcb8b";
        regular4 = "81a1c1";
        regular5 = "b48ead";
        regular6 = "88c0d0";
        regular7 = "e5e9f0";

        bright0 = "4c566a";
        bright1 = "bf616a";
        bright2 = "a3be8c";
        bright3 = "ebcb8b";
        bright4 = "81a1c1";
        bright5 = "b48ead";
        bright6 = "8fbcbb";
        bright7 = "eceff4";

        selection-background = "4c566a";
        selection-foreground = "d8dee9";
      };
    };
  };
}

