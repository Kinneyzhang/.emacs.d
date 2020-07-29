(setq gk-habit-file "~/habit.org")

(setq gk-habits '("跑步" "早起" "早睡"))

(setq gk-habit-keys '("DATE" "HABIT" "STATUS" "COMMENT"))

(setq gk-habit-status '("DONE" "MISS"))

(defun gk-habit-init-file ()
  "Initialize gk-habit source file."
  (interactive)
  (let* ((nums (length gk-habit-keys)))
    (with-temp-file gk-habit-file
      (org-table-create (concat (format "%s" nums) "x2"))
      (dotimes (i nums)
	(org-table-next-field)
	(insert (nth i titles)))
      (message "habit.org created!"))))

(defun gk-habit-insert-record ()
  "Insert a habit redord in table."
  (interactive)
  (let ((date (format-time-string "%Y-%m-%d"))
	(habit (completing-read "habit: " gk-habits))
	(status (completing-read "status: " gk-habit-status))
	(comment (completing-read "comment: " nil)))
    (with-temp-buffer
      (insert-file-contents gk-habit-file)
      (goto-char (point-min))
      (skip-chars-forward "[ \n\s\t]")
      (when (org-at-table-p)
	(forward-line 2)
	(org-table-next-field)
	(while (thing-at-point 'word)
	  (forward-line)
	  (org-table-next-field))
	(dotimes (i (length gk-habit-keys))
	  (insert (nth i `(,date ,habit ,status ,comment)))
	  (org-table-next-field)))
      (write-region (point-min) (point-max) gk-habit-file))))
