;;; init-blog
;;;===================================================================================
(require 'print-html)
(require 'print-xml)
;;; auto generate blog's sitemap.xml, post-info, index.org, archive.org, category.org.
(defvar blog-root-dir "~/iCloud/blog_site/")
(defvar blog-post-dir "~/iCloud/blog_site/org/")
(defvar blog-html-dir "~/iCloud/blog_site/post/")
(defvar blog-page-dir "~/iCloud/blog_site/page/")
(defvar blog-site-domain "https://blog.geekinney.com/")
(defvar blog-site-name "戈楷旎")
(defvar blog-site-description "happy hacking emacs!")
(defvar blog-author "Kinney Zhang")
(defvar blog-author-email "kinneyzhang666@gmail.com")
(defvar blog-language "zh-cn")
(defvar blog-generator "Emacs OrgMode 9.1.9")
(defvar blog-icon "https://blog.geekinney.com/static/img/favicon.ico")

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

(defun geekblog--get-post-meta (meta post)
  "get meta info of a post"
  (with-temp-buffer
    (insert-file-contents (concat blog-post-dir post))
    (re-search-forward (concat "^#\\+" (upcase meta)))
    (if (string= "count" meta)
	(setq count (my/word-count))
      (setq meta (plist-get (cadr (org-element-at-point)) :value)))))

;;;-----------------------------------------------------------
(defun geekblog--post-info-format (url count title date category)
  "get post info html"
  (print-html
   `(div :class "post-info"
	 (p "「"
	    (span "分类: " ,category " · ")
	    (span "字数: " ,(number-to-string count) " · ")
	    (span :id ,url
		  :class "leancloud_visitors"
		  :data-flag-title ,title
		  (span :class "post-meta-item-text" "阅读 ")
		  (span :class "leancloud-visitors-count" "...")
		  " 次")
	    "」"))))

(defun geekblog/generate-post-info ()
  "generate post info for each post"
  (let ((post buffer-file-name)
	(html-str ""))
    (progn
      (setq valine-visitor-url (concat "/" (string-trim blog-html-dir blog-root-dir) (file-name-base post) ".html"))
      (setq count (geekblog--get-post-meta "count" post))
      (setq title (geekblog--get-post-meta "title" post))
      (setq date (geekblog--get-post-meta "date" post))
      (setq category (geekblog--get-post-meta "category" post))
      (setq html-str (geekblog--post-info-format valine-visitor-url count title date category)))
    html-str))
;;;--------------------------------------------------
(defun geekblog--sitemap-format-part (url date)
  (print-html
   `(url (loc ,url)
	 (lastmod ,date)
	 (changefreq "daily")
	 (priority "0.8"))))

(defun geekblog--sitemap-format (posts)
  "get blog sitemap.xml"
  (let ((xml-str ""))
    (if (stringp posts)
	(setq posts (read posts)))
    (dolist (post posts)
      (progn
	(setq url (concat blog-site-domain (string-trim blog-html-dir blog-root-dir) (car (split-string post "\\.")) ".html"))
	(setq date (geekblog/get-post-meta "date" post))
	(setq xml-str (concat xml-str (geekblog--sitemap-format-part url date)))))
    (concat "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n" xml-str "</urlset>")))

(defun geekblog/generate-sitemap (&optional proj)
  (interactive)
  (let ((xml (concat blog-root-dir "sitemap.xml")))
    (with-temp-buffer
      (insert (geekblog--sitemap-format (my/blog-posts-sorted-by-date)))
      (write-file xml))
    (message "sitemap.xml deployed successfully!")))
;;;-------------------------------------------------
(defun geekblog--rss-format-part (title url digest date)
  (print-html
   `(item (title ,title)
	  (link ,url)
	  (description ,digest)
	  (author ,blog-author)
	  (pubDate ,date))))

(defun geekblog--rss-format-all (xml-str)
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
				,xml-str))))))

(defun geekblog--get-post-digest (post pos)
  ;; (setq buffer-string (replace-regexp-in-string "^#\\+.+\n+" "" (buffer-substring-no-properties (point-min) (point-max)))
  ;; 	buffer-string (replace-regexp-in-string "\\([a-zA-Z0-9]\\)[ ]+\\(\\cc\\)" "" buffer-string)
  ;; 	buffer-string (replace-regexp-in-string "\\[\\[.+\\]\\[" "" buffer-string)
  ;; 	buffer-string (replace-regexp-in-string "\\]\\]" "" buffer-string)
  ;; 	buffer-string (replace-regexp-in-string "\\*+" "" buffer-string)
  ;; 	buffer-string (replace-regexp-in-string "|-*" "" buffer-string)
  ;; 	buffer-string (replace-regexp-in-string "\n+" "" buffer-string)
  ;; 	buffer-string (replace-regexp-in-string " =" "" buffer-string)
  ;; 	buffer-string (replace-regexp-in-string "= " "" buffer-string))
  ;; (setq digest (concat (substring buffer-string 0 100) " ......"))
  )

(defun geekblog--rss-format (posts)
  (let ((xml-str ""))
    (if (stringp posts)
	(setq posts (read posts)))
    (dolist (post posts)
      (with-temp-buffer
	(setq url (concat blog-site-domain (string-trim blog-html-dir blog-root-dir) (car (split-string post "\\.")) ".html"))
	(setq title (geekblog--get-post-meta "title" post))
	(setq date (geekblog--get-post-meta "date" post))
	(setq digest (geekblog--get-post-digest post 100))
	(setq xml-str (concat xml-str (geekblog--rss-format-part title url digest date)))))
    (geekblog--rss-format-all xml-str)))

(defun geekblog/generate-rss (&optional proj)
  (interactive)
  (let ((rss (concat blog-root-dir "feed.xml")))
    (with-temp-buffer
      (insert (geekblog--rss-format (geekblog--get-all-posts)))
      (write-file rss))
    (message "feed.xml deployed successfully!")
    ))
;;;-------------------------------------------------
(defun list-car-string-less (list1 list2)
  "compare the car of list1 to list2, which is a string"
  (if (string< (car list1) (car list2))
      (eq t t)
    (eq t nil)))

(defun geekblog--get-all-posts ()
  "make all posts a list by date"
  (interactive)
  (let ((posts (cdr (cdr (directory-files blog-post-dir))))
	(date-post-list)
	(post-list))
    (dolist (post posts)
      (setq date (geekblog--get-post-meta "date" post))
      (setq date-post-pair `(,date ,post))
      (setq date-post-list (cons date-post-pair date-post-list)))
    (setq date-post-list-sorted (sort date-post-list 'list-car-string-less))
    (dolist (item date-post-list-sorted)
      (setq post-list (cons (cadr item) post-list)))
    post-list))
;;;--------------------------------------------------
(defun geekblog--index-format
    (post-url title digest category-url category count date)
  (print-html
   `(div :id "post-div"
	 (h2 (a :href ,post-url ,title))
	 (p ,digest " ......" (a :href ,post-url "「阅读全文」"))
	 (p (code (a :href ,category-url ,category))
	    (span :id "post-div-meta"
		  (span ,(number-to-string count) "字 · ")
		  (span :class "post-date" ,date))))))

(defun geekblog--index-html (posts)
  (let ((html-str "")
	(category-url (concat blog-site-domain "category.html")))
    (dolist (post posts)
      (setq post-url (concat blog-site-domain (string-trim blog-html-dir blog-root-dir) (car (split-string post "\\.")) ".html"))
      (setq valine-visitor-url (concat "/" (string-trim blog-html-dir blog-root-dir) (file-name-base post) ".html"))
      (setq count (geekblog--get-post-meta "count" post))
      (setq title (geekblog--get-post-meta "title" post))
      (setq date (geekblog--get-post-meta "date" post))
      (setq category (geekblog--get-post-meta "category" post))
      (setq digest (geekblog--get-post-digest post 170))
      (setq html-str (concat html-str (geekblog--index-format post-url title digest category-url category count date))))
    (concat "#+TITLE: Geekinney Blog\n#+OPTIONS: title:nil\n#+begin_export html\n" html-str "#+end_export")))

(defun geekblog/generate-index-page (&optional proj)
  (interactive)
  (let ((index (concat blog-page-dir "index.org")))
    (with-temp-buffer
      (insert (geekblog--index-html (geekblog--get-all-posts)))
      (write-file index))
    (message "index.org deployed successfully!")))
;;;--------------------------------------------------------
(defun geekblog--archive-format (posts)
  (let ((archive-year-str "")
	(archive-year-str-with-year "")
	(year-list nil)
	(year-and-archive-single-str-list nil))
    (dolist (post posts)
      (setq url (concat blog-site-domain (string-trim blog-html-dir blog-root-dir) (car (split-string post "\\.")) ".html"))
      (setq title (geekblog--get-post-meta "title" post))
      (setq date (geekblog--get-post-meta "date" post))
      (setq year (substring date 0 4))
      (setq month-and-day (concat (substring date 5 7) (substring date 8 10)))
      (setq archive-single-str (concat " * " month-and-day " [[" url "][" title "]]"))
      (setq year-and-archive-single-str-list (cons `(,year ,archive-single-str) year-and-archive-single-str-list))
      ;; (("2020" " * 0222 [[url][title]]") ("2020" " * 0221 [[url][title]]") ... ("2019" " * 1231 [[url][title]]"))
      (setq year-list (cons year year-list)))
    (setq year-and-archive-single-str-list (reverse year-and-archive-single-str-list))
    (setq year-list (reverse year-list))
    (setq years (delete-dups year-list))
    (dolist (year years)
      (dolist (elem year-and-archive-single-str-list)
	(if (string= year (car elem))
	    (setq archive-year-str (concat archive-year-str (cadr elem) "\n"))))
      (setq archive-year-str-with-year (concat archive-year-str-with-year "* " year "\n" archive-year-str))
      (setq archive-year-str ""))
    (concat "#+TITLE: 文章归档\n#+STARTUP: showall\n#+OPTIONS: toc:nil H:1 num:0 title:nil\n" archive-year-str-with-year)))

