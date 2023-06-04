(use-package rich-text
  :load-path "~/EmacsLisp/rich-text"
  :config
  (use-package selected :ensure t)
  (rich-text-mode 1))

(use-package mind-wave
  :load-path "~/.config/emacs/site-lisp/mind-wave")

(defun mind-wave-new-file-and-chat ()
  (interactive)
  (let* ((dir (expand-file-name "mind-wave" user-emacs-directory))
         (file (expand-file-name "1.chat" dir))
         (buf (find-file-noselect file)))
    (switch-to-buffer buf)
    (mind-wave-chat-ask)))
(global-set-key "\C-c\C-j" 'mind-wave-new-file-and-chat)

(use-package emacsql
  :ensure t)

(use-package emacsql-sqlite
  :ensure t)

(use-package db
  :ensure t)

(use-package mygtd
  :load-path "~/EmacsLisp/mygtd"
  :config
  (setq mygtd-db-file "~/iCloud/hack/mygtd/mygtd.db")
  (global-set-key (kbd "C-c m d") #'mygtd-daily-show))

(use-package md-wiki
  :load-path "~/iCloud/hack/md-wiki"
  :config
  (defun md-wiki-gen-site-force-nav-and-wiki ()
    (interactive)
    (md-wiki-gen-site-force-nav)
    (gk/deploy-wiki))

  (defun md-wiki-gen-site-force-meta-and-wiki ()
    (interactive)
    (md-wiki-gen-site-force-meta)
    (gk/deploy-wiki))

  (setq md-wiki-dir "~/geekblog/content/gknows")
  (setq md-wiki-bookmark-list '("习惯培养" "费曼学习法"))
  (setq md-wiki-tree-file "~/iCloud/hack/md-wiki/config/mdwiki.org")
  (setq md-wiki-diff-file "~/iCloud/hack/md-wiki/config/mdwiki-diff.el")
  
  (bind-key (kbd "C-c w f") #'md-wiki-page-edit)
  (bind-key (kbd "C-c w p") #'md-wiki-gen-site)
  (bind-key (kbd "C-c w [") #'md-wiki-gen-site-force-nav-and-wiki)
  (bind-key (kbd "C-c w ]") #'md-wiki-gen-site-force-meta-and-wiki)
  (bind-key (kbd "C-c w o") #'md-wiki-tree-edit)
  (bind-key (kbd "C-c w d") #'md-wiki-show-diff)
  (bind-key (kbd "C-c w b") #'md-wiki-browse-page)
  (bind-key (kbd "C-c w B") #'md-wiki-browse-curr-page)
  (bind-key (kbd "C-c w I") #'md-wiki-tree-show)
  (bind-key (kbd "C-c w c") #'md-wiki-page-capture))

(use-package gkroam
  :load-path "~/iCloud/hack/gkroam"
  :hook (after-init . gkroam-mode)
  :init
  (setq gkroam-root-dir "~/gknows/")
  (setq gkroam-show-brackets-flag nil
        gkroam-prettify-page-flag t
        gkroam-title-height 200
        gkroam-use-default-filename t
        gkroam-window-margin 4)
  :bind
  (:map gkroam-mode-map
        (("C-c r g" . gkroam-update)
         ("C-c r d" . gkroam-daily)
         ("C-c r b" . gkroam-bootstrap)
         ("C-c r D" . gkroam-delete)
         ("C-c r f" . gkroam-find)
         ("C-c r c" . gkroam-capture)
         ("C-c r e" . gkroam-link-edit)
         ("C-c r n" . gkroam-dwim)
         ("C-c r i" . gkroam-insert)
         ("C-c r I" . gkroam-index)
         ("C-c r u" . gkroam-show-unlinked)
         ("C-c r t" . gkroam-toggle-brackets)
         ("C-c r p" . gkroam-toggle-prettify)
         ("C-c r R" . gkroam-rebuild-caches)))
  :config
  (setq org-startup-folded nil)
  (defun gkroam-bootstrap ()
    (interactive)
    (gkroam-find "bootstrap")))

(use-package color-rg
  :load-path "~/.config/emacs/site-lisp/color-rg")

(use-package xnote
  :load-path "~/iCloud/hack/xnote/")

(use-package zksummary
  :load-path "~/zksummary"
  :config
  (setq zksummary-db-file "~/ego/zksummary.db")
  (global-set-key "\C-css" #'zksummary-daily-show-curr-week))

;; (defun my/color-rg-search-input ()
;;   (interactive)
;;   (minibuffer-with-setup-hook
;;       (lambda () (insert "thing-at-point"))
;;     (color-rg-search-input)))

(provide 'init-mine)
