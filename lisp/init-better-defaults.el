;;全局默认设置

(setq ring-bell-function 'ignore);;消除滑动到底部或顶部时的声音

(global-auto-revert-mode t);;自动加载更新内容

(setq make-backup-files nil);;不允许备份
(setq auto-save-default nil);;不允许自动保存

(setq-default abbrev-mode t)
(define-abbrev-table 'global-abbrev-table '(
					    ("8ki" "kinney")
					    
					    ))

;;(setq truncate-lines nil)
;;(setq visual-line-mode t)


;;打开最近文件
(recentf-mode 1)
(setq recentf-max-menu-items 25)

(add-hook 'prog-mode-hook 'linum-mode);显示行号
(delete-selection-mode t);;双击单词可以选中替换
(add-hook 'emacs-lisp-mode-hook 'show-paren-mode);;括号匹配

;;让 Emacs 可以直接打开和显示图片。 
(setq auto-image-file-mode t)

;;防止页面滚动时跳动， 
;;scroll-margin 3 可以在靠近屏幕边沿3行时就开始滚动 
;;scroll-step 1 设置为每次翻滚一行，可以使页面更连续 
(setq scroll-step 1 scroll-margin 3 scroll-conservatively 10000)

;;代码全部缩进
(defun indent-buffer()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun indent-region-or-buffer()
  (interactive)
  (save-excursion
    (if (region-active-p)
	(progn
	  (indent-region (region-beginning) (region-end))
	  (message "Indent selected region."))
      (progn
	(indent-buffer)
	(message "Indent buffer.")))))

;;更强的代码补全功能
(setq hippie-expand-try-function-list '(try-expand-debbrev
					try-expand-debbrev-all-buffers
					try-expand-debbrev-from-kill
					try-complete-file-name-partially
					try-complete-file-name
					try-expand-all-abbrevs
					try-expand-list
					try-expand-line
					try-complete-lisp-symbol-partially
					try-complete-lisp-symbol))

;;用y/s 代替yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;;全部递归拷贝删除文件夹中的文件
(setq dired-recursive-deletes 'always)
(setq dired-recursive-copies 'always)

;;避免每一级目录都产生一个buffer
(put 'dired-find-alternate-file 'disabled nil)

(require 'dired-x)
(setq dired-dwim-target t)

;;config for occur-mode,自动确定光标位置单词为搜索词
(defun occur-dwim ()
  "Call `occur' with a sane default."
  (interactive)
  (push (if (region-active-p)
	    (buffer-substring-no-properties
	     (region-beginning)
	     (region-end))
	  (let ((sym (thing-at-point 'symbol)))
	    (when (stringp sym)
	      (regexp-quote sym))))
	regexp-history)
  (call-interactively 'occur))
(global-set-key (kbd "M-s o") 'occur-dwim)

(setq browse-url-browser-function 'browse-url-default-macosx-browser)
(global-set-key (kbd "M-s M-s") 'browse-url-default-macosx-browser)

								      
(provide 'init-better-defaults)
