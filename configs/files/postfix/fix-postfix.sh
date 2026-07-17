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
postconf -e "local_recipient_maps = proxy:unix:passwd.byname $alias_maps"

# ===============================
# Relay restrictions
# ===============================
postconf -e "smtpd_relay_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination"

# ===============================
# Recipient restrictions
# ===============================
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

postfix reload
systemctl restart postfix
