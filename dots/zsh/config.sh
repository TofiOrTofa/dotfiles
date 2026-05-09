export ZSH="$HOME/.oh-my-zsh"
export TERM=alacritty
export PATH="$PATH:$(ruby -e "print Gem.user_dir")/bin"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/nix/store/7klk0fb1nx1xdgczwlbhj6a7raqxfy5d-nix-2.33.2/bin:$PATH"
export PATH="$HOME/.nix-profile/bin:$PATH"
export XDG_DATA_DIRS="$HOME/.nix-profile/share:$HOME/.local/share:/usr/local/share:/usr/share"
export PATH="$PATH:/nix/var/nix/profiles/default/bin:~/.nix-profile/bin"
export WLR_RENDERER=vulkan


# Загружаем переменные Home Manager
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"



function change_cursor_color_on_error {
    if [[ $? -ne 0 ]]; then
        # Если последняя команда завершилась с ошибкой ($? != 0):
        # \e]12;red\a — делает курсор красным
        # \e[1 q — делает курсор мигающим блоком (как в TempleOS)
        echo -ne "\e]12;#bf616aa\a\e[1 q"
    else
        # Если всё успешно ($? == 0):
        # Возвращаем стандартный цвет (например, белый или серый)
        # \e[2 q — блок без мигания (или \e[1 q если хотите мигание всегда)
        echo -ne "\e]12;#cccccc\a\e[2 q"
    fi
}

command_not_found_handler() {
    # 5 - мигание, 1 - жирный, 97 - белый текст, 41 - красный фон
    printf "\e[1;41;30m ERROR \e[0m\e[31m\e[0m command \e[31;1m%s\e[0m not faund\n" "$1"
    return 127
}

nx() {
    local branch="nixos-24.11" # По умолчанию stable
    local pkg=""

    case "$1" in
        stable)
            branch="nixos-24.11"
            pkg=$2
            shift 2
            ;;
        unstable)
            branch="nixos-unstable"
            pkg=$2
            shift 2
            ;;
        *)
            pkg=$1
            shift 1
            ;;
    esac

    if [ -z "$pkg" ]; then
        echo "Использование: nx [stable|unstable] <package> [args]"
        return 1
    fi

    # --offline заставит Nix выдать ошибку, если пакета нет на диске
    # Убери --offline, если хочешь, чтобы он всё-таки качал недостающее
    nix run "github:nixos/nixpkgs/$branch#$pkg" -- "$@"
}


ZSH_THEME="robbyrussell"

plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

alias phone='ssh -p 2222 192.168.0.44'
alias sway_mods='sway -c .config/sway/config_mods'


source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

add-zsh-hook precmd change_cursor_color_on_error
eval $(luarocks path --local)

