(defun offlineimap-get-password (host port)
  (require 'netrc)
  (let* ((netrc (netrc-parse (expand-file-name "~/.authinfo.gpg")))
         (hostentry (netrc-machine netrc host port port)))
    (when hostentry (netrc-get hostentry "password"))))

(require 'mu4e)                      ; load mu4e
;; Use mu4e as default mail agent
(setq mail-user-agent 'mu4e-user-agent)
;; Mail folder set to ~/Maildir
(setq mu4e-maildir "~/Maildir")         ; NOTE: should not be symbolic link
;; Fetch mail by offlineimap
(setq mu4e-get-mail-command "offlineimap")
;; Fetch mail in 60 sec interval
(setq mu4e-update-interval 60)

;; folder for sent messages
(setq mu4e-sent-folder   "/Gmail/Sent")
;; unfinished messages
(setq mu4e-drafts-folder "/Gmail/Drafts")
;; trashed messages
(setq mu4e-trash-folder  "/Gmail/Trash")
;; saved messages
(setq mu4e-trash-folder  "/Gmail/Archive")
;; attachment save dir
(setq mu4e-attachment-dir "~/Documents/Mu4e")

(require 'mu4e-contrib)
(setq mu4e-html2text-command 'mu4e-shr2text)
;; try to emulate some of the eww key-bindings
(add-hook 'mu4e-view-mode-hook
          (lambda ()
            (local-set-key (kbd "<tab>") 'shr-next-link)
            (local-set-key (kbd "<backtab>") 'shr-previous-link)))

(setq mu4e-view-show-images t)

;; SMTP setup
(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-stream-type 'starttls
      starttls-use-gnutls t)
;; Personal info
(setq user-full-name "KinneyZhang")          ; FIXME: add your info here
(setq user-mail-address "kinneyzhang666@gmail.com"); FIXME: add your info here
;; gmail setup
(setq smtpmail-smtp-server "smtp.gmail.com")
(setq smtpmail-smtp-service 587)
(setq smtpmail-smtp-user "kinneyzhang666@gmail.com") ; FIXME: add your gmail addr here

(setq mu4e-compose-signature "Sent from emacs.")


(use-package mu4e-maildirs-extension
  :ensure t
  :config (mu4e-maildirs-extension))

(use-package mu4e-alert
  :ensure t
  :init
  (setq mu4e-alert-email-notification-types '(count))
  (setq mu4e-alert-interesting-mail-query
	(concat
	 "flag:unread"
	 " AND NOT flag:trashed"
	 " AND NOT maildir:"
	 "\"/[Gmail].All Mail\""))
  :config
  (mu4e-alert-set-default-style 'libnotify)
  (alert-add-rule :category "mu4e-alert" :style 'fringe :predicate (lambda (_) (string-match-p "^mu4e-" (symbol-name major-mode))) :continue t)
  (mu4e-alert-enable-notifications)
  (add-hook 'after-init-hook #'mu4e-alert-enable-notifications)
  (add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display)
  )

(provide 'init-mu4e)
