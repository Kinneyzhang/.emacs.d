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
			  counsel
			  dash
			  epl
			  evil
			  evil-leader
			  evil-nerd-commenter
			  exec-path-from-shell
			  expand-region
			  flycheck
			  helm
			  helm-ag
			  helm-core
			  hungry-delete
			  iedit
			  ivy
			  js2-mode
			  js2-refactor
			  leuven-theme
			  nodejs-repl
			  org-pomodoro
			  org-projectile
			  org-bullets
			  package-build
			  pkg-info
			  popup
			  popwin
			  reveal-in-osx-finder
			  ruby-hash-syntax
			  shell-pop
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
