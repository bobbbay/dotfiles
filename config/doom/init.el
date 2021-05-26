(doom! :input
       :completion
       company           ; the ultimate code completion backend
       ivy               ; a search engine for love and life

       :ui

       doom              ; what makes DOOM look the way it does
       doom-dashboard    ; a nifty splash screen for Emacs
       doom-quit         ; DOOM quit-message prompts when you quit Emacs
       (emoji +unicode)  ; 🙂
       hl-todo           ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       indent-guides     ; highlighted indent columns
       ligatures         ; ligatures and symbols to make your code pretty again

       modeline          ; snazzy, Atom-inspired modeline, plus API
       ophints           ; highlight the region an operation acts on
       (popup +defaults) ; tame sudden yet inevitable temporary windows
       treemacs          ; a project drawer, like neotree but cooler
       unicode           ; extended unicode support for various languages
       vc-gutter         ; vcs diff in the fringe

       vi-tilde-fringe   ; fringe tildes to mark beyond EOB

       workspaces        ; tab emulation, persistence & separate workspaces
       zen               ; distraction-free coding or writing

       :editor
       (evil +everywhere); come to the dark side, we have cookies
       file-templates    ; auto-snippets for empty files

       fold              ; (nigh) universal code folding
       (format +onsave)  ; automated prettiness

       multiple-cursors  ; editing in many places at once

       snippets          ; my elves. They type so I don't have to
       word-wrap         ; soft wrapping with language-aware indent

       :emacs
       dired             ; making dired pretty [functional]
       electric          ; smarter, keyword-based electric-indent
       undo              ; persistent, smarter undo for your inevitable mistakes
       vc                ; version-control and Emacs, sitting in a tree

       :term
       vterm             ; the best terminal emulation in Emacs

       :checkers

       syntax            ; tasing you for every semicolon you forget
       (spell +flyspell) ; tasing you for misspelling mispelling
       grammar           ; tasing grammar mistake every you make

       :tools
       debugger          ; FIXME stepping through code, to help you add bugs
       (eval +overlay)   ; run code, run (also, repls)
       lookup            ; navigate your code and its documentation

       magit             ; a git porcelain for Emacs

       make              ; run make tasks from Emacs
       pdf               ; pdf enhancements
       rgb               ; creating color strings

       :os
       (:if IS-MAC macos)  ; improve compatibility with macOS

       :lang

       cc                ; C/C++/Obj-C madness

       (dart +flutter)   ; paint ui and not much else
       emacs-lisp        ; drown in parentheses

       (haskell +dante)  ; a language that's lazier than I am
       idris             ; a language you can depend on

       json              ; At least it ain't XML
       (java +meghanada) ; the poster child for carpal tunnel syndrome
       javascript        ; all(hope(abandon(ye(who(enter(here))))))

       lua               ; one-based indices? one-based indices
       markdown          ; writing docs for people to ignore
       nix               ; I hereby declare "nix geht mehr!"
       ;; ocaml             ; an objective camel
       org               ; organize your plain life in plain text

       python            ; beautiful is better than ugly
       rust              ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
       sh                ; she sells {ba,z,fi}sh shells on the C xor

       ;;yaml              ; JSON, but readable

       :config
       (default +bindings +smartparens))
