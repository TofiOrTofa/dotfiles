{ stable-pkgs, ... }:

let
  NORMAL_mode = key: action: {
    mode = "n";
    inherit key action;
    options = {
      silent = true;
      noremap = true;
    };
  };
in

{
  programs.nixvim = {
    enable = true;

    globals.mapleader = "\\<Space>";

    keymaps = [
      {
        mode = "n";
        key = "<leader>ff";
        action = ":NERDTreeToggle<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key =
      }{}
    ];
  };
}
