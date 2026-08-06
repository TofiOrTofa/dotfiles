;; Костыли для Emacs, чтобы пойти против воли Столлмана:
(setq-default indent-tabs-mode t) ; заставить использовать табы
(setq-default tab-width 8)        ; поставить ширину 8
(setq c-basic-offset 8)           ; исправить отступы в Си


(setq inhibit-startup-message t)



;; Отключаем подсветку синтаксиса (делаем текст монохромным)
(global-font-lock-mode 0)
(set-face-foreground 'default "white")

(setq inferior-lisp-program "sbcl")
(require 'sly)
(add-hook 'lisp-mode-hook 'sly-mode)

;; отключения
(blink-cursor-mode -1)(setq visible-cursor nil) ;; мигающего курсора
(menu-bar-mode -1) ;; верхнее меню
(tool-bar-mode -1) ;; панель инструментов
(scroll-bar-mode -1) ;; скроллбар

;; авто закрытие скобок
(electric-pair-mode 1)

;; сохранение похиции курсора при выходе из файла
(save-place-mode 1)

;; отступ по сторанам для перемещения
(setq scroll-margin 2)

;; замена цифр
(line-number-mode 1)
(column-number-mode 1)

;; список, выбор
(fido-vertical-mode 1)

;; директория для сохранения бэкапов
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))


;; что бы работало расширение для common lisp( .cl )
(add-to-list 'auto-mode-alist '("\\.cl\\'" . lisp-mode))


(defun my/disable-theme-background ()
  "Убирает фоновые цвета интерфейса и делает текст белым."
  ;; 1. Очищаем фон у всего интерфейса
  (set-face-background 'default "unspecified-background")
  (set-face-background 'mode-line "unspecified-background")
  (set-face-background 'mode-line-inactive "unspecified-background")
  (set-face-background 'tab-bar "unspecified-background")
  (set-face-background 'tab-bar-tab "unspecified-background")
  (set-face-background 'tab-bar-tab-inactive "unspecified-background")
  (set-face-background 'tab-line "unspecified-background")

  ;; 2. Делаем текст строки состояния белым
  (set-face-foreground 'mode-line "white")
  (set-face-foreground 'mode-line-inactive "gray50")
  (set-face-attribute 'mode-line nil :box nil)
  (set-face-attribute 'mode-line-inactive nil :box nil)

  ;; 3. Делаем текст вкладок (tab-bar) белым
  (set-face-foreground 'tab-bar-tab "white")          ; Активная вкладка
  (set-face-foreground 'tab-bar-tab-inactive "gray50") ; Неактивная вкладка
  (set-face-foreground 'tab-bar "gray50")              ; Пустое пространство панели

  ;; 4. На всякий случай для альтернативного режима вкладок (tab-line)
  (set-face-foreground 'tab-line "gray50"))

;; Применяем настройки
(my/disable-theme-background)
(add-hook 'after-make-frame-functions
          (lambda (frame)
            (with-selected-frame frame
              (my/disable-theme-background))))
