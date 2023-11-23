#multitail "/var/log/maillog | grep -i login" "/var/log/maillog | grep -i dk_check"
#multitail -e login "/var/log/maillog" -e dk_check "/var/log/maillog"
#multitail "/var/log/maillog" -e sasl_username "/var/log/maillog" -e dovecot "/var/log/maillog" -e postfix/smtpd "/var/log/maillog"

multitail -e Login "/var/log/maillog" -e dovecot "/var/log/maillog" -e smtpd "/var/log/maillog"