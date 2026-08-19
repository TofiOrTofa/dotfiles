#!/bin/bash
while read -r total active; do
        # Если переменные пустые, пропускаем шаг
        [[ -z "$total" || -z "$active" ]] && continue

        result=""
        if [[ "$total" -eq 0 ]]; then
                result="</>"
        else
                human_active=$((active + 1))
                result="<${human_active}/${total}>"
        fi
        # Исправлено: один \n вместо двух
        echo "windows|string|\"$result\""
	echo ""
done

