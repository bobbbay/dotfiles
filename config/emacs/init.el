(require 'use-package)
(require 'use-package-ensure)
(setq use-package-always-ensure t) ;; Ensure that all packages are installed before use-package'ing

;; The best scrollbar is no scrollbar
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

(set-frame-font "Iosevka Extralight" nil t)

;; Keep those autosaves somewhere else
;; TODO: Automatically mkdir /tmp/emacs-saves if not already created.
(setq backup-by-copying t
      backup-directory-alist '(("." . "/tmp/emacs-saves/"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)
(setq auto-save-file-name-transforms
  `((".*" "/tmp/emacs-saves/" t)))

;; Nord
(load-theme 'nord t)

;; Embrace evil
(use-package evil
  :config
  (evil-mode))

;; Fancy projects
(use-package projectile
  :config
  (projectile-mode))

;; nyanyanyanyanyan
(use-package nyan-mode
  :init
  (setq nyan-animate-nyancat 't) ;; Keep the cat moving
  :config
  (nyan-mode))

(use-package org
  :init
  (setq org-agenda-files (list "~/org/personal.org"
                               "~/org/school.org"))
  :config
  (define-key global-map "\C-cl" 'org-store-link)
  (define-key global-map "\C-ca" 'org-agenda))

(use-package multi-vterm
  :config
  (define-key global-map "\C-c\C-v" 'vterm))

(use-package lsp-mode
  :commands lsp
  :custom
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  :hook
  ((
    nix-mode
    rustic-mode
    haskell-mode
    ) . lsp)
  )

(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  :init
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
  (setq dashboard-banner-logo-title "Welcome to Emacs, Bob!")
  (setq dashboard-center-content t)
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-items '((recents  . 10)
                          (bookmarks . 5)
                          (projects . 5)
                          (agenda . 10)
                          (registers . 5))))

(use-package projectile
  :init
  (projectile-mode)
  :bind (:map projectile-mode-map
	  ("s-p" . projectile-command-map)
          ("C-c p" . projectile-command-map)))

(use-package restart-emacs
  :bind ("C-c C-f" . restart-emacs))

(use-package free-keys
  :commands free-keys)

(use-package ledger-mode
  :commands ledger-mode
  :init
  (setq ledger-clear-whole-transactions 1)
  :config
  (add-to-list 'evil-emacs-state-modes 'ledger-report-mode)
  :mode "\\.dat\\'")
