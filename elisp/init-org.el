;; init-org.el
(use-package org
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
    (setq org-directory "~/GTD/")
    ;; (setq org-agenda-files '("~/GTD/org/"))
    (setq org-src-fontify-natively t)
    (setq org-agenda-window-setup 'current-window)))

(use-package org-src
  :hook ((org-mode . (lambda ()
                       "Beautify Org Checkbox Symbol"
		       (local-set-key (kbd "C-c o e") 'org-edit-src-code)
		       (local-set-key (kbd "C-c o i") 'org-insert-src-block)))
         (org-indent-mode . (lambda()
                              (diminish 'org-indent-mode)
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
	    '("emacs-lisp" "rust" "python" "C" "shell" "java"
              "js" "clojure" "C++" "css" "calc" "asymptote"
              "dot" "gnuplot" "lilypond" "mscgen"
	      "octave" "oz" "plantuml" "R" "sass" "screen" "sql"
              "awk" "ditaa" "haskell" "latex" "lisp" "matlab"
              "ocaml" "org" "perl" "ruby" "scheme" "sqlite" "html")))
       (list (ido-completing-read "Source code type: " src-code-types))))
    (save-excursion
      (newline-and-indent)
      (insert (format "#+BEGIN_SRC %s\n" src-code-type))
      (newline-and-indent)
      (insert "#+END_SRC\n")
      (previous-line 2)
      (org-edit-src-code))))

(defun my/org-hide-emphasis-markers ()
  (interactive)
  (setq org-hide-emphasis-markers t))

(defun my/org-show-emphasis-markers ()
  (interactive)
  (setq org-hide-emphasis-markers nil))

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
   (org . t)
   (clojure . t)))

(setq org-confirm-babel-evaluate nil)

;; (setq org-capture-templates
;;       '(("i" "inbox" entry (file "~/GTD/Inbox.org")
;; 	 "* TODO %?" :clock-resume t)
;; 	("t" "task" entry (file "~/GTD/Todo.org")
;; 	 "* TODO %?" :clock-resume t)
;; 	("s" "someday" entry (file "~/GTD/Someday.org")
;; 	 "* TODO %?" :clock-resume t)
;; 	("p" "project" entry (file "~/iCloud/org/project.org")
;; 	 "* PROJ %? [%]\n** TODO" :clock-resume t)))
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

(use-package htmlize
  :ensure t
  :defer 5)

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun org-current-is-todo ()
  (string= "TODO" (org-get-todo-state)))

(defun gk-set-todo-state-next ()
  "Visit each parent task and change NEXT states to TODO"
  (org-todo "NEXT"))

(add-hook 'org-clock-in-hook 'gk-set-todo-state-next 'append)

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "APPT(a)" "PROJ(p)" "NOTE(N)" "|" "DONE(d)")
        (sequence "WAITING(w@/!)" "DEFFERED(f@/!)" "|" "CANCELLED(c@/!)")))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
	      ("NEXT" :foreground "blue" :weight bold)
	      ("DONE" :foreground "forest green" :weight bold)
	      ("APPT" :foreground "orange" :weight bold)
	      ("PROJ" :foreground "black" :weight bold)
              ("NOTE" :foreground "black" :weight bold)
	      ("WAITING" :foreground "darkorange" :weight bold)
	      ("CANCELLED" :foreground "grey" :weight bold)
	      ("DEFFERED" :foreground "grey" :weight bold))))

(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-log-state-notes-insert-after-drawers nil)

(setq org-highest-priority ?A)
(setq org-lowest-priority  ?C)
(setq org-default-priority ?B)

(setq org-priority-faces
      '((?A . (:background "red" :foreground "white" :weight bold))
	(?B . (:background "DarkOrange" :foreground "white" :weight bold))
	(?C . (:background "SkyBlue" :foreground "black" :weight bold))))

(setq org-global-properties
      '(("Effort_ALL" . "0:15 0:30 1:00 2:00 3:00 4:00 5:00 6:00")
	("STYLE_ALL" . "habit")))

;; 标签设置的细不一定好，关键要对自己有意义。
;; (setq org-tag-alist (quote ((:startgroup)
;; 			    ("@study" . ?s)
;; 			    ("@hack" . ?h)
;; 			    ("@free" . ?f)
;; 			    ("@work" . ?w)
;; 			    (:endgroup)
;; 			    (:newline) 
;; 			    (:startgroup)
;; 			    ("monthly" . ?M)
;; 			    ("weekly" . ?W)
;; 			    (:endgroup)
;;                             (:newline)
;; 			    ("#think" . ?t)
;; 			    ("#buy" . ?b)
;;                             ("#animation" . ?a))))

(setq org-fast-tag-selection-single-key t)
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes nil)
(setq org-refile-targets '(("Todo.org" :level . 0)
			   ("Someday.org" :level . 0)))
;; Column View
(setq org-columns-default-format "%40ITEM(Task) %Effort(EE){:} %CLOCKSUM(Time Spent) %SCHEDULED(Scheduled) %DEADLINE(Deadline)")

;; ----------------------------------------------------------------
;; org clock
;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
(setq org-clock-in-resume t)
(setq org-clock-out-when-done t)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist t)
;; Do not prompt to resume an active clock
(setq org-clock-persist-query-resume nil)
;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)
;; Show the clocked-in task - if any - in the header line
(setq org-clock-out-remove-zero-time-clocks t)

(defun my/show-org-clock-in-header-line ()
  (setq-default header-line-format '((" " org-mode-line-string " "))))

(defun my/hide-org-clock-from-header-line ()
  (setq-default header-line-format nil))

(add-hook 'org-clock-in-hook 'my/show-org-clock-in-header-line)
(add-hook 'org-clock-out-hook 'my/hide-org-clock-from-header-line)
(add-hook 'org-clock-cancel-hook 'my/hide-org-clock-from-header-line)

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

(use-package valign
  :ensure t)

(provide 'init-org)
