;; As suggested in the init.el
;;   any personal preferences should be elsewhere (i.e. here)

(setq system-time-locale "C")

(setq create-lockfiles nil)

(load-theme 'monokai t)
(setq require-final-newline t)
(show-paren-mode 1)
(global-hl-line-mode 1)
(turnon-keyfreq-mode)

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

(workgroups-mode 1)
