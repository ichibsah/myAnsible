sudo nano /etc/rsyslog.d/20-firewall.conf

sudo mkdir -p /var/log/firewall
sudo chown root:adm /var/log/firewall
sudo chmod 750 /var/log/firewall

sudo systemctl restart rsyslog

