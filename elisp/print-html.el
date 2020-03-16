;;; 解析elisp为html

;; (parse-html-unformated
;;  '(div :class "post-div" :style "text-align:center;"
;;        "text in div"
;;        (h3 (a :href "url" "post-title") "another h3 content")
;;        (p "digest")
;;        (img :href "url")
;;        (code (a :href "url" "tagname"))
;;        (span "date")))

(defvar print-html--single-tag-list
  '("img" "br" "hr" "input" "meta" "link" "param"))

(defun print-html--get-plist (list)
  "get attributes of a tag"
  (let* ((i 0)
	 (plist nil))
    (while (and (nth i list) (symbolp (nth i list)))
      (setq key (nth i list))
      (setq value (nth (1+ i) list))
      (setq plist (append plist (list key value)))
      (incf i 2))
    plist))

(defun print-html--get-inner (list)
  "get inner html of a tag"
  (let* ((i 0)
	 (inner nil)
	 (plist (print-html--get-plist list)))
    (if (null plist)
	(setq inner list)
      (dolist (p plist)
	(setq inner (remove p list))
	(setq list inner)))
    inner))

(defun print-html--plist->alist (plist)
  "convert plist to alist"
  (if (null plist)
      '()
    (cons
     (list (car plist) (cadr plist))
     (print-html--plist->alist (cddr plist)))))

(defun print-html--insert-html-tag (tag &optional attrs)
  "insert html tag and attributes"
  (let ((tag (symbol-name tag))
	(attrs (print-html--plist->alist attrs)))
    (if (member tag print-html--single-tag-list)
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

(defun print-html--jump-outside (tag)
  "jump outside of html tag"
  (let ((tag (symbol-name tag)))
    (if (member tag print-html--single-tag-list)
	(forward-char 0)
      (forward-char (+ 3 (length tag))))))
;;----------------------------------------
;; (defun print-html--parse-list-unformated (list)
;;   "parse elisp to unformated html"
;;   (let* ((tag (car list))
;; 	 (left (cdr list))
;; 	 (plist (print-html--get-plist left))
;; 	 (inner (print-html--get-inner left))
;; 	 (html ""))
;;     (with-current-buffer (get-buffer-create "*print html*")
;;       (print-html--insert-html-tag tag plist)
;;       (dolist (item inner)
;; 	(if (listp item)
	    
;; 	    (print-html--parse-list-unformated item)
;; 	  (insert item)))
;;       (print-html--jump-outside tag)
;;       (setq html (buffer-substring-no-properties (point-min) (point-max))))
;;     html))
;;----------------------------------------
(defun print-html--if-no-child (inner)
  "judge if html tag has child-tag"
  (let ((no-child t))
    (dolist (item inner)
      (if (listp item)
	  (setq no-child nil)))
    no-child))

(defun print-html--format-html (tag inner)
  "format html tag, tag which has no child show in one line, others are well formated by default. change this function to redesign the format rule."
  (let ((tag (symbol-name tag)))
    (if (member tag print-html--single-tag-list)
	(insert "")
      (progn
	(if (not (print-html--if-no-child inner))
	    (insert "\n"))))))

(defun print-html--parse-list-formated (list)
  "parse elisp to formated html"
  (let* ((tag (car list))
	 (left (cdr list))
	 (plist (print-html--get-plist left))
	 (inner (print-html--get-inner left))
	 (html ""))
    (with-current-buffer (get-buffer-create "*print html*")
      (print-html--insert-html-tag tag plist)
      (print-html--format-html tag inner)
      (dolist (item inner)
	(if (listp item)
	    (print-html--parse-list-formated item)
	  (progn
	    (insert item)
	    (print-html--format-html tag inner))))
      (print-html--jump-outside tag)
      (insert "\n")
      (setq html (buffer-substring-no-properties (point-min) (point-max))))
    html))
;;---------------------------------------
;; (defun print-html-unformated (LIST)
;;   (let ((html (print-html--parse-list-unformated LIST)))
;;     (kill-buffer "*print html*")
;;     html))

(defun print-html (LIST)
  (let ((html (print-html--parse-list-formated LIST)))
    (kill-buffer "*print html*")
    html))

(provide 'print-html)
