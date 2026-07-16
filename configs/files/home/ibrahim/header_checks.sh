# Basic phishing patterns
/Subject:.*Fed[eE]x.*(parcel|delivery|delay)/ REJECT FedEx phishing
/Subject:.*DHL.*(shipment|delivery)/ REJECT DHL phishing
/Subject:.*UPS.*(delivery|package)/ REJECT UPS phishing

# Fake banking
/Subject:.*(account.*suspended|verify your account)/ REJECT phishing

# Fake brands in From
/^From:.*amazon.*@(?!.*amazon\.com)/ REJECT fake Amazon
/^From:.*paypal.*@(?!.*paypal\.com)/ REJECT fake PayPal

# Common scam phrases
/Subject:.*(urgent action required|final notice)/ REJECT scam

# Suspicious TLDs (be careful)
/From:.*\.(xyz|top|click|work|fit|gq|tk)/ REJECT suspicious domain