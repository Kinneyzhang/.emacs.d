;; Add export PATH="/path/to/code/cask/bin:$PATH" by Package.el.
;; This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(setq package-archives
      '(("gnu" . "https://mirrors.ustc.edu.cn/elpa/gnu/")
        ("melpa" . "https://mirrors.ustc.edu.cn/elpa/melpa/")
        ("nongnu" . "https://mirrors.ustc.edu.cn/elpa/nongnu/")))

(package-initialize)
;; (toggle-debug-on-error)
;; Bootstrap `use-package'
(require 'package)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;; (package-refresh-contents)

(setq package-enable-at-startup nil
      file-name-handler-alist nil
      message-log-max 16384
      gc-cons-threshold 800000
      gc-cons-percentage 0.6
      auto-window-vscroll nil
      user-full-name "Kinneyzhang")

(add-to-list 'load-path (concat user-emacs-directory "elisp"))

(setq custom-file (expand-file-name (concat user-emacs-directory "elisp/custom.el")))
(defvar icloud-directory (expand-file-name "~/Library/Mobile Documents/com~apple~CloudDocs/"))
(defvar site-lisp (expand-file-name (concat user-emacs-directory "site-lisp/")))

(require 'init-submodule)
(require 'init-better)
(require 'init-utils)
(require 'init-ui)
(require 'init-key)
(require 'init-ivy)
(require 'init-window)
(require 'init-misc)
(require 'init-org)
(require 'init-dired)
(require 'init-hydra)
(require 'init-mine)
(require 'init-music)

;; (require 'init-pdf)
;; (require 'lang-python)
;; (require 'lang-web)
;; (require 'lang-clojure)
;; (require 'lang-rust)
(put 'narrow-to-region 'disabled nil)
