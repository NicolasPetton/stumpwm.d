;;; Convenience function wrapping the slack REST API

(in-package :stumpwm)

(ql:quickload :do-urlencode)
(load-user-module "utils")

(defun slack-token ()
  (pass "slack-token"))

(defun slack-say (message)
  (let ((token (slack-token))
        (team "foretagsplatsen")
        (username "nico")
        (channel "C02N47RE1")
        (avatar "https://s.gravatar.com/avatar/a3c3672b9004598db722ec181362f91a?s=80"))
    (curl-get (format nil
                      "https://~A.slack.com/api/chat.postMessage?token=~A&channel=~A&text=~A&username=~A&icon_url=~A"
                      team
                      token
                      channel
                      (do-urlencode:urlencode message)
                      username
                      avatar))))

(defun slack-running-p ()
  (find-matching-windows '(:class "Slack") t t))

(defcommand slack () ()
  "Start slack unless it is already running, in which case focus it."
  (run-or-raise "slack" '(:class "Slack")))

(defun slack-kill ()
  (delete-all-windows-matching '(:class "Slack")))
