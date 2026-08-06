{ stable-pkgs, unstable-pkgs, nixgl, ... }:

{
    home.packages = with stable-pkgs; [
      pyright
      nodejs
      ruff
      mypy
    ];

  programs.vim = {
    enable=true;
    extraConfig = ''
      ${builtins.readFile ./dots/configs/vim/vimrc}
      ${builtins.readFile ./dots/configs/vim/binds.vim}
    '';
	};
	programs.emacs = {
		enable=true;
		extraPackages = epkgs: with epkgs; [
			sly
		];
		extraConfig = builtins.readFile ./dots/configs/emacs/init.el;
	};

  home.file.".vim/coc-settings.json".text = builtins.toJSON {
    "suggest.autoTrigger" = "none";
    "python.linting.mypyEnabled" = true;
    "python.linting.enabled" = true;
    "ruff.enable" = true;
    "editor.formatOnSave" = true;

    # --- ВОТ ЭТО ОТКЛЮЧИТ ПОДСКАЗКИ ТИПОВ (Inlay Hints) ---
    "inlayHint.enable" = false;
    "python.analysis.inlayHints.variableTypes" = false;
    "python.analysis.inlayHints.functionReturnTypes" = false;
    "python.analysis.inlayHints.callArgumentNames" = false;
    "python.analysis.inlayHints.parameterTypes" = false;
  };
}
