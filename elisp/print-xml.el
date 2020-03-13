(defvar print-xml--single-tag-list nil)

(defun print-xml--get-plist (list)
  "get attributes of a tag"
  (let* ((i 0)
	 (plist nil))
    (while (and (nth i list) (symbolp (nth i list)))
      (setq key (nth i list))
      (setq value (nth (1+ i) list))
      (setq plist (append plist (list key value)))
      (incf i 2))
    plist))

(defun print-xml--get-inner (list)
  "get inner xml of a tag"
  (let* ((i 0)
	 (inner nil)
	 (plist (print-xml--get-plist list)))
    (if (null plist)
	(setq inner list)
      (dolist (p plist)
	(setq inner (remove p list))
	(setq list inner)))
    inner))

(defun print-xml--plist->alist (plist)
  "convert plist to alist"
  (if (null plist)
      '()
    (cons
     (list (car plist) (cadr plist))
     (print-xml--plist->alist (cddr plist)))))

(defun print-xml--insert-xml-tag (tag &optional attrs)
  "insert xml tag and attributes"
  (let ((tag (symbol-name tag))
	(attrs (print-xml--plist->alist attrs)))
    (if (member tag print-xml--single-tag-list)
	(progn
	  (insert (concat "<" tag "/>"))
	  (backward-char 2)
	  (dolist (attr attrs)
	    (insert (concat " " (substring (symbol-name (car attr)) 1) "=" "\"" (cadr attr) "\"")))
	  (forward-char 2))
      (progn
	(insert (concat "<" tag ">" "</" tag ">"))
	(backward-char (+ 4 (length tag)))
	(dolist (attr attrs)
	  (insert (concat " " (substring (symbol-name (car attr)) 1) "=" "\"" (cadr attr) "\"")))
	(forward-char 1)))
    ))

(defun print-xml--jump-outside (tag)
  "jump outside of xml tag"
  (let ((tag (symbol-name tag)))
    (if (member tag print-xml--single-tag-list)
	(forward-char 0)
      (forward-char (+ 3 (length tag))))))
;;----------------------------------------
(defun print-xml--if-no-child (inner)
  "judge if xml tag has child-tag"
  (let ((no-child t))
    (dolist (item inner)
      (if (listp item)
	  (setq no-child nil)))
    no-child))

(defun print-xml--format-xml (tag inner)
  "format xml tag, tag which has no child show in one line, others are well formated by default. change this function to redesign the format rule."
  (let ((tag (symbol-name tag)))
    (if (member tag print-xml--single-tag-list)
	(insert "")
      (progn
	(if (not (print-xml--if-no-child inner))
	    (insert "\n"))))))

(defun print-xml--parse-list-formated (list)
  "parse elisp to formated xml"
  (let* ((tag (car list))
	 (left (cdr list))
	 (plist (print-xml--get-plist left))
	 (inner (print-xml--get-inner left))
	 (xml ""))
    (with-current-buffer (get-buffer-create "*print xml*")
      (print-xml--insert-xml-tag tag plist)
      (print-xml--format-xml tag inner)
      (dolist (item inner)
	(if (listp item)
	    (print-xml--parse-list-formated item)
	  (progn
	    (insert item)
	    (print-xml--format-xml tag inner))))
      (print-xml--jump-outside tag)
      (insert "\n")
      (setq xml (buffer-substring-no-properties (point-min) (point-max))))
    xml))
;;---------------------------------------
(defun print-xml (LIST)
  (let ((xml (print-xml--parse-list-formated LIST)))
    (kill-buffer "*print xml*")
    xml))

(provide 'print-xml)
