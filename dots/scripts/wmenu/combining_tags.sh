#!/bin/sh

# Вызов wmenu для ввода тегов
input=$(printf '\n' | wmenu -b -p "tags")

# Если ввод пуст, переключаем все 9 тегов (маска 511) и выходим
if [ -z "$input" ]; then
    riverctl toggle-focused-tags 511
    exit 0
fi

mask=0

# Стандартный для POSIX sh способ посимвольного перебора строки
while [ -n "$input" ]; do
    # Отрезаем первый символ
    tag=$(printf '%s' "$input" | cut -c1)
    # Удаляем первый символ из основной строки
    input=$(printf '%s' "$input" | cut -c2-)

    case "$tag" in
        [1-9])
            # Побитовый сдвиг через арифметику POSIX $((...))
            # В sh нет оператора "<<", поэтому используем умножение на степени двойки
            shift_val=$((tag - 1))
            multiplier=1
            while [ "$shift_val" -gt 0 ]; do
                multiplier=$((multiplier * 2))
                shift_val=$((shift_val - 1))
            done
            
            mask=$((mask | multiplier))
            ;;
    esac
done

# Если маска изменилась, применяем её
[ "$mask" -ne 0 ] && riverctl toggle-focused-tags "$mask"

