sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp -m multiport --dports 80,443,3306,27017,27018,27019 -j ACCEPT
sudo iptables -A INPUT -j DROP
sudo dpkg-reconfigure iptables-persistent
#restart fail2ban
