;; My custom (and minimal) Emacs configuration.

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
; '(ansi-color-faces-vector
;   [default default default italic underline success warning error])
; '(ansi-color-names-vector
;   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(column-number-mode t)
 '(global-linum-mode t)
 '(global-visual-line-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t))

;; This package will allow you to switch between buffers with M-[Buffer Number]
;; instead of constant C-x o. You will have to install it yourself via list-packages
(require 'window-number)
(window-number-mode)
(window-number-meta-mode)

