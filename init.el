;; Added export PATH="/path/to/code/cask/bin:$PATH" by Package.el.
;; This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("gnu"   . "http://mirrors.cloud.tencent.com/elpa/gnu/")
                         ("melpa" . "http://mirrors.cloud.tencent.com/elpa/melpa/")))

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(add-to-list 'load-path (concat user-emacs-directory "elisp"))

(setq custom-file (expand-file-name "custom.el" (concat user-emacs-directory "elisp/")))

(let ((gc-cons-threshold most-positive-fixnum) ;; 加载的时候临时增大`gc-cons-threshold'以加速启动速度。
      (file-name-handler-alist nil)) ;; 清空避免加载远程文件的时候分析文件。
  
  (require 'benchmark-init-modes)
  (require 'benchmark-init)
  (benchmark-init/activate)
  
  (require 'custom)
  (require 'init-better)
  (require 'init-ui)
  (require 'init-window)
  (require 'init-org)
  (require 'init-ivy)
  (require 'init-music)
  (require 'init-misc)
  (require 'init-emms)
  
  (require 'lang-python)
  (require 'lang-ruby)
  (require 'lang-javascript)
  (require 'lang-web)
  (require 'lang-c)
  (require 'lang-php)
  )
