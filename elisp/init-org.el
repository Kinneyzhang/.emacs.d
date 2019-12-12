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
  :bind (("C-c c" . org-capture)
	 ("<f11>" . plain-org-wiki)
	 ("<f12>" . org-agenda)
	 ("C-c a" . org-agenda)
	 ("C-c o l" . org-store-link)
	 ("C-c t v" . org-tags-view)
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
  ;;; org code block
  (defun org-insert-src-block (src-code-type)
    "Insert a `SRC-CODE-TYPE' type source code block in org-mode."
    (interactive
     (let ((src-code-types
	    '("emacs-lisp" "python" "C" "shell" "java" "js" "clojure" "C++" "css"
	      "calc" "asymptote" "dot" "gnuplot" "ledger" "lilypond" "mscgen"
	      "octave" "oz" "plantuml" "R" "sass" "screen" "sql" "awk" "ditaa"
	      "haskell" "latex" "lisp" "matlab" "ocaml" "org" "perl" "ruby"
	      "scheme" "sqlite")))
       (list (ido-completing-read "Source code type: " src-code-types))))
    (progn
      (newline-and-indent)
      (insert (format "#+BEGIN_SRC %s\n" src-code-type))
      (newline-and-indent)
      (insert "#+END_SRC\n")
      (previous-line 2)
      (org-edit-src-code)))
  (add-to-list 'org-src-lang-modes '("html" . web)))

