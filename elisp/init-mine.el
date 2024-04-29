(defun mind-wave-new-file-and-chat ()
  (interactive)
  (let* ((dir (expand-file-name "mind-wave" user-emacs-directory))
         (file (expand-file-name "1.chat" dir))
         (buf (find-file-noselect file)))
    (switch-to-buffer buf)
    (mind-wave-chat-ask)))
(global-set-key "\C-c\C-j" 'mind-wave-new-file-and-chat)

(use-package color-rg
  :load-path "~/.emacs.d/site-lisp/color-rg")

(eval-when-compile
  (require 'cl-lib)) ;;; 整个文件 byte compile 就行了，没有必要显式调用 `byte-compile`
(add-hook 'post-gc-hook ;; post gc hook 內容要小，以防极端情况产生 dead loop
          (let ((--gcs-done -1))
            (lambda ()
              (when (/= --gcs-done gcs-done)
                (redraw-frame)
                (setq --gcs-done gcs-done)))))

(defun PREFIX/runtime-info-string ()
  (format-spec "%N GC (%ts total): %M VM, %hh runtime"
               `((?N . ,(format "%d%s"
                                gcs-done
                                (pcase (mod gcs-done 10)
                                  (1 "st")
                                  (2 "nd")
                                  (3 "rd")
                                  (_ "th"))))
                 (?t . ,(round gc-elapsed))
                 (?M . ,(cl-loop for memory = (memory-limit) then (/ memory 1024.0)
                                 for mem-unit across "KMGT"
                                 when (< memory 1024)
                                 return (format "%.1f%c"
                                                memory
                                                mem-unit)))
                 (?h . ,(format "%.1f"
                                (/ (time-to-seconds (time-since before-init-time))
                                   3600.0))))))

(setq frame-title-format '("" default-directory "  "
                           (:eval (PREFIX/runtime-info-string))))

;; 不需要显式调用 gc 或 redraw-frame。

;;;;; set and map in elisp

(defun set-make ()
  (make-hash-table :test 'equal))
(defun set-empty-p (set)
  (hash-table-empty-p set))
(defun set-count (set)
  (hash-table-count set))
(defun set-add (set el)
  (puthash el t set))
(defun set-member (set el)
  (gethash el set nil))
(defun set-list (set)
  (hash-table-keys set))
(defun set-remove (set el)
  (remhash el set))

(defun map-make ()
  (make-hash-table))
(defun map-empty-p (map)
  (hash-table-empty-p map))
(defun map-count (map)
  (hash-table-count map))
(defun map-set (map key value)
  (puthash key value map))
(defun map-get (map key)
  (gethash key map nil))
(defun map-remove (map key)
  (remhash key map))
(defun map-list (map)
  (cl-mapcan #'list (hash-table-keys map)
             (hash-table-values map)))

(provide 'init-mine)
