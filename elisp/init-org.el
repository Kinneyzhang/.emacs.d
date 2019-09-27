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
	   "* TODO %?\n" :clock-resume t
	   :empty-lines 1)
	  
	  ;; ("t" "todo" entry (file "~/org/inbox.org")
	  ;;  "* TODO %?\n  :LOGBOOK:\n  - Added %U\n  :END:" :clock-resume t
	  ;;  :empty-lines 1)
	  
	  ("b" "bookmark" entry (file+headline "~/org/blog/_pages/bookmark.org" "Misc")
	   "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n"
	   :empty-lines 1)
	  ("j" "Journal entry" entry (function org-journal-find-location)
	   "* %(format-time-string org-journal-time-format)%?")
	  ("w" "org-protocol" entry (file "~/org/inbox.org")
	   "* TODO Review %c\n%U\n" :immediate-finish t
	   :empty-lines 1)
	  ("h" "Habit" entry (file "~/org/gtd.org")
	   "* NEXT %?\n  :PROPERTIES:\n  :STYLE: habit\n  :REPEAT_TO_STATE: NEXT\n  :END:\n  :LOGBOOK:\n  - Added %U\n  :END:"
	   )))
  :config

  ;;; org habit
  (require 'org-habit)
  (defvar my/org-habit-show-graphs-everywhere nil
    "If non-nil, show habit graphs in all types of agenda buffers.
Normally, habits display consistency graphs only in
\"agenda\"-type agenda buffers, not in other types of agenda
buffers.  Set this variable to any non-nil variable to show
consistency graphs in all Org mode agendas.")

  (defun my/org-agenda-mark-habits ()
    "Mark all habits in current agenda for graph display.

This function enforces `my/org-habit-show-graphs-everywhere' by
marking all habits in the current agenda as such.  When run just
before `org-agenda-finalize' (such as by advice; unfortunately,
`org-agenda-finalize-hook' is run too late), this has the effect
of displaying consistency graphs for these habits.

When `my/org-habit-show-graphs-everywhere' is nil, this function
has no effect."
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

  (advice-add #'org-agenda-finalize :before #'my/org-agenda-mark-habits)

  ;;Enable habit tracking (and a bunch of other modules)
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
  (setq org-habit-graph-column 30)
  ;;; org habit end

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
  (setq org-agenda-dim-blocked-tasks t)
  ;; Compact the block agenda view
  (setq org-agenda-compact-blocks t)
  ;; Custom agenda command definitions
  (setq org-agenda-custom-commands
  	(quote (("o" "Omni Agenda"
  		 ((agenda "" nil)
  		  (tags "REFILE-emacs-blog"
  			((org-agenda-overriding-header "\n------------Inbox, Tasks to Refile------------\n Other")
  			 (org-tags-match-list-sublevels nil)))
		  (tags-todo "habit"
			     ((org-agenda-overriding-header "\nHabits")
			      (org-tags-match-list-sublevels nil)))
		  (tags-todo "emacs"
			     ((org-agenda-overriding-header "\nEmacs")
			      (org-tags-match-list-sublevels nil)))
		  (tags-todo "blog"
			     ((org-agenda-overriding-header "\nBlog")
			      (org-tags-match-list-sublevels nil)))
		  ))
  		)))


  (setq org-todo-keywords
	(quote ((sequence "TODO(t)" "NEXT(n)" "SOMEDAY(s)" "|" "DONE(d!)")
		(sequence "WAITING(w@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))


  (setq org-todo-keyword-faces
	(quote (("TODO" :foreground "red" :weight bold)
		("NEXT" :foreground "blue" :weight bold)
		("DONE" :foreground "forest green" :weight bold)
		("SOMEDAY" :foreground "orange" :weight bold)
		("WAITING" :foreground "magenta" :weight bold)
		("CANCELLED" :foreground "forest green" :weight bold)
		("MEETING" :foreground "forest green" :weight bold)
		("PHONE" :foreground "forest green" :weight bold))))

  ;; to state tiggers
  (setq org-todo-state-tags-triggers
	(quote (("CANCELLED" ("CANCELLED" . t))
		("WAITING" ("WAITING" . t))
		(done ("WAITING"))
		("TODO" ("WAITING") ("CANCELLED"))
		("NEXT" ("WAITING") ("CANCELLED"))
		("DONE" ("WAITING") ("CANCELLED")))))

  ;; Tags with fast selection keys
  (setq org-tag-alist (quote ((:startgroup)
			      ("@office" . ?o)
			      ("@home" . ?H)
			      (:endgroup)
			      ("WAITING" . ?w)
			      ("PERSONAL" . ?P)
			      ("WORK" . ?W)
			      ("NOTE" . ?n)
			      ("CANCELLED" . ?c)
			      ("FLAGGED" . ??)
			      ("emacs" . ?e)
			      ("blog" . ?b)
			      ("server" . ?s)
			      ("habit" . ?h)
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
  (setq org-drawers (quote ("LOGBOOK")))
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

(use-package org-pomodoro
  :ensure t
  :bind (("<f10>" . org-pomodoro)))

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

;; org html export
(setq org-html-doctype "html5")
(setq org-html-html5-fancy t)
(defun org-html-src-block2 (src-block _contents info)
  "Transcode a SRC-BLOCK element from Org to HTML.
CONTENTS holds the contents of the item.  INFO is a plist holding
contextual information."
  (if (org-export-read-attribute :attr_html src-block :textarea)
      (org-html--textarea-block src-block)
    (let ((lang (org-element-property :language src-block))
          (code (org-html-format-code src-block info))
          (label (let ((lbl (and (org-element-property :name src-block)
                                 (org-export-get-reference src-block info))))
                   (if lbl (format " id=\"%s\"" lbl) ""))))
      (if (not lang) (format "<pre><code class=\"example\"%s>\n%s</code></pre>" label code)
        (format "<div class=\"col-auto\">\n%s%s\n</div>"
                ;; Build caption.
                (let ((caption (org-export-get-caption src-block)))
                  (if (not caption) ""
                    (let ((listing-number
                           (format
                            "<span class=\"listing-number\">%s </span>"
                            (format
                             (org-html--translate "Listing %d:" info)
                             (org-export-get-ordinal
                              src-block info nil #'org-html--has-caption-p)))))
                      (format "<label class=\"org-src-name\">%s%s</label>"
                              listing-number
                              (org-trim (org-export-data caption info))))))
                ;; Contents.
                (format "<pre><code class=\"%s\"%s>%s</code></pre>"
                        lang label code))))))

(advice-add 'org-html-src-block :override 'org-html-src-block2)

;; org journal
(use-package org-journal
  :ensure t
  :custom
  (org-journal-dir "~/org/journal/")
  (org-journal-date-format "%A, %d %B %Y")
  :init
  (setq org-journal-enable-agenda-integration t)
  :bind (("C-c j c" . calendar)
	 ("C-c j t" . journal-file-today)
	 ("C-c j y" . journal-file-yesterday))
  :preface
  (defun get-journal-file-today ()
    "Gets filename for today's journal entry."
    (let ((daily-name (format-time-string "%Y%m%d")))
      (expand-file-name (concat org-journal-dir daily-name))))

  (defun journal-file-today ()
    "Creates and load a journal file based on today's date."
    (interactive)
    (find-file (get-journal-file-today)))

  (defun get-journal-file-yesterday ()
    "Gets filename for yesterday's journal entry."
    (let* ((yesterday (time-subtract (current-time) (days-to-time 1)))
	   (daily-name (format-time-string "%Y%m%d" yesterday)))
      (expand-file-name (concat org-journal-dir daily-name))))

  (defun journal-file-yesterday ()
    "Creates and load a file based on yesterday's date."
    (interactive)
    (find-file (get-journal-file-yesterday)))
  :config
  (defun org-journal-find-location ()
    (org-journal-new-entry t)
    ;; (find-file-noselect (get-journal-file-today))
    (goto-char (point-min)))
  )

(provide 'init-org)
