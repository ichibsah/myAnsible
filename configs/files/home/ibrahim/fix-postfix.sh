#!/bin/bash

# Core rejection behavior
postconf -e "smtpd_delay_reject = yes"
postconf -e "unknown_local_recipient_reject_code = 550"

# Recipient restrictions (FULL, CLEAN, NO DUPLICATES)
postconf -e "smtpd_recipient_restrictions = reject_non_fqdn_recipient, reject_unknown_recipient_domain, reject_unlisted_recipient, reject_unknown_sender_domain, reject_non_fqdn_sender, reject_rbl_client zen.spamhaus.org, reject_rbl_client bl.spamcop.net, reject_rhsbl_reverse_client dbl.spamhaus.org, reject_rhsbl_sender dbl.spamhaus.org, permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination"

# Client restrictions (cleaned)
postconf -e "smtpd_client_restrictions = permit_mynetworks, reject_unknown_client_hostname"

# HELO restrictions
postconf -e "smtpd_helo_required = yes"
postconf -e "smtpd_helo_restrictions = reject_invalid_helo_hostname"

# Sender restrictions
postconf -e "smtpd_sender_restrictions = reject_unknown_sender_domain"

# Rate limiting (keep yours)
postconf -e "smtpd_client_message_rate_limit = 100"
postconf -e "smtpd_client_connection_rate_limit = 30"
postconf -e "smtpd_client_connection_count_limit = 10"

# Run the script
#bash /usr/local/bin/fix-postfix.sh
postfix reload
systemctl restart postfix

#Create the script:
touch /usr/local/bin/fix-postfix.sh
# EOF

# #Add a Plesk event handler
# plesk bin event_handler --create -event mail_management_status_update -priority 100 -user root -command "/usr/local/bin/fix-postfix.sh"

# plesk bin event_handler -l

# #/**/ Method A: Use telnet (best test)
# telnet 85.215.157.19 25
# EHLO test.com
# MAIL FROM:<test@gmail.com>
# RCPT TO:<doesnotexist@opendotsolutions.com>
# /**/
# expected results: 550 5.1.1 Recipient address rejected