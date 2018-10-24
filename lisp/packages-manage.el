;;this is the packages that i have installed
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
			   ("melpa" . "http://elpa.emacs-china.org/melpa/"))))
;; cl - Common Lisp Extension
(require 'cl)
;; Add Packages
(defvar kinney/packages '(
			  alert
			  async
			  auto-complete
			  auto-yasnippet
			  ccls
			  color-theme-sanityinc-tomorrow
			  company
			  company-anaconda
			  company-ycmd
			  counsel
			  csharp-mode
			  dash
			  epl
			  evil
			  evil-leader
			  evil-nerd-commenter
			  exec-path-from-shell
			  expand-region
			  flycheck
			  gntp
			  goto-chg
			  helm
			  helm-ag
			  helm-core
			  hungry-delete
			  iedit
			  ivy
			  js2-mode
			  js2-refactor
			  leuven-theme
			  log4e
			  memoize
			  monokai-theme
			  multiple-cursors
			  nodejs-repl
			  org-pomodoro
			  org-projectile
			  org-bullets
			  package-build
			  pkg-info
			  popup
			  popwin
			  powerline
			  powerline-evil
			  reveal-in-osx-finder
			  ruby-hash-syntax
			  shell-pop
			  shut-up
			  smartparens
			  swiper
			  use-package
			  web-mode
			  which-key
			  window-numbering
			  yasnippet
			  sr-speedbar
			  ) "Default packages")

(setq package-selected-packages kinney/packages)

(defun kinney/packages-installed-p ()
  (loop for pkg in kinney/packages
	when (not (package-installed-p pkg)) do (return nil)
	finally (return t)))

(unless (kinney/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg kinney/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

(provide 'packages-manage)
