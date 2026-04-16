;; Add export PATH="/path/to/code/cask/bin:$PATH" by Package.el.
;; This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(setq package-check-signature nil)
;; (setq package-archives
;;       '(("melpa" . "https://gitlab.com/d12frosted/elpa-mirror/raw/master/melpa/")
;;         ("gnu"   . "https://gitlab.com/d12frosted/elpa-mirror/raw/master/gnu/")))
(setq package-archives '(("gnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
;; (setq package-archives '(("gnu" . "https://mirrors.ustc.edu.cn/elpa/gnu/")
;;                          ("melpa" . "https://mirrors.ustc.edu.cn/elpa/melpa/")
;;                          ("nongnu" . "https://mirrors.ustc.edu.cn/elpa/nongnu/")))

(package-initialize)
;; Bootstrap `use-package'
(require 'package)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(defvar emacs-source-dir "d:/emacs-source-30-1/src")
(setq source-directory emacs-source-dir)
(setq find-function-C-source-directory emacs-source-dir)

;;; fasten emacs in general

(use-package gcmh
  :ensure t
  :config
  (gcmh-mode 1)
  (setq gcmh-high-cons-threshold most-positive-fixnum)
  (setq gcmh-idle-delay 300))

;; if you don't use RTL ever, this could improve perf
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right
              bidi-inhibit-bpa t)

;; improves terminal emulator (vterm/eat) throughput
(setq read-process-output-max (* 2 1024 1024)
      process-adaptive-read-buffering nil)

(setq fast-but-imprecise-scrolling t
      redisplay-skip-fontification-on-input t
      inhibit-compacting-font-caches t)

;; (setq idle-update-delay nil)
;; (setq jit-lock-defer-time nil)
(setq package-native-compile t)

(setq long-line-threshold 1000
      large-hscroll-threshold 1000
      syntax-wholeline-max 1000)

(setq file-name-handler-alist nil
      message-log-max 16384
      auto-window-vscroll nil
      user-full-name "Kinneyzhang")

(require 'dired-x)

(add-to-list 'load-path (concat user-emacs-directory "elisp"))
(setq custom-file (expand-file-name (concat user-emacs-directory "elisp/custom.el")))
(defvar site-lisp (expand-file-name (concat user-emacs-directory "site-lisp/")))
(defvar emacs-site-lisp (expand-file-name (concat user-emacs-directory "site-lisp/")))
;; (org-babel-load-file "~/.emacs.d/config.org")
(require 'init-utils)
(require 'init-ui)
(require 'gk-english)
(require 'init-ivy)
(require 'init-better)
(require 'init-window)
(require 'init-misc)
(require 'init-org)
;; (require 'init-hydra)
;; (require 'init-gtd)
(require 'init-music)
;;(require 'init-elfeed)
;;(require 'lang-python)
;;(require 'lang-ruby)
;;(require 'lang-javascript)
;; (require 'lang-web)
;; (require 'lang-c)
;;(require 'lang-php)
(require 'lang-elisp)
(require 'lang-shell)
(require 'lang-lisp)
(require 'lang-rust)
;;(require 'init-pdf)
(require 'init-sql)
(require 'init-hack)
(require 'init-mine)
(put 'erase-buffer 'disabled nil)
(put 'scroll-left 'disabled nil)

(load-file "~/IPARA/3-RESOURCES/emacs/config/init.el")
(require 'init)
