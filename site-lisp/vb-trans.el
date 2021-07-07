;;; verisbilling ifield to ofield.

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

(defvar vb-ifileds nil)

(defvar vb-ofileds nil)

(defvar vb-fetch-buffer "*VB Fetch*")

(defvar vb-field-pairs
  '(("user_id" . "inst_id")
    ("start_date" . "valid_date")
    ("so_date" . "commit_date"))
  "Matched ifield and ofield pairs.")

(defun vb-find-ifield (ofield)
  "Find ifield according to OFIELD in `vb-field-pairs'."
  (car (seq-find (lambda (pair)
                   (string= (cdr pair) ofield))
                 vb-field-pairs)))

(defun vb-get-iNo (ifield)
  "return the serial number of IFIELD in `vb-ifileds'."
  (when-let ((pos (seq-position vb-ifileds ifield)))
    (1+ pos)))

;; (defun vb-trans-info (ifield ofield iNo oNo)
;;   (format "%s %s ------ %s > %s" iNo oNo ifield ofield))

(defun vb-trans-field (ifields ofields)
  "Return the result of matching string."
  (let (lst)
    (dotimes (i (length ofields))
      (let ((oNo (1+ i))
            (ofield (nth i ofields)))
        (pcase ofield
          ((pred vb-find-ifield)
           (let* ((ifield (vb-find-ifield ofield))
                  (iNo (vb-get-iNo ifield)))
             (push (list iNo oNo ifield ofield) lst)))
          ((and (let iNo (vb-get-iNo ofield))
                (guard iNo))
           (push (list iNo oNo ofield ofield) lst))
          (_ (push (list "" oNo "" ofield) lst)))))
    (reverse lst)))

;;;###autoload
(define-minor-mode vb-fetch-mode
  "Minor mode for fetching ifileds and ofields
in `vb-fetch-buffer' buffer."
  nil nil
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-c") #'vb-fetch-finalize)
    (define-key map (kbd "C-c C-k") #'vb-fetch-cancel)
    map)
  (if vb-fetch-mode
      (setq header-line-format "Press 'C-c C-c' to finish, 'C-c C-k' to cancel.")
    (setq header-line-format nil)))

;;;###autoload
(defun vb-fetch-cancel ()
  (interactive)
  (kill-buffer vb-fetch-buffer))

;;;###autoload
(defun vb-fetch-finalize ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((count 0))
      (while (re-search-forward "^;; -+" nil t)
        (setq count (1+ count))
        (let* ((beg (point))
               (end (save-excursion
                      (if (re-search-forward "^;; -+" nil t)
                          (progn
                            (forward-line -1)
                            (point))
                        (point-max))))
               (_ (message "beg,end: %s %s"  beg end))
               (str (string-trim (buffer-substring-no-properties beg end)))
               (lst (split-string str "[\n]+")))
          (pcase count
            (1 (setq vb-ifileds lst)
               (message "ifileds:%S" lst))
            (2 (setq vb-ofileds lst)
               (message "ofileds:%S" lst))
            (3 (setq vb-field-pairs
                     (mapcar (lambda (str)
                               (cons (car (split-string str))
                                     (cadr (split-string str))))
                             lst))
               (message "io pairs:%S" vb-field-pairs)))))))
  (pop-to-buffer "*VB Result*")
  (erase-buffer)
  (org-mode)
  (insert "* VB ifiled to ofield\n\n")
  (let* ((inhibit-read-only 1)
         (data (vb-trans-field vb-ifileds vb-ofileds))
         (data (progn
                 (push 'hl data)
                 (push '("src" "des" "ifield" "ofield") data))))
    (insert (vb-org-table-create data)))
  (read-only-mode 1))

;;;###autoload
(defun vb-trans ()
  (interactive)
  (let ((buf (get-buffer-create vb-fetch-buffer)))
    (switch-to-buffer buf)
    (vb-fetch-mode)
    (erase-buffer)
    (insert ";; 1.请在下面输入所有 'ifield' 字段名，每个字段一行：
;; -----------------------------------\n\n")
    (insert ";; 2.请在下面输入所有 'ofield' 字段名，每个字段一行：
;; -----------------------------------\n\n")
    (insert ";; 3.请在下面输入所有不同的 'ifield ofiled' 匹配，每个匹配一行：
;; -----------------------------------\n")))


(bind-key (kbd "C-c c v") #'vb-trans 'global-map)

;; test data
;; 1.请在下面输入所有 'ifield' 字段名，每个字段一行：
;; -----------------------------------
CUST_ID
GROUP_ID
GROUP_CUST_NAME
GROUP_TYPE
MEMBER_BELONG
MEMBER_KIND
MEMBER_CUST_ID
USECUST_ID
USER_ID
SERIAL_NUMBER
NET_TYPE_CODE
CUST_NAME
USECUST_NAME
VPMN_GROUP_ID
JOIN_TYPE
JOIN_DATE
JOIN_STAFF_ID
JOIN_DEPART_ID
REMOVE_TAG
REMOVE_DATE
REMOVE_STAFF_ID
REMOVE_REASON
UPDATE_TIME
;; 2.请在下面输入所有 'ofield' 字段名，每个字段一行：
;; -----------------------------------
CUST_ID
GROUP_ID
GROUP_TYPE
MEMBER_CUST_ID
USECUST_ID
USER_ID
REMOVE_TAG
VALID_DATE
EXPIRE_DATE
OPER_TYPE
SO_NBR
COMMIT_DATE
REMARK
;; 3.请在下面输入所有不同的 'ifield ofiled' 匹配，每个匹配一行：
;; -----------------------------------
JOIN_DATE VALID_DATE
REMOVE_DATE EXPIRE_DATE
MODIFY_TAG OPER_TYPE
event_code SO_NBR
UPDATE_TIME COMMIT_DATE
