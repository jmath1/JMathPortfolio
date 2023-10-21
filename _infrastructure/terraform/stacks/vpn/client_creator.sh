#!/bin/bash
CLIENT_NAME=$1

CLIENT_DIR="/etc/openvpn/clients"
sudo mkdir -p $CLIENT_DIR


PUBLIC_IP=$(curl -s https://api.ipify.org)

cd /etc/openvpn/easy-rsa
# Generate client certificate and key
echo -e "1\n" | sudo ./easyrsa build-client-full $CLIENT_NAME nopass

# Create client configuration file
cat <<EOT > "$CLIENT_DIR/$CLIENT_NAME.ovpn"
client
dev tun
proto udp
remote $PUBLIC_IP 1194
nobind
persist-key
persist-tun
cipher AES-256-CBC
auth SHA256
comp-lzo
key-direction 1

<ca>
$(cat /etc/openvpn/easy-rsa/pki/ca.crt)
</ca>

<cert>
$(cat /etc/openvpn/easy-rsa/pki/issued/$CLIENT_NAME.crt)
</cert>

<key>
$(cat /etc/openvpn/easy-rsa/pki/private/$CLIENT_NAME.key)
</key>

<tls-auth> 
$(cat /etc/openvpn/easy-rsa/pki/ta.key)
</tls-auth>
EOT


cat /etc/openvpn/clients/$CLIENT_NAME.ovpn