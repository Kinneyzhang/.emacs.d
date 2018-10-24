;;按键设置

;;config for evil-leader
(evil-leader/set-key
  ;;文件操作
  "ff" 'find-file
  "fr" 'sr-speedbar-open
  "fe" 'sr-speedbar-close

  ;;窗口操作
  "bb" 'switch-to-buffer
  "1"  'select-window-1
  "2"  'select-window-2
  "3"  'select-window-3
  "4"  'select-window-4
  "w/" 'split-window-right
  "w-" 'split-window-below
  "wd" 'delete-window
  "wj" 'other-window
  "ww" 'delete-other-windows

  ;;打开配置文件
  "em" 'open-my-packages-manage-file
  "ep" 'open-my-init-packages-file
  "ei" 'open-my-init-file
  "eb" 'open-my-init-better-defaults-file
  "ec" 'open-my-init-custom-file
  "ek" 'open-my-init-keybindings-file
  "eo" 'open-my-init-org-file
  "eu" 'open-my-init-ui-file

  ;;org-mode相关按键
  "<SPC>"  'counsel-M-x
  "cc"  'org-capture
  "aa" 'org-agenda
  "as" 'org-agenda-schedule
  "ad" 'org-agenda-deadline
  "az" 'org-agenda-add-note
  
  "osi" 'org-insert-src-block
  "ose" 'org-edit-src-code
  "oo" 'org-open-at-point
  
  "ee" 'eval-last-sexp
  "q" 'save-buffers-kill-terminal
  "pf" 'counsel-git
  "t" 'shell-pop
  "/" 'evilnc-comment-or-uncomment-lines
  "d" 'dired
  "j" 'goto-line
  "hk" 'describe-key
  "hv" 'counsel-describe-variable
  "hf" 'counsel-describe-function

  "ss" 'save-buffer
  "sw" 'swiper
  "snc" 'aya-create
  "sne" 'aya-expand
  "snp" 'aya-persist-snippet

  "cg" 'customize-group
  
  "v" 'er/expand-region
  )

(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-h f") 'counsel-describe-function)
(global-set-key (kbd "C-h v") 'counsel-describe-variable)

(global-set-key (kbd "C-h C-f") 'find-function)
(global-set-key (kbd "C-h C-v") 'find-variable)
(global-set-key (kbd "C-h C-k") 'find-fuction-on-key)

(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(global-set-key (kbd "<f1>") 'open-my-init-file)
(global-set-key (kbd "<f2>") 'open-my-packages-file)

;;(global-set-key (kbd "C-c p f") 'counsel-git);;从默认git仓库中查找文件

(global-set-key (kbd "C-c a") 'org-agenda)

;; 设置C->键作为窗口之间的切换，默认的是C-x-o,比较麻烦 
(global-set-key (kbd "C-.") 'other-window)

;; 把C-j绑定到到达指定行上 
(global-set-key (kbd "C-j") 'goto-line)

;;设置M-/作为标志位，默认C-@来setmark,C-@不太好用 
;;M-/本来对应zap-to-char，这里占用了
(global-set-key (kbd "M-/") 'set-mark-command)

(global-set-key (kbd "C-M-\\") 'indent-region-or-buffer);;代码缩进

(global-set-key (kbd "s-/") 'hippie-expand);;补全功能

;; 延迟加载
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file))

;;切换web-mode下默认tab空格数
(global-set-key (kbd "C-c t i") 'my-toggle-web-indent)

;;标记后智能选中区域
(global-set-key (kbd "C-=") 'er/expand-region)

(global-set-key (kbd "M-p") 'my-org-screenshot)


(provide 'init-keybindings)
