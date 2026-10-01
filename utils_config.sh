# utils_config.sh — Вспомогательные функции для работы с конфигами

write_config() {
  local _source_text
  [ "$1" = "-" ] \
    && _source_text=$(cat) \
    || _source_text="$1"
  local _dest_path="$2"
  if [ -f "$_dest_path" ] && \
    [ "$_source_text" = "$(cat "$_dest_path")" ]
  then
    echo "[ OK ] $_dest_path"
    return 0
  fi
  if [ ! -f "$_dest_path" ]; then
    echo "[ NEW ] $_dest_path"
    mkdir -p "$(dirname "$_dest_path")"
    printf "%s\n" "$_source_text" > "$_dest_path"
    return 0
  fi
  echo "[ FILE ] $_dest_path"
  diff -u \
    "$_dest_path" \
    <(printf "%s\n" "$_source_text") \
    || true
  printf "overwrite file? [y/n]: "
  read _reply < /dev/tty
  echo ""
  case "$_reply" in
    [Yy]* ) ;;
    * )
      echo "[ SKIPPED ]: $_dest_path"
      return 0
      ;;
  esac
  echo "[ UPDATED ] $_dest_path"
  mkdir -p "$(dirname "$_dest_path")"
  chmod +w "$_dest_path"
  printf "%s\n" "$_source_text" > "$_dest_path"
}

spawn_script_link() {
  DST="$HOME/.local/bin/$1"
  SRC="$DOTFILES/scripts/$2"

  if [ ! -e "$DST" ]; then
    mkdir -p "$(dirname "$DST")"
    ln -sf "$SRC" "$DST"
    echo "[ NEW ] $1"
  else
    echo "[ OK ] $1"
  fi
  [ ! -x "$SRC" ] && chmod +x "$SRC" || true
}
