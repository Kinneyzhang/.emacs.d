;;; init-blog

;; https://gongzhitaao.org/orgcss/org.css

;; org html export
(setq org-html-htmlize-output-type "inline-css") ;; 导出时不加行间样式！
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
(setq org-html-preamble t)
(setq org-html-postamble t)
(setq org-html-postamble-format
      '((
	 "en"
	 "<div id=\"disqus_thread\"></div>
<script>
(function() { // DON'T EDIT BELOW THIS LINE
var d = document, s = d.createElement('script');
s.src = 'https://geekinney-blog.disqus.com/embed.js';
s.setAttribute('data-timestamp', +new Date());
(d.head || d.body).appendChild(s);
})();
</script>
<noscript>Please enable JavaScript to view the <a href=\"https://disqus.com/?ref_noscript\">comments powered by Disqus.</a></noscript>

<p class=\"author\">Author: %a (%e)</p>
<p class=\"date\">Date: %d</p>
<p class=\"creator\">%c</p>\n")))

(setq org-html-creator-string
      "<a href=\"https://www.gnu.org/software/emacs/\">Emacs</a> 26.3 (<a href=\"https://orgmode.org\">Org</a> mode 9.1.9)")

(setq org-publish-project-alist
      '(("geekblog"
	 :base-extension "org"
	 :recursive nil
	 :base-directory "~/iCloud/blog_site/org/"
	 :publishing-directory "~/iCloud/blog_site/post/"
	 :publishing-function org-html-publish-to-html
	 :html-home/up-format "
<div id=\"org-div-home-and-up2\">
<a accesskey=\"H\" href=\"/post/index.html\"> Home </a>&nbsp;|&nbsp;
<a accesskey=\"a\" href=\"/post/bookmark.html\"> 链接收藏 </a>  &nbsp;|&nbsp;
<a accesskey=\"a\" href=\"/post/videos-collection.html\"> 视频收藏 </a>  &nbsp;|&nbsp;
<a accesskey=\"p\" href=\"https://github.com/Kinneyzhang\"> Github </a>&nbsp;|&nbsp;
</div>
"
	 :html-head
	 "<!-- Google Analytics -->
<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-149578968-1', 'auto');
ga('send', 'pageview');
</script>
<!-- End Google Analytics -->

<link rel=\"stylesheet\" type=\"text/css\" href=\"https://blog.geekinney.com/static/ostyle.css\"/>
<link rel=\"stylesheet\" type=\"text/css\" href=\"https://blog.geekinney.com/static/ostyle2.css\"/>
<script src=\"https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.10.0/highlight.min.js\"></script>
<script>var hlf=function(){Array.prototype.forEach.call(document.querySelectorAll(\"pre.src\"),function(t){var e;e=t.getAttribute(\"class\").toLowerCase(),e=e.replace(/src-(\w+)/,\"src-$1 $1\"),console.log(e),t.setAttribute(\"class\",e),hljs.highlightBlock(t)})};addEventListener(\"DOMContentLoaded\",hlf);</script>
<link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.10.0/styles/googlecode.min.css\"/>"
	 :html-link-home "/"
	 :html-link-up "/" 
	 :auto-preamble t
	 :auto-sitemap nil
	 :html-extension "html"
	 :body-only nil
	 )
	
	("org-wiki"
	 :base-extension "org"
	 :recursive nil
	 :base-directory "~/iCloud/wiki/"
	 :publishing-directory "~/iCloud/wiki_site/"
	 :publishing-function org-html-publish-to-html
	 :html-head
	 "<!-- Google Analytics -->
<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-149578968-1', 'auto');
ga('send', 'pageview');
</script>
<!-- End Google Analytics -->

<link rel=\"stylesheet\" type=\"text/css\" href=\"https://blog.geekinney.com/static/ostyle.css\"/>
<link rel=\"stylesheet\" type=\"text/css\" href=\"https://blog.geekinney.com/static/ostyle2.css\"/>
<script src=\"https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.10.0/highlight.min.js\"></script>
<script>var hlf=function(){Array.prototype.forEach.call(document.querySelectorAll(\"pre.src\"),function(t){var e;e=t.getAttribute(\"class\").toLowerCase(),e=e.replace(/src-(\w+)/,\"src-$1 $1\"),console.log(e),t.setAttribute(\"class\",e),hljs.highlightBlock(t)})};addEventListener(\"DOMContentLoaded\",hlf);</script>
<link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.10.0/styles/googlecode.min.css\"/>"
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

(defun capture-blog-post-file ()
  (let* ((title (read-string "Slug: "))
         (slug (replace-regexp-in-string "[^a-z]+" "-" (downcase title))))
    (expand-file-name
     (format "~/Library/Mobile Documents/com~apple~CloudDocs/blog_site/post/%s.org"
             (format-time-string "%Y" (current-time))
             slug))))

(add-to-list 'org-capture-templates
             '("b" "Blog Post" plain
               (file (capture-blog-post-file))
	       (file "~/iCloud/blog_site/code/template.org")))

(provide 'init-blog)
