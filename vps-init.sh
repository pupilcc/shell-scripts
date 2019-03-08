#!/bin/bash
# VPS 初始化

# 验证参数个数
declare -i COUNT=0

for i in "$@"
do
    let COUNT+=1
done

if [ $COUNT != 3 ]
then
    echo "终止脚本运行，请输入正确参数个数。"
    exit
fi

# 是否修改密码
if [ $1 -eq 1 ] || [ $1 -eq 0 ]
then
    # 修改密码
    if [ $1 = 1 ]
    then
        echo "===修改密码==="
        passwd
    fi

    # 不修改密码
    if [ $1 = 0 ]
    then
        echo "===不修改密码==="
    fi
else
    echo "请输入正确的参数值来决定是否修改密码"
    exit
fi

# 修改主机名
echo "===修改主机名==="
echo $2 > /etc/hostname

# 修改时区
echo "===修改时区==="
#Debian / Centos 6
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#Centos 7
timedatectl set-timezone Asia/Shanghai

# 设置时间同步
echo "===设置时间同步==="
yum install -y ntpdate
apt-get install -y ntpdate
echo "*/5 * * * * root ntpdate asia.pool.ntp.org;hwclock -w" >> /etc/crontab

# 更新软件
echo "===更新软件==="
apt-get update -y || yum update -y

# 安装常用软件包
echo "===安装常用软件包==="
apt-get install -y wget git vim screen ca-certificates || yum install -y wget git vim screen ca-certificates

# 添加 ssh 密钥
echo "===添加 ssh 密钥==="
apt-get install -y wget git vim screen || yum install -y wget git vim screen 
wget https://raw.githubusercontent.com/KiritoMiao/SSHKEY_Installer/master/key.sh && bash key.sh $3

# 一键安装部署 Fail2ban
echo "===一键安装部署 Fail2ban==="
wget https://raw.githubusercontent.com/FunctionClub/Fail2ban/master/fail2ban.sh && bash fail2ban.sh

# 重启
echo "===重启==="
reboot