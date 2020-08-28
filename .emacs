;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(case-fold-search t)
 '(column-number-mode t)
 '(current-language-environment "Latin-1")
 '(custom-enabled-themes nil)
 '(default-input-method "latin-1-prefix")
 '(global-font-lock-mode t nil (font-lock))
 '(indent-tabs-mode nil)
 '(package-selected-packages
   (quote
    (iedit helm-projectile magit helm auto-complete-c-headers yasnippet auto-complete)))
 '(query-user-mail-address nil)
 '(show-paren-mode t nil (paren))
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(user-mail-address "blah@blah.com"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(custom-themed ((((min-colors 88) (class color)) (:background "black" :foreground "white")))))
(add-to-list 'default-frame-alist
             '(font . "Monaco-16"))
(setq ring-bell-function 'ignore)

;; use gnuserv;one instance of emacs and connect to it via
;; gnuclient
(server-start)

(column-number-mode t)

(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

(set-scroll-bar-mode 'right)

(tool-bar-mode -1)

(fset 'yes-or-no-p 'y-or-n-p)

;; every buffer starts out with syntax highlighting
(global-font-lock-mode t)

;; show which function we're in for code editing
(which-func-mode t)

;; never quit without being asked
(global-set-key [(control x) (control c)]
               (function
                (lambda () (interactive)
                  (cond ((y-or-n-p "Quit editor? ")
                         (save-buffers-kill-emacs))))))

(global-set-key (kbd "<C-tab>") 'other-window)
(global-set-key [(f12)] 'other-frame)
(global-set-key [(meta f4)] 'delete-frame)
(global-set-key [(meta g)] 'goto-line)

;;F11 to switch from cpp to .h and vice versa
(global-set-key [(f11)] 'helm-projectile-find-other-file)

(delete-selection-mode 1)

(fset 'yes-or-no-p 'y-or-n-p)
;; these are set globally so they work from the compilation buffer too
(global-set-key [(f9)] 'next-error)
(global-set-key [(shift f9)] 'previous-error)
(global-set-key [(f10)] 'compile)
(global-set-key [(shift f10)] 'make-clean)
(global-set-key [(f2)] 'bookmark-jump)
(global-set-key [(f3)] 'revert-buffer)
(global-set-key [(f4)] 'read-only-mode)

(global-set-key [home] 'move-beginning-of-line)
(global-set-key [end] 'move-end-of-line)

(desktop-save-mode 1)

;; scroll by one line when moving beyond top or bottom of screen
(setq scroll-step 1
 scroll-conservatively 10000)

(add-hook 'makefile-mode-hook (lambda () (setq indent-tabs-mode t)))
(add-hook 'shell-mode-hook 'install-shell-fonts) ;;so that shell looks better
    ;; so I can type "y" or "n" instead of "yes" and "no"


;; Hooks into the various editing modes, primarily for source code
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(defun my-c-mode-common-hook ()
    (c-add-style "cau"
        '((c-basic-offset . 4)
          (c-offsets-alist . ((case-label . 4)
                              (knr-argdecl-intro . 5)
                              (substatement-open . 0))))
        t)
    (turn-on-font-lock)
	(setq indent-tabs-mode nil)
    (c-set-offset 'case-label '+)
    (setq c-tab-always-indent nil)
    (setq compile-command "make")
    (define-key c-mode-base-map [(f5)] 'document-inline)
    (define-key c-mode-base-map [(shift f5)] 'make-guard)
    (define-key c-mode-base-map [(return)] 'newline-and-indent)
    (define-key c-mode-base-map [(meta q)] 'c-indent-line-or-region))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
(add-hook 'fortran-mode-hook 'turn-on-font-lock)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
;; these are set globally so they work from the compilation buffer too
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(defun test-program ()
  "Create a new tiny program suitable for testing some C++ stuff,
and arrange for M-x compile to be ready to compile and run it"
  (interactive)
  (let* ((base-name (format "%s_test_%s" 
                            (user-login-name)
                            (format-time-string "%Y%m%d_%H%M%S")))
         (cpp-name (concat base-name ".cpp"))
         )
    (find-file (concat "~/tmp/" cpp-name))
    (insert "#include <cassert>
#include <cstdlib>
#include <iostream>
using namespace std;

// Use M-x compile to build and run me.

int main(int argc, const char **argv)
{
    cout << 1 << endl;
    return EXIT_SUCCESS;
}")
    (forward-line -2)
    (forward-char 4)
    (set-buffer-modified-p nil)
    (set (make-local-variable 'compile-command)
         (format "g++ -std=c++1y %s && ./a.out" cpp-name))))

;; use gdb-many-windows by default
(setq  gdb-many-windows t )

(require 'helm-config)
(helm-mode 1)
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(setq helm-M-x-fuzzy-match t)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x C-r") 'helm-projectile-find-file)
(global-set-key (kbd "C-x C-a") 'helm-projectile-find-file-in-known-projects)
(global-set-key (kbd "M-s o") 'helm-occur)
(global-set-key (kbd "M-s r") 'helm-projectile-grep)
(add-to-list 'projectile-globally-ignored-files "*.tsk")
(add-to-list 'projectile-globally-ignored-files "*.d")
(add-to-list 'projectile-globally-ignored-files "00*")
(add-to-list 'projectile-globally-ignored-files "*link*")
(add-to-list 'projectile-globally-ignored-files "*.log*")

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(require 'yasnippet)
(yas-global-mode 1)

(semantic-mode 1)
(defun my:add-semantic-to-autocomplete() 
  (add-to-list 'ac-sources 'ac-source-semantic)
)
(add-hook 'c-mode-common-hook 'my:add-semantic-to-autocomplete)
(global-semantic-idle-scheduler-mode 1)
(define-key global-map (kbd "C-.") 'semantic-ia-fast-jump)
(define-key global-map (kbd "<C-return>") 'semantic-ia-show-variants)

(setq-default mode-line-format
              '("%e" mode-line-front-space
                ;; Standard info about the current buffer
                mode-line-mule-info
                mode-line-client
                mode-line-modified
                mode-line-remote
                mode-line-frame-identification
                mode-line-buffer-identification " " mode-line-position
                ;; Some specific information about the current buffer:
                " "
                mode-line-misc-info
                vc-mode
                ;; And the modes, which I don't really care for anyway
                " " mode-line-modes mode-line-end-spaces))
