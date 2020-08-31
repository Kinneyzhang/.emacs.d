;;; includes some basic settings, theme, modeline, neotree and some ui library.
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
;; (fringe-mode -1)

(setq display-time-default-load-average t)
(display-time-mode -1)

(global-hl-line-mode -1);;光标行高亮

;; from centaur
(push '(vertical-scroll-bars . nil) default-frame-alist)
(when (featurep 'ns)
  (push '(ns-transparent-titlebar . t) default-frame-alist))

(setq hi-lock-file-patterns-policy #'(lambda (dummy) t)) ;;加载高亮模式
(setq initial-frame-alist (quote ((fullscreen . maximized))));;启动最大化窗口
;; (toggle-frame-maximized)
(setq inhibit-splash-screen nil);取消默认启动窗口
(setq-default cursor-type 'box);变光标, setq-default设置全局

(load-theme 'material t)
(set-frame-font "Source Code Variable" 12 t)
;;==================================================

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
