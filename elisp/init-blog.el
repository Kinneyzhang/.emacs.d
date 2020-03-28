;;; init-blog
;;;===================================================================================
(require 'pp-html)
(require 'print-xml)

(defun my/insert-html-tag-with-attr (tag &optional attr)
  "insert a html tag and some attributes at cursor point"
  (let ((single-tag-list '("img" "br" "hr" "input" "meta" "link" "param")))
    (if (member tag single-tag-list)
	(progn
	  (insert (concat "<" tag "/>"))
	  (backward-char 2)
	  (mapcar (lambda (x) (insert (concat " " (car x) "=" "\"" (cadr x) "\""))) attr)
	  (forward-char 2)
	  )
      (progn
	(insert (concat "<" tag ">" "</" tag ">"))
	(backward-char (+ 4 (length tag)))
	(mapcar (lambda (x) (insert (concat " " (car x) "=" "\"" (cadr x) "\""))) attr)
	(forward-char 1)
	))
    ))

;;; auto generate blog's sitemap.xml, post-info, index.org, archive.org, category.org.
(defvar blog-root-dir "~/iCloud/blog_site/")
(defvar blog-post-dir "~/iCloud/blog_site/org/")
(defvar blog-html-dir "~/iCloud/blog_site/post/")
(defvar blog-page-dir "~/iCloud/blog_site/page/")
(defvar blog-site-domain "https://geekinney.com/")
(defvar blog-site-name "戈楷旎")
(defvar blog-site-description "happy hacking emacs!")
(defvar blog-author "Kinney Zhang")
(defvar blog-author-email "kinneyzhang666@gmail.com")
(defvar blog-language "zh-cn")
(defvar blog-generator "Emacs OrgMode 9.1.9")
(defvar blog-icon "https://geekinney.com/static/img/favicon.ico")

;; get valine appid and appkey
(defun my/blog-get-valine-info ()
  "get appId and appKey list"
  (let ((valine-file (concat blog-root-dir "valine"))
	(applist nil))
    (with-temp-buffer
      (insert-file-contents valine-file)
      (goto-char (point-min))
      (setq appid (substring (thing-at-point 'line) 0 -1))
      (next-line)
      (setq appkey (thing-at-point 'line))
      (setq applist `(,appid ,appkey)))
    applist))

;; generate article's post-info
(defun my/blog-get-post-info ()
  (interactive)
  (let ((post buffer-file-name)
	(html-str ""))
    (with-temp-buffer
      (setq valine-visitor-url (concat "/" (string-trim blog-html-dir blog-root-dir) (file-name-base post) ".html"))
      (insert-file-contents post)
      (goto-char (point-min))
      (setq count (my/word-count))
      (goto-char (point-min))
      (re-search-forward "^#\\+TITLE")
      (setq title (plist-get (cadr (org-element-at-point)) :value))
      (goto-char (point-min))
      (re-search-forward "^#\\+DATE")
      (setq date (plist-get (cadr (org-element-at-point)) :value))
      (goto-char (point-min))
      (re-search-forward "^#\\+CATEGORY")
      (setq category (plist-get (cadr (org-element-at-point)) :value))
      ;; (setq html-str (concat "「 分类:" category " / 字数:" (number-to-string count) "阅读量:"  " 」"))
      (erase-buffer)
      (insert
       (pp-html `(div :class "post-info"
		      (p "「"
			 (span "分类: " ,category " · ")
			 (span "字数: " ,(number-to-string count) " · ")
			 (span :id ,valine-visitor-url
			       :class "leancloud_visitors"
			       :data-flag-title ,title
			       (span :class "post-meta-item-text" "阅读 ")
			       (span :class "leancloud-visitors-count" "...")
			       " 次")
			 "」"))))
      (setq html-str (buffer-substring-no-properties (point-min) (point-max)))
      )
    html-str))

;; (my/insert-html-tag-with-attr "span" `(("id" ,valine-visitor-url) ("class" "leancloud_visitors") ("data-flag-title" ,title)))
;; (my/insert-html-tag-with-attr "em" '(("class" "post-meta-item-text")))
;; (insert "阅读量 ")
;; (forward-char 5)
;; (my/insert-html-tag-with-attr "i" '(("class" "leancloud-visitors-count")))
;; (insert "0 / ")
;; (forward-char 11)

;;;--------------------------------------------------
;; generate blog's sitemap.xml file
(defun my/blog-generate-sitemap-format (posts)
  (let ((xml-str ""))
    (if (stringp posts)
	(setq posts (read posts)))
    (dolist (post posts)
      (with-temp-buffer
	(setq post-url (concat blog-site-domain (string-trim blog-html-dir blog-root-dir) (car (split-string post "\\.")) ".html"))
	(insert-file-contents (concat blog-post-dir post))
	(goto-char (point-min))
	(re-search-forward "^#\\+DATE")
	(setq date (plist-get (cadr (org-element-at-point)) :value))
	(erase-buffer)
	(insert
	 (print-xml
	  `(url (loc ,post-url)
		(lastmod ,date)
		(changefreq "daily")
		(priority "0.8"))))
	(setq xml-str (concat xml-str (buffer-substring-no-properties (point-min) (point-max))))
	(erase-buffer)
	))
    (concat "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n" xml-str "</urlset>")
    ))

(defun my/blog-generate-sitemap-xml (&optional proj)
  (interactive)
  (let ((sitemap-xml (concat blog-root-dir "sitemap.xml")))
    (with-temp-buffer
      (insert (my/blog-generate-sitemap-format (my/blog-posts-sorted-by-date)))
      (write-file sitemap-xml))
    (message "sitemap.xml deployed successfully!")
    ))

;;;-------------------------------------------------
;; generate blog's rss file
(defun my/blog-generate-rss-format (posts)
  (let ((xml-str ""))
    (if (stringp posts)
	(setq posts (read posts)))
    (dolist (post posts)
      (with-temp-buffer
	(setq url (concat blog-site-domain (string-trim blog-html-dir blog-root-dir) (car (split-string post "\\.")) ".html"))
	(insert-file-contents (concat blog-post-dir post))
	(goto-char (point-min))
	(re-search-forward "^#\\+TITLE")
	(setq title (plist-get (cadr (org-element-at-point)) :value))
	(goto-char (point-min))
	(re-search-forward "^#\\+DATE")
	(setq date (plist-get (cadr (org-element-at-point)) :value))
	(setq buffer-string (replace-regexp-in-string "^#\\+.+\n+" "" (buffer-substring-no-properties (point-min) (point-max)))
	      buffer-string (replace-regexp-in-string "^.+#\\+BEGIN_SRC.+\n{.+\n}+.+#\\+END_SRC" "" buffer-string)
	      buffer-string (replace-regexp-in-string "^本文转载.+\n" "" buffer-string)
	      buffer-string (replace-regexp-in-string "^http.+\n" "" buffer-string)
	      buffer-string (replace-regexp-in-string "\\[\\[.+\\]\\[" "" buffer-string)
	      buffer-string (replace-regexp-in-string "\\]\\]" "" buffer-string)
	      buffer-string (replace-regexp-in-string "\\*+" "" buffer-string)
	      buffer-string (replace-regexp-in-string "|-*" "" buffer-string)
	      buffer-string (replace-regexp-in-string "\n+" "" buffer-string)
	      buffer-string (replace-regexp-in-string " =" "" buffer-string)
	      buffer-string (replace-regexp-in-string "= " "" buffer-string))
	(setq digest (concat (substring buffer-string 0 100) " ....."))
	(setq xml-str
	      (concat xml-str
		      (print-xml
		       `(item (title ,title)
			      (link ,url)
			      (description ,digest)
			      (author ,blog-author)
			      (pubDate ,date)))))))
    (setq xml-str
	  (concat "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n"
		  (print-xml
		   `(rss :version "2.0"
			 (channel (title ,blog-site-name)
				  (link ,blog-site-domain)
				  (description ,blog-site-description)
				  (Webmaster ,blog-author-email)
				  (language ,blog-language)
				  (generator ,blog-generator)
				  (ttl "5")
				  (image
				   (url ,blog-icon)
				   (title ,blog-site-name)
				   (link ,blog-site-domain)
				   (width "32")
				   (height "32"))
				  ,xml-str)))))
    xml-str))

(defun my/blog-generate-rss-feed (&optional proj)
  (interactive)
  (let ((rss-xml (concat blog-root-dir "feed.xml")))
    (with-temp-buffer
      (insert (my/blog-generate-rss-format (my/blog-posts-sorted-by-date)))
      (write-file rss-xml))
    (message "feed.xml deployed successfully!")
    ))
;;;-------------------------------------------------
;; get all org posts
(defun list-car-string-less (list1 list2)
  "compare the car of list1 to list2, which is a string"
  (if (string< (car list1) (car list2))
      (eq t t)
    (eq t nil)))

(defun my/blog-posts-sorted-by-date ()
  "make all posts name a list by date"
  (interactive)
  (let ((post-files (cdr (cdr (directory-files blog-post-dir))))
	(date-post-list '())
	(post-list '()))
    (mapcar (lambda (post)
	      (with-temp-buffer
		(insert-file-contents (concat blog-post-dir post))
		(goto-char (point-min))
		(re-search-forward "^#\\+DATE")
		(setq date (plist-get (cadr (org-element-at-point)) :value))
		(setq date-post-pair (list date post))
		(setq date-post-list (cons date-post-pair date-post-list))
		(erase-buffer)
		))
	    post-files)
    (setq date-post-list-sorted (sort date-post-list 'list-car-string-less))
    (mapcar (lambda (e)
	      (setq post-list (cons (cadr e) post-list)))
	    date-post-list-sorted)
    post-list))
;;;--------------------------------------------------
;; generate index.org
(defun my/blog-generate-digest-html (posts)
  "generate blog's digest page html"
  (let ((html-str "")
	(category-url (concat blog-site-domain "category.html")))
    (mapcar (lambda (post)
	      (with-temp-buffer
		(setq post-url (concat blog-site-domain (string-trim blog-html-dir blog-root-dir) (car (split-string post "\\.")) ".html"))
		(setq valine-visitor-url (concat "/" (string-trim blog-html-dir blog-root-dir) (file-name-base post) ".html"))
		(insert-file-contents (concat blog-post-dir post))
		(setq count (my/word-count))
		(goto-char (point-min))
		(re-search-forward "^#\\+TITLE")
		(setq title (plist-get (cadr (org-element-at-point)) :value))
		(goto-char (point-min))
		(re-search-forward "^#\\+DATE")
		(setq date (plist-get (cadr (org-element-at-point)) :value))
		(goto-char (point-min))
		(re-search-forward "^#\\+CATEGORY")
		(setq category (plist-get (cadr (org-element-at-point)) :value))
		(setq buffer-string (replace-regexp-in-string "^#\\+.+\n+" "" (buffer-substring-no-properties (point-min) (point-max)))
		      ;; !!!
		      buffer-string (replace-regexp-in-string "^.+#\\+BEGIN_SRC.+\n.+\n+.+#\\+END_SRC" "" buffer-string)
		      buffer-string (replace-regexp-in-string "^本文转载.+\n" "" buffer-string)
		      buffer-string (replace-regexp-in-string "^http.+\n" "" buffer-string)
		      ;; buffer-string (replace-regexp-in-string "\\([a-zA-Z0-9]\\)[ ]+\\(\\cc\\)" "" buffer-string)
		      buffer-string (replace-regexp-in-string "\\[\\[.+\\]\\[" "" buffer-string)
		      buffer-string (replace-regexp-in-string "\\]\\]" "" buffer-string)
		      buffer-string (replace-regexp-in-string "\\*+" "" buffer-string)
		      buffer-string (replace-regexp-in-string "|-*" "" buffer-string)
		      buffer-string (replace-regexp-in-string "\n+" "" buffer-string)
		      buffer-string (replace-regexp-in-string " =" "" buffer-string)
		      buffer-string (replace-regexp-in-string "= " "" buffer-string))
		(setq digest (substring buffer-string 0 168))
		(erase-buffer)
		(insert
		 (pp-html
		  `(div :id "post-div"
			(h2 (a :href ,post-url ,title))
			(p ,digest " ......" (a :href ,post-url "「阅读全文」"))
			(p (code (a :href ,category-url ,category))
			   (span :id "post-div-meta"
				 (span ,(number-to-string count) "字 · ")
				 (span :class "post-date" ,date)
				 )))))
		(setq html-str (concat html-str (buffer-substring-no-properties (point-min) (point-max))))
		))
	    posts)
    html-str))

;; (span :id ,valine-visitor-url
;;       :class "leancloud_visitors"
;;       :data-flag-title ,title
;;       (span :class "post-meta-item-text" "阅读 ")
;;       (span :class "leancloud-visitors-count" "..")
;;       " 次 · ")

(defun my/blog-generate-index-org (&optional proj)
  "generate blog's index.org file"
  (interactive)
  (let* ((html-str (my/blog-generate-digest-html (my/blog-posts-sorted-by-date)))
	 (index-str (concat "#+TITLE: Geekinney Blog\n#+OPTIONS: title:nil\n#+begin_export html\n" html-str "#+end_export")))
    (with-temp-buffer
      (insert index-str)
      (write-file (concat blog-page-dir "index.org")))))
;;; --------------------------------------------------
;; generate archive.org
(defun my/blog-generate-archive-str (posts)
  "generate blog's archive.org string"
  (let ((archive-year-str "")
	(archive-year-str-with-year "")
	(year-list nil)
	(year-and-archive-single-str-list nil))
    (dolist (post posts)
      (with-temp-buffer
	(setq url (concat blog-site-domain (string-trim blog-html-dir blog-root-dir) (car (split-string post "\\.")) ".html"))
	(insert-file-contents (concat blog-post-dir post))
	(goto-char (point-min))
	(re-search-forward "^#\\+TITLE")
	(setq title (plist-get (cadr (org-element-at-point)) :value))
	(goto-char (point-min))
	(re-search-forward "^#\\+DATE")
	(setq date (plist-get (cadr (org-element-at-point)) :value))
	(setq year (substring date 0 4))
	(setq month-and-day (concat (substring date 5 7) (substring date 8 10)))
	(setq archive-single-str (concat " * " month-and-day " [[" url "][" title "]]"))
	(setq year-and-archive-single-str-list (cons `(,year ,archive-single-str) year-and-archive-single-str-list)) ;; (("2020" " * 0222 [[url][title]]") ("2020" " * 0221 [[url][title]]") ... ("2019" " * 1231 [[url][title]]"))
	(setq year-list (cons year year-list))
	(erase-buffer)
	))
    (setq year-and-archive-single-str-list (reverse year-and-archive-single-str-list))
    (setq year-list (reverse year-list))
    (setq years (delete-dups year-list))
    (dolist (year years)
      (dolist (elem year-and-archive-single-str-list)
	(if (string= year (car elem))
	    (setq archive-year-str (concat archive-year-str (cadr elem) "\n"))))
      (setq archive-year-str-with-year (concat archive-year-str-with-year "* " year "\n" archive-year-str))
      (setq archive-year-str ""))
    (concat "#+TITLE: 文章归档\n#+STARTUP: showall\n#+OPTIONS: toc:nil H:1 num:0 title:nil\n" archive-year-str-with-year)
    ))

(defun my/blog-generate-archive-org (&optional proj)
  "generate blog's archive.org file"
  (interactive)
  (let ((archive-org-file (concat blog-page-dir "archive.org"))
	(archive-str (my/blog-generate-archive-str (my/blog-posts-sorted-by-date))))
    (with-temp-buffer
      (insert archive-str)
      (write-file archive-org-file))))
;;;----------------------------------------------------
;; generate category.org
(defun my/blog-generate-category-str (posts)
  "generate blog's category.org string"
  (interactive)
  (let ((one-category-str "")
	(category-str-with-category "")
	(category-and-category-single-str-list nil)
	(category-list nil))
    (dolist (post posts)
      (with-temp-buffer
	(setq url (concat blog-site-domain (string-trim blog-html-dir blog-root-dir) (car (split-string post "\\.")) ".html"))
	(insert-file-contents (concat blog-post-dir post))
	(goto-char (point-min))
	(re-search-forward "^#\\+TITLE")
	(setq title (plist-get (cadr (org-element-at-point)) :value))
	(goto-char (point-min))
	(re-search-forward "^#\\+CATEGORY")
	(setq category (plist-get (cadr (org-element-at-point)) :value))
	
	(setq category-single-str (concat " * [[" url "][" title "]]"))
	(setq category-and-category-single-str-list (cons `(,category ,category-single-str) category-and-category-single-str-list))
	(setq category-list (cons category category-list))
	(erase-buffer)
	))
    (setq category-list (sort category-list 'string<))
    (setq categories (delete-dups category-list))
    (dolist (category categories)
      (dolist (elem category-and-category-single-str-list)
	(if (string= category (car elem))
	    (setq one-category-str (concat one-category-str (cadr elem) "\n"))))
      (setq category-str-with-category (concat category-str-with-category "* " category "\n" one-category-str))
      (setq one-category-str ""))
    (concat "#+TITLE: 标签分类\n#+STARTUP: showall\n#+OPTIONS: toc:nil H:1 num:0 title:nil\n" category-str-with-category)
    ))

(defun my/blog-generate-category-org (&optional proj)
  "generate blog's category.org file"
  (interactive)
  (let ((category-org-file (concat blog-page-dir "category.org"))
	(category-str (my/blog-generate-category-str (my/blog-posts-sorted-by-date))))
    (with-temp-buffer
      (insert category-str)
      (write-file category-org-file))))

;;--------------------------------------------------
(defun my/blog-push-to-github (&optional proj)
  (progn
    (shell-command "~/iCloud/blog_site/deploy.sh")
    (message "blog deployed successfully!")))

(defun my/org-publish-project-force (proj)
  (interactive "sEnter the project name: ")
  (org-publish proj t nil))

(defun my/blog-new-post (slug title category)
  (interactive "sinput slug: \nsinput title: \nsinput category: ")
  (let* ((blog-org-dir "~/iCloud/blog_site/org/")
	 (blog-org-file (concat blog-org-dir slug ".org"))
	 (blog-org-created-date (format-time-string "%Y-%m-%d"))
	 (blog-org-head-template (concat "#+TITLE: " title "\n#+DATE: " blog-org-created-date "\n#+CATEGORY: " category "\n#+INCLUDE: \"../code/post-info.org\"\n#+STARTUP: showall\n#+OPTIONS: toc:nil H:2 num:2\n#+TOC: headlines:2\n")))
    (if (file-exists-p blog-org-file)
	(find-file blog-org-file)
      (progn
	(find-file blog-org-file)
	(insert blog-org-head-template)))))

;;-------------------------------------------------------
(defun my/org-grid-img (row col ulist)
  "insert imag in mood diary, use it as a macro"
  (interactive)
  (let ((html-parse-single-tag-list '("img" "br" "hr" "input" "meta" "link" "param"))
	(row (string-to-number row))
	(col (string-to-number col))
	(ulist (read ulist)))
    (with-temp-buffer
      (insert "#+begin_export html\n \n#+end_export")
      (backward-char 14)
      (my/insert-html-tag-with-attr "div" '(("class" "img-container")))
      (dotimes (i row)	
	(my/insert-html-tag-with-attr "div" '(("class" "img-row")))
	(dotimes (j col)
	  (setq url (nth (+ j (* i col)) ulist))
	  (my/insert-html-tag-with-attr "a" (list (list "href" url)))
	  (my/insert-html-tag-with-attr "img" (list (list "src" url)))
	  (forward-char 6))
	(forward-char 8))
      (buffer-substring-no-properties (point-min) (point-max))
      )
    ))

;; '(div :class "img-container"
;;       (:loop ))

;;;==============================================================
;; https://gongzhitaao.org/orgcss/org.css
;; org html export
(setq org-html-head-include-scripts nil)
(setq org-html-head-include-default-style nil)
(setq org-html-htmlize-output-type nil) ;; 导出时不加行间样式！
(setq org-html-doctype "html5")
(setq org-html-html5-fancy t)

(defun org-html-src-block2 (src-block _contents info)
  "Transcode a SRC-BLOCK element from Org to HTML.
		    CONTENTS holds the contents of the item.  INFO is a plist holding
		    contextual information."
  (if (org-export-read-attribute :attr_html src-block :textarea)
      (org-html--textarea-block src-block)
    (let ((lang (org-element-property :language src-block))
	  (code (org-html-format-code src-block info))
	  (label (let ((lbl (and (org-element-property :name src-block)
				 (org-export-get-reference src-block info))))
		   (if lbl (format " id=\"%s\"" lbl) ""))))
      (if (not lang) (format "<pre><code class=\"example\"%s>\n%s</code></pre>" label code)
	(format "<div class=\"col-auto\">\n%s%s\n</div>"
		;; Build caption.
		(let ((caption (org-export-get-caption src-block)))
		  (if (not caption) ""
		    (let ((listing-number
			   (format
			    "<span class=\"listing-number\">%s </span>"
			    (format
			     (org-html--translate "Listing %d:" info)
			     (org-export-get-ordinal
			      src-block info nil #'org-html--has-caption-p)))))
		      (format "<label class=\"org-src-name\">%s%s</label>"
			      listing-number
			      (org-trim (org-export-data caption info))))))
		;; Contents.
		(format "<pre><code class=\"%s\"%s>%s</code></pre>"
			lang label code))))))

(advice-add 'org-html-src-block :override 'org-html-src-block2)
;;-------------------------------------------------------------
(setq user-full-name "Kinney Zhang")
(setq user-mail-address "kinneyzhang666@gmail.com")
(setq org-export-with-author t)
(setq org-export-with-email t)
(setq org-export-with-date t)
(setq org-export-with-creator t)
(setq org-html-creator-string
      "<a href=\"https://www.gnu.org/software/emacs/\">Emacs</a> 26.3 (<a href=\"https://orgmode.org\">Org</a> mode 9.1.9)")

(setq my/html-head
      "
<link rel=\"shortcut icon\" href=\"/static/img/favicon.ico\"/>
<link rel=\"bookmark\" href=\"/static/img/favicon.ico\" type=\"image/x-icon\"/>
<link id=\"pagestyle\" rel=\"stylesheet\" type=\"text/css\" href=\"/static/light.css\"/>
<!-- Google Adsense -->
<script data-ad-client=\"ca-pub-3231589012114037\" async src=\"https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js\"></script>
<!-- End Google Adsense -->
")

(setq my/html-home/up-format
      "
<div id=\"org-div-header\">
<div class=\"toptitle\">
<a id=\"logo\" href=\"/\">戈楷旎</a>
<p class=\"description\">happy hacking emacs!</p>
</div>
<div class=\"topnav\">
<a href=\"/\">首页</a>&nbsp;&nbsp;
<a href=\"/archive.html\">归档</a>&nbsp;&nbsp;
<a href=\"/category.html\">分类</a>&nbsp;&nbsp;
<a href=\"/about.html\">关于</a>&nbsp;&nbsp;
<a href=\"/message.html\">留言</a>&nbsp;&nbsp;
</div>
</div>")

(setq my/org-html-postamble-of-page
      '(("en"
	 "
<script src=\"/static/jQuery.min.js\"></script>

<p><span class=\"dim\">©2020</span> 戈楷旎 <span class=\"dim\">| Licensed under </span><a rel=\"license\" href=\"http://creativecommons.org/licenses/by-nc-sa/4.0/\"><img alt=\"知识共享许可协议\" style=\"border-width:0\" src=\"/static/img/license.png\"/></a></p>
<p class=\"creator\"><span class=\"dim\">Generated by</span> %c</p>\n

<!-- Google Analytics -->
<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');ga('create', 'UA-149578968-1', 'auto');ga('send', 'pageview');
</script>
<!-- End Google Analytics -->

<script>
$(document).ready(function(){
var theme = sessionStorage.getItem(\"theme\");
if(theme==\"dark\"){
document.getElementById(\"pagestyle\").href=\"/static/dark.css\";
}else if(theme==\"light\"){
document.getElementById(\"pagestyle\").href=\"/static/light.css\";
}else{
sessionStorage.setItem(\"theme\",\"light\");
}});
</script>")))

(setq my/org-html-postamble-of-post
      `(( "en"
	  ,(concat "
<p class=\"date\"><i>Posted on %d</i></p><br>

<script src=\"/static/jQuery.min.js\"></script>
<script src=\"/static/Valine.min.js\"></script>

<div id=\"vcomments\"></div>
<script>
new Valine({
el: '#vcomments',
appId: '" (car (my/blog-get-valine-info)) "',
appKey: '" (cadr (my/blog-get-valine-info)) "',
visitor: true,
notify: true,
verify: false,
avatar: 'identicon',
placeholder: '留下你的评论吧～'
})
</script>

<p><span class=\"dim\">©2020</span> 戈楷旎 <span class=\"dim\">| Licensed under </span><a rel=\"license\" href=\"http://creativecommons.org/licenses/by-nc-sa/4.0/\"><img alt=\"知识共享许可协议\" style=\"border-width:0\" src=\"/static/img/license.png\"/></a></p>
<p class=\"creator\"><span class=\"dim\">Generated by</span> %c</p>\n

<!-- Google Analytics -->
<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');ga('create', 'UA-149578968-1', 'auto');ga('send', 'pageview');
</script>
<!-- End Google Analytics -->

<script>
$(document).ready(function(){
var theme = sessionStorage.getItem(\"theme\");
if(theme==\"dark\"){
document.getElementById(\"pagestyle\").href=\"/static/dark.css\";
}else if(theme==\"light\"){
document.getElementById(\"pagestyle\").href=\"/static/light.css\";
}else{
sessionStorage.setItem(\"theme\",\"light\");
}});
</script>"))))

;;--------------------------------------------------------------
(setq org-publish-project-alist
      `(("blog_page"
	 :base-extension "org"
	 :recursive nil
	 :base-directory "~/iCloud/blog_site/page/"
	 :publishing-directory "~/iCloud/blog_site/"
	 :publishing-function org-html-publish-to-html
	 :completion-function my/blog-push-to-github
	 :html-link-home "/"
	 :html-link-up "/"
	 :html-postamble t
	 :html-head ,my/html-head
	 :html-home/up-format ,my/html-home/up-format
	 :html-postamble-format ,my/org-html-postamble-of-page
	 )
	("blog_org"
	 :base-extension "org"
	 :recursive nil
	 :base-directory "~/iCloud/blog_site/org/"
	 :publishing-directory "~/iCloud/blog_site/post/"
	 :publishing-function org-html-publish-to-html
	 :preparation-function (my/blog-generate-rss-feed my/blog-generate-sitemap-xml my/blog-generate-index-org my/blog-generate-archive-org my/blog-generate-category-org)
	 :completion-function my/blog-push-to-github
	 :html-link-home "/"
	 :html-link-up "/"
	 :html-postamble t
	 :html-head ,my/html-head
	 :html-home/up-format ,my/html-home/up-format
	 :html-postamble-format ,my/org-html-postamble-of-post
	 )
	("geekblog"
	 :components ("blog_page" "blog_org"))
	))

(provide 'init-blog)
