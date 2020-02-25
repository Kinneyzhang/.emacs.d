;;; includes some basic settings, theme, modeline, neotree and some ui library.
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(fringe-mode 1)

(setq display-time-default-load-average t)
(display-time-mode -1)

(global-hl-line-mode -1);;光标行高亮

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . light))

(setq icon-title-format nil)
(setq frame-title-format t)
(setq multiple-frames t)
(setq display-battery-mode nil)

(setq hi-lock-file-patterns-policy #'(lambda (dummy) t)) ;;加载高亮模式
(setq initial-frame-alist (quote ((fullscreen . maximized))));;启动最大化窗口
(toggle-frame-maximized)
(setq inhibit-splash-screen nil);取消默认启动窗口
(setq-default cursor-type 'box);变光标, setq-default设置全局

;;==================================================
(use-package org-beautify-theme
  :ensure t
  :config
  (load-theme 'org-beautify))

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  ;; (doom-themes-visual-bell-config)
  
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config)
  
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; (use-package dashboard
;;   :ensure t
;;   :init
;;   (setq dashboard-center-content t)
;;   (setq dashboard-set-navigator t)
;;   (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
;;   (setq dashboard-banner-logo-title "Happy hacking emacs!  [Author:Kinney] [Github:https://github.com/Kinneyzhang/.emacs.d.git]")
;;   (setq dashboard-startup-banner "~/.emacs.d/img/ying.png")
;;   (setq dashboard-items '((recents  . 8) (projects . 5)))
;;   :config
;;   (dashboard-setup-startup-hook))

;; modeline

;; (use-package awesome-tray
;;   :load-path "~/.emacs.d/site-lisp/awesome-tray"
;;   :config
;;   (awesome-tray-mode 1))

;; (use-package doom-modeline
;;   :ensure t
;;   :hook (after-init . doom-modeline-mode)
;;   :config
;;   (setq doom-modeline-height 10)
;;   (setq doom-modeline-bar-width 2)
;;   (setq doom-modeline-buffer-file-name-style 'truncate-upto-project)
;;   (setq doom-modeline-icon t)
;;   (setq doom-modeline-major-mode-icon t)
;;   (setq doom-modeline-major-mode-color-icon t)
;;   (setq doom-modeline-buffer-state-icon t)
;;   (setq doom-modeline-buffer-modification-icon t)
;;   (setq doom-modeline-minor-modes nil)
;;   (setq doom-modeline-enable-word-count nil)
;;   (setq doom-modeline-buffer-encoding t)
;;   (setq doom-modeline-indent-info nil)
;;   (setq doom-modeline-checker-simple-format t)
;;   (setq doom-modeline-vcs-max-length 12)
;;   (setq doom-modeline-persp-name t)
;;   (setq doom-modeline-lsp t)
;;   (setq doom-modeline-github nil)
;;   (setq doom-modeline-github-interval (* 30 60))
;;   (setq doom-modeline-env-version t)
;;   (setq doom-modeline-env-enable-python t)
;;   (setq doom-modeline-env-enable-ruby t)
;;   (setq doom-modeline-env-enable-perl t)
;;   (setq doom-modeline-env-enable-go t)
;;   (setq doom-modeline-env-enable-elixir t)
;;   (setq doom-modeline-env-enable-rust t)
;;   ;; Change the executables to use for the language version string
;;   (setq doom-modeline-env-python-executable "python")
;;   (setq doom-modeline-env-ruby-executable "ruby")
;;   (setq doom-modeline-env-perl-executable "perl")
;;   (setq doom-modeline-env-go-executable "go")
;;   (setq doom-modeline-env-elixir-executable "iex")
;;   (setq doom-modeline-env-rust-executable "rustc")
;;   ;; Whether display mu4e notifications or not. Requires `mu4e-alert' package.
;;   (setq doom-modeline-mu4e t)
;;   ;; Whether display irc notifications or not. Requires `circe' package.
;;   (setq doom-modeline-irc t)
;;   ;; Function to stylize the irc buffer names.
;;   (setq doom-modeline-irc-stylize 'identity)
;;   )

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :init
  (setq doom-modeline-height 20))

(use-package all-the-icons-dired
  :ensure t
  :config
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

;; colorful dired-mode
(use-package diredfl
  :ensure t
  :config (diredfl-global-mode t))

(use-package indent-guide
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'indent-guide-mode)
  (add-hook 'org-mode-hook 'indent-guide-mode)
  (setq indent-guide-delay 0)
  (setq indent-guide-recursive nil)
  (setq indent-guide-char "|"))

(provide 'init-ui)
