;;; programming.el --- Jacob Emacs programming -*- lexical-binding: t; -*-

;;; Commentary:
;;; Jacob's Emacs package configuration for packages that relate to programming modes,
;;; not core to Emacs functionality.

;;; Code:

;;; Programming language modes -----
(use-package nix-mode :defer t)

(use-package dhall-mode :defer t)

(use-package haskell-mode :defer t)

(use-package rustic :defer t)

;;; Utilites -----
(use-package direnv
  :hook (after-init . direnv-mode)
  :custom
  (direnv-always-show-summary nil))

;;; Language Server Protocol ------
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :diminish (auto-revert-mode)
  :general-config
  (:keymaps 'lsp-mode-map
            "C-c C-d" 'lsp-describe-thing-at-point)
  (:keymaps 'lsp-mode-map :states 'motion :prefix ","
            "F" 'lsp-format-region
            "f" 'lsp-format-buffer
            "r" 'lsp-workspace-restart
            "d" 'lsp-describe-thing-at-point
            "c" 'lsp-find-definition
            "x" 'lsp-execute-code-action)
  :init
  ;; still trying to understand / update this but for now it works
  (defun my/lsp-mode-setup-completion ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(flex)))
  (lsp-modeline-code-actions-mode nil) ; Don't show code actions on modeline

  :hook (lsp-completion-mode . my/lsp-mode-setup-completion)
  :custom
  (lsp-enable-snippet nil)
  (lsp-completion-provider :none)
  ;; (completion-category-overrides '((lsp-capf (styles flex)))) ; WIP
  :config
  (setq read-process-output-max (* 1024 1024)))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-enable nil))

(use-package lsp-haskell
  :diminish (interactive-haskell-mode)
  :hook (haskell-mode . lsp-deferred) ; `lsp-deferred' to allow direnv to kick in
  :custom
  (lsp-haskell-server-path "haskell-language-server")
  (lsp-haskell-formatting-provider "fourmolu")
  (lsp-haskell-plugin-stan-global-on nil))

(use-package lsp-pyright
  :hook (python-mode . lsp-deferred)
  :custom
  (lsp-pyright-langserver-command "basedpyright"))

(use-package git-gutter
  :diminish git-gutter-mode 
  :hook (prog-mode . git-gutter-mode))

(use-package flycheck
  :hook (flycheck-mode . flycheck-set-indication-mode)
  :config
  (setq-default flycheck-indication-mode 'right-margin))

(use-package eldoc :diminish eldoc-mode) ; Diminish this default package

;;; programming.el ends here
