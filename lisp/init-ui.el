;;emacs基础ui配置
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode t)
(set-default-font "-*-Monaco-normal-normal-normal-*-13-*-*-*-m-0-iso10646-1")
(global-hl-line-mode t);;光标行高亮
(setq inhibit-splash-screen t);取消默认启动窗口
(setq-default cursor-type 'bar);变光标, setq-default设置全局
(setq initial-frame-alist (quote ((fullscreen . maximized))));;启动最大化窗口

;;设置窗口位置为屏库左上角(0,0)
;;(set-frame-position (selected-frame) 160 70)
;;设置宽和高,我的十寸小本是110,33,大家可以调整这个参数来适应自己屏幕大小
;;(set-frame-width (selected-frame) 140)
;;(set-frame-height (selected-frame) 45)

;; (setq split-height-threshold nil)
;; (setq split-width-threshold 0)

(provide 'init-ui)
