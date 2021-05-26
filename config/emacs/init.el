(evil-mode 1)
(server-start)

(set-frame-font "Iosevka Extralight" nil t)

(setq org-agenda-files (list "~/org/personal.org"
                             "~/org/school.org"))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)

