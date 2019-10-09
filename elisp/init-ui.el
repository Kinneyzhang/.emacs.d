;;; includes some basic settings, theme, modeline, neotree and some ui library.
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(fringe-mode 1)

(setq display-time-default-load-average nil)
(display-time-mode t)

(global-hl-line-mode -1);;光标行高亮

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . light))

(setq icon-title-format nil)
(setq frame-title-format t)
(setq multiple-frames t)

(setq hi-lock-file-patterns-policy #'(lambda (dummy) t)) ;;加载高亮模式
(setq initial-frame-alist (quote ((fullscreen . maximized))));;启动最大化窗口
(toggle-frame-maximized)
(setq inhibit-splash-screen nil);取消默认启动窗口
(setq-default cursor-type 'box);变光标, setq-default设置全局

;;==================================================
(use-package dracula-theme
  :ensure t)
(load-theme 'dracula)

(use-package dashboard
  :ensure t
  :init
  (setq dashboard-center-content t)
  (setq dashboard-set-navigator t)
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
  (setq dashboard-banner-logo-title "Happy hacking emacs!  [Author:Kinney] [Github:https://github.com/Kinneyzhang/.emacs.d.git]")
  (setq dashboard-startup-banner "~/.emacs.d/img/ying.png")
  (setq dashboard-items '((recents  . 8) (projects . 5)))
    ;; Format: "(icon title help action face prefix suffix)"
  ;; (setq dashboard-navigator-buttons
  ;; 	`(;; line1
  ;; 	  ((,(all-the-icons-octicon "mark-github" :height 1.1 :v-adjust 0.0)
  ;; 	    "Homepage"
  ;; 	    "Browse homepage"
  ;; 	    (lambda (&rest _) (browse-url "homepage")))
  ;; 	   ("★" "Star" "Show stars" (lambda (&rest _) (show-stars)) warning)
  ;; 	   ("?" "" "?/h" #'show-help nil "<" ">"))
  ;; 	  ;; line 2
  ;; 	  ((,(all-the-icons-faicon "linkedin" :height 1.1 :v-adjust 0.0)
  ;; 	    "Linkedin"
  ;; 	    ""
  ;; 	    (lambda (&rest _) (browse-url "homepage")))
  ;; 	   ("⚑" nil "Show flags" (lambda (&rest _) (message "flag")) error))))
  :config
  (dashboard-setup-startup-hook))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :config
  ;; How tall the mode-line should be. It's only respected in GUI.
  ;; If the actual char height is larger, it respects the actual height.
  (setq doom-modeline-height 25)

  ;; How wide the mode-line bar should be. It's only respected in GUI.
  (setq doom-modeline-bar-width 3)

  (setq doom-modeline-buffer-file-name-style 'truncate-upto-project)

  ;; Whether display icons in mode-line or not.
  (setq doom-modeline-icon t)

  ;; Whether display the icon for major mode. It respects `doom-modeline-icon'.
  (setq doom-modeline-major-mode-icon t)

  ;; Whether display color icons for `major-mode'. It respects
  ;; `doom-modeline-icon' and `all-the-icons-color-icons'.
  (setq doom-modeline-major-mode-color-icon t)

  ;; Whether display icons for buffer states. It respects `doom-modeline-icon'.
  (setq doom-modeline-buffer-state-icon t)

  ;; Whether display buffer modification icon. It respects `doom-modeline-icon'
  ;; and `doom-modeline-buffer-state-icon'.
  (setq doom-modeline-buffer-modification-icon t)

  ;; Whether display minor modes in mode-line or not.
  (setq doom-modeline-minor-modes nil)

  ;; If non-nil, a word count will be added to the selection-info modeline segment.
  (setq doom-modeline-enable-word-count nil)

  ;; Whether display buffer encoding.
  (setq doom-modeline-buffer-encoding t)

  ;; Whether display indentation information.
  (setq doom-modeline-indent-info nil)

  ;; If non-nil, only display one number for checker information if applicable.
  (setq doom-modeline-checker-simple-format t)

  ;; The maximum displayed length of the branch name of version control.
  (setq doom-modeline-vcs-max-length 12)

  ;; Whether display perspective name or not. Non-nil to display in mode-line.
  (setq doom-modeline-persp-name t)

  ;; Whether display `lsp' state or not. Non-nil to display in mode-line.
  (setq doom-modeline-lsp t)

  ;; Whether display github notifications or not. Requires `ghub` package.
  (setq doom-modeline-github nil)

  ;; The interval of checking github.
  (setq doom-modeline-github-interval (* 30 60))

  ;; Whether display environment version or not
  (setq doom-modeline-env-version t)
  ;; Or for individual languages
  (setq doom-modeline-env-enable-python t)
  (setq doom-modeline-env-enable-ruby t)
  (setq doom-modeline-env-enable-perl t)
  (setq doom-modeline-env-enable-go t)
  (setq doom-modeline-env-enable-elixir t)
  (setq doom-modeline-env-enable-rust t)

  ;; Change the executables to use for the language version string
  (setq doom-modeline-env-python-executable "python")
  (setq doom-modeline-env-ruby-executable "ruby")
  (setq doom-modeline-env-perl-executable "perl")
  (setq doom-modeline-env-go-executable "go")
  (setq doom-modeline-env-elixir-executable "iex")
  (setq doom-modeline-env-rust-executable "rustc")

  ;; Whether display mu4e notifications or not. Requires `mu4e-alert' package.
  (setq doom-modeline-mu4e t)

  ;; Whether display irc notifications or not. Requires `circe' package.
  (setq doom-modeline-irc t)

  ;; Function to stylize the irc buffer names.
  (setq doom-modeline-irc-stylize 'identity)
  )


(use-package all-the-icons-dired
  :ensure t
  :config
  (require 'all-the-icons-dired)
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

;; colorful dired-mode
(use-package diredfl
  :ensure t
  :config (diredfl-global-mode t))


(use-package fancy-battery
  :ensure t
  :config (add-hook 'after-init-hook #'fancy-battery-mode))

(use-package indent-guide
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'indent-guide-mode)
  (add-hook 'org-mode-hook 'indent-guide-mode)
  (setq indent-guide-delay 0)
  (setq indent-guide-recursive nil)
  (setq indent-guide-char "|"))

(use-package nyan-mode
  :ensure t
  :defer 5
  :init (setq mode-line-format (list '(:eval (list (nyan-create))))))

(provide 'init-ui)
