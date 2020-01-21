# unique mac address
ip link show eth1
# unique producet_uuid
sudo cat /sys/class/dmi/id/product_uuid
# switch nftables to legacy
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
sudo update-alternatives --set arptables /usr/sbin/arptables-legacy
sudo update-alternatives --set ebtables /usr/sbin/ebtables-legacy
