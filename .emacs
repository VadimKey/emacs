;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(leuven))
 '(delete-trailing-lines t)
 '(display-line-numbers t)
 '(fido-mode t)
 '(global-superword-mode t)
 '(global-tab-line-mode t)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(isearch-allow-motion t)
 '(next-screen-context-lines 4)
 '(package-selected-packages '(dumb-jump helm magit whole-line-or-region))
 '(show-trailing-whitespace t)
 '(tab-line-tabs-function 'tab-line-tabs-mode-buffers)
 '(tab-width 4)
 '(visible-bell t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(tab-bar-tab ((t (:background "gray20" :foreground "cornsilk" :box (:line-width (2 . 2) :style flat-button) :weight bold :height 1.0))))
 '(tab-bar-tab-group-inactive ((t (:background "black" :foreground "black"))))
 '(tab-bar-tab-inactive ((t (:background "gray85" :foreground "gray40")))))

;; new modern way to list buffers
(global-set-key [remap list-buffers] 'ibuffer)

;; M-o to switch to next window (instead of C-x o)
(global-set-key (kbd "M-o") 'other-window)

;; imenu
(global-set-key (kbd "M-i") 'imenu)

;; S-arrow to switch to the window in this direction
(windmove-default-keybindings)

;; Helm - vk: not sure that i like it
;; (require 'helm)
;; (helm-mode 1)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(global-set-key [remap dabbrev-expand] 'hippie-expand)


;; MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; dumb-jump
(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)

(require 'whole-line-or-region)
(whole-line-or-region-global-mode 1)
