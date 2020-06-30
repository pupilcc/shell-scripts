#!/bin/bash

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

# 禁用 firewalld
echo -e "禁用 firewalld"
systemctl status firewalld
systemctl stop firewalld
systemctl disable firewalld

# 安装 iptables
echo -e "安装 iptables"
yum install -y iptables
yum update iptables
yum install -y iptables-services

# 启用 iptables
echo -e "启用 iptables"
systemctl enable iptables
systemctl start iptables
systemctl status iptables

# 开放端口提示
echo -e "此时规则都保存在 /etc/sysconfig/iptables 中，修改该文件后使用 systemctl restart iptables 来生效更改"