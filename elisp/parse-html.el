;;; 解析elisp为html

;; (parse-html-unformated
;;  '(div :class "post-div" :style "text-align:center;"
;;        "text in div"
;;        (h3 (a :href "url" "post-title") "another h3 content")
;;        (p "digest")
;;        (img :href "url")
;;        (code (a :href "url" "tagname"))
;;        (span "date")))

(defvar html-parse--single-tag-list
  '("img" "br" "hr" "input" "meta" "link" "param"))

(defun parse-html--get-plist (list)
  "get attributes of a tag"
  (let* ((i 0)
	 (plist nil))
    (while (and (nth i list) (symbolp (nth i list)))
      (setq key (nth i list))
      (setq value (nth (1+ i) list))
      (setq plist (append plist (list key value)))
      (incf i 2))
    plist))

(defun parse-html--get-inner (list)
  "get inner html of a tag"
  (let* ((i 0)
	 (inner nil)
	 (plist (parse-html--get-plist list)))
    (if (null plist)
	(setq inner list)
      (dolist (p plist)
	(setq inner (remove p list))
	(setq list inner)))
    inner))

(defun parse-html--plist->alist (plist)
  "convert plist to alist"
  (if (null plist)
      '()
    (cons
     (list (car plist) (cadr plist))
     (parse-html--plist->alist (cddr plist)))))

(defun parse-html--insert-html-tag (tag &optional attrs)
  "insert html tag and attributes"
  (let ((tag (symbol-name tag))
	(attrs (parse-html--plist->alist attrs)))
    (if (member tag html-parse--single-tag-list)
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

(defun parse-html--jump-outside (tag)
  "jump outside of html tag"
  (let ((tag (symbol-name tag)))
    (if (member tag html-parse--single-tag-list)
	(forward-char 0)
      (forward-char (+ 3 (length tag))))))
;;----------------------------------------
(defun parse-html--parse-list-unformated (list)
  "parse elisp to unformated html"
  (let* ((tag (car list))
	 (left (cdr list))
	 (plist (parse-html--get-plist left))
	 (inner (parse-html--get-inner left))
	 (html ""))
    (with-current-buffer (get-buffer-create "*parse html*")
      (parse-html--insert-html-tag tag plist)
      (dolist (item inner)
	(if (listp item)
	    (parse-html--parse-list-unformated item)
	  (insert item)))
      (parse-html--jump-outside tag)
      (setq html (buffer-substring-no-properties (point-min) (point-max))))
    html))
;;----------------------------------------
(defun parse-html--if-no-child (inner)
  "judge if html tag has child-tag"
  (let ((no-child t))
    (dolist (item inner)
      (if (listp item)
	  (setq no-child nil)))
    no-child))

(defun parse-html--format-html (tag inner)
  "format html tag, tag which has no child show in one line, others are well formated by default. change this function to redesign the format rule."
  (let ((tag (symbol-name tag)))
    (if (member tag html-parse--single-tag-list)
	(insert "")
      (progn
	(if (not (parse-html--if-no-child inner))
	    (insert "\n"))))))

(defun parse-html--parse-list-formated (list)
  "parse elisp to formated html"
  (let* ((tag (car list))
	 (left (cdr list))
	 (plist (parse-html--get-plist left))
	 (inner (parse-html--get-inner left))
	 (html ""))
    (with-current-buffer (get-buffer-create "*parse html*")
      (parse-html--insert-html-tag tag plist)
      (parse-html--format-html tag inner)
      (dolist (item inner)
	(if (listp item)
	    (parse-html--parse-list-formated item)
	  (progn
	    (insert item)
	    (parse-html--format-html tag inner))))
      (parse-html--jump-outside tag)
      (insert "\n")
      (setq html (buffer-substring-no-properties (point-min) (point-max))))
    html))
;;---------------------------------------
(defun parse-html-unformated (LIST)
  (let ((html (parse-html--parse-list-unformated LIST)))
    (kill-buffer "*parse html*")
    html))

(defun parse-html-formated (LIST)
  (let ((html (parse-html--parse-list-formated LIST)))
    (kill-buffer "*parse html*")
    html))

(defun parse-html (FORMATED LIST)
  "parse html with elisp. the first elem of LIST is always a html tag, others could be attributes or text content or child tag. the three mentioned above are all optional. if has, attributes must be in first place, followed by text content and child tag.

eg. LIST is:

'(div :class \"post-container\"
	       (div :class \"post-div\"
		    (h1 (a :href \"url\" \"text of link\"))
		    (p \"content of paragraph...\")
		    (img :src \"src-url\" :alt \"alt-name\")
		    (code (span :class \"post-date\" \"date\"))))

if FORMATTED is non-nil nil it will be parse into:

<div class=\"post-container\">
<div class=\"post-div\">
<h1>
<a ref=\"url\">text of link</a>
</h1>
<p>content of paragraph...</p>
<img src=\"src-url\" alt=\"alt-name\"/>
<code>
<span class=\"post-date\">date</span>
</code>
</div>
</div>

other, the html will be in one line.
"
  (let ((html ""))
    (if FORMATED
	(parse-html-formated LIST)
	(parse-html-unformated LIST)
	)))

(provide 'parse-html)
