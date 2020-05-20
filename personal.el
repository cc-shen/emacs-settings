;; As suggested in the init.el
;;   any personal preferences should be elsewhere (i.e. here)

(setq system-time-locale "C")

(setq create-lockfiles nil)

(load-theme 'zenburn t)
(setq require-final-newline t)
(show-paren-mode 1)
(global-hl-line-mode 1)
(turnon-keyfreq-mode)

;; back up settings
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
  )

;; counsel-etags stuff
(eval-after-load 'counsel-etags
  '(progn
     (push "build_clang" counsel-etags-ignore-directories)
     (push "TAGS" counsel-etags-ignore-filenames)
     (push "*.json" counsel-etags-ignore-filenames)))

(setq tags-revert-without-query t)
(setq large-file-warning-threshold nil)
(add-hook 'prog-mode-hook
          (lambda ()
            (add-hook 'after-save-hook
                      'counsel-etags-virtual-update-tags 'append 'local)))

;; lsp-mode settings
(with-eval-after-load "lsp-mode"
  ;; enable log only for debug
  (setq lsp-log-io nil)
  ;; use `evil-matchit' instead
  (setq lsp-enable-folding nil)
  ;; no real time syntax check
  (setq lsp-diagnostic-package :none)
  ;; handle yasnippet by myself
  (setq lsp-enable-snippet nil)
  ;; use `company-ctags' only.
  ;; Please note `company-lsp' is automatically enabled if it's installed
  (setq lsp-enable-completion-at-point nil)
  ;; turn off for better performance
  (setq lsp-enable-symbol-highlighting nil)
  ;; use find-fine-in-project instead
  (setq lsp-enable-links nil)
  ;; auto restart lsp
  (setq lsp-restart 'auto-restart)
  ;; don't watch 3rd party javascript libraries
  (push "[/\\\\][^/\\\\]*\\.\\(json\\|html\\|jade\\)$" lsp-file-watch-ignored)
  ;; don't ping LSP lanaguage server too frequently
  (defvar lsp-on-touch-time 0)
  (defadvice lsp-on-change (around lsp-on-change-hack activate)
    ;; do run `lsp-on-change' too frequently
    (when (> (- (float-time (current-time))
                lsp-on-touch-time) 30) ;; 30 seconds
      (setq lsp-on-touch-time (float-time (current-time)))
      ad-do-it)))

;; ffip settings
(defun setup-ffip-environment ()
  (interactive)
  (require 'find-file-in-project)
  (setq-local ffip-patterns '(
                              ;; Web
                              "*.html"
                              "*.js"
                              "*.jsx"
                              "*.css"
                              "*.scss"
                              ;; Other
                              "*.java"
                              "*.py"
                              ;; Lisp Clojure
                              "*.el"
                              "*.clj"
                              ;; Config/Document files
                              "*.yaml"
                              "*.json"
                              "*.md"))
  (add-to-list 'ffip-ignore-filenames "*.egg-info")
  (add-to-list 'ffip-ignore-filenames "*._*")
  (add-to-list 'ffip-prune-patterns "*/docker-venv")
  (add-to-list 'ffip-prune-patterns "*/venv")
  (add-to-list 'ffip-prune-patterns "*/virtualrun_venv")
  (add-to-list 'ffip-prune-patterns "*/.*_playground")
  (add-to-list 'ffip-prune-patterns "*/.mypy_cache"))
(add-hook 'prog-mode-hook 'setup-ffip-environment)

(require 'mouse)
(xterm-mouse-mode t)
(defun track-mouse (e))
(setq mouse-sel-mode t)

(electric-indent-mode -1)
(workgroups-mode 1)
