;;; -*- lexical-binding: t -*-

;;; Little help
;; Use 'xref-find-definitions' [M-.] to find sources of functions
;; Use 'describe-function' bound to [C-h f]
;; Use M-: for 'eval-expression'

;;;
;;; links.txt - various Emacs related online resources
;;;
;;
;; *** Written Guides ***
;;
;; 1) Mastering Emacs - https://www.masteringemacs.org/ – Not
;; C++-specific, but teaches you how Emacs works under the hood
;; (editing, buffers, minibuffer, keybindings). Very helpful before
;; diving into IDE features.
;;
;;    1.1 Package management: Learn straight.el or use-package.
;;
;; 2) LSP Mode Manual -- https://emacs-lsp.github.io/lsp-mode/ –
;; Explains how Language Server Protocol integration works in
;; Emacs. This is the backbone of “IDE-like” features (autocomplete,
;; jump to definition, refactoring).
;;
;; 3) DAP Mode Docs -- https://emacs-lsp.github.io/dap-mode/
;;    – For debugging with GDB/LLDB (like CLion/VSCode).
;;
;; 4) Emacs as a C++ IDE (nilsdeppe.github.io) - https://nilsdeppe.com/posts/emacs-c++-ide
;;    – A clean walkthrough of setting up lsp-mode, clangd, company, and debugging.
;;
;; 5) Emacs Wiki: C++ Development Environment - https://www.emacswiki.org/emacs/SiteMap
;;    – Older, but gives context and lists common tools.
;;
;;
;; *** Videos ***
;;
;; 1) System Crafters (YouTube) -- https://www.youtube.com/@SystemCrafters/playlists
;;    Playlist: Building Your Emacs Configuration
;;    Not C++-specific, but excellent to learn how to gradually build a modern IDE-like config.
;;
;; 2) Protesilaos Stavrou (YouTube) -- https://www.youtube.com/@protesilaos/playlists
;;    Deep dives into Emacs packages like eglot, corfu, vertico. Very clear explanations.
;;
;; 3) emacsrocks.com (short videos) -- https://emacsrocks.com/
;;    Fun, quick showcases of Emacs power (a bit dated but inspiring).
;;
;; 4) Emacs as a C++ IDE (YouTube, Derek Taylor / DistroTube)
;;    Practical demo of lsp-mode + clangd for C++.
;;
;; 	     https://www.youtube.com/@DistroTube/playlists
;; 	     https://www.youtube.com/watch?v=5FQwQ0QWBTU
;; 	     https://www.youtube.com/watch?v=qW7sw7pd_6s
;;
;; *** Configurations to Learn From ***
;;
;; Doom Emacs – a prebuilt distribution with C++ IDE support out of
;; the box. Good to explore if you want everything working fast, then
;; pick apart the config to learn.
;; https://github.com/doomemacs/doomemacs


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
 '(text-mode-hook '(turn-on-auto-fill))
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
(put 'narrow-to-region 'disabled nil)


;;; Key binding for 'occur'
; I use occur a lot, so let's bind it to a key:
(keymap-global-set "C-c o" 'occur)


;;; Line to top of window.
;;; replace three keystroke sequence C-u 0 C-l
(defun line-to-top-of-window ()
  "Move the line that point is on to top of window."
  (interactive)
  (recenter 0))

(keymap-global-set "<f6>" 'line-to-top-of-window)
