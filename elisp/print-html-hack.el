;;; 解析elisp为html
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
;;; hacking logic tag!
(defun print-html--process-logic (list)
  "process template logic"
  (let ((logic (car list))
	(left (cdr list)))
    (cond ((eq logic :include)
	   (dolist (item (car left))
	     (print-html-unformated item)))
	  ((eq logic :if)
	   (if (car left)
	       (print-html-unformated (cadr left))
	     (print-html-unformated (cadr (cdr left)))))
	  ((eq logic :each)
	   (dolist (item (car left))
	     (setq each-list
		   (read
		    (replace-regexp-in-string
		     "item" (concat "\"" item "\"") (prin1-to-string (cadr left)))))
	     (print-html-unformated each-list))
	   )
	  )
    ))

(defun print-html--process-tag (list)
  "process html tag"
  (let ((tag (car list))
	(plist (print-html--get-plist (cdr list)))
	(inner (print-html--get-inner (cdr list))))
    (with-current-buffer (get-buffer-create "*print html*")
      (when tag
	(progn
	  (print-html--insert-html-tag tag plist)
	  (dolist (item inner)
	    (if (listp item)
		(print-html-unformated item)
	      (insert item)))
	  (print-html--jump-outside tag)
	  (buffer-substring-no-properties (point-min) (point-max)))))
    ))

(defun print-html-unformated (list)
  "parse elisp to unformated html"
  (let ((car-str (symbol-name (car list))))
    (if (string= (substring car-str 0 1) ":")
	(print-html--process-logic list)
      (print-html--process-tag list))
    ))

(defun print-html (LIST)
  (let ((html (print-html-unformated LIST)))
    (kill-buffer "*print html*")
    html))
;;----------------------------------------
;;; temp to format html!
(with-current-buffer "*print html*"
  (setq point (goto-char (point-min)))
  (while point
    (progn
      (setq point (re-search-forward ">" nil t))
      (newline))))
;;----------------------------------------
;;; example!
(print-html-unformated
 `(div :class "post-info"
       (p "「"
	  (:include ,test)
	  (:if ,comment
	       (a "show comment") ;; (:include ,comment-div1)
	       (a "hide comment") ;; (:include ,comment-div2)
	       )
	  (ul
	   (:each
	    ("apple" "peach" "orange" "grape")
	    (li :class "fruit" item)))
	  (span "分类")
	  (span "字数")
	  (span :id "id"
		(span :class "post-meta-item-text" "阅读 ")
		(span :class "leancloud-visitors-count" "...")
		" 次")
	  "」")))
;;----------------------------------------------------------------
;;; extend 和 include的区别和联系??
(setq base-html
      '(body
	(h1 :id "logo" "戈楷旎")
	(p :id "description" "happy hacking emacs")
	(div :id "content"
	     (:block main (p "this is the default main content")))
	))

(setq extend-html
      `(:extend ,base-html
		(:block main (p "this is the extented main content"))
		))
;;----------------------------------------------------------------------
;;; test var!
(setq comment nil)
(setq comment-div1 '((a :class "if-test" "if-test-content")))
(setq comment-div2 '((a :class "else-test" "else-test-content")))
(setq list '((span :class "span" item)))
(setq test `((span :class "test" "test-content")))

;;;========================================================================
;; (defun print-html--if-no-child (inner)
;;   "judge if html tag has child-tag"
;;   (let ((no-child t))
;;     (dolist (item inner)
;;       (if (listp item)
;; 	  (setq no-child nil)))
;;     no-child))

;; (defun print-html--format-html (tag inner)
;;   "format html tag, tag which has no child show in one line, others are well formated by default. change this function to redesign the format rule."
;;   (let ((tag (symbol-name tag)))
;;     (if (member tag print-html--single-tag-list)
;; 	(insert "")
;;       (progn
;; 	(if (not (print-html--if-no-child inner))
;; 	    (insert "\n"))))))
;;--------------------------------------------------
;;;;;;;; ! new function
;; (defun print-html--parse-list-formated (list)
;;   (let* ((car (car list))
;; 	 (car-str (symbol-name car))
;; 	 (left (cdr list))
;; 	 (left-car (cadr list))
;; 	 (plist (print-html--get-plist left))
;; 	 (inner (print-html--get-inner left))
;; 	 (html ""))
;;     (if (string= (substring car-str 0 1) ":")
;; 	(progn
;; 	  (setq logic (substring car-str 1))
;; 	  (cond ((string= logic "include") (dolist (item left-car)
;; 					     (print-html--parse-list-formated item)))
;; 		;; ((string= logic "if") (...))
;; 		))
;;       (with-current-buffer (get-buffer-create "*print html*")
;; 	(setq tag car)
;; 	(print-html--insert-html-tag tag plist)
;; 	(print-html--format-html tag inner)
;; 	(dolist (item inner)
;; 	  (if (listp item)
;; 	      (print-html--parse-list-formated item)
;; 	    (progn
;; 	      (insert item)
;; 	      (print-html--format-html tag inner))))
;; 	(print-html--jump-outside tag)
;; 	(insert "\n")
;; 	(setq html (buffer-substring-no-properties (point-min) (point-max))))
;;       )
;;     ))
;;;==================================================

;; (print-html--parse-list `(:include ,var))
;; (setq var '((link :rel "shortcut icon" :href "/static/img/favicon.ico")
;; 	    (link :rel "bookmark" :href "/static/img/favicon.ico" :type "image/x-icon")
;; 	    (link :id "pagestyle" :rel "stylesheet" :type "text/css" :href "/static/light.css"))
;;       )

;;===========================================================

(provide 'print-html)
