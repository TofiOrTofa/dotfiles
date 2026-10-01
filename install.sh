#!/usr/bin/env sh
set -eu

DOTFILES="$HOME"/.dotfiles-test/dots
CONFIG="$HOME"/.config
SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)

. "$SCRIPT_DIR/utils_config.sh"

spawn_script_link "command-center" "wofi/commandCenter/main.lua"
spawn_script_link "compilate-template-text" \
  "compilate-template/compilate-template-text.lua"

write_config - "$CONFIG"/compilate-template-text/dotfiles.lua \
  < "$DOTFILES"/configs/compilate-template-text/dotfiles.lua

if command -v emacs > /dev/null 2>&1; then
  write_config - "$HOME/.emacs" < "$DOTFILES/configs/emacs/init.el"
fi
if command -v foot > /dev/null 2>&1; then
  cat "$DOTFILES"/configs/foot/config.ini \
    | compilate-template-text dotfiles \
    | write_config - "$CONFIG"/foot/foot.ini
fi
if command -v yambar > /dev/null 2>&1; then
  cat "$DOTFILES"/configs/yambar/config.yml \
    | compilate-template-text dotfiles \
    | write_config - "$CONFIG"/yambar/config.yml
fi
if command -v  river > /dev/null 2>&1; then
  spawn_script_link "generate-configs.river" "river/generate-configs.lua"
  spawn_script_link "combining-tags.river"   "river/combining-tags.sh"
  spawn_script_link "window-share.river"     "river/window-share.sh"
  spawn_script_link "layout-menu.river"      "river/layoutmenu.lua"

  write_config - "$CONFIG/river/init" < "$DOTFILES/configs/river/init"
  write_config - "$CONFIG/river/config.d/layouts.lua" \
    < "$DOTFILES/configs/river/config.d/layouts.lua"
fi
if command -v vim > /dev/null 2>&1; then
  write_config - "$HOME/.vimrc" < "$DOTFILES/configs/vim/vimrc"
  write_config - "$HOME/.vim/binds.vim" < "$DOTFILES/configs/vim/binds.vim"
  write_config - "$HOME/.vim/filetypes.vim" \
    < "$DOTFILES/configs/vim/filetypes.vim"
fi
if command -v zramctl > /dev/null 2>&1; then
  write_config - "$CONFIG/zram/zram-generator.conf" \
    < "$DOTFILES/configs/zram/zram-generator.conf"
fi
if command -v wofi > /dev/null 2>&1; then
  write_config - "$CONFIG/wofi/config" < "$DOTFILES/configs/wofi/config"
  write_config - "$CONFIG/wofi/style.css" < "$DOTFILES/configs/wofi/style.css"
fi
if command -v tmux > /dev/null 2>&1; then
  write_config - "$CONFIG/tmux/tmux.conf" < "$DOTFILES/configs/tmux/tmux.conf"
fi
