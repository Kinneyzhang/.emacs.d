;;; hacking habit record
(require 'cl-lib)
(require 'emacsql-sqlite)

(defvar db (emacsql-sqlite "~/.emacs.d/gk-habit/habit.db"))

(setq gk-habit-file "~/habit.org")

(setq gk-habit-frequency-type '("everyday" "repeat" "by-week" "by-month"))

(setq gk-habit-period '("get-up" "morning" "noon" "afternoon" "evening" "before-sleep"))

(setq gk-habit-status '("DONE" "MISS"))

;; (defun gk-habit-init-file ()
;;   "Initialize gk-habit source file."
;;   (interactive)
;;   (let* ((nums (length gk-habit-keys)))
;;     (with-temp-file gk-habit-file
;;       (org-table-create (concat (format "%s" nums) "x2"))
;;       (dotimes (i nums)
;; 	(org-table-next-field)
;; 	(insert (nth i titles)))
;;       (message "habit.org created!"))))

(defun gk-habit-db--create-tables ()
  "Create database tables of gk-habit."
  (emacsql db [:create-table habit
			     ([(create-time string :primary-key :not-null)
			       (name string :not-null :unique)
			       (frequency-type string :not-null)
			       (frequency-param)
			       (period string :not-null)
			       (remind-time)
			       (remind-string)
			       (status string :not-null)
			       (archive-time string)])])
  
  (emacsql db [:create-table record
			     ([(create-time string :primary-key :not-null)
			       (habit string :not-null)
			       (status string :not-null)
			       (comment string)]
			      (:foreign-key [habit] :references habit [name]
					    :on-delete :cascade))]))

(defun gk-habit-db--drop-tables ()
  "Drop database tables of gk-habit."
  (let* ((tables (emacsql db [:select name
				      :from sqlite_master
				      :where (= type 'table)]))
	 (table (completing-read "Choose a table: " tables nil t)))
    (emacsql db `[:drop-table ,(intern table)])))

(defun gk-habit-frequency-params (frequency-type)
  "Get the habit frequency parameters"
  (let (param)
    (cond
     ((string= frequency-type "everyday")
      (setq param nil))
     ((string= frequency-type "repeat")
      (setq param (completing-read "repeated day (exam. \"135\" means habit repeat on Monday, Wensday and Friday in every week.): " nil)))
     ((string= frequency-type "by-week")
      (setq param (completing-read "how many times a week: " nil)))
     ((string= frequency-type "by-month")
      (setq param (completing-read "how many times a month: " nil))))
    param))

(defun gk-habit-add-habit ()
  "Add a new habit"
  (interactive)
  (cl-block 'return
    (let* ((create-time (format-time-string "%Y-%m-%d %T"))
	   (habit
	    (let ((temp (completing-read "name of habit: " nil))
		  (habits (mapcar 'car (emacsql db [:select name :from habit
							    :where (= status "Active")]))))
	      (if (member temp habits)
		  (cl-return-from 'return
		    (message "the habit '%s' already exist!" temp))
		temp)))
	   (frequency-type (completing-read "frequency of habit: " gk-habit-frequency-type nil t))
	   (frequency-param (gk-habit-frequency-params frequency-type))
	   (period  (completing-read "period of habit: " gk-habit-period nil t))
	   (remind-time
	    (let ((temp (completing-read "remind this habit at: " nil)))
	      (if (string= "" temp)
		  nil temp)))
	   (remind-string
	    (let ((temp (completing-read "habit remind sentence: " nil)))
	      (if (string= "" temp)
		  nil temp))))
      (emacsql db `[:insert :into habit
			    :values ([,create-time ,habit ,frequency-type ,frequency-param ,period ,remind-time ,remind-string "Active" nil])])
      (message "Habit '%s' is added!" habit))))

(defun gk-habit-archive-habit ()
  "Archive a habit"
  (interactive)
  (let* ((habits (emacsql db [:select name :from habit
				      :where (= status "Active")]))
	 (habit (completing-read "Choose a habit: " habits nil t)))
    (emacsql db `[:update habit
			  :set (= status "Archive")
			  :where (= name ,habit)])))

(defun gk-habit-insert-record ()
  "Insert a habit redord in table."
  (interactive)
  (let ((create-time (format-time-string "%Y-%m-%d %T"))
	(habit (completing-read "habit: "
				(emacsql db [:select [name] :from habit
						     :where (= status "Active")])))
	(status (completing-read "status: " gk-habit-status))
	(comment
	 (let ((temp (completing-read "comment: " nil)))
	   (if (string= "" temp)
	       nil temp))))
    (emacsql db `[:insert-into record
			       :values ([,create-time ,habit ,status ,comment])])
    (message "Habit '%s' is %s, record on %s, %s" habit status create-time comment)))





;; (defun gk-habit-insert-record ()
;;   "Insert a habit redord in table."
;;   (interactive)
;;   (let ((date (format-time-string "%Y-%m-%d"))
;; 	(habit (completing-read "habit: " gk-habits))
;; 	(status (completing-read "status: " gk-habit-status))
;; 	(comment (completing-read "comment: " nil)))
;;     (with-temp-buffer
;;       (insert-file-contents gk-habit-file)
;;       (goto-char (point-min))
;;       (skip-chars-forward "[ \n\s\t]")
;;       (when (org-at-table-p)
;; 	(forward-line 2)
;; 	(org-table-next-field)
;; 	(while (thing-at-point 'word)
;; 	  (forward-line)
;; 	  (org-table-next-field))
;; 	(dotimes (i (length gk-habit-keys))
;; 	  (insert (nth i `(,date ,habit ,status ,comment)))
;; 	  (org-table-next-field)))
;;       (write-region (point-min) (point-max) gk-habit-file))
;;     (message "a habit record inserted!")))

;; (require 'widget)
;; (eval-when-compile
;;   (require 'wid-edit))
;; (defun gk-habit-add-habit-display ()
;;   "Display a widget buffer when add a new habit."
;;   (interactive)
;;   (display-buffer-at-bottom (get-buffer-create "*Add a habit*")
;; 			    '((window-height . 10)))
;;   (progn
;;     (set-buffer "*Add a habit*")
;;     (kill-all-local-variables)
;;     (let ((inhibit-read-only t))
;;       (erase-buffer))
;;     (remove-overlays)
;;     (widget-insert "Add a new habit.\n\n")
;;     (widget-create 'editable-field
;; 		   :size 12
;; 		   :format "%{Habit Name:%} %v "
;; 		   :sample-face '(:foreground "grey")
;; 		   :help-echo "input a habit name!")
;;     (widget-insert " |  ")
;;     (widget-create 'menu-choice
;; 		   :tag "Habit Frequency"
;; 		   :value "repeat everyday"
;; 		   :help-echo "choose habit frequency"
;; 		   '(item :menu-tag "everyday" "repeat everyday")
;; 		   '(editable-field :menu-tag "by-week" :size 2 :format " %v time a week ")
;; 		   '(editable-field :menu-tag "by-month" :size 2 :format " %v time a month "))
;;     (widget-insert " |  ")
;;     (widget-create 'menu-choice
;; 		   :tag "Habit Period"
;; 		   :value "Get Up"
;; 		   :help-echo "choose habit peroid"
;; 		   '(item :menu-tag "get up" "Get Up")
;; 		   '(item :menu-tag "morning" "Morning")
;; 		   '(item :menu-tag "noon" "Noon")
;; 		   '(item :menu-tag "afternoon" "Afternoon")
;; 		   '(item :menu-tag "evening" "Evening")
;; 		   '(item :menu-tag "before sleep" "Before Sleep")
;; 		   )
;;     (use-local-map widget-keymap)
;;     (widget-setup)))
