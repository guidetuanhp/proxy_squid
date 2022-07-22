install_squid() {
wget https://raw.githubusercontent.com/guidetuanhp/proxy/main/squid3-install.sh && sudo bash squid3-install.sh
}

edit_network() {
wget https://raw.githubusercontent.com/guidetuanhp/proxy/main/network.txt
sudo cp network.txt /etc/netplan
cd /etc/netplan
sudo cp 50-cloud-init.yaml 51-cloud-init.yaml 
sudo cat 51-cloud-init.yaml network.txt > 50-cloud-init.yaml
sudo netplan try
}
update_ip() {
IP_ALL=$(/sbin/ip -4 -o addr show scope global | awk '{gsub(/\/.*/,"",$4); print $4}')
echo $IP_ALL
IP_ALL_ARRAY=($IP_ALL)

SQUID_CONFIG="\n"

for IP_ADDR in ${IP_ALL_ARRAY[@]}; do
    ACL_NAME="proxy_ip_${IP_ADDR//\./_}"
    SQUID_CONFIG+="acl ${ACL_NAME}  myip ${IP_ADDR}\n"
    SQUID_CONFIG+="tcp_outgoing_address ${IP_ADDR} ${ACL_NAME}\n\n"
done

echo "Updating squid config"

echo -e $SQUID_CONFIG >> /etc/squid/squid.conf

echo "Restarting squid..."

systemctl restart squid

echo "Done"
}
install_squid
edit_network
update_ip
