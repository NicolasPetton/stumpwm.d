(in-package :stumpwm)

(defcommand clipboard-manager () ()
  "Emacs as a clipboard manager."
  (without-windows-placement-rules
      (run-shell-command "emacsclient -c -n -e '(helm-clipboard-manager-frame)'")))


;; start the clipboard manager on startup
(run-shell-command "~/.stumpwm.d/bin/clipboard-manager.sh")
