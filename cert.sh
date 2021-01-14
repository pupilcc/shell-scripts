#!/bin/bash
#=============================================================
# https://github.com/pupilcc/shell-scripts
# Description: Generate SSL Certificates
# Author: pupilcc
#=============================================================

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

# 验证参数个数
# 参数个数
declare -i COUNT=0

for i in "$@"
do
    let COUNT+=1
done

check_param_count(){
    if [ $COUNT != 1 ]
    then
        echo -e "${Error} 终止脚本运行，请输入域名。"
        exit
    fi
}
check_param_count

# 证书存放目录
certFolder="/home/cert"
# 域名
domain=$1

# 安装依赖
apt install -y socat git
yum install -y socat git

# 安装 acme.sh
echo -e "${Info} 安装 acme.sh"
cd ~
git clone https://github.com/Neilpang/acme.sh.git
cd acme.sh
./acme.sh --install --home ~/.acme.sh

# 生成证书
echo -e "${Info} 证书路径：${certFolder}"
mkdir ${certFolder}
cd ${certFolder}
echo -e "${Info} 安装证书：${domain}"
~/.acme.sh/acme.sh --issue -d ${domain} --standalone -k ec-256 --force
~/.acme.sh/acme.sh --installcert -d ${domain} --fullchainpath ${certFolder}/${domain}.crt --keypath ${certFolder}/${domain}.key --ecc