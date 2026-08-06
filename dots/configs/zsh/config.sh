# ==============================================================================
# 1. ПЕРЕМЕННЫЕ ОКРУЖЕНИЯ И XDG (Убираем мусор из корня ~)
# ==============================================================================
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export PATH="$HOME/.local/bin:$PATH"


# Прячем кэш Zsh автодополнения в .cache
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump-${HOST}-${ZSH_VERSION}"

# Настройки для Wayland / Среды
export WLR_RENDERER=vulkan
export TZDIR="/usr/share/zoneinfo"

# ==============================================================================
# 2. НАСТРОЙКА PATH (Чистая, без жестких хэшей /nix/store)
# ==============================================================================
# Базовый PATH
typeset -U path # Запрещает дублирование путей в PATH

path=(
    "$HOME/.cargo/bin"
    "$HOME/.local/state/nix/profiles/profile/bin" # Стандартный путь профиля
    "$HOME/.nix-profile/bin"
    "/nix/var/nix/profiles/default/bin"
    $path
)

# Добавляем путь Ruby Gems, если установлен Ruby
if command -v ruby &>/dev/null; then
    path=("$(ruby -e 'print Gem.user_dir')/bin" $path)
fi

export PATH
export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_HOME:/usr/local/share:/usr/share"

# Загружаем переменные Home Manager (если файл существует)
[ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ] && . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

# ==============================================================================
# 3. OH-MY-ZSH & ПЛАГИНЫ
# ==============================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Syntax-highlighting загрузится автоматически через oh-my-zsh
plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# ==============================================================================
# 4. АЛИАСЫ И УТИЛИТЫ
# ==============================================================================
alias phone='ssh -p 2222 192.168.0.44'
alias sway_mods='sway -c .config/sway/config_mods'
alias mango="arch env LD_PRELOAD=/usr/lib/libjemalloc.so mango"
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lA'
alias python-tree="tree -a -I '.git|__pycache__|.mypy_cache|.pytest_cache|.venv|env|*.pyc'"


# Безопасная инициализация luarocks (не спамит ошибками, если lua нет)
command -v luarocks &>/dev/null && eval $(luarocks path --local)

# ==============================================================================
# 5. ФУНКЦИИ И КАСТОМИЗАЦИЯ ТЕРМИНАЛА
# ==============================================================================

# Изменение цвета курсора (Исправлен HEX-цвет)
function change_cursor_color_on_error {
    if [[ $? -ne 0 ]]; then
        echo -ne "\e]12;#bf616a\a\e[1 q"  # Корректный цвет Nord Red и мигающий блок
    else
        echo -ne "\e]12;#cccccc\a\e[2 q"  # Статичный серый блок
    fi
}
add-zsh-hook precmd change_cursor_color_on_error

# Красивый вывод при ошибке «Команда не найдена» (Исправлена опечатка 'faund')
command_not_found_handler() {
    printf "\e[1;41;30m ERROR \e[0m\e[31m\e[0m command \e[31;1m%s\e[0m not found\n" "$1"
    return 127
}

# Жесткий запуск программ строго из профиля Home Manager (Nix)
nixos() {
    if [ -z "$1" ]; then
        echo "Использование: nixos <команда> [аргументы]"
        return 1
    fi

    # Задаем PATH локально, заставляя систему смотреть только в Home Manager
    PATH="$HOME/.nix-profile/bin" "$@"
}


# Быстрый запуск пакетов из Nix Flakes / Channels
#nixos() {
#    local branch="nixos-24.11"
#    local pkg=""
#
#    case "$1" in
#        stable)   branch="nixos-24.11"; pkg=$2; shift 2 ;;
#        unstable) branch="nixos-unstable"; pkg=$2; shift 2 ;;
#        *)        pkg=$1; shift 1 ;;
#    esac
#
#    if [ -z "$pkg" ]; then
#        echo "Использование: nx [stable|unstable] <package> [args]"
#        return 1
#    fi
#
#    nix run "github:nixos/nixpkgs/$branch#$pkg" -- "$@"
#}

# emerge(portage) прямиком из gentoo
emerge() {
    /home/comu/gentoo/startprefix -c "emerge $*"
}
alias gentoo="$HOME/gentoo/startprefix_in_the_moment"

# Жесткий запуск программ из чистого Arch Linux (без Nix и Gentoo)
arch() {
    if [ -z "$1" ]; then
        echo "Использование: arch <команда> [аргументы]"
        return 1
    fi

    # Переопределяем PATH локально внутри функции, оставляя только родные пути Arch
    # и передаем туда команду со всеми ее аргументами
    PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin" "$@"
}

