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
(setq org-html-postamble t)
(setq org-html-postamble-format
      '(("en" "<p class=\"author\">Author: %a (%e)</p>
<p class=\"date\">Date: %d</p>
<p class=\"creator\">%c</p>\n")))

(setq org-html-creator-string
      "<a href=\"https://www.gnu.org/software/emacs/\">Emacs</a> 26.3 (<a href=\"https://orgmode.org\">Org</a> mode 9.1.9)")

(setq org-publish-project-alist
      '(("geekblog"
	 :base-extension "org"
	 :recursive nil
	 :base-directory "~/iCloud/blog_site/org/"
	 :publishing-directory "~/iCloud/blog_site/html/"
	 :publishing-function org-html-publish-to-html
	 :html-head
	 "<link rel=\"stylesheet\" type=\"text/css\" href=\"https://blog.geekinney.com/static/ostyle.css\"/>
<link rel=\"stylesheet\" type=\"text/css\" href=\"https://blog.geekinney.com/static/ostyle2.css\"/>
<script src=\"https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.10.0/highlight.min.js\"></script>
<script>var hlf=function(){Array.prototype.forEach.call(document.querySelectorAll(\"pre.src\"),function(t){var e;e=t.getAttribute(\"class\").toLowerCase(),e=e.replace(/src-(\w+)/,\"src-$1 $1\"),console.log(e),t.setAttribute(\"class\",e),hljs.highlightBlock(t)})};addEventListener(\"DOMContentLoaded\",hlf);</script>
<link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.10.0/styles/googlecode.min.css\"/>"
	 ;; :with-toc t
	 ;; :headline-levels 4
	 ;; :table-of-contents nil
	 ;; :section-numbers nil
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
	 "<link rel=\"stylesheet\" type=\"text/css\" href=\"https://blog.geekinney.com/static/ostyle.css\"/>
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

(provide 'init-blog)
