#!/bin/bash

update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
#update-alternatives --set arptables /usr/sbin/arptables-legacy
#update-alternatives --set ebtables /usr/sbin/ebtables-legacy

cat > /etc/iptables.test.rules <<EOF
*filter

# Allows all loopback (lo0) traffic and drop all traffic to 127/8 that doesn't use lo0
-A INPUT -i lo -j ACCEPT
-A INPUT ! -i lo -d 127.0.0.0/8 -j REJECT

# Accepts all established inbound connections
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allows all outbound traffic
# You could modify this to only allow certain traffic
-A OUTPUT -j ACCEPT

# Allows HTTP and HTTPS connections from anywhere (the normal ports for websites)
-A INPUT -p tcp --dport 80 -j ACCEPT
-A INPUT -p tcp --dport 443 -j ACCEPT

# Allows SSH connections 
# The --dport number is the same as in /etc/ssh/sshd_config
-A INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT

# Now you should read up on iptables rules and consider whether ssh access 
# for everyone is really desired. Most likely you will only allow access from certain IPs.

# Allow ping
#  note that blocking other types of icmp packets is considered a bad idea by some
#  remove -m icmp --icmp-type 8 from this line to allow all kinds of icmp:
#  https://security.stackexchange.com/questions/22711
-A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

# log iptables denied calls (access via 'dmesg' command)
-A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

# Reject all other inbound - default deny unless explicitly allowed policy:
-A INPUT -j REJECT
-A FORWARD -j REJECT

COMMIT
EOF

iptables-restore < /etc/iptables.test.rules
iptables-save > /etc/iptables.up.rules

cat > /etc/network/if-pre-up.d/iptables <<EOF
#!/bin/sh
/sbin/iptables-restore < /etc/iptables.up.rules
EOF

chmod +x /etc/network/if-pre-up.d/iptables

# 保存规则sh
cat > ~/iptables-save.sh <<EOF
#!/bin/bash

# 防火墙规则持久化

iptables-restore < /etc/iptables.test.rules
iptables-save> /etc/iptables.up.rules
EOF

chmod +x ~/iptables-save.sh

# 开放端口提示
echo -e "此时规则都保存在 /etc/iptables.test.rules 中，修改该文件后使用 bash ~/iptables-save.sh 来生效更改"