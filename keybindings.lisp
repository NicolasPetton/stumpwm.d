(in-package :stumpwm)
(load-user-module "utils")
(load-user-module "multimedia")

(set-prefix-key (kbd "C-t"))

;; focus follow mouse
;; (setf *mouse-focus-policy* :sloppy)
(setf *mouse-focus-policy* :click)


(defapp "firefox")
(defapp "devtools")
(defapp "skype")
(defapp "slack")

(defcommand popup-xterm () ()
  "popup a new xterm window."
  (popup)
  (without-windows-placement-rules
      (run-shell-command "xterm")))

(global-set-key (kbd "s-x") "colon")
(global-set-key (kbd "s-y") "clipboard-manager")
(define-key *root-map* (kbd "y") "clipboard-manager")

;; multimedia keys
(global-set-key (kbd "XF86MonBrightnessUp") "brightness-inc")
(global-set-key (kbd "XF86MonBrightnessDown") "brightness-dec")

(global-set-key (kbd "XF86AudioRaiseVolume") "volume-inc")
(global-set-key (kbd "XF86AudioLowerVolume") "volume-dec")
(global-set-key (kbd "S-XF86AudioRaiseVolume") "volume-inc-small")
(global-set-key (kbd "S-XF86AudioLowerVolume") "volume-dec-small")
(global-set-key (kbd "XF86AudioMute") "volume-toggle")

(global-set-key (kbd "SunPrint_Screen") "screenshot")
(global-set-key (kbd "S-SunPrint_Screen") "screenshot-part")
(global-set-key (kbd "Sys_Req") "screenshot-part") ;; Shift-prt_screen on the kinesis

;; window/frame navigation
(global-set-key (kbd "s-w") "windowlist-by-class")
(define-key *root-map* (kbd "w") "windowlist-by-class")
(define-key *root-map* (kbd "C-w") "windowlist-by-class")
(global-set-key (kbd "C-TAB") "pull-hidden-next")
(global-set-key (kbd "C-ISO_Left_Tab") "pull-hidden-previous")
(global-set-key (kbd "M-TAB") "fnext")
(global-set-key (kbd "M-ISO_Left_Tab") "fprev")
(global-set-key (kbd "s-TAB") "fnext")
(define-key *root-map* (kbd "1") "only")
(define-key *root-map* (kbd "2") "vsplit")
(define-key *root-map* (kbd "3") "hsplit")
(define-key *root-map* (kbd "0") "remove")
(global-set-key (kbd "s-r") "iresize")
(global-set-key (kbd "s-'") "select")

;; Browse the www
(define-key *root-map* (kbd "b") "firefox")
(define-key *root-map* (kbd "C-b") "firefox")
;; ssh somewhere
(define-key *root-map* (kbd "C-s") "colon1 exec xterm -e ssh ")
;; Lock screen
(define-key *root-map* (kbd "C-l") "xlock")

(define-key *root-map* (kbd "M-s") "duck")
(define-key *root-map* (kbd "M-i") "imdb")
