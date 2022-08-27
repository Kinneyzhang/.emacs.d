;; Add export PATH="/path/to/code/cask/bin:$PATH" by Package.el.
;; This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(setq package-archives '(("melpa-cn" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
                         ("gnu-cn"   . "http://mirrors.cloud.tencent.com/elpa/gnu/")))

(package-initialize)

;; Bootstrap `use-package'
(require 'package)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;; (package-refresh-contents)

(setq package-enable-at-startup nil
      file-name-handler-alist nil
      message-log-max 16384
      gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6
      auto-window-vscroll nil
      user-full-name "Kinneyzhang")

(add-to-list 'load-path (concat user-emacs-directory "elisp"))

(setq custom-file (expand-file-name (concat user-emacs-directory "elisp/custom.el")))
(setq icloud-directory (expand-file-name "~/Library/Mobile Documents/com~apple~CloudDocs/"))
(setq site-lisp (expand-file-name (concat user-emacs-directory "site-lisp/")))
(defvar emacs-site-lisp (expand-file-name (concat user-emacs-directory "site-lisp/")))

(require 'init-utils)
(require 'init-ui)
(require 'init-ivy)
(require 'init-hydra)
(require 'init-better)
(require 'init-window)
(require 'init-misc)
(require 'init-org)
(require 'init-music)
(require 'lang-python)
(require 'lang-web)
(require 'lang-clojure)
(require 'lang-elisp)
(require 'lang-rust)
(require 'init-sql)
(require 'init-gtd)
;; (require 'init-modal)
;;(require 'init-elfeed)
;;(require 'lang-ruby)
;;(require 'lang-javascript)
;;(require 'lang-c)
;;(require 'lang-php)
;;(require 'init-pdf)
