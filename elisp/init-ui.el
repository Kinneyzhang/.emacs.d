(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(fringe-mode 0)
(display-time-mode -1)
(global-hl-line-mode -1)
(global-display-line-numbers-mode -1)
(setq display-time-default-load-average t)
(when (featurep 'ns)
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . light)))
(setq hi-lock-file-patterns-policy #'(lambda (dummy) t)) ;; 加载高亮模式
(setq initial-frame-alist (quote ((fullscreen . maximized)))) ;;启动最大化窗口
(setq inhibit-compacting-font-caches t)
(setq-default cursor-type 'bar) ;; 光标样式

;;; theme
(use-package doom-themes
  :ensure t)

;; (load-theme 'doom-material t)
(load-theme 'tsdh-light t)

;;; Fonts

(defun font-installed-p (font-name)
  "Check if font with FONT-NAME is available."
  (find-font (font-spec :name font-name)))

(when (display-graphic-p)
  ;; Set default font
  (cl-loop for font in '("Source Code Variable"
                         "Fira Code"
                         "Menlo" "SF"
                         "Monaco Mono" "Hack"
                         "DejaVu Sans Mono"
                         "Consolas")
           when (font-installed-p font)
           return (set-face-attribute
                   'default nil
                   :font font
                   :height (cond ((eq system-type 'darwin) 125)
                                 ((eq system-type 'windows-nt) 110)
                                 (t 100))))
  ;; Specify font for all unicode characters
  (cl-loop for font in '("Symbola" "Apple Color Emoji" "Symbol")
           when (font-installed-p font)
           return (set-fontset-font t 'unicode font nil 'append))
  ;; Specify font for Chinese characters
  (cl-loop for font in
           '("Source Han Serif SC"
             "Source Han Sans SC VF"
             "WenQuanYi Micro Hei"
             "Microsoft Yahei")
           when (font-installed-p font)
           return (dolist (charset '(kana han hangul cjk-misc bopomofo))
                    (set-fontset-font t charset font))))

(use-package all-the-icons
  :ensure t)

;;; modeline

(use-package powerline
  :ensure t
  :config
  (powerline-default-theme))

(use-package spaceline
  :ensure t
  :config
  (spaceline-spacemacs-theme))

;; colorful dired-mode

(use-package diredfl
  :ensure t
  :config (diredfl-global-mode t))

(provide 'init-ui)
