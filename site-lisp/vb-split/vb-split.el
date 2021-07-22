(defvar vb-info-str-file
  (concat emacs-site-lisp "vb-split/vb-info-str"))

(defvar vb-result-file
  (concat emacs-site-lisp "vb-split/vb-result"))

(defun vb-org-table-create (LIST)
  "Create org table from a LIST form at point."
  (let ((column (catch 'break
		  (dolist (row-data LIST)
		    (when (listp row-data)
		      (throw 'break (length row-data))))))
	(beg (point)))
    (org-table-create (concat (number-to-string column) "x1"))
    (goto-char beg)
    (when (org-at-table-p)
      (org-table-next-field)
      (dotimes (i (length LIST))
	(let ((row-data (nth i LIST)))
	  (if (listp row-data)
	      (dolist (data row-data)
		(cond
		 ((numberp data)
		  (insert (number-to-string data)))
		 ((null data)
		  (insert ""))
		 (t (insert data)))
		(org-table-next-field))
	    (when (equal 'hl row-data)
	      (org-table-insert-hline 1)))
	  (when (= i (1- (length LIST)))
	    (org-table-kill-row))))))
  (forward-line))

(defun vb-info-str-lst (info-type)
  (with-current-buffer (get-file-buffer vb-info-str-file)
    (let ((specific-regexp (concat "^-+" info-type "-+$"))
          beg end lst)
      (save-excursion
        (goto-char (point-min))
        (when (re-search-forward specific-regexp nil t)
          (setq beg (1+ (point)))
          (if (re-search-forward "^-+" nil t)
              (setq end (line-beginning-position))
            (setq end (point-max)))))
      (setq lst (split-string
                 (buffer-substring-no-properties beg end)))
      lst)))

(defun vb-split (info-type info-str)
  (interactive "sInput the info-type: \nsInput the info-str: ")
  (let* ((field-lst (vb-info-str-lst info-type))
         (len (length field-lst))
         (str-lst (split-string info-str "")))
    (with-current-buffer (find-file-noselect vb-result-file)
      (save-excursion
        (read-only-mode -1)
        (org-mode)
        (goto-char (point-min))
        (let ((type-regexp (format "^* %s$" info-type))
              beg end)
          (if (re-search-forward type-regexp nil t)
              (progn
                (setq beg (line-beginning-position))
                (if (re-search-forward "^* [0-9]+$" nil t)
                    (progn
                      (goto-char (line-beginning-position))
                      (setq end (point)))
                  (setq end (point-max)))
                (delete-region beg end))
            (goto-char (point-max))))
        (let (table-data)
          (dotimes (i len)
            (let ((order (1+ i))
                  (field (nth i field-lst))
                  (value (nth i str-lst)))
              (pcase value
                ((pred string-empty-p) (setq value "null"))
                ((pred null) (setq value "")))
              (push (list order field value) table-data)))
          (setq table-data (reverse table-data))
          (insert (format "* %s\n" info-type))
          (vb-org-table-create table-data))
        (read-only-mode 1)))))

;; ---------------------------
