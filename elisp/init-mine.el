(use-package emacsql
  :ensure t)

(use-package emacsql-sqlite
  :ensure t)

(use-package db
  :ensure t)

;; (use-package mygtd
;;   :load-path "~/iCloud/hack/mygtd")

;; (use-package md-wiki
;;   :load-path "~/iCloud/hack/md-wiki"
;;   :config
;;   (defun md-wiki-gen-site-force-nav-and-wiki ()
;;     (interactive)
;;     (md-wiki-gen-site-force-nav)
;;     (gk/deploy-wiki))

;;   (defun md-wiki-gen-site-force-meta-and-wiki ()
;;     (interactive)
;;     (md-wiki-gen-site-force-meta)
;;     (gk/deploy-wiki))

;;   (setq md-wiki-dir "~/geekblog/content/gknows")
;;   (setq md-wiki-bookmark-list '("习惯培养" "费曼学习法"))
;;   (setq md-wiki-tree-file "~/iCloud/hack/md-wiki/config/mdwiki.org")
;;   (setq md-wiki-diff-file "~/iCloud/hack/md-wiki/config/mdwiki-diff.el")
  
;;   (bind-key (kbd "C-c w f") #'md-wiki-page-edit)
;;   (bind-key (kbd "C-c w p") #'md-wiki-gen-site)
;;   (bind-key (kbd "C-c w [") #'md-wiki-gen-site-force-nav-and-wiki)
;;   (bind-key (kbd "C-c w ]") #'md-wiki-gen-site-force-meta-and-wiki)
;;   (bind-key (kbd "C-c w o") #'md-wiki-tree-edit)
;;   (bind-key (kbd "C-c w d") #'md-wiki-show-diff)
;;   (bind-key (kbd "C-c w b") #'md-wiki-browse-page)
;;   (bind-key (kbd "C-c w B") #'md-wiki-browse-curr-page)
;;   (bind-key (kbd "C-c w I") #'md-wiki-tree-show)
;;   (bind-key (kbd "C-c w c") #'md-wiki-page-capture))


(add-to-list 'load-path "~/PARA/RESOURCE/Emacs/elisp")
(require 'zkutils)
(require 'tps)
(require 'org-prettify)
(require 'autoflow)
(require 'geekblog)

(use-package etaf
  :load-path "~/PARA/RESOURCE/Emacs/pkgs/emacs-taf")

(add-to-list 'load-path "~/PARA/RESOURCE/Emacs/pkgs/para")
(require 'para)

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

(provide 'init-mine)
