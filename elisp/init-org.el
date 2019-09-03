;;; Org clock
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
  :pretty-hydra
  ((:title (pretty-hydra-title "Org Template" 'fileicon "org")
  	   :color blue :quit-key "q")
   ("Basic"
    (("a" (hot-expand "<a") "ascii")
     ("c" (hot-expand "<c") "center")
     ("e" (hot-expand "<e") "example")
     ("h" (hot-expand "<h") "html")
     ("l" (hot-expand "<l") "latex")
     ("o" (hot-expand "<q") "quote")
     ("v" (hot-expand "<v") "verse"))
    "Head"
    (("i" (hot-expand "<i") "index")
     ("A" (hot-expand "<A") "ASCII")
     ("I" (hot-expand "<I") "INCLUDE")
     ("H" (hot-expand "<H") "HTML")
     ("L" (hot-expand "<L") "LaTeX"))
    "Source"
    (("s" (hot-expand "<s") "src")
     ("m" (hot-expand "<s" "emacs-lisp") "emacs-lisp")
     ("y" (hot-expand "<s" "python :results output") "python")
     ("p" (hot-expand "<s" "perl") "perl")
     ("r" (hot-expand "<s" "ruby") "ruby")
     ("S" (hot-expand "<s" "sh") "sh")
     ("g" (hot-expand "<s" "go :imports '\(\"fmt\"\)") "golang"))
    "Misc"
    (("u" (hot-expand "<s" "plantuml :file CHANGE.png") "plantuml")
     ("Y" (hot-expand "<s" "ipython :session :exports both :results raw drawer\n$0") "ipython")
     ("P" (progn
            (insert "#+HEADERS: :results output :exports both :shebang \"#!/usr/bin/env perl\"\n")
            (hot-expand "<s" "perl")) "Perl tangled")
     ("<" self-insert-command "ins"))))
  :hook ((org-mode . (lambda ()
                       "Beautify Org Checkbox Symbol"
                       (push '("[ ]" . ?☐) prettify-symbols-alist)
                       (push '("[X]" . ?☑) prettify-symbols-alist)
                       (push '("[-]" . ?❍) prettify-symbols-alist)
                       (push '("#+BEGIN_SRC" . ?✎) prettify-symbols-alist)
                       (push '("#+END_SRC" . ?□) prettify-symbols-alist)
                       (push '("#+BEGIN_QUOTE" . ?») prettify-symbols-alist)
                       (push '("#+END_QUOTE" . ?«) prettify-symbols-alist)
                       (push '("#+HEADERS" . ?☰) prettify-symbols-alist)
                       (prettify-symbols-mode 1)
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
  :bind (("C-c c" . org-capture)
	 ("<f11>" . plain-org-wiki)
	 ("<f12>" . org-agenda)
	 ("C-c a" . org-agenda)
	 ("C-c o l" . org-store-link)
	 ("C-c t v" . org-tags-view)
	 :map org-mode-map
         ("<" . (lambda ()
                  "Insert org template."
                  (interactive)
                  (if (or (region-active-p) (looking-back "^\s*" 1))
                      (org-hydra/body)
                    (self-insert-command 1)))))
  :init
  (setq org-src-fontify-natively t
	org-agenda-files '("~/org")
	org-agenda-window-setup 'current-window
	org-agenda-window-setup 'current-window
	org-directory "~/org"
	org-default-notes-file "~/org/inbox.org"
	;; Capture templates for: TODO tasks, Notes, diary, habit and org-protocol
	org-capture-templates
	'(("t" "todo" entry (file "~/org/inbox.org")
	   "* TODO %?\n%U\n" :clock-resume t
	   :empty-lines 1)
	  ("n" "note" entry (file "~/org/inbox.org")
	   "* %? :NOTE:\n%U\n" :clock-resume t
	   :empty-lines 1)
	  ("j" "Journal entry" entry (function org-journal-find-location)
	   "* %(format-time-string org-journal-time-format)%^{Title}\n%i%?")
	  ("w" "org-protocol" entry (file "~/org/inbox.org")
	   "* TODO Review %c\n%U\n" :immediate-finish t
	   :empty-lines 1)
	  ("h" "Habit" entry (file "~/org/inbox.org")
	   "* NEXT %?\n%U\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n")
	  ))
  :config

  ;;; org habit
					;Enable habit tracking (and a bunch of other modules)
  (setq org-modules (quote (org-bbdb
			    org-bibtex
			    org-crypt
			    org-gnus
			    org-id
			    org-info
			    org-jsinfo
			    org-habit
			    org-inlinetask
			    org-irc
			    org-mew
			    org-mhe
			    org-protocol
			    org-rmail
			    org-vm
			    org-wl
			    org-w3m)))
  
					; position the habit graph on the agenda to the right of the default
  (setq org-habit-graph-column 50)
  ;;; org habit end
  
  ;;; org code block
  (defun org-insert-src-block (src-code-type)
    "Insert a `SRC-CODE-TYPE' type source code block in org-mode."
    (interactive
     (let ((src-code-types
	    '("emacs-lisp" "python" "C" "sh" "java" "js" "clojure" "C++" "css"
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

  (defun bh/remove-empty-drawer-on-clock-out ()
    "Remove empty LOGBOOK drawers on clock out"
    (interactive)
    (save-excursion
      (beginning-of-line 0)
      (org-remove-empty-drawer-at (point))))

  (add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)

  ;; org refile config
  ;;==================================================
					; Targets include this file and any file contributing to the agenda - up to 9 levels deep
  (setq org-refile-targets (quote ((nil :maxlevel . 9)
				   (org-agenda-files :maxlevel . 9))))

					; Use full outline paths for refile targets - we file directly with IDO
  (setq org-refile-use-outline-path t)

					; Targets complete directly with IDO
  (setq org-outline-path-complete-in-steps nil)

					; Allow refile to create parent tasks with confirmation
  (setq org-refile-allow-creating-parent-nodes (quote confirm))

					; Use IDO for both buffer and file completion and ido-everywhere to t
  (setq org-completion-use-ido t)
  (setq ido-everywhere t)
  (setq ido-max-directory-size 100000)
  (ido-mode (quote both))
					; Use the current window when visiting files and buffers with ido
  (setq ido-default-file-method 'selected-window)
  (setq ido-default-buffer-method 'selected-window)
					; Use the current window for indirect buffer display
  (setq org-indirect-buffer-display 'current-window)

	    ;;;; Refile settings
					; Exclude DONE state tasks from refile targets
  (defun bh/verify-refile-target ()
    "Exclude todo keywords with a done state from refile targets"
    (not (member (nth 2 (org-heading-components)) org-done-keywords)))

  (setq org-refile-target-verify-function 'bh/verify-refile-target)

  (setq org-agenda-span 'day)

    ;;; ==================================================
    ;;; ==================================================

  (setq org-stuck-projects (quote ("" nil nil "")))

  (defun bh/is-project-p ()
    "Any task with a todo keyword subtask"
    (save-restriction
      (widen)
      (let ((has-subtask)
  	    (subtree-end (save-excursion (org-end-of-subtree t)))
  	    (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
  	(save-excursion
  	  (forward-line 1)
  	  (while (and (not has-subtask)
  		      (< (point) subtree-end)
  		      (re-search-forward "^\*+ " subtree-end t))
  	    (when (member (org-get-todo-state) org-todo-keywords-1)
  	      (setq has-subtask t))))
  	(and is-a-task has-subtask))))

  ;; (defun bh/is-project-subtree-p ()
  ;;   "Any task with a todo keyword that is in a project subtree.
  ;;   Callers of this function already widen the buffer view."
  ;;   (let ((task (save-excursion (org-back-to-heading 'invisible-ok)
  ;; 				(point))))
  ;;     (save-excursion
  ;; 	(bh/find-project-task)
  ;; 	(if (equal (point) task)
  ;; 	    nil
  ;; 	  t))))

  (defun bh/is-task-p ()
    "Any task with a todo keyword and no subtask"
    (save-restriction
      (widen)
      (let ((has-subtask)
  	    (subtree-end (save-excursion (org-end-of-subtree t)))
  	    (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
  	(save-excursion
  	  (forward-line 1)
  	  (while (and (not has-subtask)
  		      (< (point) subtree-end)
  		      (re-search-forward "^\*+ " subtree-end t))
  	    (when (member (org-get-todo-state) org-todo-keywords-1)
  	      (setq has-subtask t))))
  	(and is-a-task (not has-subtask)))))

  ;; (defun bh/is-subproject-p ()
  ;;   "Any task which is a subtask of another project"
  ;;   (let ((is-subproject)
  ;; 	  (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
  ;;     (save-excursion
  ;; 	(while (and (not is-subproject) (org-up-heading-safe))
  ;; 	  (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
  ;; 	    (setq is-subproject t))))
  ;;     (and is-a-task is-subproject)))

  ;; (defun bh/list-sublevels-for-projects-indented ()
  ;;   "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  ;;     This is normally used by skipping functions where this variable is already local to the agenda."
  ;;   (if (marker-buffer org-agenda-restrict-begin)
  ;; 	(setq org-tags-match-list-sublevels 'indented)
  ;;     (setq org-tags-match-list-sublevels nil))
  ;;   nil)

  ;; (defun bh/list-sublevels-for-projects ()
  ;;   "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  ;;     This is normally used by skipping functions where this variable is already local to the agenda."
  ;;   (if (marker-buffer org-agenda-restrict-begin)
  ;; 	(setq org-tags-match-list-sublevels t)
  ;;     (setq org-tags-match-list-sublevels nil))
  ;;   nil)

  ;; (defvar bh/hide-scheduled-and-waiting-next-tasks t)

  ;; (defun bh/toggle-next-task-display ()
  ;;   (interactive)
  ;;   (setq bh/hide-scheduled-and-waiting-next-tasks (not bh/hide-scheduled-and-waiting-next-tasks))
  ;;   (when  (equal major-mode 'org-agenda-mode)
  ;;     (org-agenda-redo))
  ;;   (message "%s WAITING and SCHEDULED NEXT Tasks" (if bh/hide-scheduled-and-waiting-next-tasks "Hide" "Show")))

  ;; (defun bh/skip-stuck-projects ()
  ;;   "Skip trees that are not stuck projects"
  ;;   (save-restriction
  ;;     (widen)
  ;;     (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
  ;; 	(if (bh/is-project-p)
  ;; 	    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
  ;; 		   (has-next ))
  ;; 	      (save-excursion
  ;; 		(forward-line 1)
  ;; 		(while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
  ;; 		  (unless (member "WAITING" (org-get-tags-at))
  ;; 		    (setq has-next t))))
  ;; 	      (if has-next
  ;; 		  nil
  ;; 		next-headline)) ; a stuck project, has subtasks but no next task
  ;; 	  nil))))

  ;; (defun bh/skip-non-stuck-projects ()
  ;;   "Skip trees that are not stuck projects"
  ;;   ;; (bh/list-sublevels-for-projects-indented)
  ;;   (save-restriction
  ;;     (widen)
  ;;     (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
  ;; 	(if (bh/is-project-p)
  ;; 	    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
  ;; 		   (has-next ))
  ;; 	      (save-excursion
  ;; 		(forward-line 1)
  ;; 		(while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
  ;; 		  (unless (member "WAITING" (org-get-tags-at))
  ;; 		    (setq has-next t))))
  ;; 	      (if has-next
  ;; 		  next-headline
  ;; 		nil)) ; a stuck project, has subtasks but no next task
  ;; 	  next-headline))))

  ;; (defun bh/skip-non-projects ()
  ;;   "Skip trees that are not projects"
  ;;   ;; (bh/list-sublevels-for-projects-indented)
  ;;   (if (save-excursion (bh/skip-non-stuck-projects))
  ;; 	(save-restriction
  ;; 	  (widen)
  ;; 	  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
  ;; 	    (cond
  ;; 	     ((bh/is-project-p)
  ;; 	      nil)
  ;; 	     ((and (bh/is-project-subtree-p) (not (bh/is-task-p)))
  ;; 	      nil)
  ;; 	     (t
  ;; 	      subtree-end))))
  ;;     (save-excursion (org-end-of-subtree t))))

  ;; (defun bh/skip-non-tasks ()
  ;;   "Show non-project tasks.
  ;;   Skip project and sub-project tasks, habits, and project related tasks."
  ;;   (save-restriction
  ;;     (widen)
  ;;     (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
  ;; 	(cond
  ;; 	 ((bh/is-task-p)
  ;; 	  nil)
  ;; 	 (t
  ;; 	  next-headline)))))

  ;; (defun bh/skip-project-trees-and-habits ()
  ;;   "Skip trees that are projects"
  ;;   (save-restriction
  ;;     (widen)
  ;;     (let ((subtree-end (save-excursion (org-end-of-subtree t))))
  ;; 	(cond
  ;; 	 ((bh/is-project-p)
  ;; 	  subtree-end)
  ;; 	 ((org-is-habit-p)
  ;; 	  subtree-end)
  ;; 	 (t
  ;; 	  nil)))))

  ;; (defun bh/skip-projects-and-habits-and-single-tasks ()
  ;;   "Skip trees that are projects, tasks that are habits, single non-project tasks"
  ;;   (save-restriction
  ;;     (widen)
  ;;     (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
  ;; 	(cond
  ;; 	 ((org-is-habit-p)
  ;; 	  next-headline)
  ;; 	 ((and bh/hide-scheduled-and-waiting-next-tasks
  ;; 	       (member "WAITING" (org-get-tags-at)))
  ;; 	  next-headline)
  ;; 	 ((bh/is-project-p)
  ;; 	  next-headline)
  ;; 	 ((and (bh/is-task-p) (not (bh/is-project-subtree-p)))
  ;; 	  next-headline)
  ;; 	 (t
  ;; 	  nil)))))

  ;; (defun bh/skip-project-tasks-maybe ()
  ;;   "Show tasks related to the current restriction.
  ;;   When restricted to a project, skip project and sub project tasks, habits, NEXT tasks, and loose tasks.
  ;;   When not restricted, skip project and sub-project tasks, habits, and project related tasks."
  ;;   (save-restriction
  ;;     (widen)
  ;;     (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
  ;; 	     (next-headline (save-excursion (or (outline-next-heading) (point-max))))
  ;; 	     (limit-to-project (marker-buffer org-agenda-restrict-begin)))
  ;; 	(cond
  ;; 	 ((bh/is-project-p)
  ;; 	  next-headline)
  ;; 	 ((org-is-habit-p)
  ;; 	  subtree-end)
  ;; 	 ((and (not limit-to-project)
  ;; 	       (bh/is-project-subtree-p))
  ;; 	  subtree-end)
  ;; 	 ((and limit-to-project
  ;; 	       (bh/is-project-subtree-p)
  ;; 	       (member (org-get-todo-state) (list "NEXT")))
  ;; 	  subtree-end)
  ;; 	 (t
  ;; 	  nil)))))

  ;; (defun bh/skip-project-tasks ()
  ;;   "Show non-project tasks.
  ;;   Skip project and sub-project tasks, habits, and project related tasks."
  ;;   (save-restriction
  ;;     (widen)
  ;;     (let* ((subtree-end (save-excursion (org-end-of-subtree t))))
  ;; 	(cond
  ;; 	 ((bh/is-project-p)
  ;; 	  subtree-end)
  ;; 	 ((org-is-habit-p)
  ;; 	  subtree-end)
  ;; 	 ((bh/is-project-subtree-p)
  ;; 	  subtree-end)
  ;; 	 (t
  ;; 	  nil)))))

  ;; (defun bh/skip-non-project-tasks ()
  ;;   "Show project tasks.
  ;;   Skip project and sub-project tasks, habits, and loose non-project tasks."
  ;;   (save-restriction
  ;;     (widen)
  ;;     (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
  ;; 	     (next-headline (save-excursion (or (outline-next-heading) (point-max)))))
  ;; 	(cond
  ;; 	 ((bh/is-project-p)
  ;; 	  next-headline)
  ;; 	 ((org-is-habit-p)
  ;; 	  subtree-end)
  ;; 	 ((and (bh/is-project-subtree-p)
  ;; 	       (member (org-get-todo-state) (list "NEXT")))
  ;; 	  subtree-end)
  ;; 	 ((not (bh/is-project-subtree-p))
  ;; 	  subtree-end)
  ;; 	 (t
  ;; 	  nil)))))

  ;; (defun bh/skip-projects-and-habits ()
  ;;   "Skip trees that are projects and tasks that are habits"
  ;;   (save-restriction
  ;;     (widen)
  ;;     (let ((subtree-end (save-excursion (org-end-of-subtree t))))
  ;; 	(cond
  ;; 	 ((bh/is-project-p)
  ;; 	  subtree-end)
  ;; 	 ((org-is-habit-p)
  ;; 	  subtree-end)
  ;; 	 (t
  ;; 	  nil)))))

  ;; (defun bh/skip-non-subprojects ()
  ;;   "Skip trees that are not projects"
  ;;   (let ((next-headline (save-excursion (outline-next-heading))))
  ;;     (if (bh/is-subproject-p)
  ;; 	  nil
  ;; 	next-headline)))

  ;; (defun org-is-habit-p ())

    ;;; ==================================================

  ;; Do not dim blocked tasks
  (setq org-agenda-dim-blocked-tasks nil)
  ;; Compact the block agenda view
  (setq org-agenda-compact-blocks t)
  ;; Custom agenda command definitions
  (setq org-agenda-custom-commands
	(quote (("o" "Omni Agenda"
		 ((agenda "" nil)
		  (tags "REFILE"
			((org-agenda-overriding-header "Inbox, task to refile!")
			 (org-tags-match-list-sublevels nil)))))
		)))


  (setq org-todo-keywords
	(quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
		(sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))


  (setq org-todo-keyword-faces
	(quote (("TODO" :foreground "red" :weight bold)
		("NEXT" :foreground "blue" :weight bold)
		("DONE" :foreground "forest green" :weight bold)
		("WAITING" :foreground "orange" :weight bold)
		("HOLD" :foreground "magenta" :weight bold)
		("CANCELLED" :foreground "forest green" :weight bold)
		("MEETING" :foreground "forest green" :weight bold)
		("PHONE" :foreground "forest green" :weight bold))))

  ;; to state tiggers
  (setq org-todo-state-tags-triggers
	(quote (("CANCELLED" ("CANCELLED" . t))
		("WAITING" ("WAITING" . t))
		("HOLD" ("WAITING") ("HOLD" . t))
		(done ("WAITING") ("HOLD"))
		("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
		("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
		("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

  ;; Tags with fast selection keys
  (setq org-tag-alist (quote ((:startgroup)
			      ("@office" . ?o)
			      ("@home" . ?H)
			      (:endgroup)
			      ("WAITING" . ?w)
			      ("HOLD" . ?h)
			      ("PERSONAL" . ?P)
			      ("WORK" . ?W)
			      ("NOTE" . ?n)
			      ("CANCELLED" . ?c)
			      ("FLAGGED" . ??)
			      ("emacs" . ?e)
			      ("blog" . ?b)
			      ("server" . ?s)
			      )))

					; Allow setting single tags without the menu
  (setq org-fast-tag-selection-single-key (quote expert))

					; For tag searches ignore tasks with scheduled and deadline dates
  (setq org-agenda-tags-todo-honor-ignore-options t)

  ;; cycle through the todo states but skip setting timestamps.
  (setq org-treat-S-cursor-todo-selection-as-state-change nil)


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


  ;; =====================clock setup=============================

  ;; Resume clocking task when emacs is restarted
  (org-clock-persistence-insinuate)
  ;;
  ;; Show lot of clocking history so it's easy to pick items off the C-F11 list
  (setq org-clock-history-length 23)
  ;; Resume clocking task on clock-in if the clock is open
  (setq org-clock-in-resume t)
  ;; Change tasks to NEXT when clocking in
  (setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
  ;; Separate drawers for clocking and logs
  (setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
  ;; Save clock data and state changes and notes in the LOGBOOK drawer
  (setq org-clock-into-drawer t)
  ;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
  (setq org-clock-out-remove-zero-time-clocks t)
  ;; Clock out when moving task to a done state
  (setq org-clock-out-when-done t)
  ;; Save the running clock and all clock history when exiting Emacs, load it on startup
  (setq org-clock-persist t)
  ;; Do not prompt to resume an active clock
  (setq org-clock-persist-query-resume nil)
  ;; Enable auto clock resolution for finding open clocks
  (setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
  ;; Include current clocking task in clock reports
  (setq org-clock-report-include-clocking-task t)

  (setq bh/keep-clock-running nil)

  (defun bh/clock-in-to-next (kw)
    "Switch a task from TODO to NEXT when clocking in.
	Skips capture tasks, projects, and subprojects.
	Switch projects and subprojects from NEXT back to TODO"
    (when (not (and (boundp 'org-capture-mode) org-capture-mode))
      (cond
       ((and (member (org-get-todo-state) (list "TODO"))
	     (bh/is-task-p))
	"NEXT")
       ((and (member (org-get-todo-state) (list "NEXT"))
	     (bh/is-project-p)
	     )
	"TODO"))))

  (defun bh/clock-out-maybe ()
    (when (and bh/keep-clock-running
	       (not org-clock-clocking-in)
	       (marker-buffer org-clock-default-task)
	       (not org-clock-resolving-clocks-due-to-idleness))
      (bh/clock-in-parent-task)))

  (add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)

  (setq org-time-stamp-rounding-minutes (quote (1 1)))

  (setq org-agenda-clock-consistency-checks
	(quote (:max-duration "4:00"
			      :min-duration 0
			      :max-gap 0
			      :gap-ok-around ("4:00"))))

  
  ;;; Show the clocked-in task - if any - in the header line
  (defun sanityinc/show-org-clock-in-header-line ()
    (setq-default header-line-format '((" " org-mode-line-string " "))))

  (defun sanityinc/hide-org-clock-from-header-line ()
    (setq-default header-line-format nil))

  (add-hook 'org-clock-in-hook 'sanityinc/show-org-clock-in-header-line)
  (add-hook 'org-clock-out-hook 'sanityinc/hide-org-clock-from-header-line)
  (add-hook 'org-clock-cancel-hook 'sanityinc/hide-org-clock-from-header-line)

    ;;; =================Time Reporting and Tracking=================================
  (setq org-clock-out-remove-zero-time-clocks t)

  ;; Agenda clock report parameters
  (setq org-agenda-clockreport-parameter-plist
	(quote (:link t :maxlevel 5 :fileskip0 t :compact t :narrow 80)))

  ;; Set default column view headings: Task Effort Clock_Summary
  (setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")

  ;; global Effort estimate values
  ;; global STYLE property values for completion
  (setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
				      ("STYLE_ALL" . "habit"))))

  ;; Agenda log mode items to display (closed and state changes by default)
  (setq org-agenda-log-mode-items (quote (closed state)))

  ;; ==================================================
  ;; 中文换行问题
  (add-hook 'org-mode-hook 
	    (lambda () (setq truncate-lines nil)))

  )


(use-package org-bullets
  :ensure t
  :init (setq org-bullets-bullet-list '("♥" "●" "◇" "✚" "✜" "☯" "◆" "♠" "♣" "♦" "☢" "❀" "◆" "◖""▶"))
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

;; org html export
(setq org-html-doctype "html5")
(setq org-html-html5-fancy t)
(setq org-html-head
      "<link rel=\"stylesheet\" href=\"style.css\">")
(setq org-html-head-extra
      "<link rel=\"stylesheet\" href=\"style2.css\">")

;; org feed
;; (setq org-feed-alist
;;       '(("Geekblog"
;;          "https://blog.geekinney.com/latest"
;;          "~/org/feeds.org" "Geekblog")))

;; org journal

(use-package org-journal
  :ensure t
  :custom
  (org-journal-dir "~/org/journal/")
  (org-journal-date-format "%A, %d %B %Y")
  :init
  (setq org-journal-enable-agenda-integration t)
  :bind (("C-c j" . calendar))
  :config
  (defun org-journal-find-location ()
    ;; Open today's journal, but specify a non-nil prefix argument in order to
    ;; inhibit inserting the heading; org-capture will insert the heading.
    (org-journal-new-entry t)
    ;; Position point on the journal's top-level heading so that org-capture
    ;; will add the new entry as a child entry.
    (goto-char (point-min))))

;; (use-package org-octopress
;;   :ensure t
;;   :init
;;   (setq org-octopress-directory-top       "~/Geekstuff/hexoBlog")
;;   (setq org-octopress-directory-posts     "~/Geekstuff/hexoBlog/source/_posts") ;文章发布目录
;;   (setq org-octopress-directory-org-top   "~/Geekstuff/hexoBlog")
;;   (setq org-octopress-directory-org-posts "~/Geekstuff/hexoBlog/blog") ;org文章目录
;;   (setq org-octopress-setup-file          "~/Geekstuff/hexoBlog/setupfile.org")
;;   :config
;;   (require 'ox-publish)
;;   (defun org-custom-link-img-follow (path)
;;     (org-open-file-with-emacs
;;      (format "../source/img/%s" path)))   ;the path of the image in local dic

;;   (defun org-custom-link-img-export (path desc format)
;;     (cond
;;      ((eq format 'html)
;;       (format "<img src=\"/img/%s\" alt=\"%s\"/>" path desc)))) ;the path of the image in webserver

;;   (org-add-link-type "img" 'org-custom-link-img-follow 'org-custom-link-img-export)
;;   )


(provide 'init-org)
