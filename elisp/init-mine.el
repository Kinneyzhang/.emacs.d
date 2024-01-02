(use-package etaf
  :load-path "~/PARA/RESOURCE/Emacs/pkgs/emacs-taf")

(use-package zknote
  :load-path "~/PARA/RESOURCE/Emacs/pkgs/zknote"
  :config
  (setq zknote-post-dir "~/geekblog/content/gknows")
  (setq zknote-db-file "~/ego/zknote.db")
  (global-set-key (kbd "C-c n f") #'zknote-note-find)
  (global-set-key (kbd "C-c n s") #'zknote-note-show)
  (global-set-key (kbd "C-c n i") #'zknote-note-index))

;; (add-to-list 'load-path "~/.emacs.d/site-lisp/holo-layer")
;; (require 'holo-layer)
;; (holo-layer-enable)
;; (setq holo-layer-enable-cursor-animation t)

(add-to-list 'load-path "~/PARA/RESOURCE/Emacs/elisp")
(require 'zkutils)
(require 'tps)
(require 'org-prettify)
(require 'autoflow)
(require 'geekblog)

(add-to-list 'load-path "~/PARA/RESOURCE/Emacs/pkgs/para")
(require 'para)

(add-to-list 'load-path "~/PARA/RESOURCE/Emacs/pkgs/flowedit")
(require 'flowedit)
(flowedit-mode 1)

(add-to-list 'load-path "~/PARA/RESOURCE/Emacs/pkgs/twidget")
(require 'twidget)

(defun flowedit-shorthand-para (filepath)
  (let ((file (concat "~/PARA/AREA" filepath))
        point)
    (with-current-buffer (find-file-noselect file)
      (setq point (point-max)))
    (cons file point)))

(setq flowedit-shorthand-function-alist
      `(("i" . ,(flowedit-shorthand-para "/待办事项/inbox.org"))
        ("t" . ,(flowedit-shorthand-para "/待办事项/todo.org"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package company-english-helper
  :load-path "~/.emacs.d/site-lisp/company-english-helper")

(use-package rich-text
  :load-path "~/PARA/RESOURCE/Emacs/pkgs/rich-text"
  :init (setq rich-text-selected-ignore-modes '(prog-mode))
  :config
  (rich-text-mode 1)
  (require 'rich-text-plus))

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

(unbind-key (kbd "M-n"))
(bind-key (kbd "M-n") #'forward-word 'global-map)

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
  :load-path "~/.emacs.d/site-lisp/color-rg")

;; (use-package xnote
;;   :load-path "~/iCloud/hack/xnote/")

(use-package zksummary
  :load-path "~/PARA/RESOURCE/Emacs/pkgs/zksummary"
  :config
  (setq zksummary-db-file "~/ego/zksummary.db")
  (global-set-key "\C-css" #'zksummary-daily-show-curr-week))

;; (defun my/color-rg-search-input ()
;;   (interactive)
;;   (minibuffer-with-setup-hook
;;       (lambda () (insert "thing-at-point"))
;;     (color-rg-search-input)))

(eval-when-compile
  (require 'cl-lib)) ;;; 整个文件 byte compile 就行了，没有必要显式调用 `byte-compile`
(add-hook 'post-gc-hook ;; post gc hook 內容要小，以防极端情况产生 dead loop
          (let ((--gcs-done -1))
            (lambda ()
              (when (/= --gcs-done gcs-done)
                (redraw-frame)
                (setq --gcs-done gcs-done)))))

(defun PREFIX/runtime-info-string ()
  (format-spec "%N GC (%ts total): %M VM, %hh runtime"
               `((?N . ,(format "%d%s"
                                gcs-done
                                (pcase (mod gcs-done 10)
                                  (1 "st")
                                  (2 "nd")
                                  (3 "rd")
                                  (_ "th"))))
                 (?t . ,(round gc-elapsed))
                 (?M . ,(cl-loop for memory = (memory-limit) then (/ memory 1024.0)
                                 for mem-unit across "KMGT"
                                 when (< memory 1024)
                                 return (format "%.1f%c"
                                                memory
                                                mem-unit)))
                 (?h . ,(format "%.1f"
                                (/ (time-to-seconds (time-since before-init-time))
                                   3600.0))))))

(setq frame-title-format '("" default-directory "  "
                           (:eval (PREFIX/runtime-info-string))))

;; 不需要显式调用 gc 或 redraw-frame。

;;;;; set and map in elisp

(defun set-make ()
  (make-hash-table :test 'equal))
(defun set-empty-p (set)
  (hash-table-empty-p set))
(defun set-count (set)
  (hash-table-count set))
(defun set-add (set el)
  (puthash el t set))
(defun set-member (set el)
  (gethash el set nil))
(defun set-list (set)
  (hash-table-keys set))
(defun set-remove (set el)
  (remhash el set))

(defun map-make ()
  (make-hash-table))
(defun map-empty-p (map)
  (hash-table-empty-p map))
(defun map-count (map)
  (hash-table-count map))
(defun map-set (map key value)
  (puthash key value map))
(defun map-get (map key)
  (gethash key map nil))
(defun map-remove (map key)
  (remhash key map))
(defun map-list (map)
  (cl-mapcan #'list (hash-table-keys map)
             (hash-table-values map)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ego-index

(defvar ego-dir (expand-file-name "~/PARA/RESOURCE/MISC"))

(defvar ego-index-file (expand-file-name "ego.org" ego-dir))

(defun ego-index ()
  (interactive)
  (switch-to-buffer (find-file-noselect ego-index-file))
  (let ((inhibit-read-only -1))
    (setq-local org-link-elisp-confirm-function nil)
    ;; (org-bullets-mode 1)
    (valign-mode 1)
    (read-only-mode 1)))

;; (defun ego-index-update-score ()
;;   (let ((score (number-to-string (ego-reward-score))))
;;     (when (re-search-forward "^* 当前积分: \\([-0-9]+\\)" nil t)
;;       (replace-match score nil nil nil 1))))

(defun ego-base-gknows-open (title)
  (interactive)
  (ignore (gkroam-find title)))

(defun ego-base-file-open (title)
  (interactive)
  (let* ((sxv8-dir "c:/Users/26289/Asiainfo/陕西V8")
         (file (expand-file-name title sxv8-dir)))
    (find-file file)))

(global-set-key (kbd "<f1>") 'ego-index)

(provide 'init-mine)
