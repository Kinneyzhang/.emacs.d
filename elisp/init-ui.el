;;; includes some basic settings, theme, modeline, neotree and some ui library.
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(fringe-mode -1)

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

(load-theme 'dracula t)
(set-frame-font "Source Code Variable" 12 t)
;;==================================================
;; (use-package doom-themes
;;   :ensure t
;;   :config
;;   ;; Global settings (defaults)
;;   (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
;;         doom-themes-enable-italic t) ; if nil, italics is universally disabled
;;   ;; (load-theme 'doom-one t)
;;   ;; Enable flashing mode-line on errors
;;   ;; (doom-themes-visual-bell-config)
;;   ;; Enable custom neotree theme (all-the-icons must be installed!)
;;   (doom-themes-neotree-config)
;;   ;; or for treemacs users
;;   (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
;;   (doom-themes-treemacs-config)
;;   ;; Corrects (and improves) org-mode's native fontification.
;;   (doom-themes-org-config))

;; ;; (use-package dashboard
;; ;;   :ensure t
;; ;;   :init
;; ;;   (setq dashboard-center-content t)
;; ;;   (setq dashboard-set-navigator t)
;; ;;   (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
;; ;;   (setq dashboard-banner-logo-title "Happy hacking emacs!  [Author:Kinney] [Github:https://github.com/Kinneyzhang/.emacs.d.git]")
;; ;;   (setq dashboard-startup-banner "~/.emacs.d/img/ying.png")
;; ;;   (setq dashboard-items '((recents  . 8) (projects . 5)))
;; ;;   :config
;; ;;   (dashboard-setup-startup-hook))

;; ;; modeline

;; ;; (use-package awesome-tray
;; ;;   :load-path "~/.emacs.d/site-lisp/awesome-tray"
;; ;;   :config
;; ;;   (awesome-tray-mode 1))

;; ;; (use-package doom-modeline
;; ;;   :ensure t
;; ;;   :hook (after-init . doom-modeline-mode)
;; ;;   :config
;; ;;   (setq doom-modeline-height 10)
;; ;;   (setq doom-modeline-bar-width 2)
;; ;;   (setq doom-modeline-buffer-file-name-style 'truncate-upto-project)
;; ;;   (setq doom-modeline-icon t)
;; ;;   (setq doom-modeline-major-mode-icon t)
;; ;;   (setq doom-modeline-major-mode-color-icon t)
;; ;;   (setq doom-modeline-buffer-state-icon t)
;; ;;   (setq doom-modeline-buffer-modification-icon t)
;; ;;   (setq doom-modeline-minor-modes nil)
;; ;;   (setq doom-modeline-enable-word-count nil)
;; ;;   (setq doom-modeline-buffer-encoding t)
;; ;;   (setq doom-modeline-indent-info nil)
;; ;;   (setq doom-modeline-checker-simple-format t)
;; ;;   (setq doom-modeline-vcs-max-length 12)
;; ;;   (setq doom-modeline-persp-name t)
;; ;;   (setq doom-modeline-lsp t)
;; ;;   (setq doom-modeline-github nil)
;; ;;   (setq doom-modeline-github-interval (* 30 60))
;; ;;   (setq doom-modeline-env-version t)
;; ;;   (setq doom-modeline-env-enable-python t)
;; ;;   (setq doom-modeline-env-enable-ruby t)
;; ;;   (setq doom-modeline-env-enable-perl t)
;; ;;   (setq doom-modeline-env-enable-go t)
;; ;;   (setq doom-modeline-env-enable-elixir t)
;; ;;   (setq doom-modeline-env-enable-rust t)
;; ;;   ;; Change the executables to use for the language version string
;; ;;   (setq doom-modeline-env-python-executable "python")
;; ;;   (setq doom-modeline-env-ruby-executable "ruby")
;; ;;   (setq doom-modeline-env-perl-executable "perl")
;; ;;   (setq doom-modeline-env-go-executable "go")
;; ;;   (setq doom-modeline-env-elixir-executable "iex")
;; ;;   (setq doom-modeline-env-rust-executable "rustc")
;; ;;   ;; Whether display mu4e notifications or not. Requires `mu4e-alert' package.
;; ;;   (setq doom-modeline-mu4e t)
;; ;;   ;; Whether display irc notifications or not. Requires `circe' package.
;; ;;   (setq doom-modeline-irc t)
;; ;;   ;; Function to stylize the irc buffer names.
;; ;;   (setq doom-modeline-irc-stylize 'identity)
;; ;;   )

;; (use-package centaur-tabs
;;   :ensure t
;;   :config
;;   (setq centaur-tabs-style "box"
;; 	centaur-tabs-height 22
;; 	centaur-tabs-set-icons t
;; 	centaur-tabs-plain-icons nil
;; 	centaur-tabs-gray-out-icons nil
;; 	centaur-tabs-set-close-button nil
;; 	centaur-tabs-set-modified-marker t
;; 	centaur-tabs-show-navigation-buttons nil
;; 	centaur-tabs-set-bar 'left
;; 	centaur-tabs-cycle-scope 'tabs
;;  	x-underline-at-descent-line nil
;; 	)
;;   (centaur-tabs-headline-match)
;;   (centaur-tabs-change-fonts "Source Code Variable" 120)
;;   ;; (setq centaur-tabs-gray-out-icons 'buffer)
;;   ;; (centaur-tabs-enable-buffer-reordering)
;;   ;; (setq centaur-tabs-adjust-buffer-order t)
;;   (setq uniquify-separator "/")
;;   (setq uniquify-buffer-name-style 'forward)
;;   (defun centaur-tabs-buffer-groups ()
;;     "`centaur-tabs-buffer-groups' control buffers' group rules.

;;  Group centaur-tabs with mode if buffer is derived from `eshell-mode' `emacs-lisp-mode' `dired-mode' `org-mode' `magit-mode'.
;;  All buffer name start with * will group to \"Emacs\".
;;  Other buffer group by `centaur-tabs-get-group-name' with project name."
;;     (list
;;      (cond
;;       ;; ((not (eq (file-remote-p (buffer-file-name)) nil))
;;       ;; "Remote")
;;       ((ignore-errors
;; 	 (and (string= "*xwidget" (substring (buffer-name) 0 8))
;; 	      (not (string= "*xwidget-log*" (buffer-name)))))
;;        "Xwidget")
;;       ((or (string-equal "*" (substring (buffer-name) 0 1))
;; 	   (memq major-mode '(magit-process-mode
;; 			      magit-status-mode
;; 			      magit-diff-mode
;; 			      magit-log-mode
;; 			      magit-file-mode
;; 			      magit-blob-mode
;; 			      magit-blame-mode
;; 			      )))
;;        "Emacs")
;;       ((derived-mode-p 'prog-mode)
;;        "Editing")
;;       ((derived-mode-p 'dired-mode)
;;        "Dired")
;;       ((memq major-mode '(helpful-mode
;; 			  help-mode))
;;        "Help")
;;       ((memq major-mode '(org-mode
;; 			  org-agenda-clockreport-mode
;; 			  org-src-mode
;; 			  org-agenda-mode
;; 			  org-beamer-mode
;; 			  org-indent-mode
;; 			  org-bullets-mode
;; 			  org-cdlatex-mode
;; 			  org-agenda-log-mode
;; 			  diary-mode))
;;        "OrgMode")
;;       (t
;;        (centaur-tabs-get-group-name (current-buffer))))))
;;   :hook
;;   (dashboard-mode . centaur-tabs-local-mode)
;;   (term-mode . centaur-tabs-local-mode)
;;   (calendar-mode . centaur-tabs-local-mode)
;;   (org-agenda-mode . centaur-tabs-local-mode)
;;   (helpful-mode . centaur-tabs-local-mode)
;;   :bind
;;   ("C-c b" . centaur-tabs-backward)
;;   ("C-c n" . centaur-tabs-forward)
;;   ("C-c g" . centaur-tabs-forward-group)
;;   ("C-c t s" . centaur-tabs-counsel-switch-group))

(use-package spaceline
  :ensure t
  :config (spaceline-emacs-theme))

(use-package spaceline-all-the-icons
  :ensure t)

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
