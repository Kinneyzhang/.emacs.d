;; Added export PATH="/path/to/code/cask/bin:$PATH" by Package.el.
;; This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("gnu"   . "http://elpa.emacs-china.org/gnu/"))
(add-to-list 'package-archives
	     '("melpa" . "http://elpa.emacs-china.org/melpa/"))

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(add-to-list 'load-path (concat user-emacs-directory "elisp"))

(setq custom-file (expand-file-name "custom.el" (concat user-emacs-directory "elisp/")))

(require 'custom)

(require 'lang-python)

(require 'lang-javascript)

(require 'lang-web)

(require 'lang-c)


(org-babel-load-file (expand-file-name "~/.emacs.d/myconfig.org"))
