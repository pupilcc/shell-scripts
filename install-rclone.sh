#!/bin/bash

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

# 判定是否为root用户
is_root(){
    if [ `id -u` == 0 ]
        then echo -e "${Info} 当前用户是root用户，进入安装流程"
        sleep 1
    else
        echo -e "${Error} 当前用户不是root用户，请切换到root用户后重新执行脚本" 
        exit 1
    fi
}

# 安装 rclone
install_rclone(){
    wget https://downloads.rclone.org/v1.41/rclone-v1.41-linux-amd64.zip
    unzip rclone-v1.41-linux-amd64.zip
    chmod 0777 ./rclone-*/rclone
    cp ./rclone-*/rclone /usr/bin/
    rm -rf ./rclone-*
}

main(){
    is_root
    install_rclone
    echo -e "${Info} rclone 安装成功"
}

main