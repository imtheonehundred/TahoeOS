#!/bin/bash
set -e

dnf install -y firewalld fail2ban

systemctl enable firewalld
systemctl start firewalld

firewall-cmd --permanent --set-default-zone=home
firewall-cmd --permanent --zone=home --add-service=dhcpv6-client
firewall-cmd --permanent --zone=home --add-service=mdns
firewall-cmd --permanent --zone=home --add-service=samba-client
firewall-cmd --reload

systemctl enable fail2ban

cat > /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3

[sshd]
enabled = true
port = ssh
filter = sshd
EOF

systemctl restart fail2ban 2>/dev/null || true

echo "tahoe-security installed"
