;;; ~/.doom.d/+mail.el -*- lexical-binding: t; -*-

(after! mu4e
  (setq mu4e-sent-messages-behavior 'delete)
  (setq mail-user-agent 'mu4e-user-agent)
  (setq message-kill-buffer-on-exit t)
  (setq +email-backend 'offlineimap)
  (setq mu4e-maildir (expand-file-name "~/Maildir"))
  (setq smtpmail-auth-credentials (expand-file-name "~/.authinfo.gpg"))
  (setq mu4e-attachment-dir (expand-file-name "~/Maildir/Attachments"))
  ;; disable auto-save for email: since I have set
  ;; auto-save-visited-file-name, auto-save seems to leave multiple copies of
  ;; a message in the drafts folder. this is not nice.
  (add-hook 'mu4e-compose-mode-hook #'(lambda () (auto-save-mode -1)))
  (remove-hook 'mu4e-compose-mode-hook 'org-mu4e-compose-org-mode)
  (set-email-account! "newrelic"
                      '((mu4e-sent-folder       . "/treina@newrelic.com/sent")
                        (mu4e-drafts-folder     . "/treina@newrelic.com/drafts")
                        (mu4e-trash-folder      . "/treina@newrelic.com/trash")
                        (mu4e-refile-folder     . "/treina@newrelic.com/archive")
                        (mu4e-maildir-shortcuts . (("/treina@newrelic.com/INBOX" . ?i)))
                        (smtpmail-smtp-user     . "treinaperez@newrelic.com")
                        (smtpmail-smtp-server   . "smtp.gmail.com")
                        (smtpmail-smtp-service  . 587)
                        (user-full-name         . "Toni Reina")
                        (user-mail-address      . "treina@newrelic.com")
                        (mu4e-compose-signature . "Toni Reina"))
                      t))

(provide '+mail)
