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

# ZeroSSL Email
account=""

# 证书存放目录
certFolder="/home/cert"

# 设置 DNS API
init_dns_api(){
    # DNS API
    export CF_Key=""
    export CF_Email=""
    echo -e "${Info} 设置 DNS API 成功"
}

# 安装 acme.sh
install(){
    # 安装依赖
    apt install -y socat git
    yum install -y socat git

    # 安装 acme.sh
    echo -e "${Info} 安装 acme.sh"
    cd ~
    git clone https://github.com/acmesh-official/acme.sh.git
    cd acme.sh
    ./acme.sh --install --home ~/.acme.sh

    # 设置默认 CA
    ~/.acme.sh/acme.sh --set-default-ca --server zerossl
    
    # 安装证书路径
    mkdir ${certFolder}
}

# 更新 acme.sh
update(){
    ~/.acme.sh/acme.sh --upgrade
}

# 生成证书
generate(){
    read -p "请输入域名: " domain

    # 设置 ZeroSSL 帐号
    ~/.acme.sh/acme.sh --register-account -m ${account} --server zerossl

    echo -e "${Info} 证书路径：${certFolder}"
    cd ${certFolder}
    echo -e "${Info} 安装证书：${domain}"
    ~/.acme.sh/acme.sh --issue -d ${domain} --dns dns_cf --standalone -k 2048 --force
    ~/.acme.sh/acme.sh --installcert -d ${domain} --fullchainpath ${certFolder}/${domain}.crt --keypath ${certFolder}/${domain}.key
}

#选项菜单	
echo -e "${Info} 0. 设置 DNS API"
echo -e "${Info} 1. 安装 acme.sh"
echo -e "${Info} 2. 更新 acme.sh"
echo -e "${Info} 3. 生成证书"

start_manu(){
	read -p " 请输入正确的数字: " mian
	case "$mian" in
		0)
		init_dns_api
		;;
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

#启动目录
start_manu