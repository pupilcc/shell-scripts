#!/bin/bash
# VPS 初始化

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

# 验证参数个数
declare -i COUNT=0

for i in "$@"
do
    let COUNT+=1
done

if [ $COUNT != 3 ]
then
    echo -e "${Error} 终止脚本运行，请输入正确参数个数。"
    exit
fi

# 是否修改密码
if [ $1 -eq 1 ] || [ $1 -eq 0 ]
then
    # 修改密码
    if [ $1 = 1 ]
    then
        echo -e "${Info} 修改密码"
        passwd
    fi

    # 不修改密码
    if [ $1 = 0 ]
    then
        echo -e "${Info} 不修改密码"
    fi
else
    echo -e "${Error} 请输入正确的参数值来决定是否修改密码"
    exit
fi

# 修改主机名
echo -e "${Info} 修改主机名为 ${Green_font_prefix}${2}${Font_color_suffix}"
echo $2 > /etc/hostname

# 修改时区
echo -e "${Info} 修改时区为 ${Green_font_prefix}上海${Font_color_suffix}"
#Debian / Centos 6
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#Centos 7
timedatectl set-timezone Asia/Shanghai

# 设置时间同步
echo -e "${Info} 设置时间同步"
yum install -y ntpdate
apt-get install -y ntpdate
echo "*/5 * * * * root ntpdate asia.pool.ntp.org;hwclock -w" >> /etc/crontab

# 更新软件
echo -e "${Info} 更新软件"
apt-get update -y || yum update -y

# 安装常用软件包
echo -e "${Info} 安装常用软件包"
apt-get install -y wget git vim screen ca-certificates || yum install -y wget git vim screen ca-certificates

# 添加 ssh 密钥
echo -e "${Info} 添加 GitHub 用户名为 ${Green_font_prefix}${3}${Font_color_suffix} 的公钥"
apt-get install -y wget git vim screen || yum install -y wget git vim screen 
wget https://raw.githubusercontent.com/KiritoMiao/SSHKEY_Installer/master/key.sh && bash key.sh $3

# 一键安装部署 Fail2ban
echo -e "${Info} 一键安装部署 Fail2ban"
wget https://raw.githubusercontent.com/FunctionClub/Fail2ban/master/fail2ban.sh && bash fail2ban.sh

# 重启
echo -e "${Info} VPS 重启中..."
reboot