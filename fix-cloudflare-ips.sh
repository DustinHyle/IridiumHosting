#!/bin/bash

# Enable mod_remoteip and configure Cloudflare IPs
REMOTEIP_CONF="/etc/httpd/conf.modules.d/00-remoteip.conf"
echo "Creating/updating RemoteIP configuration..."
sudo tee "$REMOTEIP_CONF" > /dev/null <<EOL
LoadModule remoteip_module modules/mod_remoteip.so
RemoteIPHeader CF-Connecting-IP
# Cloudflare trusted proxy IPs (2025-05-10):
RemoteIPTrustedProxy 173.245.48.0/20
RemoteIPTrustedProxy 103.21.244.0/22
RemoteIPTrustedProxy 103.22.200.0/22
RemoteIPTrustedProxy 103.31.4.0/22
RemoteIPTrustedProxy 141.101.64.0/18
RemoteIPTrustedProxy 108.162.192.0/18
RemoteIPTrustedProxy 190.93.240.0/20
RemoteIPTrustedProxy 188.114.96.0/20
RemoteIPTrustedProxy 197.234.240.0/22
RemoteIPTrustedProxy 198.41.128.0/17
RemoteIPTrustedProxy 162.158.0.0/15
RemoteIPTrustedProxy 104.16.0.0/13
RemoteIPTrustedProxy 104.24.0.0/14
RemoteIPTrustedProxy 172.64.0.0/13
RemoteIPTrustedProxy 131.0.72.0/22
EOL

# Update Apache LogFormat
HTTPD_CONF="/etc/httpd/conf/httpd.conf"
echo "Updating LogFormat in $HTTPD_CONF..."
sudo sed -i 's/^\(LogFormat "%\)h\( %l %u %t .*combined"\)/\1a\2/' "$HTTPD_CONF"

# Restart Apache
echo "Restarting Apache..."
sudo systemctl restart httpd

echo "Configuration complete! Verify with:"
echo "sudo tail -n 20 /home/dirtinmy/var/dirtinmyshoes.com/logs/transfer*"
