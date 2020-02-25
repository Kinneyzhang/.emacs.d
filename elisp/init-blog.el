;;; init-blog

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
<!-- Google Analytics -->
<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
ga('create', 'UA-149578968-1', 'auto');
ga('send', 'pageview');
</script>
<!-- End Google Analytics -->
")

(setq my/html-home/up-format
      "
<div id=\"org-div-header\">
<div class=\"toptitle\">
<span href=\"/post/index.html\">Geekinney Blog</span>
<span onclick=\"switchTheme();\">切换主题</span>
</div>
<div class=\"topnav\">
<a href=\"/index.html\">首页</a>&nbsp;|&nbsp;
<a href=\"/archive.html\">归档</a>&nbsp;|&nbsp;
<a href=\"/category.html\">分类</a>&nbsp;|&nbsp;
<a href=\"/bookmark.html\">书签</a>&nbsp;|&nbsp;
<a href=\"/friendly-link.html\">友链</a>&nbsp;|&nbsp;
<a href=\"/message.html\">留言</a>&nbsp;|&nbsp;
<a href=\"https://github.com/Kinneyzhang\">Github</a>&nbsp;
</div>
</div>")

(setq my/org-html-postamble-of-page
      '(("en"
	 "
<script src=\"/static/jQuery.min.js\"></script>
<script>var hlf=function(){Array.prototype.forEach.call(document.querySelectorAll(\"pre.src\"),function(t){var e;e=t.getAttribute(\"class\").toLowerCase(),e=e.replace(/src-(\w+)/,\"src-$1 $1\"),console.log(e),t.setAttribute(\"class\",e),hljs.highlightBlock(t)})};addEventListener(\"DOMContentLoaded\",hlf);</script>

<p class=\"author\">Author: %a (%e)</p>
<p class=\"creator\">%c</p>\n

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

function switchTheme(){
if(sessionStorage.getItem(\"flag\")==\"false\"){
document.getElementById(\"pagestyle\").href=\"/static/light.css\";
sessionStorage.setItem(\"theme\",\"light\");
sessionStorage.setItem(\"flag\", \"true\");
}else{
document.getElementById(\"pagestyle\").href=\"/static/dark.css\";
sessionStorage.setItem(\"theme\",\"dark\");
sessionStorage.setItem(\"flag\", \"false\");
}};
</script>")))

(setq my/org-html-postamble-of-post
      '(("en"
	 "
<script src=\"/static/jQuery.min.js\"></script>
<script src=\"/static/Valine.min.js\"></script>
<script>var hlf=function(){Array.prototype.forEach.call(document.querySelectorAll(\"pre.src\"),function(t){var e;e=t.getAttribute(\"class\").toLowerCase(),e=e.replace(/src-(\w+)/,\"src-$1 $1\"),console.log(e),t.setAttribute(\"class\",e),hljs.highlightBlock(t)})};addEventListener(\"DOMContentLoaded\",hlf);</script>

<div id=\"vcomments\"></div>
<script>
new Valine({
el: '#vcomments',
appId: 'jVMbXK6tJDtPCzR3Mp0V5L6V-gzGzoHsz',
appKey: 'SX4oRFXp8K7KgeGhKTTDy3VI',
visitor: true,
notify: true,
verify: false,
avatar: 'identicon',
placeholder: '留下你的评论吧～'
})
</script>
<p class=\"author\">Author: %a (%e)</p>
<p class=\"date\">Date: %d</p>
<p class=\"creator\">%c</p>\n

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

function switchTheme(){
if(sessionStorage.getItem(\"flag\")==\"false\"){
document.getElementById(\"pagestyle\").href=\"/static/light.css\";
sessionStorage.setItem(\"theme\",\"light\");
sessionStorage.setItem(\"flag\", \"true\");
}else{
document.getElementById(\"pagestyle\").href=\"/static/dark.css\";
sessionStorage.setItem(\"theme\",\"dark\");
sessionStorage.setItem(\"flag\", \"false\");
}};
</script>")))

(setq org-publish-project-alist
      `(("blog_page"
	 :base-extension "org"
	 :recursive nil
	 :base-directory "~/iCloud/blog_site/page/"
	 :publishing-directory "~/iCloud/blog_site/"
	 :publishing-function org-html-publish-to-html
	 ;; :preparation-function (my/blog-generate-sitemap-xml my/blog-generate-index-org)
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
	 :preparation-function (my/blog-generate-sitemap-xml my/blog-generate-index-org)
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

;;-------------------------------------------------------
(defun my/blog-push-to-github (&optional proj)
  (progn
    (shell-command "~/iCloud/blog_site/deploy.sh")
    (message "blog deployed successfully!")))

(defun my/org-publish-project-force (proj)
  (interactive "sEnter the project name: ")
  (org-publish proj t nil))

(defun my/org-publish-project (proj)
  (interactive "sEnter the project name: ")
  (org-publish proj nil nil))

(defun my/org-publish-current-file ()
  (interactive)
  (let ((file buffer-file-name))
    (org-publish-file file (car org-publish-project-alist))))

(defun my/blog-new-post (slug title category)
  (interactive "sinput slug: \nsinput title: \nsinput category: ")
  (let* ((blog-org-dir "~/iCloud/blog_site/org/")
	 (blog-org-file (concat blog-org-dir slug ".org"))
	 (blog-org-created-date (format-time-string "%Y-%m-%d"))
	 (blog-org-head-template (concat "#+TITLE: " title "\n#+DATE: " blog-org-created-date "\n#+CATEGORY: " category "\n#+INCLUDE: \"../code/post-info.org\"\n#+STARTUP: content\n#+OPTIONS: toc:nil H:2 num:2\n#+TOC: headlines:2\n")))
    (if (file-exists-p blog-org-file)
	(find-file blog-org-file)
      (progn
	(find-file blog-org-file)
	(insert blog-org-head-template)))))

;;--------------------------------------------------
(defvar html-parse-single-tag-list
  '("img" "br" "hr" "input" "meta" "link" "param"))

(defun my/insert-html-tag-with-attr (tag &optional attr)
  "insert a html tag and some attributes at cursor point"
  ;; (interactive "sinput tag name: \nsis single tag? [y or n]: ")
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

;; (my/org-grid-img "2" "2" "(\"hello\" \"emacs\" \"happy\" \"happy\")")
;;;==========================================================
(defvar blog-root-dir "~/iCloud/blog_site/")
(defvar blog-post-dir "~/iCloud/blog_site/org/")
(defvar blog-html-dir "~/iCloud/blog_site/post/")
(defvar blog-page-dir "~/iCloud/blog_site/page/")
(defvar blog-site-domain "https://blog.geekinney.com/")

;; generate sitemap.xml
(defun my/blog-generate-sitemap-format (posts)
  (let ((xml-str ""))
    (if (stringp posts)
	(setq posts (read posts)))
    (mapcar (lambda (post)
	      (with-temp-buffer
		(setq post-url (concat blog-site-domain (string-trim blog-html-dir blog-root-dir) (car (split-string post "\\.")) ".html"))
		(insert-file-contents (concat blog-post-dir post))
		(goto-char (point-min))
		(re-search-forward "^#\\+DATE")
		(setq date (plist-get (cadr (org-element-at-point)) :value))
		(erase-buffer)
		(my/insert-html-tag-with-attr "url")
		(my/insert-html-tag-with-attr "loc")
		(insert post-url)
		(forward-char 6)
		(my/insert-html-tag-with-attr "lastmod")
		(insert date)
		(forward-char 10)
		(my/insert-html-tag-with-attr "changefreq")
		(insert "daily")
		(forward-char 13)
		(my/insert-html-tag-with-attr "priority")
		(insert "0.8")
		(forward-char 17)
		(insert "\n")
		(setq xml-str (concat xml-str (buffer-substring-no-properties (point-min) (point-max))))
		(erase-buffer)
		))
	    posts)
    (concat "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n" xml-str "</urlset>")
    ))

(defun my/blog-generate-sitemap-xml (&optional proj)
  (interactive)
  (let ((index-page (concat blog-page-dir "index.org"))
	(sitemap-xml (concat blog-root-dir "sitemap.xml")))
    (with-temp-buffer
      (insert (my/blog-generate-sitemap-format (my/blog-posts-sorted-by-date)))
      (write-file sitemap-xml))
    (message "sitemap.xml deployed successfully!")
    ))
;;;-------------------------------------------------
;; generate index.org
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

(defun my/blog-generate-digest-html (posts)
  "generate blog digest page html"
  (let ((html-str "")
	(category-url (concat blog-site-domain "category.html")))
    (mapcar (lambda (post)
	      (with-temp-buffer
		(setq post-url (concat blog-site-domain (string-trim blog-html-dir blog-root-dir) (car (split-string post "\\.")) ".html"))
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
		      buffer-string (replace-regexp-in-string "\\([a-zA-Z0-9]\\)[ ]+\\(\\cc\\)" "" buffer-string)
		      buffer-string (replace-regexp-in-string "\\[\\[.+\\]\\[" "" buffer-string)
		      buffer-string (replace-regexp-in-string "\\]\\]" "" buffer-string))
		(dotimes (i 8) (setq buffer-string (replace-regexp-in-string "^*+" "" buffer-string)))
		(dotimes (i 8) (setq buffer-string (replace-regexp-in-string "^|-*|" "" buffer-string)))
		(dotimes (i 8) (setq buffer-string (replace-regexp-in-string "\n+" "" buffer-string)))
		(dotimes (i 10) (setq buffer-string (replace-regexp-in-string "[ ]+" "" buffer-string)))
		(setq digest (substring buffer-string 0 170))
		
		(erase-buffer)

		;;可封装，elisp解析html
		(my/insert-html-tag-with-attr "div" '(("class" "post-div")))
		(my/insert-html-tag-with-attr "h3")
		(my/insert-html-tag-with-attr "a" `(("href" ,post-url)))
		(insert title)
		(forward-char 9)
		(my/insert-html-tag-with-attr "p")
		(insert (concat digest " ...... "))
		(my/insert-html-tag-with-attr "a" `(("href" ,post-url)))
		(insert "阅读全文")
		(forward-char 8)
		(my/insert-html-tag-with-attr "code")
		(my/insert-html-tag-with-attr "a" `(("href" ,category-url)))
		(insert category)
		(forward-char 11)
		(my/insert-html-tag-with-attr "span")
		(insert date)
		(forward-char 13)
		(insert "\n\n")
		(setq html-str (concat html-str (buffer-substring-no-properties (point-min) (point-max))))
		))
	    posts)
    html-str))

(defun my/blog-generate-index-org (&optional proj)
  "generate blog index.org file"
  (interactive)
  (let* ((html-str (my/blog-generate-digest-html (my/blog-posts-sorted-by-date)))
	 (index-str (concat "#+TITLE: Geekinney Blog\n#+OPTIONS: title:nil\n#+begin_export html\n" html-str "#+end_export")))
    (with-temp-buffer
      (insert index-str)
      (write-file (concat blog-page-dir "index.org")))))

;;; --------------------------------------------------
;; generate archive.org

(provide 'init-blog)
