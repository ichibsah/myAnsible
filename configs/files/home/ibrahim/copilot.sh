Great—this is exactly the kind of issue where proper Postfix + OpenDKIM + OpenARC setup makes a huge difference. Your logs show the classic forwarding problem (SPF passes, DKIM breaks → DMARC fail). Below is a working production-style configuration to fix it.

✅ Goal
Fix forwarding so that:

✅ SPF survives (SRS)
✅ DKIM survives (don’t break it)
✅ DMARC passes via ARC trust


🧩 1. POSTFIX CONFIG (main.cf)
Edit /etc/postfix/main.cf
INI# Basic identitymyhostname = mail.opendotsolutions.commydomain = opendotsolutions.com# TLS (required for trust)smtpd_tls_security_level = maysmtp_tls_security_level = may# Enable milters (DKIM + ARC)milter_default_action = acceptmilter_protocol = 6smtpd_milters = inet:127.0.0.1:8891, inet:127.0.0.1:8893non_smtpd_milters = inet:127.0.0.1:8891, inet:127.0.0.1:8893# Keep original headers intact (IMPORTANT for DKIM)receive_override_options = no_header_body_checks# Avoid breaking DKIMdisable_mime_output_conversion = yes# SRS for forwarding (via postsrsd)sender_canonical_maps = tcp:127.0.0.1:10001sender_canonical_classes = envelope_senderrecipient_canonical_maps = tcp:127.0.0.1:10002recipient_canonical_classes = envelope_recipientShow more lines

🔁 2. INSTALL + CONFIGURE SRS (postsrsd)
Install
Shellapt install postsrsdShow more lines
Edit /etc/default/postsrsd
INISRS_DOMAIN=opendotsolutions.comSRS_SECRET=your-very-long-random-secretSRS_FORWARD_PORT=10001SRS_REVERSE_PORT=10002Show more lines
✅ Restart:
Shellsystemctl restart postsrsdShow more lines

🔐 3. OPENDKIM CONFIG
/etc/opendkim.conf
INISyslog yesUMask 002Canonicalization relaxed/relaxedMode svSubDomains noSocket inet:8891@localhostKeyTable /etc/opendkim/key.tableSigningTable /etc/opendkim/signing.tableTrustedHosts /etc/opendkim/trusted.hostsOversignHeaders FromAutoRestart yesAutoRestartRate 10/1hShow more lines

/etc/opendkim/trusted.hosts
Plain Text127.0.0.1localhost*.opendotsolutions.comShow more lines

/etc/opendkim/key.table
Plain Textopendotsolutions.com opendotsolutions.com:mail:/etc/opendkim/keys/opendotsolutions.com/mail.privateShow more lines

/etc/opendkim/signing.table
Plain Text*@opendotsolutions.com opendotsolutions.comShow more lines

✅ Generate key:
Shellmkdir -p /etc/opendkim/keys/opendotsolutions.comcd /etc/opendkim/keys/opendotsolutions.comopendkim-genkey -s mail -d opendotsolutions.comchown opendkim:opendkim mail.privateShow more lines
✅ Add DNS record (mail._domainkey)

🧠 4. OPENARC CONFIG (THIS FIXES DMARC!)
Install:
Shellapt install openarcShow more lines

/etc/openarc.conf
INISyslog yesUMask 002Socket inet:8893@localhostDomain opendotsolutions.comSelector arcKeyFile /etc/openarc/keys/opendotsolutions.com/arc.privateCanonicalization relaxed/relaxedMode svAuthservID mail.opendotsolutions.comTrustedAuthservIDs mx.google.comAutoRestart yesAutoRestartRate 10/1hShow more lines

Generate ARC key
Shellmkdir -p /etc/openarc/keys/opendotsolutions.comcd /etc/openarc/keys/opendotsolutions.comopenarc-genkey -s arc -d opendotsolutions.comchown openarc:openarc arc.privateShow more lines

DNS record
Add:
arc._domainkey.opendotsolutions.com

TXT value (from generated file)

🔁 5. FORWARDING LOGIC (critical)
✅ Use aliases (NOT rewriting content)
Edit /etc/aliases:
Plain Textrinascaba@opendotsolutions.com: ichibsah@gmail.comShow more lines
Then:
ShellnewaliasesShow more lines
✅ Do NOT:

Add disclaimers
Modify subject/body
Use content filters


⚠️ 6. WHAT THIS SETUP FIXES

























ProblemFixSPF breaks on forward✅ SRS (postsrsd)DKIM breaks✅ avoid modificationDMARC fails✅ ARC chain preserves original authGmail distrust✅ ARC + TLS

✅ 7. FINAL TEST CHECKLIST
After setup:
Send test from Odoo or any external service
Then verify in Gmail:
Authentication-Results:
   spf=pass
   dkim=pass
   dmarc=fail (BUT arc=pass ✅)

✅ This is OK:

Gmail will accept via ARC


💡 PRO TIP (very important)
Even with perfect config:
👉 Forwarding will ALWAYS risk DMARC fail
✅ ARC makes it acceptable, not perfect

🚀 If you want next level
I can help you:

Add DMARC aggregate reports (rua)
Setup OpenDMARC for monitoring
Or debug your live server step-by-step

Just tell me 👍