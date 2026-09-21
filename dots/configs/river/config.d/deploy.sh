#!/usr/bin/env sh

export LUA_PATH="$DOTFILES/configs/river/config.d/?.lua;;"
PATH_LUA_CONFIG="$DOTFILES/configs/river/config.d/init.lua"
lua $PATH_LUA_CONFIG | generate_configs.river | sh
