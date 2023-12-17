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

# DNS API
# see: https://github.com/acmesh-official/acme.sh/wiki/dnsapi
export CF_Email=""
export CF_Key=""
dns="dns_cf"

# Notify Email
accountemail=""

# save cert folder
certFolder="/opt/cert"

# create cert folder
cert_folder(){
    if [ ! -d "${certFolder}" ]; then
        mkdir ${certFolder}
    fi
}

# install acme.sh
install(){
    # install dependent
    apt install -y socat git
    yum install -y socat git

    echo -e "${Info} 安装 acme.sh"
    cd ~
    git clone https://github.com/acmesh-official/acme.sh.git
    cd acme.sh
    ./acme.sh --install --home ~/.acme.sh --accountemail ${accountemail} 

    # set default ca
    ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
}

# update acme.sh
update(){
    ~/.acme.sh/acme.sh --upgrade
}

# generate cert
generate(){
    read -p "请输入域名: " domain

    echo -e "${Info} 证书路径：${certFolder}"
    cert_folder
    cd ${certFolder}
    echo -e "${Info} 安装证书：${domain}"
    ~/.acme.sh/acme.sh --issue --dns ${dns} -d ${domain} --standalone -k 2048 --force --log
    ~/.acme.sh/acme.sh --installcert -d ${domain} --fullchainpath ${certFolder}/"${domain}".crt --keypath ${certFolder}/"${domain}".key
}

# menu	
echo -e "${Info} 1. 安装 acme.sh"
echo -e "${Info} 2. 更新 acme.sh"
echo -e "${Info} 3. 生成证书"

start_manu(){
	read -p "请输入正确的数字: " mian
	case "$mian" in
		1)
		install
		;;
		2)
	    update	
		;;
		3)
		generate
		;;
		*)
		echo -e  "${yellow} 请输入正确数字！${font}"
		;;
	esac
}

# start
start_manu