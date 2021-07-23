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
      (while (re-search-forward "^-+.+-+$" nil t)
        (setq count (1+ count))
        (let* ((beg (point))
               (end (save-excursion
                      (if (re-search-forward "^-+.+-+$" nil t)
                          (line-beginning-position)
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
  (let* ((inhibit-read-only 1)
         (data (vb-trans-field vb-ifileds vb-ofileds))
         (data (progn
                 (push 'hl data)
                 (push '("src" "des" "ifield" "ofield") data))))
    (view-buffer (get-buffer-create "*VB Result*") #'kill-buffer)
    (erase-buffer)
    (org-mode)
    (insert "* VB ifiled to ofield\n\n")
    (insert (vb-org-table-create data))
    (read-only-mode 1)))

;;;###autoload
(defun vb-trans ()
  (interactive)
  (let ((buf (get-buffer-create vb-fetch-buffer)))
    (switch-to-buffer buf)
    (vb-fetch-mode)
    (erase-buffer)
    (insert "------------------------ ifield ---------------------\n\n")
    (insert "------------------------ ofield ---------------------\n\n")
    (insert "-----------------ifield and ofield diff ---------------\n")))


(bind-key (kbd "C-c c v") #'vb-trans 'global-map)

;; sql-plus

;; 0(require 'sqlplus)

;; jdbc:oracle:thin:@10.170.103.171:1521:V8TESTCI

;; PD/V8testci@10.170.103.171:1521/V8TESTCI

;; select * from pd.td_b_ifield_def where info_type=307;

(setq sql-connection-alist
      '(("V8TESTCI"
         (sql-product 'oracle)
         (sql-user "pd")
         (sql-password "V8testci")
         (sql-database "10.170.103.171:1521/V8TESTCI"))))

;; (sql-connect "V8TESTCI")
;;; ===========================================================
(defvar vb-info-str-file "~/Test/info-type-str")

(defvar vb-result-buf "*Vb Result*")

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
  (with-current-buffer (get-file-buffer info-str-file)
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
    (with-current-buffer (get-buffer-create vb-result-buf)
      (save-excursion
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
          (vb-org-table-create table-data))))))
