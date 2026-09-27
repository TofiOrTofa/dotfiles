#!/usr/bin/env sh

lua ~/.dotfiles/configs/river/config.d/generate.lua \
    | ~/.dotfiles/scripts/river/generate-configs.river \
    > ~/.dotfiles/configs/river/init

