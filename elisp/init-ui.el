;;; includes some basic settings, theme, modeline, neotree and some ui library.
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(fringe-mode 0)

(setq display-time-default-load-average t)
(display-time-mode -1)

;;光标行高亮
(global-hl-line-mode 1)

(when (featurep 'ns)
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . light)))

(setq hi-lock-file-patterns-policy #'(lambda (dummy) t)) ;;加载高亮模式
(setq initial-frame-alist (quote ((fullscreen . maximized)))) ;;启动最大化窗
(setq-default cursor-type '(bar . 4)) ;变光标, setq-default设置全局

;; theme
(use-package material-theme
  :ensure t)
(load-theme 'material t)

;; Fonts
(defun font-installed-p (font-name)
  "Check if font with FONT-NAME is available."
  (find-font (font-spec :name font-name)))

(when (display-graphic-p)
  ;; Set default font
  (cl-loop for font in '("Consolas")
           when (font-installed-p font)
           return (set-face-attribute 'default nil
                                      :font font
                                      :height (cond ((eq system-type 'darwin) 130)
                                                    ((eq system-type 'windows-nt) 110)
                                                    (t 100))))
  ;; Specify font for all unicode characters
  (cl-loop for font in '("Symbola" "Symbol")
           when (font-installed-p font)
           return (set-fontset-font t 'unicode font nil 'append))
  ;; Specify font for Chinese characters
  (cl-loop for font in '("仿宋" "微软雅黑")
           when (font-installed-p font)
           return (dolist (charset '(kana han hangul cjk-misc bopomofo))
                    (set-fontset-font t charset font))))

;; (set-fontset-font t '(#x4e00 . #x9fff) font)
;; (when window-system
;;   (cl-loop for font in '("Microsoft Yahei" "PingFang SC" "Noto Sans Mono CJK SC")
;;            when (font-installed-p font)
;;            return (dolist (charset '(kana han hangul cjk-misc bopomofo))
;;                     (set-fontset-font t charset font)))
;;   (cl-loop for font in '("Segoe UI Emoji" "Apple Color Emoji" "Noto Color Emoji")
;;            when (font-installed-p font)
;;            return (set-fontset-font t 'unicode font nil 'append))
;;   (dolist (font '("HanaMinA" "HanaMinB"))
;;     (when (font-installed-p font)
;;       (set-fontset-font t 'unicode font nil 'append))))

;; 设置中文标点
;; (set-fontset-font t 'cjk-misc "微软雅黑")
;; (dolist (character '(?\x25C9 ?\x25CB ?\x2738 ?\x273F ?\xA1F3))
;;   (set-fontset-font nil character (font-spec :family "微软雅黑")))

(set-fontset-font t 'cjk-misc "Noto Sans CJK SC Regular")
;; (message "%s"(font-family-list))

;; @purcell
(defun sanityinc/adjust-opacity (frame incr)
  "Adjust the background opacity of FRAME by increment INCR."
  (unless (display-graphic-p frame)
    (error "Cannot adjust opacity of this frame"))
  (let* ((oldalpha (or (frame-parameter frame 'alpha) 100))
         (oldalpha (if (listp oldalpha) (car oldalpha) oldalpha))
         (newalpha (+ incr oldalpha)))
    (when (and (<= frame-alpha-lower-limit newalpha) (>= 100 newalpha))
      (modify-frame-parameters frame (list (cons 'alpha newalpha))))))

(global-set-key (kbd "M-C-8") (lambda () (interactive) (sanityinc/adjust-opacity nil -2)))
(global-set-key (kbd "M-C-9") (lambda () (interactive) (sanityinc/adjust-opacity nil 2)))
(global-set-key (kbd "M-C-7") (lambda () (interactive) (modify-frame-parameters nil `((alpha . 100)))))
;;==================================================

(use-package powerline
  :ensure t
  :config
  (powerline-default-theme))

(use-package spaceline
  :ensure t
  :config
  (spaceline-spacemacs-theme))

;; colorful dired-mode
(use-package diredfl
  :ensure t
  :config (diredfl-global-mode t))

(provide 'init-ui)
