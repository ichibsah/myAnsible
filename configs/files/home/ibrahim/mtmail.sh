# https://www.linuxbabe.com/mail-server/postfix-amavis-spamassassin-clamav-ubuntu
# sudo apt install clamav clamav-daemon

https://www.clamav.net/downloads/production/clamav-1.2.1.linux.x86_64.deb

systemctl status clamav-freshclam
sudo journalctl -eu clamav-freshclam
systemctl status clamav-daemon
sudo systemctl restart clamav-daemon
sudo systemctl enable clamav-daemon

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
hostnamectl set-hostname 4a999ff.imsawadogo.com
hostnamectl set-hostname de-1010-xl.imsawadogo.com


#multitail "/var/log/maillog | grep -i login" "/var/log/maillog | grep -i dk_check"
#multitail -e login "/var/log/maillog" -e dk_check "/var/log/maillog"
#multitail "/var/log/maillog" -e sasl_username "/var/log/maillog" -e dovecot "/var/log/maillog" -e postfix/smtpd "/var/log/maillog"

multitail -e Login "/var/log/maillog" -e dovecot "/var/log/maillog" -e smtpd "/var/log/maillog"



multitail -e Login "/var/log/maillog" -e dovecot "/var/log/maillog" -e smtpd "/var/log/maillog" "/var/log/auth.log"

multitail -e Login "/var/log/auth.log" -e fail "/var/log/auth.log" -e ssh "/var/log/auth.log" "/var/log/auth.log"


sudo multitail -e ban "/var/log/fail2ban.log" -e unban "/var/log/fail2ban.log" -e ssh "/var/log/fail2ban.log" "/var/log/fail2ban.log"