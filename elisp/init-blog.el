;;; init-blog

;; https://gongzhitaao.org/orgcss/org.css

;; org html export
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


(setq user-full-name "Kinney Zhang")
(setq user-mail-address "kinneyzhang666@gmail.com")
(setq org-export-with-author t)
(setq org-export-with-email t)
(setq org-export-with-date t)
(setq org-export-with-creator t)
(setq org-html-preamble nil)
(setq org-html-postamble t)

(setq org-html-creator-string
      "<a href=\"https://www.gnu.org/software/emacs/\">Emacs</a> 26.3 (<a href=\"https://orgmode.org\">Org</a> mode 9.1.9)")

(setq org-html-postamble-format
      '((
	 "en"
	 "
<script src=\"/static/jQuery.min.js\"></script>
<script src=\"/static/Valine.min.js\"></script>
<script src=\"/static/highlight.min.js\"></script>
<script>var hlf=function(){Array.prototype.forEach.call(document.querySelectorAll(\"pre.src\"),function(t){var e;e=t.getAttribute(\"class\").toLowerCase(),e=e.replace(/src-(\w+)/,\"src-$1 $1\"),console.log(e),t.setAttribute(\"class\",e),hljs.highlightBlock(t)})};addEventListener(\"DOMContentLoaded\",hlf);</script>

<div id=\"vcomments\"></div>
<script>
new Valine({
el: '#vcomments',
appId: 'jVMbXK6tJDtPCzR3Mp0V5L6V-gzGzoHsz',
appKey: 'SX4oRFXp8K7KgeGhKTTDy3VI',
notify:false,
verify:false,
avatar:'identicon',
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
      '(("geekblog"
	 :base-extension "org"
	 :recursive nil
	 :base-directory "~/iCloud/blog_site/org/"
	 :publishing-directory "~/iCloud/blog_site/post/"
	 :publishing-function org-html-publish-to-html
	 :html-head
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
"
	 :html-home/up-format
	 "
<div id=\"org-div-header\">
<div class=\"toptitle\">
<span href=\"/post/index.html\">Geekinney Blog</span>
<span onclick=\"switchTheme();\">切换主题</span>
</div>
<div class=\"topnav\">
<a href=\"/post/index.html\">首页</a>&nbsp;|&nbsp;
<a href=\"/post/archive.html\">归档</a>&nbsp;|&nbsp;
<a href=\"/post/category.html\">分类</a>&nbsp;|&nbsp;
<a href=\"/post/friendly-link.html\">友链</a>&nbsp;|&nbsp;
<a href=\"https://github.com/Kinneyzhang\">Github</a>&nbsp;
</div>
</div>"
	 :sitemap-file-entry-format "%d ====> %t"
	 :sitemap-sort-files anti-chronologically
	 :sitemap-filename "sitemap.org"
	 :sitemap-title nil
	 :auto-sitemap t
	 
	 :html-link-home "/"
	 :html-link-up "/"
	 :html-extension "html"
	 :body-only nil
	 )

	;; ("geekblog_rss"
	;;  :base-directory "~/iCloud/blog_site/org/"
	;;  :base-extension "org"
	;;  :rss-image-url "https://blog.geekinney.com/static/img/rss.png"
	;;  :html-link-home "https://blog.geekinney.com"
	;;  :html-link-use-abs-url t
	;;  :rss-extension "xml"
	;;  :publishing-directory "~/iCloud/blog_site/"
	;;  :publishing-function (org-rss-publish-to-rss)
	;;  :section-numbers nil
	;;  :exclude "index.org"            ;; To exclude all files...
	;;  :include (".*")   ;; ... except index.org.
	;;  :table-of-contents nil)
	
	;; ("org-journal"
	;;  :base-extension "org"
	;;  :recursive nil
	;;  :base-directory "~/iCloud/blog_site/journal/"
	;;  :publishing-directory "~/iCloud/blog_site/post/"
	;;  :publishing-function org-html-publish-to-html
	;;  :html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"/static/journal.css\"/>"
	
	;;  :auto-preamble nil
	;;  :auto-postamble nil
	;;  :auto-sitemap nil
	;;  :html-extension "html"
	;;  :body-only nil
	;;  )
	
	("org-wiki"
	 :base-extension "org"
	 :recursive nil
	 :base-directory "~/iCloud/wiki/"
	 :publishing-directory "~/iCloud/wiki_site/"
	 :publishing-function org-html-publish-to-htmld
	 ;; :with-toc nil
	 ;; :headline-levels 4
	 ;; :table-of-contents nil
	 ;; :section-numbers nil
	 :auto-preamble t
	 :auto-sitemap nil
	 :html-extension "html"
	 :body-only nil
	 )
	))

(defun my/org-publish-project-force (proj)
  (interactive "sEnter the project name: ")
  (org-publish proj t nil)
  )
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

;; (my/blog-generate-index '("elisp-hack-video-compress-and-convert-format.org"))
(defun my/blog-generate-index (posts)
  "generate blog index page"
  (interactive)
  (let ((post-dir "~/iCloud/blog_site/org/")
	(category-url "https://blog.geekinney.com/post/category.html")
	(html-str ""))
    (if (stringp posts)
	(setq posts (read posts)))
    (mapcar (lambda (post)
	      (with-temp-buffer
		(setq post-url (concat "https://blog.geekinney.com/post/" (car (split-string post "\\.")) ".html"))
		(insert-file-contents (concat post-dir post))
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
		(setq buffer-string (replace-regexp-in-string "^#\\+.+\n+" "" (buffer-substring-no-properties (point-min) (point-max))))
		(setq buffer-string (replace-regexp-in-string ".*\\* " "" buffer-string))
		(setq buffer-string (replace-regexp-in-string ".*\\*.+\\*" "" buffer-string))
		(setq buffer-string (replace-regexp-in-string ".*\\*\\* " "" buffer-string))
		(setq buffer-string (replace-regexp-in-string ".*\\*\\*\\* " "" buffer-string))
		(setq buffer-string (replace-regexp-in-string "^\n+" "" buffer-string))
		(setq buffer-string (replace-regexp-in-string "^\n+" "" buffer-string))
		(setq buffer-string (replace-regexp-in-string "^\n+" "" buffer-string))
		(setq buffer-string (replace-regexp-in-string "^\n+" "" buffer-string))
		(setq buffer-string (replace-regexp-in-string "^\n+" "" buffer-string))
		(setq digest (substring buffer-string 0 170))
		;; (setq posts-str (concat posts-str "*" title "*" "\n\n" digest "...\\\\" "\n" "=" category "=" "\t\t\t" date "\n-----\n"))
		
		(erase-buffer)

		;; (insert "#+begin_export html\n\n#+end_export")
		;; (backward-char 13)
		
		(my/insert-html-tag-with-attr "div" '(("class" "post-div")))
		(my/insert-html-tag-with-attr "h3")
		(my/insert-html-tag-with-attr "a" (list (list "href" post-url)))
		(insert title)
		(forward-char 9)
		(my/insert-html-tag-with-attr "p")
		(insert (concat digest " ...... "))
		(my/insert-html-tag-with-attr "a" (list (list "href" post-url)))
		(insert "阅读全文")
		(forward-char 8)
		(my/insert-html-tag-with-attr "code")
		(my/insert-html-tag-with-attr "a" (list (list "href" category-url)))
		(insert category)
		(forward-char 11)
		(my/insert-html-tag-with-attr "span")
		(insert date)
		(forward-char 13)
		(insert "\n\n")
		(setq html-str (concat html-str (buffer-substring-no-properties (point-min) (point-max))))
		))
	    posts)
    (concat "#+begin_export html\n" html-str "#+end_export")))

(provide 'init-blog)
