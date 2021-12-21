;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Dov Alperin"
      user-mail-address "dzalperin@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dark+)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

(setq lsp-clients-clangd-args '("-j=3"
                                "--background-index"
                                "--clang-tidy"
                                "--completion-style=detailed"
                                "--header-insertion=never"
                                "--header-insertion-decorators=0"))

(after! lsp-clangd (set-lsp-priority! 'clangd 2))

;;https://github.com/hlissner/doom-emacs/issues/5904
(after! lsp-mode
  (advice-remove #'lsp #'+lsp-dont-prompt-to-install-servers-maybe-a))

(after! org-mode
  (setq org-agenda-timegrid-use-ampm 1))

(defun send-C-space ()
  (interactive)
  (vterm-send "C-SPC"))

(map! :after vterm
      :map vterm-mode-map
      :ni "C-SPC" #'send-C-space)

(add-hook 'org-mode-hook
        (setq org-default-notes-file
                (expand-file-name +org-capture-notes-file org-directory)
                +org-capture-journal-file
                (expand-file-name +org-capture-journal-file org-directory)
                org-capture-templates
                '(("t" "Personal todo" entry
                (file+headline +org-capture-todo-file "Inbox")
                "* [ ] %?\n%i" :prepend t)
                ("n" "Personal notes" entry
                (file+headline +org-capture-notes-file "Inbox")
                "* %u %?\n%i" :prepend t)
                ("j" "Journal" entry
                (file+olp+datetree +org-capture-journal-file)
                "* %U %?\n%i" :prepend t)

                ("c" "Context aware templates")
                ("ct" "Context-aware todo" entry
                (file+headline +org-capture-todo-file "Inbox")
                "* TODO %?\n%i\n%a" :prepend t)
                ("cn" "Context-aware personal notes" entry
                (file+headline +org-capture-notes-file "Inbox")
                "* %U %?\n%i\n%a" :prepend t)
                ("cj" "Context-aware journal" entry
                (file+olp+datetree +org-capture-journal-file)
                "* %U %?\n%i\n%a" :prepend t)
                ;; Will use {project-root}/{todo,notes,changelog}.org, unless a
                ;; {todo,notes,changelog}.org file is found in a parent directory.
                ;; Uses the basename from `+org-capture-todo-file',
                ;; `+org-capture-changelog-file' and `+org-capture-notes-file'.
                ("p" "Templates for projects")
                ("pt" "Project-local todo" entry  ; {project-root}/todo.org
                (file+headline +org-capture-project-todo-file "Inbox")
                "* TODO %?\n%i\n%a" :prepend t)
                ("pn" "Project-local notes" entry  ; {project-root}/notes.org
                (file+headline +org-capture-project-notes-file "Inbox")
                "* %U %?\n%i\n%a" :prepend t)
                ("pc" "Project-local changelog" entry  ; {project-root}/changelog.org
                (file+headline +org-capture-project-changelog-file "Unreleased")
                "* %U %?\n%i\n%a" :prepend t)

                ;; Will use {org-directory}/{+org-capture-projects-file} and store
                ;; these under {ProjectName}/{Tasks,Notes,Changelog} headings. They
                ;; support `:parents' to specify what headings to put them under, e.g.
                ;; :parents ("Projects")
                ("o" "Centralized templates for projects")
                ("ot" "Project todo" entry
                (function +org-capture-central-project-todo-file)
                "* TODO %?\n %i\n %a"
                :heading "Tasks"
                :prepend nil)
                ("on" "Project notes" entry
                (function +org-capture-central-project-notes-file)
                "* %U %?\n %i\n %a"
                :heading "Notes"
                :prepend t)
                ("oc" "Project changelog" entry
                (function +org-capture-central-project-changelog-file)
                "* %U %?\n %i\n %a"
                :heading "Changelog"
                :prepend t))))

(after! drag-stuff
  (define-key evil-normal-state-map (kbd "M-k") 'drag-stuff-up)
  (define-key evil-normal-state-map (kbd "M-j") 'drag-stuff-down)
  (define-key evil-visual-state-map (kbd "M-k") 'drag-stuff-up)
  (define-key evil-visual-state-map (kbd "M-j") 'drag-stuff-down))

(setq real-config-directory "/etc/nixos/modules/emacs/doom.d/")

(defun doom/open-private-config ()
"Browse your `doom-private-dir'."
(interactive)
(doom-project-browse real-config-directory))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' you when load with packages
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
