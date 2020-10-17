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

;; lsp-mode settings
(with-eval-after-load 'lsp-mode
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
  (defun my-lsp-on-change-hack (orig-fun &rest args)
    ;; do NOT run `lsp-on-change' too frequently
    (when (> (- (float-time (current-time))
                lsp-on-touch-time) 120) ;; 2 mins
      (setq lsp-on-touch-time (float-time (current-time)))
      (apply orig-fun args)))
  (advice-add 'lsp-on-change :around #'my-lsp-on-change-hack))

;; ffip settings
(defun setup-ffip-environment ()
  (interactive)
  (require 'find-file-in-project)
  (setq ffip-patterns '(
                        ;; Web
                        "*.js"
                        "*.jsx"
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
                        "*.md"
                        "*.org"))
  (add-to-list 'ffip-ignore-filenames "*.egg-info")
  (add-to-list 'ffip-ignore-filenames "*._*")
  (add-to-list 'ffip-prune-patterns "*/docker-venv")
  (add-to-list 'ffip-prune-patterns "*/venv")
  (add-to-list 'ffip-prune-patterns "*/virtualrun_venv")
  (add-to-list 'ffip-prune-patterns "*/.*_playground")
  (add-to-list 'ffip-prune-patterns "*/.mypy_cache"))
(add-hook 'prog-mode-hook 'setup-ffip-environment)

;; Helps with easily view indented blocks
(add-hook 'prog-mode-hook 'highlight-indentation-mode)

(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] '(lambda ()
                               (interactive)
                               (scroll-down 1)))
  (global-set-key [mouse-5] '(lambda ()
                               (interactive)
                               (scroll-up 1)))
  (defun track-mouse (e))
  (setq mouse-sel-mode t))

(electric-indent-mode -1)
