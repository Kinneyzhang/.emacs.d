;; Addedrec export PATH="/path/to/code/cask/bin:$PATH" by Package.el.
;; This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
(setq package-archives '(("gnu"   . "http://mirrors.cloud.tencent.com/elpa/gnu/")
                         ("melpa" . "http://mirrors.cloud.tencent.com/elpa/melpa/")
			 ("ublt" . "https://elpa.ubolonton.org/packages/")))

;; Bootstrap `use-package'
(require 'package)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(setq package-enable-at-startup nil
      file-name-handler-alist nil
      message-log-max 16384
      gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6
      auto-window-vscroll nil)

(add-to-list 'load-path (concat user-emacs-directory "elisp"))

(setq custom-file (expand-file-name (concat user-emacs-directory "elisp/custom.el")))
(setq icloud-directory (expand-file-name "~/Library/Mobile Documents/com~apple~CloudDocs/"))
(setq site-lisp (expand-file-name (concat user-emacs-directory "site-lisp/")))
(load (concat user-emacs-directory "elisp/custom.el"))

(require 'init-utils)
(require 'init-ui)
(require 'init-ivy)
(require 'init-hydra)
(require 'init-better)
(require 'init-window)
(require 'init-misc)
(require 'init-org)
(require 'init-music)
(require 'init-elfeed)
;; (require 'init-flywrap)
(require 'lang-python)
(require 'lang-ruby)
(require 'lang-javascript)
(require 'lang-web)
(require 'lang-c)
(require 'lang-php)
(require 'lang-elisp)
;;(require 'init-org-jekyll)
;; (require 'init-org)
(require 'init-pdf)
;; (require 'init-blog-hack)
(require 'init-test)
(require 'bklink)
;;(require 'init-mu4e)