(use-package org-habit
  :init
  (setq org-habit-show-habits t
	org-habit-show-all-today nil
	org-habit-graph-column 75
	org-habit-preceding-days 30
	org-habit-following-days 1
        org-habit-today-glyph ?@)
  :config
  (defvar my/org-habit-show-graphs-everywhere nil)

  (defun my/org-agenda-mark-habits ()
    (when (and my/org-habit-show-graphs-everywhere
	       (not (get-text-property (point) 'org-series)))
      (let ((cursor (point))
	    item data)
	(while (setq cursor (next-single-property-change cursor 'org-marker))
	  (setq item (get-text-property cursor 'org-marker))
	  (when (and item (org-is-habit-p item))
	    (with-current-buffer (marker-buffer item)
	      (setq data (org-habit-parse-todo item)))
	    (put-text-property cursor
			       (next-single-property-change cursor 'org-marker)
			       'org-habit-p data))))))
  (advice-add #'org-agenda-finalize :before #'my/org-agenda-mark-habits))

;; repeating task
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
 '( (scheme . t)
    (latex . t)
    (css . t)
    (ruby . t)
    (shell . t)
    (python . t)
    (emacs-lisp . t)
    (matlab . t)
    (C . t)
    (ledger . t)
    (jupyter . t)
    ))

(setq org-confirm-babel-evaluate nil)

;; org clock
;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
(setq org-clock-in-resume t)
(setq org-clock-out-when-done t)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist t)
(setq org-clock-persist-file (concat config-dir "org-clock-save.el"))
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

(use-package org-pomodoro
  :ensure t
  :init
  (setq org-pomodoro-length 40
	org-pomodoro-short-break-length 5
	org-pomodoro-long-break-length 15
	org-pomodoro-long-break-frequency 3
	org-pomodoro-ask-upon-killing t)
  (define-key org-agenda-mode-map "P" 'org-pomodoro)
  (add-hook 'org-pomodoro-finished-hook
	    (lambda ()
	      (notify-osx "Pomodoro completed!" "Time for a break.")))
  (add-hook 'org-pomodoro-break-finished-hook
	    (lambda ()
	      (notify-osx "Pomodoro Short Break Finished" "Ready for Another?")))
  (add-hook 'org-pomodoro-long-break-finished-hook
	    (lambda ()
	      (notify-osx "Pomodoro Long Break Finished" "Ready for Another?")))
  (add-hook 'org-pomodoro-killed-hook    
	    (lambda ()
	      (notify-osx "Pomodoro Killed" "One does not simply kill a pomodoro!")))
  :config
  (defun notify-osx (title message)   
    (call-process "terminal-notifier"		 
		  nil 0 nil		 
		  "-group" "Emacs"		 
		  "-title" title		 
		  "-sender" "org.gnu.Emacs"		 
		  "-message" message		 
		  "-activate" "oeg.gnu.Emacs")))

;;; ==========================================================================
;;; Org Mode for GTD

(require 'find-lisp)
(setq jethro/org-agenda-directory (expand-file-name "~/iCloud/"))
(setq my/blog-bookmark-file (expand-file-name "~/iCloud/blog/bookmark.org"))
(setq org-agenda-files '("~/iCloud/org/gtd.org"))

(setq org-src-fontify-natively t)
(setq org-agenda-window-setup 'current-window)
;; (setq org-directory "~/iCloud")

;;; Stage 1: Collecting

(setq org-capture-templates
      '(("i" "inbox" entry (file "~/iCloud/org/gtd.org")
	 "* TODO %? :INBOX:\n" :clock-resume t
	 :empty-lines 1)
	("n" "next" entry (file "~/iCloud/org/gtd.org")
	 "* NEXT %?" :clock-resume t
	 :empty-lines 1)
	("a" "appointment" entry (file "~/iCloud/org/gtd.org")
	 "* APPT %? :APPT:\n"
	 :empty-lines 1)
	("p" "project" entry (file "~/iCloud/org/gtd.org")
	 "* PROJ %? [%] :PROJECT:\n :PROPERTIES:\n :CATEGORY: project\n :END:\n** TODO \n" :clock-resume t
	 :empty-lines 1)
	("b" "bookmark" entry (file+headline "~/iCloud/blog/bookmark.org" "Misc")
	 "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:"
	 :empty-lines 1)
	("j" "晨间日记" entry (function org-journal-find-location)
	 "* %(format-time-string org-journal-time-format)晨间日记\n** 天气/温度/地点：\n** 纪念日：\n** 生日：\n\n** 总结\n** 学习\n** 健康\n** 兴趣\n** 人际\n"
	 )
	("h" "Habit" entry (file "~/iCloud/org/gtd.org")
	 "* TODO %?\n  :PROPERTIES:\n  :CATEGORY: Habit\n  :STYLE: habit\n  :REPEAT_TO_STATE: TODO\n  :END:\n  :LOGBOOK:\n  - Added %U\n  :END:"
	 )
	))

;;; Stage 2: Processing

;; Org Agenda Reading view


;; keywords

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "APPT(a)" "PROJ(p)" "|" "DONE(d)")
        (sequence "WAITING(w@/!)" "|" "DEFFERED(f@/!)" "CANCELLED(c@/!)")))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
	      ("NEXT" :foreground "blue" :weight bold)
	      ("DONE" :foreground "forest green" :weight bold)
	      ("APPT" :foreground "orange" :weight bold)
	      ("PROJ" :foreground "grey" :weight bold)
	      ("WAITING" :foreground "magenta" :weight bold)
	      ("DEFFERED" :foreground "forest green" :weight bold)
	      ("CANCELLED" :foreground "forest green" :weight bold)
	      )))

(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-log-state-notes-insert-after-drawers nil)

;; priority

;; 优先级范围和默认任务的优先级
(setq org-highest-priority ?A)
(setq org-lowest-priority  ?E)
(setq org-default-priority ?C)
;; 优先级醒目外观
(setq org-priority-faces
      '((?A . (:background "red" :foreground "white" :weight bold))
	(?B . (:background "DarkOrange" :foreground "white" :weight bold))
	(?C . (:background "yellow" :foreground "DarkGreen" :weight bold))
	(?D . (:background "DodgerBlue" :foreground "black" :weight bold))
	(?E . (:background "SkyBlue" :foreground "black" :weight bold))
	))

;; effort
(setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
				    ("STYLE_ALL" . "habit"))))


;; The Process
					; Step 1: Clarifying

(setq org-tag-alist (quote ((:startgroup)
			    ("@office" . ?O)
                            ("@home" . ?H)
			    (:endgroup)
                            (:newline)
                            ("WAITING" . ?W)
                            ("CANCELLED" . ?C)

			    ("emacs" . ?e)
			    ("blog" . ?b)
			    ("geekstuff" . ?g)

			    ("INBOX" . ?i)
			    ("PROJECT" . ?p)
			    ("APPT" . ?a)
			    ("SOMEDAY" . ?s)
			    ("DONE" . ?d)
			    
			    ("ONEOFF" . ?o)
			    ("reading" . ?r)
			    ("watching" . ?w)
			    ("learning" . ?l)
			    ("habit" . ?h)
			    )))

(setq org-fast-tag-selection-single-key nil)

					; Step 2: Organizing

(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
;; (setq org-refile-allow-creating-parent-nodes 'confirm)
(setq org-refile-allow-creating-parent-nodes nil)
;; (setq org-refile-targets '(
;; 			   ("gtd.org" :maxlevel . 1)
;; 			   ("someday.org" :level . 1)
;; 			   ("bookmark.org" :maxlevel . 2)))

(setq org-refile-targets '(("gtd.org" :maxlevel . 1)
			   (my/blog-bookmark-file :maxlevel . 1)))


(defvar jethro/org-agenda-bulk-process-key ?f
  "Default key for bulk processing inbox items.")

;; (defun jethro/org-process-inbox ()
;;   "Called in org-agenda-mode, processes all inbox items."
;;   (interactive)
;;   (org-agenda-bulk-mark-regexp "inbox:")
;;   (jethro/bulk-process-entries))

(defun jethro/org-process-inbox ()
  "Called in org-agenda-mode, processes all inbox items."
  (interactive)
  (org-agenda-set-tags)
  (org-agenda-set-effort)
  (org-agenda-refile)
  )


(defvar jethro/org-current-effort "1:00" "Current effort for agenda items.")

(defun jethro/my-org-agenda-set-effort (effort)
  "Set the effort property for the current headline."
  (interactive
   (list (read-string (format "Effort [%s]: " jethro/org-current-effort) nil nil jethro/org-current-effort)))
  (setq jethro/org-current-effort effort)
  (org-agenda-check-no-diary)
  (let* ((hdmarker (or (org-get-at-bol 'org-hd-marker)
                       (org-agenda-error)))
         (buffer (marker-buffer hdmarker))
         (pos (marker-position hdmarker))
         (inhibit-read-only t)
         newhead)
    (org-with-remote-undo buffer
      (with-current-buffer buffer
        (widen)
        (goto-char pos)
        (org-show-context 'agenda)
        (funcall-interactively 'org-set-effort nil jethro/org-current-effort)
        (end-of-line 1)
        (setq newhead (org-get-heading)))
      (org-agenda-change-all-lines newhead hdmarker))))

(defun jethro/org-agenda-process-inbox-item ()
  "Process a single item in the org-agenda."
  (org-with-wide-buffer
   (org-agenda-set-tags)
   (org-agenda-priority)
   (call-interactively 'jethro/my-org-agenda-set-effort)
   (org-agenda-refile nil nil t)))

(defun jethro/bulk-process-entries ()
  (if (not (null org-agenda-bulk-marked-entries))
      (let ((entries (reverse org-agenda-bulk-marked-entries))
            (processed 0)
            (skipped 0))
        (dolist (e entries)
          (let ((pos (text-property-any (point-min) (point-max) 'org-hd-marker e)))
            (if (not pos)
                (progn (message "Skipping removed entry at %s" e)
                       (cl-incf skipped))
              (goto-char pos)
              (let (org-loop-over-headlines-in-active-region) (funcall 'jethro/org-agenda-process-inbox-item))
              ;; `post-command-hook' is not run yet.  We make sure any
              ;; pending log note is processed.
              (when (or (memq 'org-add-log-note (default-value 'post-command-hook))
                        (memq 'org-add-log-note post-command-hook))
                (org-add-log-note))
              (cl-incf processed))))
        (org-agenda-redo)
        (unless org-agenda-persistent-marks (org-agenda-bulk-unmark-all))
        (message "Acted on %d entries%s%s"
                 processed
                 (if (= skipped 0)
                     ""
                   (format ", skipped %d (disappeared before their turn)"
                           skipped))
                 (if (not org-agenda-persistent-marks) "" " (kept marked)")))
    ))



(defun jethro/org-inbox-capture ()
  (interactive)
  "Capture a task in agenda mode."
  (org-capture nil "i"))

(setq org-agenda-bulk-custom-functions `((,jethro/org-agenda-bulk-process-key jethro/org-agenda-process-inbox-item)))

(defun my/make-someday-task-active ()
  "make someday project active"
  (interactive)
  (org-agenda-set-tags "SOMEDAY")
  (org-agenda-todo "NEXT"))

(defun my/make-someday-task-inactive ()
  "make someday project active"
  (interactive)
  (org-agenda-set-tags "SOMEDAY")
  (org-agenda-todo "TODO"))

(define-key org-agenda-mode-map "r" 'jethro/org-process-inbox)
;; (define-key org-agenda-mode-map "R" 'org-agenda-refile)
(define-key org-agenda-mode-map "c" 'jethro/org-inbox-capture)
(define-key org-agenda-mode-map "+" 'my/make-someday-task-active)
(define-key org-agenda-mode-map "-" 'my/make-someday-task-inactive)

;; Clocking in

(defun jethro/set-todo-state-next ()
  "Visit each parent task and change NEXT states to TODO"
  (org-todo "NEXT"))

(add-hook 'org-clock-in-hook 'jethro/set-todo-state-next 'append)


;;; Stage 3: Reviewing

;; Custom agenda Commands
(setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-include-diary nil
      org-agenda-block-separator nil
      org-agenda-compact-blocks t
      org-agenda-start-with-log-mode t)

(setq org-agenda-custom-commands
      '(("o" "Main Agenda"
         ((agenda "" ((org-agenda-span 'day)
		      (org-super-agenda-groups
                       '((:name "Daily Agenda"
                                :time-grid t
				:habit t
                                :order 1)
			 (:name "Due Today"
                                :deadline today
                                :order 2)
                         (:name "Overdue"
                                :deadline past
                                :order 3)
                         (:name "Due Soon"
                                :deadline future
                                :order 4)
			 (:discard (:anything t))
			 ))
                      ))
	  (alltodo "" ((org-agenda-overriding-header "")
		       (org-super-agenda-groups
			'((:name "Inbox"
				 :tag "INBOX")
			  (:name "Next To Do!"
				 :todo "NEXT")
			  (:name "Important"
                                 :tag "Important"
                                 :priority "A")
			  (:name "Waiting"
                                 :todo "WAITING")
			  (:name "Active Projects"
				 :todo "PROJ")
			  (:name "Detail Projects"
				 :and (:tag "PROJECT" :not (:tag "SOMEDAY")))
			  
			  (:name "---------------------------------------------\n Someday Projects"
				 :and (:tag "PROJECT" :tag "SOMEDAY"))
			  (:name "Emacs Stuff:"
				 :and (:tag "emacs" :tag "SOMEDAY"))
			  (:name "Books/articles to Read:"
				 :and (:tag "reading" :tag "SOMEDAY"))
			  (:name "Films/videos to watch:"
				 :and (:tag "watching" :tag "SOMEDAY"))
			  (:name "Blog in Plan:"
				 :and (:tag "blog" :tag "SOMEDAY"))
			  
			  (:discard (:tag "PROJECT" :habit t))))))))
	;; ("s" "Someday & Project Agenda"
	;;  ((alltodo "" ((org-agenda-overriding-header "Someday & Project Agenda")
	;; 	       (org-super-agenda-groups
	;; 		'((:name "Someday Projects"
	;; 			 :and (:tag "PROJECT" :tag "SOMEDAY"))
	;; 		  (:name "Emacs Stuff:"
	;; 			 :and (:tag "emacs" :tag "SOMEDAY"))
	;; 		  (:name "Books/articles to Read:"
	;; 			 :and (:tag "reading" :tag "SOMEDAY"))
	;; 		  (:name "Films/videos to watch:"
	;; 			 :and (:tag "watching" :tag "SOMEDAY"))
	;; 		  (:name "Blog in Plan:"
	;; 			 :and (:tag "blog" :tag "SOMEDAY"))
	;; 		  (:discard (:not (:tag "SOMEDAY")))
	;; 		  ))
	;; 	       ))))
	))

(use-package org-super-agenda
  :ensure t
  :init (setq org-super-agenda-groups t)
  :config (org-super-agenda-mode t))


(defun jethro/org-agenda-skip-all-siblings-but-first ()
  "Skip all but the first non-done entry."
  (let (should-skip-entry)
    (unless (or (org-current-is-todo)
                (not (org-get-scheduled-time (point))))
      (setq should-skip-entry t)) ;; 当前是不是TODO且当前有scheduled time才设置跳过
    (save-excursion
      (while (and (not should-skip-entry) (org-goto-sibling t))
        (when (org-current-is-todo)
	  (setq should-skip-entry t)))) ;; 在当不跳过且走到兄弟节点时循环，如何当前为TODO则跳过。
    (when should-skip-entry
      (or (outline-next-heading)
	  (goto-char (point-max))))))

(defun jethro/org-agenda-skip-all-children-but-heading ()
  "Skip all but heading entry."
  (let (should-skip-entry)
    (unless (or (org-current-is-todo)
                (not (org-get-scheduled-time (point))))
      (setq should-skip-entry t))
    (save-excursion
      (while (and (not should-skip-entry) (org-goto-sibling t))
        (when (org-current-is-todo)
	  (setq should-skip-entry t))))
    (when should-skip-entry
      (or (outline-next-heading)
	  (goto-char (point-max))))))

(defun org-current-is-todo ()
  (string= "TODO" (org-get-todo-state)))

(defun jethro/switch-to-agenda ()
  (interactive)
  (org-agenda nil " ")
  (delete-other-windows))

;; (bind-key "<f1>" 'jethro/switch-to-agenda)

;; Column View

(setq org-columns-default-format "%40ITEM(Task) %Effort(EE){:} %CLOCKSUM(Time Spent) %SCHEDULED(Scheduled) %DEADLINE(Deadline)")

;;; Stage 4: Doing

;; Org-pomodoro

;;; =========================================================================
;; other package and config

(use-package org-bullets
  :ensure t
  :init (setq org-bullets-bullet-list '("◉" "○"	"✸" "✿"))
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package org-agenda-property
  :ensure t
  :bind (("C-c o p" . org-property-action)))

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

(use-package idle-org-agenda
  :after org-agenda
  :ensure t
  :init (setq idle-org-agenda-interval 600
	      idle-org-agenda-key "o")
  :config (idle-org-agenda-mode))

;; org journal
(use-package org-journal
  :ensure t
  :custom
  (org-journal-dir "~/iCloud/journal/")
  (org-journal-date-format "%A, %d %B %Y")
  :init
  (setq org-journal-enable-agenda-integration nil)
  :bind (("C-c j c" . calendar)
	 ("C-c j t" . journal-file-today)
	 ("C-c j y" . journal-file-yesterday))
  :config
  (require 'org-journal)
  (defun org-journal-find-location ()
    (org-journal-new-entry t)
    (goto-char (point-min)))
  )

;; https://www.emacswiki.org/emacs/string-utils.el
(setq org-html-postamble nil)
(defun string-utils-escape-double-quotes (str-val)
  "Return STR-VAL with every double-quote escaped with backslash."
  (save-match-data
    (replace-regexp-in-string "\"" "\\\\\"" str-val)))

(defun string-utils-escape-backslash (str-val)
  "Return STR-VAL with every backslash escaped with an additional backslash."
  (save-match-data
    (replace-regexp-in-string "\\\\" "\\\\\\\\" str-val)))

(setq as-tmpl "set TITLE to \"%s\"
set NBODY to \"%s\"
tell application \"Notes\"
        tell folder \"Org\"
                if not (note named TITLE exists) then
                        make new note with properties {name:TITLE}
                end if
                set body of note TITLE to NBODY
        end tell
end tell")

(defun my/org-to-apple-note-export ()
  (interactive)
  (let ((title (file-name-base (buffer-file-name))))
    (with-current-buffer (org-export-to-buffer 'html "*orgmode-to-apple-notes*")
      (let ((body (string-utils-escape-double-quotes
		   (string-utils-escape-backslash (buffer-string)))))
        ;; install title + body into template above and send to notes
        (do-applescript (format as-tmpl title body))
        ;; get rid of temp orgmode-to-apple-notes buffer
        (kill-buffer))
      )))

(use-package deft
  :ensure t
  :after org
  :bind
  (("C-c n" . deft))
  :custom
  (deft-default-extension "org")
  (deft-directory "~/iCloud/blog_site/org/")
  (deft-use-filename-as-title t))

(use-package org-wiki
  :ensure t
  :init
  (setq org-wiki-location "~/iCloud/wiki")
  (setq org-wiki-default-read-only nil)
  (setq org-wiki-server-port "8000")
  (setq org-wiki-server-host "127.0.0.1")
  (setq org-wiki-template
	(string-trim
	 "
#+TITLE: %n
#+DATE: %d
#+STARTUP: showall
#+OPTIONS: toc:nil H:2 num:0

#+BEGIN_CENTER
[[wiki:index][Home Page]] / Parent 
#+END_CENTER

"))
  :config
  (defalias 'w-h #'org-wiki-helm)
  (defalias 'w-s #'org-wiki-switch)
  (defalias 'w-hf  #'org-wiki-helm-frame)
  (defalias 'w-hr #'org-wiki-helm-read-only)
  (defalias 'w-i #'org-wiki-index)
  (defalias 'w-n #'org-wiki-new)
  (defalias 'w-in #'org-wiki-insert-new)
  (defalias 'w-il #'org-wiki-insert-link)
  (defalias 'w-ad #'org-wiki-asset-dired)
  (defalias 'og2h #'org-html-export-to-html)
  (defalias 'w-close #'org-wiki-close)
  ;; (let ((url "https://raw.githubusercontent.com/caiorss/org-wiki/master/org-wiki.el"))     
  ;;   (with-current-buffer (url-retrieve-synchronously url)
  ;;     (goto-char (point-min))
  ;;     (re-search-forward "^$")
  ;;     (delete-region (point) (point-min))
  ;;     (kill-whole-line)
  ;;     (package-install-from-buffer)))
  )

(provide 'init-org)