(defun geekblog/generate-archive-page (&optional proj)
  (interactive)
  (let ((archive (concat blog-page-dir "archive.org")))
    (with-temp-buffer
      (insert (geekblog--archive-format (geekblog--get-all-posts)))
      (write-file archive))
    (message "archive.org deployed successfully!")))
;;;---------------------------------------------------------
(defun geekblog--category-format (posts)
  "generate blog's category.org string"
  (interactive)
  (let ((one-category-str "")
	(category-str-with-category "")
	(category-and-category-single-str-list)
	(category-list))
    (dolist (post posts)
      (setq url (concat blog-site-domain (string-trim blog-html-dir blog-root-dir) (car (split-string post "\\.")) ".html"))
      (setq title (geekblog--get-post-meta "title" post))
      (setq category (geekblog--get-post-meta "category" post))
      (setq category-single-str (concat " * [[" url "][" title "]]"))
      (setq category-and-category-single-str-list (cons `(,category ,category-single-str) category-and-category-single-str-list))
      (setq category-list (cons category category-list)))
    (setq category-list (sort category-list 'string<))
    (setq categories (delete-dups category-list))
    (dolist (category categories)
      (dolist (elem category-and-category-single-str-list)
	(if (string= category (car elem))
	    (setq one-category-str (concat one-category-str (cadr elem) "\n"))))
      (setq category-str-with-category (concat category-str-with-category "* " category "\n" one-category-str))
      (setq one-category-str ""))
    (concat "#+TITLE: 标签分类\n#+STARTUP: showall\n#+OPTIONS: toc:nil H:1 num:0 title:nil\n" category-str-with-category)))

(defun geekblog/generate-category-page (&optional proj)
  (interactive)
  (let ((category (concat blog-page-dir "category.org")))
    (with-temp-buffer
      (insert (geekblog--category-format (geekblog--get-all-posts)))
      (write-file archive))
    (message "category.org deployed successfully!")))
;;;------------------------------------------------------------------
(defun geekinney/push-to-github (&optional proj)
  (progn
    (shell-command "~/iCloud/blog_site/deploy.sh")
    (message "blog deployed successfully!")))

(defun geekinney/publish-project-force (proj)
  (interactive "sEnter the project name: ")
  (org-publish proj t nil))

(defun geekinney/new-post (slug title category)
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
;;;-------------------------------------------------------
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
<!-- Google Analytics -->
<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');ga('create', 'UA-149578968-1', 'auto');ga('send', 'pageview');
</script>
<!-- End Google Analytics -->
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
<span id=\"switch-theme\" onclick=\"switchTheme();\">暗色</span>
</div>
</div>")

(setq my/org-html-postamble-of-page
      '(("en"
	 "
<script src=\"/static/jQuery.min.js\"></script>

<p><span class=\"dim\">©2020</span> 戈楷旎 <span class=\"dim\">| Licensed under </span><a rel=\"license\" href=\"http://creativecommons.org/licenses/by-nc-sa/4.0/\"><img alt=\"知识共享许可协议\" style=\"border-width:0\" src=\"/static/img/license.png\"/></a></p>
<p class=\"creator\"><span class=\"dim\">Generated by</span> %c</p>\n

<script>
$(document).ready(function(){
var theme = sessionStorage.getItem(\"theme\");
if(theme==\"dark\"){
document.getElementById(\"pagestyle\").href=\"/static/dark.css\";
document.getElementById(\"switch-theme\").innerHTML = \"亮色\";
}else if(theme==\"light\"){
document.getElementById(\"pagestyle\").href=\"/static/light.css\";
document.getElementById(\"switch-theme\").innerHTML = \"暗色\";
}else{
sessionStorage.setItem(\"theme\",\"light\");
}});

function switchTheme(){
if(sessionStorage.getItem(\"flag\")==\"false\"){
document.getElementById(\"pagestyle\").href=\"/static/light.css\";
document.getElementById(\"switch-theme\").innerHTML = \"暗色\";
sessionStorage.setItem(\"theme\",\"light\");
sessionStorage.setItem(\"flag\", \"true\");
}else{
document.getElementById(\"pagestyle\").href=\"/static/dark.css\";
document.getElementById(\"switch-theme\").innerHTML = \"亮色\";
sessionStorage.setItem(\"theme\",\"dark\");
sessionStorage.setItem(\"flag\", \"false\");
}};
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

<script>
$(document).ready(function(){
var theme = sessionStorage.getItem(\"theme\");
if(theme==\"dark\"){
document.getElementById(\"pagestyle\").href=\"/static/dark.css\";
document.getElementById(\"switch-theme\").innerHTML = \"亮色\";
}else if(theme==\"light\"){
document.getElementById(\"pagestyle\").href=\"/static/light.css\";
document.getElementById(\"switch-theme\").innerHTML = \"暗色\";
}else{
sessionStorage.setItem(\"theme\",\"light\");
}});

function switchTheme(){
if(sessionStorage.getItem(\"flag\")==\"false\"){
document.getElementById(\"pagestyle\").href=\"/static/light.css\";
document.getElementById(\"switch-theme\").innerHTML = \"暗色\";
sessionStorage.setItem(\"theme\",\"light\");
sessionStorage.setItem(\"flag\", \"true\");
}else{
document.getElementById(\"pagestyle\").href=\"/static/dark.css\";
document.getElementById(\"switch-theme\").innerHTML = \"亮色\";
sessionStorage.setItem(\"theme\",\"dark\");
sessionStorage.setItem(\"flag\", \"false\");
}};
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
	 :preparation-function (my/blog-generate-sitemap-xml my/blog-generate-index-org my/blog-generate-archive-org my/blog-generate-category-org)
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
