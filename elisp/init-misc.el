
;; (use-package eaf
;;   :load-path "~/.emacs.d/site-lisp/emacs-application-framework"
;;   :custom
;;   (eaf-browser-continue-where-left-off t)
;;   (eaf-browser-enable-adblocker t)
;;   (browse-url-browser-function 'eaf-open-browser)
;;   :config
;;   (defalias 'browse-web #'eaf-open-browser)
;;   ;; (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
;;   ;; (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
;;   ;; (eaf-bind-key take_photo "p" eaf-camera-keybinding)
;;   ;; (eaf-bind-key nil "M-q" eaf-browser-keybinding)
;;   (require 'eaf-browser)
;;   )

;; (use-package meow
;;   :ensure t
;;   :config
;;   ;; (meow-setup)
;;   (meow-global-mode 1))

;; (use-package undo-tree
;;   :ensure t
;;   :config
;;   (global-undo-tree-mode 1)
;;   :bind (("C-/" . undo-tree-undo)
;;          ("C-M-/" . undo-tree-redo)))

(defvar my-ideas-file "~/geekblog/content/moments.md")

(defun quick-open-file (&optional file)
  (interactive)
  (find-file my-ideas-file))

(global-set-key (kbd "<f4>") #'quick-open-file)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;; (use-package beacon
;;   :ensure t
;;   :config (beacon-mode 1))

;; (use-package awesome-tab
;;   :load-path "~/.emacs.d/site-lisp/awesome-tab"
;;   :config
;;   (setq awesome-tab-display-icon nil)
;;   (setq awesome-tab-height 100)
;;   (setq awesome-tab-show-tab-index t)
;;   (setq awesome-tab-label-fixed-length 0)
;;   (awesome-tab-mode 1))

(defvar ebooks-dir "~/ebooks")

(defvar ebooks-alist
  '(("Building a Second Brain" . "Building a Second Brain.epub")
    ("学会提问" . "学会提问12版.epub")))

(defun ebooks-open ()
  (interactive)
  (let* ((display-buffer-alist '(("\\*Async Shell Command\\*" display-buffer-no-window)))
         (ebook (completing-read "Choose a ebook: " ebooks-alist nil t))
         (filename (cdr (assoc ebook ebooks-alist)))
         (file (expand-file-name filename ebooks-dir)))
    (message "%s" (concat "ebook-viewer " (shell-quote-argument file)))
    (async-shell-command (concat "ebook-viewer " (shell-quote-argument file)))))

;; (use-package zksummary
;;   :load-path "c:/Users/26289/Hackings/zksummary"
;;   :config
;;   (setq zksummary-db-file "~/ego/zksummary.db")
;;   (setq zksummary-window-width 60)
;;   (global-set-key "\C-css" #'zksummary-daily-show-curr-week))

;; (use-package popweb
;;   :load-path "~/.emacs.d/site-lisp/popweb/"
;;   :config
;;   (use-package popweb-dict
;;     :load-path "~/.emacs.d/site-lisp/popweb/extension/dict/")
;;   (setq popweb-url-web-window-size-use-absolute t)
;;   (setq popweb-url-web-window-width-scale 0.8)
;;   (setq popweb-url-web-window-height-scale 0.45))

(define-minor-mode centaur-read-mode
  "Minor Mode for better reading experience."
  :init-value nil
  :group centaur
  (if centaur-read-mode
      (progn
        (and (fboundp 'olivetti-mode) (olivetti-mode 1))
        (and (fboundp 'mixed-pitch-mode) (mixed-pitch-mode 1))
        (text-scale-set +2))
    (progn
      (and (fboundp 'olivetti-mode) (olivetti-mode -1))
      (and (fboundp 'mixed-pitch-mode) (mixed-pitch-mode -1))
      (text-scale-set 0))))

(use-package nov
  :mode ("\\.epub\\'" . nov-mode)
  :hook (nov-mode . my-nov-setup)
  :init
  (setq nov-unzip-program (executable-find "C:/Users/26289/Apps/GnuWin32/bin/unzip"))
  (defun my-nov-setup ()
    "Setup `nov-mode' for better reading experience."
    (visual-line-mode 1)
    (centaur-read-mode)
    (face-remap-add-relative 'variable-pitch :family "Times New Roman" :height 1.5))
  :config
  (setq nov-text-width 80)
  (with-no-warnings
    ;; WORKAROUND: errors while opening `nov' files with Unicode characters
    ;; @see https://github.com/wasamasa/nov.el/issues/63
    (defun my-nov-content-unique-identifier (content)
      "Return the the unique identifier for CONTENT."
      (let* ((name (nov-content-unique-identifier-name content))
             (selector (format "package>metadata>identifier[id='%s']"
                               (regexp-quote name)))
             (id (car (esxml-node-children (esxml-query selector content)))))
        (and id (intern id))))
    (advice-add 'nov-content-unique-identifier :override 'my-nov-content-unique-identifier))

  ;; Fix encoding issue on Windows
  (when (eq system-type 'windows-nt)
    (setq process-coding-system-alist
          (cons `(,nov-unzip-program . (gbk . gbk))
                process-coding-system-alist))))

(use-package org-remark
  :bind (;; :bind keyword also implicitly defers org-remark itself.
         ;; Keybindings before :map is set for global-map.
         ("C-c n m" . org-remark-mark)
         ("C-c n l" . org-remark-mark-line)
         :map org-remark-mode-map
         ("C-c n o" . org-remark-open)
         ("C-c n ]" . org-remark-view-next)
         ("C-c n [" . org-remark-view-prev)
         ("C-c n r" . org-remark-remove)
         ("C-c n d" . org-remark-delete))
  ;; Alternative way to enable `org-remark-global-tracking-mode' in
  ;; `after-init-hook'.
  ;; :hook (after-init . org-remark-global-tracking-mode)
  :init
  ;; It is recommended that `org-remark-global-tracking-mode' be
  ;; enabled when Emacs initializes. Alternatively, you can put it to
  ;; `after-init-hook' as in the comment above
  (org-remark-global-tracking-mode +1)
  :config
  ;; (use-package org-remark-info :after info :config (org-remark-info-mode +1))
  ;; (use-package org-remark-eww  :after eww  :config (org-remark-eww-mode +1))
  (use-package org-remark-nov  :after nov  :config (org-remark-nov-mode +1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package company-english-helper
  :load-path "~/GitRepo/company-english-helper")

(use-package color-rg
  :load-path "~/.emacs.d/site-lisp/color-rg"
  :bind ("C-c c r" . color-rg-search-input))

(use-package promise
  :ensure t)

(setq js-indent-level 2)
(setq css-indent-offset 2)

;; (use-package mygtd
;;   :load-path "~/Hackings/mygtd"
;;   :config (global-set-key "\C-cmd" (lambda ()
;;                                      (interactive)
;;                                      (mygtd-daily-show mygtd-daily-date))))

(use-package python
  :ensure nil
  :config
  (setq python-indent-offset 3))

(use-package crow
  :load-path "~/emacs-pkgs/emacs-crow"
  :config
  (setq
   ;; crow开启的翻译信息
   crow-enable-info '(:examples nil
                                :source t
                                :translit nil
                                :translation t
                                :options nil)
   ;; crow翻译间隔延迟
   crow-translate-delay 0
   ;; crow翻译单位类型
   crow-translate-type (list 'word 'sentence)
   ;; 翻译文本ui呈现类型
   crow-ui-type '(posframe eldoc)
   ;; posframe超时隐藏时间
   crow-posframe-hide-timeout 3
   ;; crow posframe放置的位置
   crow-posframe-position (lambda () (point))))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/org-roam/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

(use-package slime
  :ensure t
  :config
  ;; 设置具体的 Common Lisp 实现，我这里是 sbcl
  (setq inferior-lisp-program "sbcl")
  ;; Slime 把多数功能拆成独立的包（Contrib Packages）
  ;; 需要根据功能单独加载，其中 slime-fancy 会自动加载流行的包，一般情况下只加载 slime-fancy 即可
  (setq slime-contribs '(slime-fancy)))

(use-package tree-sitter
  :ensure t)

(use-package tree-sitter-langs
  :ensure t)

(unbind-key (kbd "<f3>") global-map)
(unbind-key (kbd "<f4>") global-map)
(global-set-key (kbd "<f7>") 'kmacro-start-macro-or-insert-counter)
(global-set-key (kbd "<f8>") 'kmacro-end-or-call-macro)

;; (use-package avy
;;   :ensure t
;;   :bind (("<f4>" . avy-goto-line)
;;          ("<f3>" . avy-goto-char-timer)))

(use-package sql-indent
  :ensure t
  :config (sqlind-minor-mode 1))

(defun my/org-hide-emphasis-markers ()
  (interactive)
  (setq org-hide-emphasis-markers t))

(defun my/org-show-emphasis-markers ()
  (interactive)
  (setq org-hide-emphasis-markers nil))

;; (use-package org-appear
;;   :ensure t
;;   :config
;;   (add-hook 'org-mode-hook 'org-appear-mode)
;;   (setq org-appear-autoemphasis t
;;         org-appear-autosubmarkers t
;;         org-appear-autolinks nil))

;; (use-package gtd
;;   :load-path "~/Emacs/gtd-mode")

(use-package elisp-demos
  :ensure t
  :config (advice-add 'describe-function-1 :after 'elisp-demos-advice-describe-function-1))

(use-package toc-org
  :ensure t
  :config
  (if (require 'toc-org nil t)
      (progn
	    (add-hook 'org-mode-hook 'toc-org-mode)
	    ;; enable in markdown, too
	    (add-hook 'markdown-mode-hook 'toc-org-mode))
    (warn "toc-org not found")))

;; (use-package pp-html
;;   :load-path "~/iCloud/hack/pp-html")

;; (use-package ledger-mode
;;   :ensure t)

;; (use-package flycheck-ledger
;;   :ensure t
;;   :config
;;   (eval-after-load 'flycheck
;;     '(require 'flycheck-ledger)))

;; (use-package bm
;;   :ensure t
;;   :demand t
;;   :init
;;   (setq bm-restore-repository-on-load t)
;;   :config
;;   (setq bm-cycle-all-buffers t)
;;   (setq-default bm-buffer-persistence t)
;;   (add-hook 'after-init-hook 'bm-repository-load)
;;   (add-hook 'kill-buffer-hook 'bm-buffer-save)
;;   (add-hook 'kill-emacs-hook '(lambda nil
;;                                  (bm-buffer-save-all)
;;                                  (bm-repository-save))))

(use-package prescient
  :ensure t
  :config (prescient-persist-mode))

(use-package ivy-prescient
  :ensure t
  :config
  (ivy-prescient-mode)
  ;; Second, overwrite ivy-prescient-re-builder by ivy--regex-plus)
  ;; To handle the error when use counsel-rg in Windows
  (setf (alist-get 'counsel-rg ivy-re-builders-alist) 'ivy--regex-plus))

(use-package company-prescient
  :ensure t
  :config (company-prescient-mode))

(use-package awesome-pair
  :load-path "~/.emacs.d/site-lisp/awesome-pair"
  :config
  (dolist (hook (list
		         'c-mode-common-hook
		         'c-mode-hook
		         'c++-mode-hook
		         'java-mode-hook
		         'haskell-mode-hook
		         'emacs-lisp-mode-hook
		         'lisp-interaction-mode-hook
		         'lisp-mode-hook
		         'maxima-mode-hook
		         'ielm-mode-hook
		         'sh-mode-hook
		         'makefile-gmake-mode-hook
		         'php-mode-hook
		         'python-mode-hook
		         'js-mode-hook
		         'go-mode-hook
		         'qml-mode-hook
		         'jade-mode-hook
		         'css-mode-hook
		         'ruby-mode-hook
		         'coffee-mode-hook
		         'rust-mode-hook
		         'qmake-mode-hook
		         'lua-mode-hook
		         'swift-mode-hook
                 'clojure-mode-hook
		         'minibuffer-inactive-mode-hook))
    (add-hook hook '(lambda () (awesome-pair-mode 1))))

  (define-key awesome-pair-mode-map (kbd "(") 'awesome-pair-open-round)
  (define-key awesome-pair-mode-map (kbd "[") 'awesome-pair-open-bracket)
  (define-key awesome-pair-mode-map (kbd "{") 'awesome-pair-open-curly)
  (define-key awesome-pair-mode-map (kbd ")") 'awesome-pair-close-round)
  (define-key awesome-pair-mode-map (kbd "]") 'awesome-pair-close-bracket)
  (define-key awesome-pair-mode-map (kbd "}") 'awesome-pair-close-curly)

  ;; (define-key awesome-pair-mode-map (kbd "%") 'awesome-pair-match-paren)
  (define-key awesome-pair-mode-map (kbd "\"") 'awesome-pair-double-quote)

  ;;(define-key awesome-pair-mode-map (kbd "M-o") 'awesome-pair-backward-delete)
  ;;(define-key awesome-pair-mode-map (kbd "C-d") 'awesome-pair-forward-delete)
  (define-key awesome-pair-mode-map (kbd "C-k") 'awesome-pair-kill)

  (define-key awesome-pair-mode-map (kbd "M-\"") 'awesome-pair-wrap-double-quote)
  (define-key awesome-pair-mode-map (kbd "M-[") 'awesome-pair-wrap-bracket)
  (define-key awesome-pair-mode-map (kbd "M-{") 'awesome-pair-wrap-curly)
  (define-key awesome-pair-mode-map (kbd "M-(") 'awesome-pair-wrap-round)
  (define-key awesome-pair-mode-map (kbd "M-)") 'awesoMe-pair-unwrap)

  (define-key awesome-pair-mode-map (kbd "M-p") 'awesome-pair-jump-left)
  (define-key awesome-pair-mode-map (kbd "M-n") 'awesome-pair-jump-right)
  (define-key awesome-pair-mode-map (kbd "M-:") 'awesome-pair-jump-out-pair-and-newline))

(global-set-key (kbd "C-x -") 'split-window-below)
(global-set-key (kbd "C-x /") 'split-window-right)

;; (global-set-key (kbd "<f5>") 'revert-buffer)

;; ================================================
(global-set-key (kbd "C-c y s c") 'aya-create)
(global-set-key (kbd "C-c y s p") 'aya-persist-snippet)
(global-set-key (kbd "C-c y s e") 'aya-expand)

;; customize group and face
(global-set-key (kbd "C-x c g") 'customize-group)
(global-set-key (kbd "C-x c f") 'customize-face)
(global-set-key (kbd "C-x c t") 'customize-themes)
(global-set-key (kbd "C-x c v") 'customize-variable)

(global-set-key (kbd "C-c C-/") 'comment-or-uncomment-region)

(global-set-key (kbd "M-/") 'set-mark-command)
(global-set-key (kbd "M-SPC") 'set-mark-command)

;;代码缩进
(add-hook 'prog-mode-hook '(lambda ()
			                 (local-set-key (kbd "C-M-\\")
					                        'indent-region-or-buffer)))

;; 延迟加载
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file))

(use-package expand-region
  :ensure t
  :bind (("C-=" . ha/expand-region))
  :config
  (defun ha/expand-region (lines)
    "Prefix-oriented wrapper around Magnar's `er/expand-region'.

Call with LINES equal to 1 (given no prefix), it expands the
region as normal.  When LINES given a positive number, selects
the current line and number of lines specified.  When LINES is a
negative number, selects the current line and the previous lines
specified.  Select the current line if the LINES prefix is zero."
    (interactive "p")
    (cond ((= lines 1)   (er/expand-region 1))
          ((< lines 0)   (ha/expand-previous-line-as-region lines))
          (t             (ha/expand-next-line-as-region (1+ lines)))))

  (defun ha/expand-next-line-as-region (lines)
    (message "lines = %d" lines)
    (beginning-of-line)
    (set-mark (point))
    (end-of-line lines))

  (defun ha/expand-previous-line-as-region (lines)
    (end-of-line)
    (set-mark (point))
    (beginning-of-line (1+ lines))))

(use-package magit
  :defer t
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package company
  :ensure t
  :defer 5
  :config
  (setq company-idle-delay 0.1)
  (setq company-candidates-length 5)
  (setq company-minimum-prefix-length 2)
  (global-company-mode t)
  (with-eval-after-load 'company
    (define-key company-active-map (kbd "\C-n") 'company-select-next)
    (define-key company-active-map (kbd "\C-p") 'company-select-previous)
    (define-key company-active-map (kbd "M-n") nil)
    (define-key company-active-map (kbd "M-p") nil)))

(use-package yasnippet
  :ensure t
  :defer t
  :init (setq yas-snippet-dirs `(,(concat user-emacs-directory "snippets")))
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode))

(use-package smartparens
  :ensure t
  :config
  (electric-pair-mode t)
  (sp-local-pair 'emacs-lisp-mode "'" nil :actions nil))

(use-package hungry-delete
  :defer 5
  :ensure t
  :config
  (global-hungry-delete-mode))

(use-package flycheck
  :ensure t
  :defer 5
  :init
  (progn
    (define-fringe-bitmap 'my-flycheck-fringe-indicator
      (vector #b00000000
	          #b00000000
	          #b00000000
	          #b00000000
	          #b00000000
	          #b00000000
	          #b00000000
	          #b00011100
	          #b00111110
	          #b00111110
	          #b00111110
	          #b00011100
	          #b00000000
	          #b00000000
	          #b00000000
	          #b00000000
	          #b00000000))

    (flycheck-define-error-level 'error
      :severity 2
      :overlay-category 'flycheck-error-overlay
      :fringe-bitmap 'my-flycheck-fringe-indicator
      :fringe-face 'flycheck-fringe-error)

    (flycheck-define-error-level 'warning
      :severity 1
      :overlay-category 'flycheck-warning-overlay
      :fringe-bitmap 'my-flycheck-fringe-indicator
      :fringe-face 'flycheck-fringe-warning)

    (flycheck-define-error-level 'info
      :severity 0
      :overlay-category 'flycheck-info-overlay
      :fringe-bitmap 'my-flycheck-fringe-indicator
      :fringe-face 'flycheck-fringe-info))

  :config
  (add-hook 'c++-mode-hook 'flycheck-mode)
  (add-hook 'python-mode-hook 'flycheck-mode)
  (add-hook 'js2-mode-hook 'flycheck-mode)
  (add-hook 'java-mode-hook 'flycheck-mode)
  (add-hook 'web-mode-hook 'flycheck-mode)
  (add-hook 'ledger-mode-hook 'flycheck-mode)
  ;; (add-hook 'emacs-lisp-mode-hook 'flycheck-mode)

;;; On Windows, commands run by flycheck may have CRs (\r\n line endings).
;;; Strip them out before parsing.
  (defun flycheck-parse-output-1 (output checker buffer)
    "Parse OUTPUT from CHECKER in BUFFER.
OUTPUT is a string with the output from the checker symbol
CHECKER.  BUFFER is the buffer which was checked.
Return the errors parsed with the error patterns of CHECKER."
    (let ((sanitized-output (replace-regexp-in-string "\r" "" output)))
      (funcall (flycheck-checker-get checker 'error-parser)
               sanitized-output checker buffer)))
  (advice-add 'flycheck-parse-output :override 'flycheck-parse-output-1))

;; markdown and preview

(use-package markdown-mode
  :ensure t
  :defer 5
  :mode (("README\\.md\\'" . gfm-mode)
	     ("\\.md\\'" . markdown-mode)
	     ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "markdown_py")
  :config
  ;; Don't like the background of markdown table.
  (add-hook 'markdown-mode-hook #'valign-mode)
  (defface markdown-table-face '((t)) ""))

(use-package exec-path-from-shell
  :defer 5
  :if (memq window-system '(ns mac))
  :ensure t
  :config
  (setq exec-path-from-shell-arguments '("-l"))
  (exec-path-from-shell-initialize))

;;;==================================================
(defun maple/mac-switch-input-source ()
  (shell-command
   "osascript -e 'tell application \"System Events\" to tell process \"SystemUIServer\"
   set currentLayout to get the value of the first menu bar item of menu bar 1 whose description is \"text input\"
   if currentLayout is not \"ABC\" then
   tell (1st menu bar item of menu bar 1 whose description is \"text input\") to {click, click (menu 1'\"'\"'s menu item \"ABC\")}
   end if
   end tell' &>/dev/null"))

(use-package cal-china-x
  :ensure t
  :after calendar
  :commands cal-china-x-setup
  :init (cal-china-x-setup)
  :config
  ;; `S' can show the time of sunrise and sunset on Calendar
  (setq calendar-location-name "Chengdu"
	    calendar-latitude 30.67
	    calendar-longitude 104.06)
  ;; Holidays
  (setq calendar-mark-holidays-flag nil)
  (setq cal-china-x-important-holidays cal-china-x-chinese-holidays)
  (setq cal-china-x-general-holidays
	    '((holiday-lunar 1 15 "元宵节")
	      (holiday-lunar 7 7 "七夕节")
	      (holiday-fixed 3 8 "妇女节")
	      (holiday-fixed 3 12 "植树节")
	      (holiday-fixed 5 4 "青年节")
	      (holiday-fixed 6 1 "儿童节")
	      (holiday-fixed 9 10 "教师节")))
  (setq holiday-other-holidays
	    '((holiday-fixed 2 14 "情人节")
	      (holiday-fixed 4 1 "愚人节")
	      (holiday-fixed 12 25 "圣诞节")
	      (holiday-float 5 0 2 "母亲节")
	      (holiday-float 6 0 3 "父亲节")
	      (holiday-float 11 4 4 "感恩节"))))

(provide 'init-misc)
