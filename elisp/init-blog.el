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
	 "
<div id=\"disqus_thread\"></div>
<script>
function loadDisqus() {
  // Disqus 安装代码
  var d = document, s = d.createElement('script');
  s.src = 'https://geekinney-blog.disqus.com/embed.js';
  s.setAttribute('data-timestamp', +new Date());
  (d.head || d.body).appendChild(s);
}

// 通过检查 window 对象确认是否在浏览器中运行
var runningOnBrowser = typeof window !== \"undefined\";
// 通过检查 scroll 事件 API 和 User-Agent 来匹配爬虫
var isBot = runningOnBrowser && !(\"onscroll\" in window) || typeof navigator !== \"undefined\" && /(gle|ing|ro|msn)bot|crawl|spider|yand|duckgo/i.test(navigator.userAgent);
// 检查当前浏览器是否支持 IntersectionObserver API
var supportsIntersectionObserver = runningOnBrowser && \"IntersectionObserver\" in window;

// 一个小 hack，将耗时任务包裹在 setTimeout(() => { }, 1) 中，可以推迟到 Event Loop 的任务队列中、等待主调用栈清空后才执行，在绝大部分浏览器中都有效
// 其实这个 hack 本来是用于优化骨架屏显示的。一些浏览器总是等 JavaScript 执行完了才开始页面渲染，导致骨架屏起不到降低 FCP 的优化效果，所以通过 hack 将耗时函数放到骨架屏渲染完成后再进行。
setTimeout(function () {
  if (!isBot && supportsIntersectionObserver) {
    // 当前环境不是爬虫、并且浏览器兼容 IntersectionObserver API
    var disqus_observer = new IntersectionObserver(function(entries) {
      // 当前视窗中已出现 Disqus 评论框所在位置
      if (entries[0].isIntersecting) {
        // 加载 Disqus
        loadDisqus();
        // 停止当前的 Observer
        disqus_observer.disconnect();
      }
    }, { threshold: [0] });
    // 设置让 Observer 观察 #disqus_thread 元素
    disqus_observer.observe(document.getElementById('disqus_thread'));
  } else {
    // 当前环境是爬虫、或当前浏览器其不兼容 IntersectionObserver API
    // 直接加载 Disqus
    loadDisqus();
  }
}, 1);
</script>

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
<div id=\"org-div-header\">
<div class=\"toptitle\">
<span href=\"/post/index.html\">Geekinney Blog</span>
</div>
<div class=\"topnav\">
<a href=\"/post/index.html\"> Home </a>&nbsp;|&nbsp;
<a href=\"/post/bookmark.html\"> 链接收藏 </a>  &nbsp;|&nbsp;
<a href=\"/post/videos-collection.html\"> 视频收藏 </a>  &nbsp;|&nbsp;
<a href=\"https://github.com/Kinneyzhang\"> Github </a>&nbsp;|&nbsp;
</div>
</div>
"
	 :html-head
	 "
<link rel=\"shortcut icon\" href=\"/static/img/favicon.ico\"/>
<link rel=\"bookmark\" href=\"/static/img/favicon.ico\" type=\"image/x-icon\"/>

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

<link rel=\"stylesheet\" type=\"text/css\" href=\"/static/ostyle.css\"/>
<link rel=\"stylesheet\" type=\"text/css\" href=\"/static/ostyle2.css\"/>

<script src=\"https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.10.0/highlight.min.js\"></script>
<script>var hlf=function(){Array.prototype.forEach.call(document.querySelectorAll(\"pre.src\"),function(t){var e;e=t.getAttribute(\"class\").toLowerCase(),e=e.replace(/src-(\w+)/,\"src-$1 $1\"),console.log(e),t.setAttribute(\"class\",e),hljs.highlightBlock(t)})};addEventListener(\"DOMContentLoaded\",hlf);</script>
"
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
