;; -*-lisp-*-

(in-package :stumpwm)

(defvar *stumpwm-config-dir* "~/.stumpwm.d/"
  "StumpWM configuration directory.")

;; load some contrib modules
(mapcar #'load-module '("cpu"
                        "mem"
                        "net"
                        "wifi"
                        "disk"
                        "ttf-fonts"))

(defun load-user-module (name)
  (load (make-pathname :defaults *stumpwm-config-dir*
                       :name name
                       :type "lisp")))

(load "~/.emacs.d/site-lisp/slime/swank-loader.lisp")
(load-user-module "setup-swank")
(load-user-module "utils")
(load-user-module "theme")
;; (load-user-module "slack")
(load-user-module "multimedia")
(load-user-module "keybindings")
(load-user-module "workflow")
(load-user-module "clipboard-manager")

;; startup commands
(run-shell-command "xautolock -locker \"xlock -mode blank -dpmsoff 10\"")
