#!/bin/bash

# ===============================
# Core rejection behavior
# ===============================
postconf -e "smtpd_delay_reject = yes"
postconf -e "unknown_local_recipient_reject_code = 550"
postconf -e "smtpd_reject_unlisted_recipient = yes"

# ===============================
# Network trust (CRITICAL)
# ===============================
postconf -e "mynetworks = 127.0.0.0/8 [::1]/128"

# ===============================
# Plesk mailbox/domain mapping
# ===============================
postconf -e "virtual_mailbox_domains = hash:/var/spool/postfix/plesk/virtual_domains"
postconf -e "virtual_mailbox_maps = proxy:hash:/var/spool/postfix/plesk/vmailbox"
postconf -e "local_recipient_maps = proxy:unix:passwd.byname \$alias_maps"

# ===============================
# Relay restrictions
# ===============================
postconf -e "smtpd_relay_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination"

# ===============================
# Recipient restrictions (FINAL CLEAN VERSION)
# ===============================
#postconf -e "smtpd_recipient_restrictions = reject_non_fqdn_recipient, reject_unknown_recipient_domain, reject_unlisted_recipient, reject_unknown_sender_domain, reject_non_fqdn_sender, reject_rbl_client zen.spamhaus.org, reject_rbl_client bl.spamcop.net, reject_rbl_client b.barracudacentral.org, reject_rbl_client dnsbl.sorbs.net, reject_rhsbl_reverse_client dbl.spamhaus.org, reject_rhsbl_sender dbl.spamhaus.org, permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination"
#postconf -e "smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_non_fqdn_recipient, reject_unknown_recipient_domain, reject_unlisted_recipient, reject_unknown_sender_domain, reject_non_fqdn_sender, reject_rbl_client zen.spamhaus.org, reject_rbl_client bl.spamcop.net, reject_rbl_client b.barracudacentral.org, reject_rhsbl_reverse_client dbl.spamhaus.org, reject_rhsbl_sender dbl.spamhaus.org, reject_unauth_destination"
postconf -e "smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_non_fqdn_recipient, reject_unknown_recipient_domain, reject_unlisted_recipient, reject_unknown_sender_domain, reject_non_fqdn_sender, reject_rbl_client zen.spamhaus.org, reject_rbl_client bl.spamcop.net, reject_rbl_client b.barracudacentral.org, reject_rhsbl_reverse_client dbl.spamhaus.org, reject_rhsbl_sender dbl.spamhaus.org, reject_unauth_destination"

# ===============================
# Client restrictions
# ===============================
postconf -e "smtpd_client_restrictions = permit_mynetworks, reject_unknown_client_hostname"

# ===============================
# HELO restrictions
# ===============================
postconf -e "smtpd_helo_required = yes"
postconf -e "smtpd_helo_restrictions = reject_invalid_helo_hostname"

# ===============================
# Sender restrictions
# ===============================
postconf -e "smtpd_sender_restrictions = reject_non_fqdn_sender, reject_unknown_sender_domain"

# ===============================
# Rate limiting (anti-abuse)
# ===============================
postconf -e "smtpd_client_message_rate_limit = 100"
postconf -e "smtpd_client_connection_rate_limit = 30"
postconf -e "smtpd_client_connection_count_limit = 10"

# ===============================
# Header filtering
# ===============================
postconf -e "header_checks = regexp:/etc/postfix/header_checks"

# ===============================
# Apply changes
# ===============================
postfix reload
systemctl restart postfix

#Create the script:
touch /usr/local/bin/fix-postfix.sh
# EOF

echo "" > /usr/local/bin/fix-postfix.sh
nano /usr/local/bin/fix-postfix.sh

user=info@alphablogistics.com, ip=[154.160.0.146].


/**/
nano /etc/fail2ban/filter.d/postfix-auth.local

[Definition]
failregex = .*postfix/smtpd\[\d+\]: warning: .*?\[<HOST>\]: SASL .* authentication failed
ignoreregex =

fail2ban-client reload
fail2ban-regex /var/log/maillog /etc/fail2ban/filter.d/postfix-auth.local
/**/

/**/
fail2ban-regex /var/log/maillog /etc/fail2ban/filter.d/postfix-auth.local

nano /etc/fail2ban/jail.d/postfix.conf

/**/


# nano /etc/postfix/header_checks
/Subject:.*FedEx.*delay/ REJECT phishing attempt

# #Add a Plesk event handler
# plesk bin event_handler --create -event mail_management_status_update -priority 100 -user root -command "/usr/local/bin/fix-postfix.sh"

# plesk bin event_handler -l

# #/**/ Method A: Use telnet (best test)
telnet 85.215.157.19 25
EHLO test.com
MAIL FROM:<test@gmail.com>
RCPT TO:<doesnotexist@opendotsolutions.com>

# /**/
# expected results: 550 5.1.1 Recipient address rejected

postconf | grep mynetworks
postconf | grep virtual_mailbox_domains
postconf | grep smtpd_sender_restrictions
postconf | grep smtpd_relay_restrictions



/**/ expected results
mynetworks = 127.0.0.0/8 [::1]/128
virtual_mailbox_domains = hash:/var/spool/postfix/plesk/virtual_domains

I can help you:

Add fail2ban SMTP jail
Check IP reputation / blacklist
Optimize for Gmail/Outlook deliverability
✅ Fail2Ban SMTP jail (blocks attackers automatically)
✅ DNSBL tuning (optimize spam blocking without false positives)
✅ IP reputation + blacklist check
✅ Gmail / Outlook delivery optimization