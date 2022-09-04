(use-package org-super-agenda
  :ensure t
  :init (setq org-super-agenda-groups t)
  :config (org-super-agenda-mode t))

(setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-include-diary nil
      org-agenda-block-separator nil
      org-agenda-compact-blocks t
      org-agenda-start-with-log-mode t)

(setq org-agenda-custom-commands
      '(("d" "Daily Agenda"
         ((agenda "" ((org-agenda-span 'day)
		      (org-super-agenda-groups
                       '((:name "◈ Daily Agenda"
                                :time-grid t
		      	        :habit t
                                :order 1)
		      	 (:name "◈ Due Today"
                                :deadline today
                                :order 2)
                         (:name "◈ Overdue"
                                :deadline past
                                :order 3)
                         (:name "◈ Due Soon"
                                :deadline future
                                :order 4)
			 (:name "◈ Important"
			        :priority "A"
			        :order 5)
		      	 (:discard (:anything t))))))
          (alltodo "" ((org-agenda-overriding-header "")
		       (org-super-agenda-groups
			'((:name "◈ Important"
				 :priority "A")
			  (:name "◈ Handly Todo"
			         :and (:category ("Task") :date nil :not (:habit t)))
			  (:discard (:anything t))))))
	  (alltodo "" ((org-agenda-overriding-header "")
		       (org-super-agenda-groups
			'((:name "◈ Weekly rewards"
				 :tag "#reward")
			  (:discard (:anything t)))))))
	 ((org-agenda-files '("~/iCloud/org/task.org" "~/iCloud/org/project.org"))))
        ("p" "Project Review"
         ((alltodo "" ((org-agenda-overriding-header "Project Review")
		       (org-agenda-skip-function 'jethro/org-agenda-skip-all-siblings-but-first)
		       (org-super-agenda-groups
			'((:name "◈ Active Projects"
				 :and (:category "Project" :not (:tag "#archive")))
			  (:discard (:anything t)))))))
         ((org-agenda-files '("~/iCloud/org/project.org"))))
	("i" "Inbox Agenda"
	 ((alltodo "" ((org-agenda-overriding-header "Inbox Review")
		       (org-super-agenda-groups
			'((:name "Need to handle:"
				 :category "Inbox"))))))
	 ((org-agenda-files '("~/GTD/Inbox.org"))))
	("s" "Someday/Maybe Agenda"
	 ((alltodo "" ((org-agenda-overriding-header "Someday/Maybe")
		       (org-super-agenda-groups
			'((:name "动漫/电影"
                                 :tag "#animation")
                          (:name "书籍/阅读"
				 :tag "#book")
                          (:name "Emacs/Elisp"
				 :tag "#emacs")
                          (:name "好物待购"
				 :tag "#buy"))))))
	 ((org-agenda-files '("~/GTD/Someday.org"))))))

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
	      ;; ("APPT" :foreground "orange" :weight bold)
	      ("PROJ" :foreground "sky blue" :weight bold)
	      ("NOTE" :foreground "grey" :weight bold)
	      ("WAITING" :foreground "magenta" :weight bold)
	      ("CANCELLED" :foreground "forest green" :weight bold)
	      ("DEFFERED" :foreground "forest green" :weight bold)
	      )))
prog-mode-map
(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-log-state-notes-insert-after-drawers nil)

(setq org-highest-priority ?A)
(setq org-lowest-priority  ?C)
(setq org-default-priority ?B)

(setq org-priority-faces
      '((?A . (:background "red" :foreground "white" :weight bold))
	(?B . (:background "DarkOrange" :foreground "white" :weight bold))
	(?C . (:background "SkyBlue" :foreground "black" :weight bold))
	))

(setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 1:00 2:00 3:00 4:00 5:00 6:00")
				    ("STYLE_ALL" . "habit"))))

