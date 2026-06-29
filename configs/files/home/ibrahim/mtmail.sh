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
hostnamectl set-hostname mail.imsawadogo.com


#multitail "/var/log/maillog | grep -i login" "/var/log/maillog | grep -i dk_check"
#multitail -e login "/var/log/maillog" -e dk_check "/var/log/maillog"
#multitail "/var/log/maillog" -e sasl_username "/var/log/maillog" -e dovecot "/var/log/maillog" -e postfix/smtpd "/var/log/maillog"

multitail -e Login "/var/log/maillog" -e dovecot "/var/log/maillog" -e smtpd "/var/log/maillog"
multitail -e dovecot "/var/log/maillog" -e smtpd "/var/log/maillog"
multitail -e sasl_username= "/var/log/maillog" -e smtpd "/var/log/maillog"


multitail -e Login "/var/log/maillog" -e dovecot "/var/log/maillog" -e smtpd "/var/log/maillog" "/var/log/auth.log"

multitail -e pam_unix "/var/log/auth.log" -e invalid "/var/log/auth.log" -e ssh "/var/log/auth.log"


sudo multitail -e ban "/var/log/fail2ban.log" -e unban "/var/log/fail2ban.log" -e ssh "/var/log/fail2ban.log" "/var/log/fail2ban.log"

#conntrack
#https://linuxvox.com/blog/conntrack-linux/

conntrack -L
conntrack -L -p tcp
conntrack -L -p tcp -E
conntrack -E

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Set up NAT for outbound traffic
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE


# tracking security issues
sudo conntrack -E | grep -e "INVALID"

/**/


dig -x 85.215.157.19 +short
dig mail.imsawadogo.com A +short
dig imsawadogo.com TXT +short | grep spf
dig TXT default._domainkey.imsawadogo.com +short
dig TXT _dmarc.imsawadogo.com +short
dig imsawadogo.com ANY +short

v=spf1 ip4:85.215.157.19 -all



postconf | grep relay

grep sasl /var/log/mail.log

postsuper -d ALL

apt install postscreen

apt install rspamd redis-server

smtpd_delay_reject = yes (in nano /etc/postfix/main.cf)

postconf smtpd_recipient_restrictions


	
	
	
smtpd_delay_reject = yes

smtpd_recipient_restrictions =
    reject_non_fqdn_recipient,
    reject_unknown_recipient_domain,
    reject_unlisted_recipient,

    reject_unknown_sender_domain,
    reject_non_fqdn_sender,

    reject_rbl_client zen.spamhaus.org,
    reject_rbl_client bl.spamcop.net,
    reject_rhsbl_reverse_client dbl.spamhaus.org,
    reject_rhsbl_sender dbl.spamhaus.org,

    permit_mynetworks,
    permit_sasl_authenticated,
    reject_unauth_destination
	
unknown_local_recipient_reject_code = 550

#  Add basic anti-spam protection
smtpd_helo_required = yes

smtpd_client_restrictions =
    permit_mynetworks,
    reject_unknown_client_hostname

smtpd_helo_restrictions =
    reject_invalid_helo_hostname

smtpd_sender_restrictions =
    reject_unknown_sender_domain


	
/**/
mkdir -p /usr/local/psa/admin/conf/templates/custom/postfix
cp /usr/local/psa/admin/conf/templates/default/postfix/main.cf \
   /usr/local/psa/admin/conf/templates/custom/postfix/main.cf
   
#Create the script:
nano /usr/local/bin/fix-postfix.sh

#paste
   
#!/bin/bash

postconf -e "smtpd_delay_reject = yes"
postconf -e "smtpd_recipient_restrictions = reject_non_fqdn_recipient, reject_unknown_recipient_domain, reject_unlisted_recipient, reject_unknown_sender_domain, reject_non_fqdn_sender, reject_rbl_client zen.spamhaus.org, reject_rbl_client bl.spamcop.net, permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination"
postconf -e "smtpd_client_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_rbl_client zen.spamhaus.org"
postconf -e "smtpd_client_message_rate_limit = 100"
postconf -e "smtpd_client_connection_rate_limit = 30"
postconf -e "smtpd_client_connection_count_limit = 10"
postconf -e "unknown_local_recipient_reject_code = 550"

systemctl restart postfix

#Delete ALL deferred mail:
postsuper -d ALL deferred
postqueue -p | grep MAILER-DAEMON | cut -d' ' -f1 | postsuper -d -

#check status
grep "NOQUEUE" /var/log/mail.log | tail -50

#accept all
postmap -q random123@opendotsolutions.com hash:/var/spool/postfix/plesk/vmailbox


#/**/ Method A: Use telnet (best test)
telnet your-server-ip 25
EHLO test.com
MAIL FROM:<test@gmail.com>
RCPT TO:<doesnotexist@opendotsolutions.com>
/**/



#Add a Plesk event handler
plesk bin event_handler --create -event mail_management_status_update -priority 100 -user root -command "/usr/local/bin/fix-postfix.sh"

plesk bin event_handler -l

#others dont run

plesk bin event_handler --create -event mail_management_status_update -priority 100 -user root -command "/usr/local/bin/fix-postfix.sh"

plesk bin event_handler --create -event mailname_update -priority 100 -user root -command "/usr/local/bin/fix-postfix.sh"

plesk bin event_handler --create -event mailname_create -priority 100 -user root -command "/usr/local/bin/fix-postfix.sh"

plesk bin event_handler --create -event mailname_delete -priority 100 -user root -command "/usr/local/bin/fix-postfix.sh"

plesk bin event_handler --create -event service_restart -priority 100 -user root -command "/usr/local/bin/fix-postfix.sh"



/**/
apt install fail2ban -y

nano /etc/fail2ban/filter.d/postfix-auth.conf

[Definition]
failregex = warning: .* SASL .* authentication failed.*\[<HOST>\]
ignoreregex =


fail2ban-regex /var/log/mail.log /etc/fail2ban/filter.d/postfix-auth.conf

nano /etc/fail2ban/jail.d/postfix.conf

[postfix-auth]
enabled = true
port = smtp,ssmtp,submission
filter = postfix-auth
logpath = /var/log/maillog
maxretry = 3
findtime = 600
bantime = 86400
backend = auto


fail2ban-client status postfix-auth

systemctl restart fail2ban
systemctl enable fail2ban

fail2ban-client status postfix-auth
fail2ban-client status ssh


nano /etc/postfix/main.cf

smtpd_recipient_restrictions =
    permit_mynetworks,
    permit_sasl_authenticated,
    reject_unauth_destination

smtpd_tls_auth_only = yes

smtpd_delay_reject = yes


iptables -A INPUT -p tcp --dport 25 -m connlimit --connlimit-above 10 -j REJECT

#monitoring
grep "authentication failed" /var/log/maillog | wc -l
grep "sasl_username" /var/log/maillog | grep -v "authentication failed"


#extra hardening
nano /etc/postfix/master.cf:

submission inet n       -       y       -       -       smtpd
  -o smtpd_sasl_auth_enable=yes

smtpd_sasl_security_options = noanonymous

