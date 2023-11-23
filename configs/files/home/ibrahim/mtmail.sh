# https://www.linuxbabe.com/mail-server/postfix-amavis-spamassassin-clamav-ubuntu
# sudo apt install clamav clamav-daemon
systemctl status clamav-freshclam
sudo journalctl -eu clamav-freshclam
systemctl status clamav-daemon
sudo systemctl restart clamav-daemon

# sudo apt install amavisd-new -y # 
systemctl status amavis
systemctl restart amavis
sudo systemctl enable amavis
sudo netstat -lnpt | grep amavis
amavisd-new -V
sudo journalctl -eu amavis

# https://bobcares.com/blog/postfix-deferred-queue/
mailq
postqueue -p
qshape deferred
#postsuper -d ALL deferred # delete
postconf -n
postsuper -r ALL
postqueue -f

hostname -f
hostnamectl set-hostname 4a999ff.online-server.cloud


#multitail "/var/log/maillog | grep -i login" "/var/log/maillog | grep -i dk_check"
#multitail -e login "/var/log/maillog" -e dk_check "/var/log/maillog"
#multitail "/var/log/maillog" -e sasl_username "/var/log/maillog" -e dovecot "/var/log/maillog" -e postfix/smtpd "/var/log/maillog"

multitail -e Login "/var/log/maillog" -e dovecot "/var/log/maillog" -e smtpd "/var/log/maillog"