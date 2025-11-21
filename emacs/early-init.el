;;; early-init.el --- Jacob Emacs early-init -*- lexical-binding: t; -*-

;;; Commentary:
;;; Jacob's early-init.el file

;;; Code:

;; Disable `package' in favor of `straight'
(setq package-enable-at-startup nil)

;; Increase GC threshold
(setq gc-cons-threshold 100000000)

;;; early-init.el ends here
