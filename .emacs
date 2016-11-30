(setq x-alt-keysym 'meta)
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
 '(query-user-mail-address nil)
 '(show-paren-mode t nil (paren))
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(user-mail-address "avyasape@ibm1.bloomberg.com"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(custom-themed ((((min-colors 88) (class color)) (:background "black" :foreground "white")))))

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
(global-set-key [delete] 'delete-char)

;(add-to-list 'load-path "~/.emacs.d")
(push "~/.emacs.d/blp-emacs" load-path)
(require 'blp-boiler-plate)
(require 'blp-conventions)
(require 'blp-sym)
(require 'lrl-mode)
(require 'csc-mode)
(add-to-list 'auto-mode-alist
             '("\\.lrl$" . lrl-mode))
(add-to-list 'auto-mode-alist
             '("\\.csc2$" . csc-mode))
;;F11 to switch from cpp to .h and vice versa
(global-set-key [(f11)] 'blp-go-to-other-file)

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

(desktop-save-mode 1)

;; scroll by one line when moving beyond top or bottom of screen
(setq scroll-step 1
 scroll-conservatively 10000)

(add-hook 'makefile-mode-hook (lambda () (setq indent-tabs-mode t)))
(add-hook 'shell-mode-hook 'install-shell-fonts) ;;so that shell looks better
    ;; so I can type "y" or "n" instead of "yes" and "no"


;; Hooks into the various editing modes, primarily for source code
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
and arrange for M-x compile to be ready to compile and run it
using Bloomberg's fine pcomp system."
  (interactive)
  (let* ((base-name (format "%s_test_%s" 
                            (user-login-name)
                            (format-time-string "%Y%m%d_%H%M%S")))
         (cpp-name (concat base-name ".cpp"))
         (pcomp-architecture (replace-regexp-in-string "\n$" "" (shell-command-to-string "/bb/shared/bin/bbarch")))
         (program-name (concat base-name "." pcomp-architecture ".tsk")))
    (find-file (concat "~/tmp/" cpp-name))
    (insert "#include <cassert>
#include <cstdlib>
#include <iostream>
using namespace std;
using namespace BloombergLP;
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
         (format "pcomp %s && ./%s" cpp-name program-name))))

(defun git-push ()
  (interactive)
  (shell-command "gitpush"))

(defun git-pull ()
  (interactive)
  (shell-command "git pull -p"))

;; use gdb-many-windows by default
(setq  gdb-many-windows t )

(setq package-archives '(("" . "/home/avyasape/emacs-packages/")))

(require 'package)
(package-initialize)

(require 'git)
;(require 'xcscope)

; Fix iedit bug 
(define-key global-map (kbd "C-c ;") 'iedit-mode)

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

(require 'yasnippet)
(yas-global-mode 1)

; let's define a function which initializes auto-complete-c-headers and gets called for c/c++ hooks
(defun my:ac-c-header-init ()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers)
  (add-to-list 'achead:include-directories '"/opt/swt/install/gcc-4.3.2/lib/gcc/x86_64-unknown-linux-gnu/4.3.2/include")
)
; now let's call this function from c/c++ hooks
(add-hook 'c++-mode-hook 'my:ac-c-header-init)
(add-hook 'c-mode-hook 'my:ac-c-header-init)

; turn on Semantic
(semantic-mode 1)
; let's define a function which adds semantic as a suggestion backend to auto complete
; and hook this function to c-mode-common-hook
(defun my:add-semantic-to-autocomplete() 
  (add-to-list 'ac-sources 'ac-source-semantic)
)
(add-hook 'c-mode-common-hook 'my:add-semantic-to-autocomplete)

(global-ede-mode 1)

; create a project for our program.
(ede-cpp-root-project "ldrv" :file "~/mbig/ldrv/Readme"
                      :include-path '("~/mbig/ldrv/livelib"))

; turn on automatic reparsing of open buffers in semantic
(global-semantic-idle-scheduler-mode 1)

(define-key global-map (kbd "C-.") 'semantic-ia-fast-jump)
(define-key global-map (kbd "<C-return>") 'semantic-ia-show-variants)

(add-to-list 'load-path "~/.emacs.d/helm")
(require 'helm-config)
(helm-mode 1)
(global-set-key (kbd "C-x b") 'helm-mini)
