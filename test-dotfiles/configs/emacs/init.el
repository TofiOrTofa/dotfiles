(setq-default indent-tabs-mode t)
(setq-default tab-width 4)
(setq c-basic-offset 4)

;; Отключаем подсветку синтаксиса (делаем текст монохромным)
(global-font-lock-mode 0)

;; Делаем так, чтобы даже принудительные цвета (например, в Си режиме) стали белыми
(set-face-foreground 'default "white")
