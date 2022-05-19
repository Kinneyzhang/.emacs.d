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
			 (:name "Important!"
				:priority "A"
				:order 5)
		      	 (:discard (:anything t))))))
	  (alltodo "" ((org-agenda-overriding-header "")
		       (org-super-agenda-groups
			'((:name "Weekly rewards"
				 :tag "#reward")
			  (:discard (:anything t))))))
	  (alltodo "" ((org-agenda-overriding-header "")
		       (org-super-agenda-groups
			'((:name "Important!"
				 :priority "A")
			  (:name "handly todo"
				 :and (:category ("Task") :date nil :not (:habit t)))
			  (:discard (:anything t)))))))
	 ((org-agenda-files '("~/GTD/Todo.org"))))
        ;; ("p" "Project Review"
        ;;  ((alltodo "" ((org-agenda-overriding-header "Project Review")
	;; 	       (org-agenda-skip-function 'jethro/org-agenda-skip-all-siblings-but-first)
	;; 	       (org-super-agenda-groups
	;; 		'((:name "Active Projects"
	;; 			 :and (:category "Project" :not (:tag "#archive")))
	;; 		  (:discard (:anything t)))))))
        ;;  ((org-agenda-files '("~/GTD/project.org"))))
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

(provide 'init-gtd)
