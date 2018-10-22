
;; Added export PATH="/path/to/code/cask/bin:$PATH" by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/lisp")

(defun open-my-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(defun open-my-init-packages-file()
  (interactive)
  (find-file "~/.emacs.d/lisp/init-packages.el"))
(defun open-my-init-better-defaults-file()
  (interactive)
  (find-file "~/.emacs.d/lisp/init-better-defaults.el"))
(defun open-my-init-keybindings-file()
  (interactive)
  (find-file "~/.emacs.d/lisp/init-keybindings.el"))
(defun open-my-init-ui-file()
  (interactive)
  (find-file "~/.emacs.d/lisp/init-ui.el"))
(defun open-my-init-custom-file()
  (interactive)
  (find-file "~/.emacs.d/lisp/init-custom.el"))
(defun open-my-init-org-file()
  (interactive)
  (find-file "~/.emacs.d/lisp/init-org.el"))


;;add more personal funcs
(require 'init-packages)
(require 'init-ui)
(require 'init-better-defaults)
(require 'init-org)
(require 'init-keybindings)

(setq custom-file (expand-file-name "lisp/init-custom.el" user-emacs-directory))
(setq debug-on-error t)

(load-file custom-file)
