;; Addedrec export PATH="/path/to/code/cask/bin:$PATH" by Package.el.
;; This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
(windmove-default-keybindings)
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("gnu"   . "http://mirrors.cloud.tencent.com/elpa/gnu/")
                         ("melpa" . "http://mirrors.cloud.tencent.com/elpa/melpa/")
			 ("ublt" . "https://elpa.ubolonton.org/packages/")))

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(add-to-list 'load-path (concat user-emacs-directory "elisp"))
;; (add-to-list 'load-path (concat user-emacs-directory "site-lisp"))

(setq custom-file (expand-file-name (concat user-emacs-directory "elisp/custom.el")))
(setq icloud-directory (expand-file-name "~/Library/Mobile Documents/com~apple~CloudDocs/"))
(setq config-dir (expand-file-name (concat user-emacs-directory "config-file/")))
(setq site-lisp (expand-file-name (concat user-emacs-directory "site-lisp/")))
(let ((gc-cons-threshold most-positive-fixnum) ;; 加载的时候临时增大`gc-cons-threshold'以加速启动速度。
      (file-name-handler-alist nil)) ;; 清空避免加载远程文件的时候分析文件。

(use-package benchmark-init
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))
  
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
  ;;(require 'doom-cyberpunk-theme)
  (require 'lang-python)
  (require 'lang-ruby)
  (require 'lang-javascript)
  (require 'lang-web)
  (require 'lang-c)
  (require 'lang-php)
  (require 'lang-elisp)
  ;; (require 'init-org-jekyll)
  (require 'init-org)
  (require 'init-pdf)
  (require 'init-blog)
  (require 'init-test)
  ;;(require 'init-mu4e)
  )
