;;============================================================================
;;functions to find my init files
(defun open-my-packages-manage-file()
  (interactive)
  (find-file "~/.emacs.d/lisp/packages-manage.el"))
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

;;let emacs could find the exe
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;;config for hungry-delete
(require 'hungry-delete)
(global-hungry-delete-mode)

;;config for smartparens 自动匹配括号
;;(require 'smartparens-config) 不需要require,因为是autoload
;;(add-hook 'emacs-lisp-mode-hook 'smartparens-mode)
(smartparens-global-mode t)
(sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)

;;config for swiper
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)

;;js2-mode config for jsfiles    
(setq auto-mode-alist
      (append
       '(("\\.js\\'" . js2-mode)
	 ("\\.html\\'" . web-mode)
	 )
       auto-mode-alist))


;;config for js2-refactor
(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-m")

;;config for js2's imenu, 列出所有函数
(defun js2-imenu-make-index ()
  (interactive)
  (save-excursion
    ;; (setq imenu-generic-expression '((nil "describe\\(\"\\(.+\\)\"" 1)))
    (imenu--generic-function '(("describe" "\\s-*describe\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
			       ("it" "\\s-*it\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
			       ("test" "\\s-*test\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
			       ("before" "\\s-*before\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
			       ("after" "\\s-*after\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
			       ("Function" "function[ \t]+\\([a-zA-Z0-9_$.]+\\)[ \t]*(" 1)
			       ("Function" "^[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*=[ \t]*function[ \t]*(" 1)
			       ("Function" "^var[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*=[ \t]*function[ \t]*(" 1)
			       ("Function" "^[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*()[ \t]*{" 1)
			       ("Function" "^[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*:[ \t]*function[ \t]*(" 1)
			       ("Task" "[. \t]task([ \t]*['\"]\\([^'\"]+\\)" 1)))))
(add-hook 'js2-mode-hook
	  (lambda ()
	    (setq imenu-create-index-function 'js2-imenu-make-index)))

(global-set-key (kbd "M-s i") 'counsel-imenu)

;;config for web-mode
(require 'web-mode)
(defun my-web-mode-indent-setup ()
  (setq web-mode-markup-indent-offset 2) ; web-mode, html tag in html file
  (setq web-mode-css-indent-offset 2)    ; web-mode, css in html file
  (setq web-mode-code-indent-offset 2)   ; web-mode, js code in html file
  )
(add-hook 'web-mode-hook 'my-web-mode-indent-setup)

;;change indent style
(defun my-toggle-web-indent ()
  (interactive)
  ;; web development
  (if (or (eq major-mode 'js-mode) (eq major-mode 'js2-mode))
      (progn
	(setq js-indent-level (if (= js-indent-level 2) 4 2))
	(setq js2-basic-offset (if (= js2-basic-offset 2) 4 2))))

  (if (eq major-mode 'web-mode)
      (progn (setq web-mode-markup-indent-offset (if (= web-mode-markup-indent-offset 2) 4 2))
	     (setq web-mode-css-indent-offset (if (= web-mode-css-indent-offset 2) 4 2))
	     (setq web-mode-code-indent-offset (if (= web-mode-code-indent-offset 2) 4 2))))
  (if (eq major-mode 'css-mode)
      (setq css-indent-offset (if (= css-indent-offset 2) 4 2)))

  (setq indent-tabs-mode nil))


;;config for c++ indent
(defun vlad-cc-style()
  (c-set-style "linux")
  (c-set-offset 'innamespace '0)
  (c-set-offset 'inextern-lang '0)
  (c-set-offset 'inline-open '0)
  (c-set-offset 'label '*)
  (c-set-offset 'case-label '*)
  ;; (c-set-offset 'access-label '/)
  (setq c-basic-offset 4)
  (setq tab-width 4)
  (setq indent-tabs-mode nil)
  )
(add-hook 'c++-mode-hook 'vlad-cc-style)
(add-hook 'c-mode-hook 'vlad-cc-style)

;;config for c++
(use-package ggtags
  :ensure 
  :config 
  (add-hook 'c-mode-common-hook
            (lambda ()
              (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
		(ggtags-mode 1))))
  )

;; Highlight parens when inside it
(define-advice show-paren-function (:around (fn) fix-show-paren-function)
  "Highlight enclosing parens."
  (cond ((looking-at-p "\\s(") (funcall fn))
        (t (save-excursion
             (ignore-errors (backward-up-list))
             (funcall fn)))))

(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
;; indent setting
(defun my-web-mode-hook ()
  ;;"Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  )
(add-hook 'web-mode-hook  'my-web-mode-hook)
;; comment style setting
(setq web-mode-comment-style 2)
(defun web-mode-keybinding-settings ()
  ;;  "Settings for keybinding."
  ;;(eal-define-keys
  ;; '(web-mode-map)
  ;; '(("C-c C-v" browse-url-of-file)))
  )

(eval-after-load "web-mode"
  '(web-mode-keybinding-settings))

;;config for popwin
(require 'popwin)
(popwin-mode t)

;;加载主题
;;(load-theme 'monokai t)

;;config for org-promodoro
(require 'org-pomodoro)

;;config for flycheck
(add-hook 'c++-mode-hook 'flycheck-mode)
(add-hook 'python-mode-hook 'flycheck-mode)
(add-hook 'js2-mode-hook 'flycheck-mode)
(add-hook 'java-mode-hook 'flycheck-mode)
(add-hook 'web-mode-hook 'flycheck-mode)

;;config for yasnippet
(require 'yasnippet)
(yas-reload-all)
(add-hook 'prog-mode-hook #'yas-minor-mode)

;;config for evil-leader
(global-evil-leader-mode t)

;;config for evil mode
(evil-mode 1)
;;(setcdr evil-insert-state-map nil)
;;(define-key evil-insert-state-map [escape] 'evil-normal-state)

;;config for Evil-nerd-commenter
(evilnc-default-hotkeys)
(define-key evil-normal-state-map (kbd ",/") 'evilnc-comment-or-uncomment-lines)
(define-key evil-visual-state-map (kbd ",/") 'evilnc-comment-or-uncomment-lines)

;;config for shell-pop
(require 'shell-pop)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(shell-pop-default-directory "/Users/kinney")
 '(shell-pop-shell-type (quote ("ansi-term" "*ansi-term*"
 				(lambda nil (ansi-term shell-pop-term-shell)))))
 '(shell-pop-term-shell "/bin/bash")
 '(shell-pop-universal-key "C-t")
 '(shell-pop-window-size 40)
 '(shell-pop-full-span t)
 '(shell-pop-window-position "right"))

;;===============================================================
;;config for company
(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)

  (global-company-mode t)
  )

(use-package company-irony
  :ensure t
  :config 
  (add-to-list 'company-backends 'company-irony)
  )

(use-package irony
  :ensure t
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  )

(use-package irony-eldoc
  :ensure t
  :config
  (add-hook 'irony-mode-hook #'irony-eldoc))

(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

(add-hook 'python-mode-hook 'my/python-mode-hook)
(use-package company-jedi
  :ensure t
  :config
  (add-hook 'python-mode-hook 'jedi:setup)
  )

(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

(add-hook 'python-mode-hook 'my/python-mode-hook)

;;; company box mode
;;(use-package company-box
;;:ensure t
;;:hook (company-mode . company-box-mode)) 
;;===============================================================

;;config for whick-key
(require 'which-key)
(which-key-mode)

;;config for window-numbering
(window-numbering-mode 1)
(setq window-numbering-assign-func
      (lambda () (when (equal (buffer-name) "*Calculator*") 9)))

;;config for ccls
(require 'ccls)
;;(setq ccls-executable "")

;;org-mode stuff
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook 'org-bullets-mode))

;;config for color-theme-sanityinc-tomorrow 
(require 'color-theme-sanityinc-tomorrow)

(provide 'init-packages)
