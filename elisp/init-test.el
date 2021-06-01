(setq repl-string-list
      '(("old" "new")
	("test" "测试")
	("错误" "right")
	("隔开你" "戈楷旎")))

(setq repl-regexp-list
      '(("\\." "。")))

(setq repl-file "~/replace.txt")

(defun replall--read-pair-from-file ()
  (let ((repl-list '()))
    (with-temp-buffer
      (insert-file-contents repl-file)
      (goto-char (point-min))
      (while (< (point) (point-max))
	(setq repl-pair (split-string (thing-at-point 'line) "[ \f\t\n\r\v]+" t "[ \f\t\n\r\v]+"))
	(if (null repl-pair)
	    (next-line)
	  (next-line)
	  (setq repl-list (append repl-list (list repl-pair))))))
    repl-list))

(defun replall--get-repl-string-list ()
  (if (bound-and-true-p repl-string-list)
      repl-string-list
    (replall--read-pair-from-file)))

(defun replall--get-repl-regexp-list ()
  (if (bound-and-true-p repl-regexp-list)
      repl-regexp-list
    (message "please set variable 'repl-regexp-list'!")))

(defun replall--string (file lst)
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (dolist (pair lst)
      (while (search-forward (car pair) nil t)
	(replace-match (cadr pair)))
      (goto-char (point-min)))
    (write-file file)))

(defun replall--regexp (file lst)
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (dolist (pair lst)
      (while (re-search-forward (car pair) nil t)
	(replace-match (cadr pair)))
      (goto-char (point-min)))
    (write-file file)))

(defun replall-string-in-curr-buffer ()
  (interactive)
  (let ((curr-file (buffer-file-name (current-buffer)))
	(repl-list (replall--get-repl-string-list)))
    (replall--string curr-file repl-list)))

(defun replall-regexp-in-curr-buffer ()
  (interactive)
  (let ((curr-file (buffer-file-name (current-buffer)))
	(repl-list (replall--get-repl-regexp-list)))
    (replall--regexp curr-file repl-list)))

(defun replall-string-in-file (file repl)
  (interactive "fchoose a file to be processed: ")
  (let ((repl-list (replall--get-repl-string-list)))
    (replall--string file repl-list)))

(defun replall-regexp-in-file (file repl)
  (interactive "fchoose a file to be processed: ")
  (let ((repl-list (replall--get-repl-regexp-list)))
    (replall--regexp file repl-list)))

(defun replall--get-real-files-in-dir (files)
  (let (real-files)
    (dolist (file files)
      (when (not (or (string= "." (substring post 0 1))
		     (string= "#" (substring post 0 1))
		     (string= "~" (substring post 0 1))))
	(push file real-files)))
    real-files))

(defun replall-string-in-directory (dir)
  (interactive "Dchoose a directory to be processed: ")
  (let* ((repl-list (replall--get-repl-string-list))
	(files (directory-files dir))
	(real-files (replall--get-real-files-in-dir files)))
    (dolist (file real-files)
      (replall--string file repl-list))))

(defun replall-regexp-in-directory (dir)
  (interactive "Dchoose a directory to be processed: ")
  (let* ((repl-list (replall--get-repl-regexp-list))
	(files (directory-files dir))
	(real-files (replall--get-real-files-in-dir files)))
    (dolist (file real-files)
      (replall--regexp file repl-list))))

(defun replall-string (type)
  (interactive "sreplace string: 1.in current buffer  2.in a file  3.in a directory (input 1~3): ")
  (cond
   ((string= type "1")
    (replall-string-in-curr-buffer))
   ((string= type "2")
    (call-interactively #'replall-string-in-file))
   ((string= type "3")
    (call-interactively #'replall-string-in-directory))
   (t (message "please input 1~3!"))))

(defun replall-regexp (type)
  (interactive "sreplace regexp: 1.in current buffer  2.in a file  3.in a directory (input 1~3): ")
  (cond
   ((string= type "1")
    (replall-regexp-in-curr-buffer))
   ((string= type "2")
    (call-interactively #'replall-regexp-in-file))
   ((string= type "3")
    (call-interactively #'replall-regexp-in-directory))
   (t (message "please input 1~3!"))))
;;------------------------------------------------------

(defun org-hide-properties ()
  "Hide org headline's properties using overlay."
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward
            "^ *:PROPERTIES:\n\\( *:.+?:.*\n\\)+ *:END:\n" nil t)
      (overlay-put (make-overlay
                    (match-beginning 0) (match-end 0))
                   'display ""))))

(add-hook 'org-mode-hook #'org-hide-properties)
;; (remove-hook 'org-mode-hook #'org-hide-properties)

(provide 'init-test)
