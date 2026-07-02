;; init.el --- Jacob Emacs init -*- lexical-binding: t; -*-

;;; Commentary:
;;;
;;; Jacob's Emacs configuration. Primary considerations:
;;;   1. Targeting Emacs in the terminal
;;;   2. Especially declarative
;;;   3. Minimal (<300 lines target for core)

;;; Code:

;; Bootstrap Straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))


;;; Package setup -----
(straight-use-package 'use-package)

(use-package straight
  :custom
  (straight-use-package-by-default t)
  (straight-current-profile 'base)
  (straight-vc-git-default-protocol 'ssh)
  :config
  (when (getenv "NIXCONFIG_DIR")
    (let ((nixdir (file-name-as-directory (getenv "NIXCONFIG_DIR"))))
	  (setq straight-profiles
            `((base . ,(file-name-concat nixdir "emacs/straight.lockfile.default.el"))
              (programming . ,(file-name-concat nixdir "emacs/straight.lockfile.programming.el")))))))

(use-package general)


;;; Basic Emacs options -----
(use-package emacs
  :init
  (setq use-short-answers t                   ; Use "y" and "n"
        scroll-conservatively 101             ; Don't jump scroll at bottom of window
        confirm-kill-emacs 'yes-or-no-p
        help-window-select t
        backup-by-copying t
        backup-directory-alist '((cons "." (file-name-concat user-emacs-directory "backup/")))
        create-lockfiles nil
        initial-scratch-message ""
        initial-major-mode 'text-mode
        ring-bell-function 'ignore            ; In GUI
        custom-safe-themes t                  ; Treat all themes as safe
        initial-buffer-choice t)              ; Open scratch buffer at startup
  :config
  (setq-default truncate-lines t
                display-line-numbers-width 3
                indent-tabs-mode nil          ; Use spaces instead of tabs
                fill-column 100
                tab-width 4)

  (auto-save-visited-mode 1)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (xterm-mouse-mode 1)
  (hl-line-mode 1)
  (fringe-mode '(8 . 8))

  (setq-default mode-line-format '(" - "
                                   (:eval (propertize (buffer-name)) 'face 'font-lock-constant-face)
                                   "%6l:%c (%o) "
                                   (:eval (unless (not vc-mode) (concat " | ⇅ " (substring-no-properties vc-mode 5))))
                                   mode-line-format-right-align
                                   (:eval (concat "  " (symbol-name major-mode)))
                                   "  " mode-line-misc-info))

  :general-config ; Keybindings unrelated to evil mode
  ("M-u" 'capitalize-word)
  ("C-x C-z" 'nil) ; Don't let C-z suspend Emacs
  ("M-=" 'count-words)
  ("M-," 'consult-outline)
  ("<escape>" 'keyboard-escape-quit)

  (:keymaps 'help-mode-map "q" 'kill-buffer-and-window
            "<escape>" 'kill-buffer-and-window))

(use-package ace-window
  :general-config
  ("M-s" 'ace-window))

;;; Saving + Recent ---------
(use-package recentf
  :hook (after-init . recentf-mode)
  :custom (recentf-max-saved-items 60))

;; Persist minibuffer history over Emacs restarts
(use-package savehist :hook (after-init . savehist-mode))


;;; Themes + Visuals ---------
(use-package modus-themes
  :defer t
  :custom (modus-themes-bold-constructs t))

(use-package doom-themes
  :custom (doom-themes-enable-bold t))

(load-theme 'doom-dark+ t)

(use-package diminish)

(use-package centered-cursor-mode
  :commands (centered-cursor-mode)
  :diminish centered-cursor-mode)

(use-package golden-ratio
  :diminish golden-ratio-mode
  :hook (after-init . golden-ratio-mode)
  :config
  (golden-ratio-toggle-widescreen)
  (dolist (command '(evil-window-down evil-window-up evil-window-left evil-window-right))
	(add-to-list 'golden-ratio-extra-commands command)))

(use-package treemacs
  :custom
  (treemacs-position 'right)
  (treemacs-project-follow-mode)
  (treemacs-width 50)
  (treemacs-show-hidden-files nil)
  :general-config
  ("M-0" 'treemacs-select-window))

(use-package treemacs-evil :after (treemacs evil))

;;; Completions -----
(use-package vertico
  :config
  (vertico-mode)
  (vertico-multiform-mode)
  :custom
  (vertico-multiform-commands ; Customize display per-command
   '((execute-extended-command flat)
     (consult-line reverse)
     (consult-recent-file reverse)
     (find-file reverse)))
  (vertico-resize t)
  (vertico-count 15))

(use-package marginalia :config (marginalia-mode))

(use-package orderless :config (setq completion-styles '(orderless basic)))

(use-package consult
  :general
  ("M-b" 'consult-buffer
   "C-s" 'consult-line)
  :config
  ;; `consult-switch-buffer' customization
  (consult-customize consult-buffer :sort t)
  (delq 'consult--source-recent-file consult-buffer-sources) ; Don't display recent files
  (add-to-list 'consult-buffer-filter "\\`\\*lsp-\.*\\'") ; Filter out lsp
  (add-to-list 'consult-buffer-filter "\\`\\*rust-analyzer\.*\\'") ; Filter out rust-analyzer
  (let ((buffers '("*Async-native-compile-log*" "*straight-process*" "*direnv*" "*Messages*"))) ; Hide these
    (dolist (buf buffers) (add-to-list 'consult-buffer-filter (regexp-quote buf)))))

(use-package corfu
  :config
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  :custom
  (corfu-auto t)
  (corfu-count 8)
  (corfu-auto-prefix 2))

(use-package corfu-terminal :hook (corfu-mode . corfu-terminal-mode))


;;; Programming Modes ------
(let ((straight-current-profile 'programming)
	  (f (expand-file-name "programming.el" user-emacs-directory)))
  (when (file-exists-p f) (load f)))

(use-package emacs
  :hook (prog-mode-hook . display-line-numbers-mode)
  :hook (prog-mode-hook . show-paren-mode))

;;; Org Mode -----------
(use-package org
  :straight (:host github :repo "bzg/org-mode"
                   :branch "main")
  :general-config
  (:keymaps 'org-mode-map
            :states 'motion
            "<TAB>" 'org-cycle)
  (:keymaps 'org-mode-map :states 'motion :prefix ","
            "c" 'org-copy-visible
            "i" 'org-cite-insert
            "p" 'org-set-property
            "t" 'org-table-create)
  :diminish visual-line-mode
  :hook (org-mode . visual-line-mode)
  :hook (org-mode . (lambda () (diminish 'org-indent-mode)))
  :custom
  (org-ellipsis "…")
  (org-startup-indented t)
  (org-cycle-separator-lines 1)
  (org-hide-emphasis-markers t))

(use-package org-roam
  :general
  (:prefix "C-c n"
           "f" 'org-roam-node-find
           "i" 'org-roam-node-insert
           "c" 'org-roam-capture)
  :config
  (org-roam-db-autosync-mode))

(use-package org-roam-ui
  :commands org-roam-ui-mode ; Command implies defer until this is run
  :diminish (org-roam-ui-mode " ORU")
  :custom (org-roam-ui-follow nil))


;;; Keybindings ------
(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode)
  (which-key-setup-minibuffer))

(use-package evil
  :general-config
  (:states '(normal motion insert)
           "C-e" 'evil-end-of-visual-line)
  (:states 'insert
           "C-a" 'evil-beginning-of-visual-line
           "C-n" 'evil-next-visual-line
           "C-e" 'evil-end-of-visual-line
           "C-p" 'evil-previous-visual-line)
  (:states 'motion
           "C-b" 'evil-scroll-up
           "C-f" nil) ; unbind from `evil-scroll-page-down'
  (:states '(normal motion)
           "gc" 'comment-dwim
           "/" '(lambda () (interactive) (split-window-horizontally) (other-window 1))
           "-" '(lambda () (interactive) (split-window-vertically) (other-window 1))
           "s" 'consult-line)
  (:states '(normal motion visual) :keymaps 'override :prefix "SPC"
           "SPC" 'find-file
           "/" 'consult-ripgrep
           "r" 'consult-recent-file
           "x" 'execute-extended-command
           "c" 'comment-line
           "l" 'treemacs
           "fd" 'consult-fd
           "bd" 'kill-buffer-and-window
           "br" 'revert-buffer-quick
           "mo" 'org-mode
           "fo" '(lambda () (interactive) (shell-command "open ."))
           "me" 'emacs-lisp-mode
           "bb" 'consult-buffer
           "bs" '(lambda () (interactive) (switch-to-buffer "*scratch*"))
           "tr" 'replace-regexp
           "wd" 'delete-window
           "wg" 'golden-ratio-mode
           "wG" 'golden-ratio-toggle-widescreen)
  (:keymaps 'evil-window-map
            (kbd "\C-q") 'evil-delete-buffer) ; Remap C-w C-q to `evil-delete-buffer'
  ;; (:keymaps 'xref--xref-buffer-mode-map
  ;;           (kbd "RET") 'xref-goto-xref)
  :init
  (setq evil-want-fine-undo t
        evil-respect-visual-line-mode t
        evil-want-keybinding nil)
  :config
  (evil-mode)
  (evil-set-initial-state 'dired-mode 'emacs))

;;; init.el ends here
