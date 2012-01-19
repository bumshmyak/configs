;; my settings
(menu-bar-mode 1) ;; place 0 here when become guru
(setq warning-suppress-types nil)
(global-set-key "\C-x\C-m" 'compile)
(column-number-mode 1)
(setq compilation-auto-jump-to-first-error t)
(tool-bar-mode -1)
(server-start)

;; make emacs start maximized
(defun toggle-fullscreen ()
  (interactive)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
)
(toggle-fullscreen)

;; cedit settings
(load-file "~/src/configs/emacs/cedet/common/cedet.el")

(global-ede-mode t)

(semantic-load-enable-excessive-code-helpers)

;; smart complitions
(require 'semantic-ia)

;; gcc setup
(require 'semantic-gcc)

(defun my-semantic-hook ()
  (imenu-add-to-menubar "TAGS"))
(add-hook 'semantic-init-hooks 'my-semantic-hook)

(ede-cpp-root-project "Toolbox"
                :name "Toolbox Project"
                :file "~/src/toolbox/config.mak"
                :include-path '("/include"))

(defun my-cedet-hook ()
  (local-set-key [(control return)] 'semantic-ia-complete-symbol)
  (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
  (local-set-key "." 'semantic-complete-self-insert)
  (local-set-key ">" 'semantic-complete-self-insert)
  (local-set-key "\C-]" 'semantic-ia-fast-jump))
(add-hook 'c-mode-common-hook 'my-cedet-hook)

;; org-mode settings
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(setq org-log-done 'time)
(setq org-log-done 'note)

(setq org-startup-indented 1)
(require 'org-latex)


;; google c++ style
(load-file "~/src/configs/emacs/google-c-style.el")
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

;; cc mode
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(require 'cl)

(defun file-in-directory-list-p (file dirlist)
  "Returns true if the file specified is contained within one of
the directories in the list. The directories must also exist."
  (let ((dirs (mapcar 'expand-file-name dirlist))
        (filedir (expand-file-name (file-name-directory file))))
    (and
     (file-directory-p filedir)
     (member-if (lambda (x) ; Check directory prefix matches
                  (string-match (substring x 0 (min(length filedir) (length x))) filedir))
                dirs))))

(defun buffer-standard-include-p ()
  "Returns true if the current buffer is contained within one of
the directories in the INCLUDE environment variable."
  (and (getenv "INCLUDE")
       (file-in-directory-list-p buffer-file-name (split-string (getenv "INCLUDE") path-separator))))

(add-to-list 'magic-fallback-mode-alist '(buffer-standard-include-p . c++-mode))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(gdb-many-windows t)
 '(gdb-show-main t)
 '(gdb-use-separate-io-buffer t)
 '(tab-width 2))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;;; Python customization
;;; bind RET to py-newline-and-indent
(add-hook 'python-mode-hook '(lambda () 
     (define-key python-mode-map "\C-m" 'newline-and-indent)))

