;; init-org.el
(use-package org
  :preface
  (defun hot-expand (str &optional mod)
    "Expand org template."
    (let (text)
      (when (region-active-p)
        (setq text (buffer-substring (region-beginning) (region-end)))
        (delete-region (region-beginning) (region-end)))
      (insert str)
      (org-try-structure-completion)
      (when mod (insert mod) (forward-line))
      (when text (insert text))))
  :bind (("C-c a" . org-agenda))
  :config
  (progn
    ;; when opening a org file, don't collapse headings
    (setq org-startup-folded nil)
    ;; wrap long lines. don't let it disappear to the right
    ;; (setq org-startup-truncated t)
    ;; when in a url link, enter key should open it
    (setq org-return-follows-link t)
    ;; make org-mode” syntax color embedded source code
    (setq org-src-fontify-natively t)
    ;; how the source code edit buffer is displayed
    (setq org-src-window-setup 'current-window)
    (setq org-directory "~/GTD/org/")
    (setq org-agenda-files '("~/GTD/org/"))
    (setq org-src-fontify-natively t)
    (setq org-agenda-window-setup 'current-window)
    ))

(use-package org-src
  :hook ((org-mode . (lambda ()
                       "Beautify Org Checkbox Symbol"
		       (local-set-key (kbd "C-<tab>") 'yas/expand-from-trigger-key)
		       (local-set-key (kbd "C-c o e") 'org-edit-src-code)
		       (local-set-key (kbd "C-c o i") 'org-insert-src-block)
		       ))
         (org-indent-mode . (lambda()
                              (diminish 'org-indent-mode)
                              ;; WORKAROUND: Prevent text moving around while using brackets
                              ;; @see https://github.com/seagle0128/.emacs.d/issues/88
                              (make-variable-buffer-local 'show-paren-mode)
                              (setq show-paren-mode nil))))
  :custom
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-edit-src-content-indentation 0)
  :config
  (add-to-list 'org-src-lang-modes '("html" . web))
  ;;; org code block
  (defun org-insert-src-block (src-code-type)
    "Insert a `SRC-CODE-TYPE' type source code block in org-mode."
    (interactive
     (let ((src-code-types
	    '("emacs-lisp" "rust" "python" "C" "shell" "java" "js" "clojure" "C++" "css"
	      "calc" "asymptote" "dot" "gnuplot" "ledger" "lilypond" "mscgen"
	      "octave" "oz" "plantuml" "R" "sass" "screen" "sql" "awk" "ditaa"
	      "haskell" "latex" "lisp" "matlab" "ocaml" "org" "perl" "ruby"
	      "scheme" "sqlite" "html")))
       (list (ido-completing-read "Source code type: " src-code-types))))
    (save-excursion
      (newline-and-indent)
      (insert (format "#+BEGIN_SRC %s\n" src-code-type))
      (newline-and-indent)
      (insert "#+END_SRC\n")
      (previous-line 2)
      (org-edit-src-code))))

(defun diary-last-day-of-month (date)
  "Return `t` if DATE is the last day of the month."
  (let* ((day (calendar-extract-day date))
         (month (calendar-extract-month date))
         (year (calendar-extract-year date))
         (last-day-of-month
          (calendar-last-day-of-month month year)))
    (= day last-day-of-month)))

;; org-bable
(org-babel-do-load-languages
 'org-babel-load-languages
 '((scheme . t)
   (latex . t)
   (css . t)
   (ruby . t)
   (shell . t)
   (python . t)
   (emacs-lisp . t)
   (matlab . t)
   (C . t)
   (ledger . t)
   (org . t)
   ))

(setq org-confirm-babel-evaluate nil)

(setq org-capture-templates
      '(("i" "inbox" entry (file "~/GTD/org/inbox.org")
	 "* TODO %?" :clock-resume t)
	("t" "task" entry (file "~/GTD/org/task.org")
	 "* TODO %?" :clock-resume t)
	("s" "someday" entry (file "~/GTD/org/someday.org")
	 "* TODO %?" :clock-resume t)
	("a" "appointment" entry (file "~/GTD/org/task.org")
	 "* APPT %?")
	("p" "project" entry (file "~/GTD/org/project.org")
	 "* PROJ %? [%]\n** TODO" :clock-resume t)
	("h" "habit" entry (file "~/GTD/org/task.org")
	 "* TODO %?\n  :PROPERTIES:\n  :CATEGORY: Habit\n  :STYLE: habit\n  :REPEAT_TO_STATE: TODO\n  :END:\n  :LOGBOOK:\n  - Added %U\n  :END:"
	 )
	("j" "Journal" entry (file+datetree "~/GTD/blog_site/org/draft/journal.org")
         "* %?\nEntered on %U\n\n")	
	("m" "Morning Journal" entry (file+datetree "~/GTD/blog_site/org/draft/journal.org")
         "* 晨间记录\nEntered on %U\n\n天气:%? / 温度: / 地点:\n\n")
	("e" "Evening Journal" entry (file+datetree "~/GTD/blog_site/org/draft/journal.org")
	 "* 晚间总结\nEntered on %U\n\n*1.最影响情绪的事是什么?*\n\n/正面:/%?\n\n/负面:/\n\n*2.今天做了什么?*\n\n/日常行为:/\n\n/突发行为:/\n\n*3.今天思考了什么?*\n")
	))

;;; =========================================================================
;; other package and config

;; org html export
(setq org-html-head-include-scripts nil)
(setq org-html-head-include-default-style nil)
(setq org-html-htmlize-output-type nil) ;; 导出时不加行间样式！
(setq org-html-doctype "html5")
(setq org-html-html5-fancy t)
(setq user-full-name "Kinney Zhang")
(setq user-mail-address "kinneyzhang666@gmail.com")
(setq org-export-with-author nil)
(setq org-export-with-email nil)
(setq org-export-with-date nil)
(setq org-export-with-creator nil)
(setq org-html-validation-link nil)
(setq org-export-backends '(ascii html icalendar latex md))

;; (use-package org-bullets
;;   :ensure t
;;   :hook (org-mode . org-bullets-mode)
;;   :init
;;   (setq org-bullets-bullet-list '()))

(use-package calfw-org
  :ensure t
  :defer t
  :bind (("C-x c c" . my-open-calendar))
  :config
  (defun my-open-calendar ()
    (interactive)
    (cfw:open-calendar-buffer
     :contents-sources
     (list
      (cfw:org-create-source "#FFFFFF")))))

(use-package calfw
  :ensure t
  :defer t)

(use-package move-text
  :ensure t
  :defer 5
  :config (move-text-default-bindings))

(use-package htmlize
  :ensure t
  :defer 5)

;; (use-package idle-org-agenda
;;   :after org-agenda
;;   :ensure t
;;   :init (setq idle-org-agenda-interval 6000
;; 	      idle-org-agenda-key "d")
;;   :config (idle-org-agenda-mode))

(defun org-display-subtree-inline-images ()
  "Toggle the display of inline images.
INCLUDE-LINKED is passed to `org-display-inline-images'."
  (interactive)
  (save-excursion
    (save-restriction
      (org-narrow-to-subtree)
      (let* ((beg (point-min))
             (end (point-max))
             (image-overlays (cl-intersection
                              org-inline-image-overlays
                              (overlays-in beg end))))
        (if image-overlays
            (progn
              (org-remove-inline-images)
              (message "Inline image display turned off"))
          (org-display-inline-images t t beg end)
          (setq image-overlays (cl-intersection
                                org-inline-image-overlays
                                (overlays-in beg end)))
          (if (and (org-called-interactively-p) image-overlays)
              (message "%d images displayed inline"
                       (length image-overlays))))))))

(provide 'init-org)

