#!/bin/bash

function update_system() {
    echo "Updating the system..."
     apt update
     apt upgrade -y
}

function install_wireguard() {
    echo "Installing WireGuard..."
     apt install -y wireguard
}

function generate_keys() {
    echo "Generating private and public keys..."
    umask 077
    wg genkey |  tee /etc/wireguard/privatekey | wg pubkey |  tee /etc/wireguard/publickey
}

function installQRCode(){
     apt install qrencode
}

function configure_wireguard() {
    echo "Configuring WireGuard server..."
     touch /etc/wireguard/wg0.conf
     chmod 600 /etc/wireguard/wg0.conf

    cat << EOF |  tee /etc/wireguard/wg0.conf
[Interface]
Address = 10.0.0.1/24
PrivateKey = $( cat /etc/wireguard/privatekey)
SaveConfig = true
ListenPort = 51820
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

EOF
}



function enable_ip_forwarding() {
    echo "Enabling IP forwarding..."
     sed -i '/^#net.ipv4.ip_forward=1/s/^#//' /etc/sysctl.conf
     sysctl -p
}
function deleteAndRecreateConfig() {
     wg-quick down wg0
     chmod -R 777 /etc/wireguard
     rm /etc/wireguard/wg0.conf
     configure_wireguard
     wg-quick up wg0
}

# stop wireguard before editing /etc/wireguard/wg0
function Stop_wireguard() {
    echo "Stop WireGuard..."
     systemctl stop wg-quick@wg0.service
     wg-quick down wg0
     systemctl status wg-quick@wg0.service
     chmod -R 777 /etc/wireguard
}

function Restart_wireguard() {
     echo "Starting WireGuard..."
     wg-quick down wg0
     wg-quick up wg0
    #  systemctl enable --now wg-quick@wg0
    #  systemctl status wg-quick@wg0.service
     chmod -R 777 /etc/wireguard
}

function display_public_key() {
     echo "Server's public key:"
     cat /etc/wireguard/publickey
}

function configure_firewall() {
    echo "Configuring firewall..."
     ufw allow 22
     ufw allow 51820/udp
     ufw enable
     ufw allow OpenSSH
}

function add_peer() {
    wg-quick up wg0
    echo "Adding a new peer to the WireGuard configuration..."
    privatekey=$(wg genkey)
    publickey=$(echo $privatekey | wg pubkey)
    umask 077
    # echo "$privatekey" > privatekey
    # echo "$publickey" > publickey

    read -p "Enter the IP address for the new peer on the WireGuard network (e.g., 10.0.0.5): " ip
    # read -p "Enter the allowed IP addresses for the new peer (e.g., 0.0.0.0): " allowed_ips

    cat << EOF > wg1.conf

[Interface]
PrivateKey = $privatekey 
Address = $ip/24

[Peer]
PublicKey = $( cat /etc/wireguard/publickey)
AllowedIPs = 0.0.0.0/0
Endpoint = $(curl -s ifconfig.me):30000

EOF

     wg set wg0 peer $publickey allowed-ips $ip
     wg-quick down wg0
     wg-quick up wg0
     qrencode -t ansiutf8 < wg1.conf
     rm wg1.conf
}

function giveFullAccessWireguardFolder() {
     chmod -R 777 /etc/wireguard
}
function giveNoAccessWireguardFolder() {
     chmod -R 000 /etc/wireguard
}

# Prompt user for input
echo "WireGuard Server Setup"
echo "----------------------"
echo "Please select an option:"
echo "1. Update the system"
echo "2. Install WireGuard"
echo "3. Generate keys"
echo "4. Configure WireGuard"
echo "5. Enable IP forwarding"
echo "6. Restart WireGuard"
echo "7. Delete And Recreate Config"
echo "8. Display server's public key"
echo "9. Configure firewall"
echo "a. Add peer"
echo "b. give Full Access Wireguard Folder"
echo "c. give No Access Wireguard Folder"
echo "d. stop wireguard"
echo "e. check who access"
echo "f. install QR code"

read -p "Enter the option number: " option

# Main script execution based on user input
case $option in
    1) update_system ;;
    2) install_wireguard ;;
    3) generate_keys ;;
    4) configure_wireguard ;;
    5) enable_ip_forwarding ;;
    6) Restart_wireguard ;;
    7) deleteAndRecreateConfig ;;
    8) display_public_key ;;
    9) configure_firewall ;;
    a) add_peer ;;
    b) giveFullAccessWireguardFolder ;;
    c) giveNoAccessWireguardFolder ;;
    d) Stop_wireguard ;;
    e) checkWhoAccess ;;
    f) installQRCode ;;
    *) echo "Invalid option selected" ;;
esac






# start wg-quick@wg0.service
# status wg-quick@wg0.service
# sudo wg-quick down wg0
# sudo wg-quick up wg0
# cat /etc/wireguard/wg0.conf