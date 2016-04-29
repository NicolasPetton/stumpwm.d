(in-package :stumpwm)

;; use xfontsel to select the font
;; (set-font "Deja Vu Sans Mono:style=Regular:size=12:antialias=true")
(set-font "Fira Mono:style=Regular:size=11:antialias=true")
(set-font "-*-Fira-Mono-*-r-*-*-*-120-100-*-*-*-*-*")
(set-fg-color "#61afef")
(set-bg-color "#21252b")
(set-border-color "#21252b")
(set-win-bg-color "#21252b")
(set-focus-color "#61afef")
(set-unfocus-color "#21252b")
(setf *maxsize-border-width* 1)
(setf *transient-border-width* 1)
(setf *normal-border-width* 1)
(set-msg-border-width 10)
(setf *window-border-style* :thin)

(setf *message-window-gravity* :top)
(setf *input-window-gravity* :top)
(setf *message-window-padding* 14)
(setf *mouse-follows-focus* t)

(setf *mode-line-background-color* "#38394c")
(setf *mode-line-foreground-color* "#61afef")
(setf *mode-line-border-color* "#28394c")

(set-maxsize-gravity :center)
(set-transient-gravity :top)

(run-shell-command "xsetroot -display :0 -solid '#282c34'")