(define-key org-mode-map (kbd "C-c C-q") 'counsel-org-tag)
;; 标签设置的细不一定好，关键要对自己有意义。
(setq org-tag-alist (quote ((:startgroup)
			    ("@study" . ?s)
			    ("@hack" . ?h)
			    ("@free" . ?f)
			    ("@work" . ?w)
			    (:endgroup)
			    (:newline) 
			    (:startgroup)
			    ("monthly" . ?M)
			    ("weekly" . ?W)
			    (:endgroup)
                            (:newline)
			    ("#think" . ?t)
			    ("#buy" . ?b)
                            ("#animation" . ?a))))

(setq org-fast-tag-selection-single-key nil)

(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes nil)
(setq org-refile-targets '(("task.org" :level . 0)
			   ("someday.org" :level . 0)
			   ("project.org" :level . 1)))
;; Column View

(setq org-columns-default-format "%40ITEM(Task) %Effort(EE){:} %CLOCKSUM(Time Spent) %SCHEDULED(Scheduled) %DEADLINE(Deadline)")

;; ----------------------------------------------------------------
;; org-refile2 advise

(advice-add 'org-refile :override #'org-refile2)
(defun org-refile2 (&optional arg default-buffer rfloc msg)
  "Move the entry or entries at point to another heading.

The list of target headings is compiled using the information in
`org-refile-targets', which see.

At the target location, the entry is filed as a subitem of the
target heading.  Depending on `org-reverse-note-order', the new
subitem will either be the first or the last subitem.

If there is an active region, all entries in that region will be
refiled.  However, the region must fulfill the requirement that
the first heading sets the top-level of the moved text.

With a `\\[universal-argument]' ARG, the command will only visit the target \
location
and not actually move anything.

With a prefix `\\[universal-argument] \\[universal-argument]', go to the \
location where the last
refiling operation has put the subtree.

With a numeric prefix argument of `2', refile to the running clock.

With a numeric prefix argument of `3', emulate `org-refile-keep'
being set to t and copy to the target location, don't move it.
Beware that keeping refiled entries may result in duplicated ID
properties.

RFLOC can be a refile location obtained in a different way.

MSG is a string to replace \"Refile\" in the default prompt with
another verb.  E.g. `org-copy' sets this parameter to \"Copy\".

See also `org-refile-use-outline-path'.

If you are using target caching (see `org-refile-use-cache'), you
have to clear the target cache in order to find new targets.
This can be done with a `0' prefix (`C-0 C-c C-w') or a triple
prefix argument (`C-u C-u C-u C-c C-w')."
  (interactive "P")
  (if (member arg '(0 (64)))
      (org-refile-cache-clear)
    (let* ((actionmsg (cond (msg msg)
			    ((equal arg 3) "Refile (and keep)")
			    (t "Refile")))
	   (regionp (org-region-active-p))
	   (region-start (and regionp (region-beginning)))
	   (region-end (and regionp (region-end)))
	   (org-refile-keep (if (equal arg 3) t org-refile-keep))
	   pos it nbuf file level reversed)
      (setq last-command nil)
      (when regionp
	(goto-char region-start)
	(beginning-of-line)
	(setq region-start (point))
	(unless (or (org-kill-is-subtree-p
		     (buffer-substring region-start region-end))
		    (prog1 org-refile-active-region-within-subtree
		      (let ((s (point-at-eol)))
			(org-toggle-heading)
			(setq region-end (+ (- (point-at-eol) s) region-end)))))
	  (user-error "The region is not a (sequence of) subtree(s)")))
      (if (equal arg '(16))
	  (org-refile-goto-last-stored)
	(when (or
	       (and (equal arg 2)
		    org-clock-hd-marker (marker-buffer org-clock-hd-marker)
		    (prog1
			(setq it (list (or org-clock-heading "running clock")
				       (buffer-file-name
					(marker-buffer org-clock-hd-marker))
				       ""
				       (marker-position org-clock-hd-marker)))
		      (setq arg nil)))
	       (setq it
		     (or rfloc
			 (let (heading-text)
			   (save-excursion
			     (unless (and arg (listp arg))
			       (org-back-to-heading t)
			       (setq heading-text-origin
				     (replace-regexp-in-string
				      org-link-bracket-re
				      "\\2"
				      (or (nth 4 (org-heading-components))
					  "")))
			       (setq heading-text
				     (if (> (length heading-text-origin) 10)
					 (concat (substring heading-text-origin
							    0 10) "....")
				       heading-text-origin)))
			     (org-refile-get-location
			      (cond ((and arg (listp arg)) "Goto")
				    (regionp (concat actionmsg " region to"))
				    (t (concat actionmsg " subtree \""
					       heading-text "\" to")))
			      default-buffer
			      (and (not (equal '(4) arg))
				   org-refile-allow-creating-parent-nodes)))))))
	  (setq file (nth 1 it)
		pos (nth 3 it))
	  (when (and (not arg)
		     pos
		     (equal (buffer-file-name) file)
		     (if regionp
			 (and (>= pos region-start)
			      (<= pos region-end))
		       (and (>= pos (point))
			    (< pos (save-excursion
				     (org-end-of-subtree t t))))))
	    (error "Cannot refile to position inside the tree or region"))
	  (setq nbuf (or (find-buffer-visiting file)
			 (find-file-noselect file)))
	  (if (and arg (not (equal arg 3)))
	      (progn
		(pop-to-buffer-same-window nbuf)
		(goto-char (cond (pos)
				 ((org-notes-order-reversed-p) (point-min))
				 (t (point-max))))
		(org-show-context 'org-goto))
	    (if regionp
		(progn
		  (org-kill-new (buffer-substring region-start region-end))
		  (org-save-markers-in-region region-start region-end))
	      (org-copy-subtree 1 nil t))
	    (with-current-buffer (setq nbuf (or (find-buffer-visiting file)
						(find-file-noselect file)))
	      (setq reversed (org-notes-order-reversed-p))
	      (org-with-wide-buffer
	       (if pos
		   (progn
		     (goto-char pos)
		     (setq level (org-get-valid-level (funcall outline-level) 1))
		     (goto-char
		      (if reversed
			  (or (outline-next-heading) (point-max))
			(or (save-excursion (org-get-next-sibling))
			    (org-end-of-subtree t t)
			    (point-max)))))
		 (setq level 1)
		 (if (not reversed)
		     (goto-char (point-max))
		   (goto-char (point-min))
		   (or (outline-next-heading) (goto-char (point-max)))))
	       (unless (bolp) (newline))
	       (org-paste-subtree level nil nil t)
	       ;; Record information, according to `org-log-refile'.
	       ;; Do not prompt for a note when refiling multiple
	       ;; headlines, however.  Simply add a time stamp.
	       (cond
		((not org-log-refile))
		(regionp
		 (org-map-region
		  (lambda () (org-add-log-setup 'refile nil nil 'time))
		  (point)
		  (+ (point) (- region-end region-start))))
		(t
		 (org-add-log-setup 'refile nil nil org-log-refile)))
	       (and org-auto-align-tags
		    (let ((org-loop-over-headlines-in-active-region nil))
		      (org-align-tags)))
	       (let ((bookmark-name (plist-get org-bookmark-names-plist
					       :last-refile)))
		 (when bookmark-name
		   (with-demoted-errors
		       (bookmark-set bookmark-name))))
	       ;; If we are refiling for capture, make sure that the
	       ;; last-capture pointers point here
	       (when (bound-and-true-p org-capture-is-refiling)
		 (let ((bookmark-name (plist-get org-bookmark-names-plist
						 :last-capture-marker)))
		   (when bookmark-name
		     (with-demoted-errors
			 (bookmark-set bookmark-name))))
		 (move-marker org-capture-last-stored-marker (point)))
	       (when (fboundp 'deactivate-mark) (deactivate-mark))
	       (run-hooks 'org-after-refile-insert-hook)))
	    (unless org-refile-keep
	      (if regionp
		  (delete-region (point) (+ (point) (- region-end region-start)))
		(org-preserve-local-variables
		 (delete-region
		  (and (org-back-to-heading t) (point))
		  (min (1+ (buffer-size)) (org-end-of-subtree t t) (point))))))
	    (when (featurep 'org-inlinetask)
	      (org-inlinetask-remove-END-maybe))
	    (setq org-markers-to-move nil)
	    (message "%s to \"%s\" in file %s: done" actionmsg
		     (car it) file)))))))

(advice-add 'org-refile-get-location :override #'org-refile-get-location2)
(defun org-refile-get-location2 (&optional prompt default-buffer new-nodes)
  "Prompt the user for a refile location, using PROMPT.
PROMPT should not be suffixed with a colon and a space, because
this function appends the default value from
`org-refile-history' automatically, if that is not empty."
  (let ((org-refile-targets org-refile-targets)
	(org-refile-use-outline-path org-refile-use-outline-path))
    (setq org-refile-target-table (org-refile-get-targets default-buffer)))
  (unless org-refile-target-table
    (user-error "No refile targets"))
  (let* ((cbuf (current-buffer))
	 (cfn (buffer-file-name (buffer-base-buffer cbuf)))
	 (cfunc (if (and org-refile-use-outline-path
			 org-outline-path-complete-in-steps)
		    #'org-olpath-completing-read
		  #'completing-read))
	 (extra (if org-refile-use-outline-path "/" ""))
	 (cbnex (concat (buffer-name) extra))
	 (filename (and cfn (expand-file-name cfn)))
	 (tbl (mapcar
	       (lambda (x)
		 (if (and (not (member org-refile-use-outline-path
				       '(file full-file-path)))
			  (not (equal filename (nth 1 x))))
		     (cons (concat (car x) extra " ("
				   (file-name-nondirectory (nth 1 x)) ")")
			   (cdr x))
		   (cons (concat (car x) extra) (cdr x))))
	       org-refile-target-table))
	 (completion-ignore-case t)
	 cdef
	 (prompt (concat prompt
			 (or (and (when-let* ((his (car org-refile-history))
                                              (len (length his)))
                                    (concat " (default "
                                            (if (> len 20)
                                                (concat (substring his 0 20) "...")
                                              his)
                                            ")")))
			     (and (assoc cbnex tbl) (setq cdef cbnex)
				  (concat " (default "
                                          (if (> (length cbnex) 20)
                                              (concat (substring cbnex 0 20) "...")
                                            cbnex)
                                          ")"))) ": "))
	 pa answ parent-target child parent old-hist)
    (setq old-hist org-refile-history)
    (setq answ (funcall cfunc prompt tbl nil (not new-nodes)
			nil 'org-refile-history
			(or cdef (concat (car org-refile-history) extra))))
    (if (setq pa (org-refile--get-location answ tbl))
	(let* ((last-refile-loc (car org-refile-history))
	       (last-refile-loc-path (concat last-refile-loc extra)))
	  (org-refile-check-position pa)
	  (when (or (not org-refile-history)
		    (not (eq old-hist org-refile-history))
		    (not (equal (car pa) last-refile-loc-path)))
	    (setq org-refile-history
		  (cons (car pa) (if (assoc last-refile-loc tbl)
				     org-refile-history
				   (cdr org-refile-history))))
	    (when (or (equal last-refile-loc-path (nth 1 org-refile-history))
		      (equal last-refile-loc (nth 1 org-refile-history)))
	      (pop org-refile-history)))
	  pa)
      (if (string-match "\\`\\(.*\\)/\\([^/]+\\)\\'" answ)
	  (progn
	    (setq parent (match-string 1 answ)
		  child (match-string 2 answ))
	    (setq parent-target (org-refile--get-location parent tbl))
	    (when (and parent-target
		       (or (eq new-nodes t)
			   (and (eq new-nodes 'confirm)
				(y-or-n-p (format "Create new node \"%s\"? "
						  child)))))
	      (org-refile-new-child parent-target child)))
	(user-error "Invalid target location")))))

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

(use-package org-pomodoro
  :ensure t
  :init
  (setq org-pomodoro-length 50
	org-pomodoro-short-break-length 5
	org-pomodoro-long-break-length 15
	org-pomodoro-long-break-frequency 4
	org-pomodoro-ask-upon-killing t
	org-pomodoro-ticking-sound-p t
	org-pomodoro-ticking-sound (concat user-emacs-directory "/pomodoro/ticking.m4a")
	org-pomodoro-finished-sound (concat user-emacs-directory "/pomodoro/alarm.m4a")
	org-pomodoro-short-break-sound (concat user-emacs-directory "/pomodoro/alarm.m4a")
	org-pomodoro-long-break-sound (concat user-emacs-directory "/pomodoro/alarm.m4a"))
  :config
  (define-key org-agenda-mode-map "P" 'org-pomodoro))


(provide 'init-gtd)
