#!/bin/bash

# Update packages
apt-get update -y

# Install OpenVPN and required packages
apt-get install -y openvpn easy-rsa

# Copy EasyRSA scripts to OpenVPN directory
cp -r /usr/share/easy-rsa /etc/openvpn/

# Generate OpenVPN server configurations
cd /etc/openvpn/easy-rsa
echo -e "1\n" | ./easyrsa init-pki
echo -e "1\n" | ./easyrsa build-ca nopass
echo -e "1\n" | ./easyrsa gen-dh
echo -e "1\n" | ./easyrsa build-server-full server nopass
openvpn --genkey --secret /etc/openvpn/easy-rsa/pki/ta.key

# Generate OpenVPN client configurations
echo -e "1\n" | ./easyrsa gen-crl

# Create server configuration file
cat <<EOF > /etc/openvpn/server.conf
port 1194
proto udp
dev tun

ca /etc/openvpn/easy-rsa/pki/ca.crt
cert /etc/openvpn/easy-rsa/pki/issued/server.crt
key /etc/openvpn/easy-rsa/pki/private/server.key
dh /etc/openvpn/easy-rsa/pki/dh.pem

server 10.3.0.0/16 255.255.255.0 

push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"

keepalive 10 120
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn/openvpn-status.log
verb 3

cipher AES-256-CBC
auth SHA256
tls-auth /etc/openvpn/easy-rsa/pki/ta.key 0
EOF

# Enable IP forwarding
sed -i 's/#net.ipv4.ip_forward/net.ipv4.ip_forward/' /etc/sysctl.conf
sysctl -p

# Enable packet forwarding via iptables
iptables -t nat -A POSTROUTING -s 10.3.0.0/16 -o eth0 -j MASQUERADE
iptables-save | sudo tee /etc/iptables.rules > /dev/null

# Update rc.local to restore iptables rules on reboot
echo -e '#!/bin/sh -e\niptables-restore < /etc/iptables.rules\nexit 0' > /etc/rc.local
chmod +x /etc/rc.local

# Start and enable OpenVPN service
systemctl start openvpn@server
systemctl enable openvpn@server
