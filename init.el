;; Added export PATH="/path/to/code/cask/bin:$PATH" by Package.el.
;; This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("gnu" . "http://elpa.emacs-china.org/gnu/"))
(add-to-list 'package-archives
	     '("melpa" . "http://elpa.emacs-china.org/melpa/"))
(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
	(package-refresh-contents)
	(package-install 'use-package))

(org-babel-load-file (expand-file-name "~/.emacs.d/myconfig.org"))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(beacon-color "#cc6666")
 '(custom-enabled-themes (quote (sanityinc-tomorrow-eighties)))
 '(custom-safe-themes
   (quote
    ("9a155066ec746201156bb39f7518c1828a73d67742e11271e4f24b7b178c4710" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" default)))
 '(evil-leader/leader ";")
 '(fci-rule-color "#373b41")
 '(flycheck-color-mode-line-face-to-color (quote mode-line-buffer-id))
 '(frame-background-mode (quote dark))
 '(hl-sexp-background-color "#efebe9")
 '(menu-bar-mode nil)
 '(org-agenda-window-setup (quote current-window))
 '(package-selected-packages
   (quote
    (elfeed-goodies elfeed hackernews python-django django-mode mingus simple-mpc alert async auto-complete auto-yasnippet ccls color-theme-sanityinc-tomorrow company counsel dash epl evil evil-leader evil-nerd-commenter exec-path-from-shell expand-region flycheck helm helm-ag helm-core hungry-delete iedit ivy js2-mode js2-refactor leuven-theme nodejs-repl org-pomodoro org-projectile org-bullets package-build pkg-info popup popwin reveal-in-osx-finder ruby-hash-syntax shell-pop smartparens swiper use-package web-mode which-key window-numbering yasnippet sr-speedbar)))
 '(show-paren-mode t)
 '(speedbar-default-position (quote right))
 '(speedbar-show-unknown-files t)
 '(sr-speedbar-auto-refresh nil)
 '(sr-speedbar-default-width 20)
 '(sr-speedbar-max-width 20)
 '(sr-speedbar-right-side nil)
 '(tool-bar-mode nil)
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#cc6666")
     (40 . "#de935f")
     (60 . "#f0c674")
     (80 . "#b5bd68")
     (100 . "#8abeb7")
     (120 . "#81a2be")
     (140 . "#b294bb")
     (160 . "#cc6666")
     (180 . "#de935f")
     (200 . "#f0c674")
     (220 . "#b5bd68")
     (240 . "#8abeb7")
     (260 . "#81a2be")
     (280 . "#b294bb")
     (300 . "#cc6666")
     (320 . "#de935f")
     (340 . "#f0c674")
     (360 . "#b5bd68"))))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(web-mode-html-attr-name-face ((t (:foreground "#FF9900"))))
 '(web-mode-html-tag-bracket-face ((t (:foreground "#408CFF"))))
 '(web-mode-html-tag-face ((t (:foreground "#408CFF")))))
