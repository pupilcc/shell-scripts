#!/bin/bash

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

# docker
echo -e "${Info} 开始安装 docker"
china=$(curl -s https://262235.xyz/ip/$(curl -s https://262235.xyz/ip/) | grep 中国)
if [[ ! -z "${china}" ]]; then
        echo $china
        # 中国使用阿里云镜像
        curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
else
        # Docker 一键安装命令
        curl -fsSL https://get.docker.com | bash -s docker
fi

systemctl start docker
systemctl enable docker

# docker-compose
echo -e "${Info} 开始安装 docker-compose"
china=$(curl -s https://262235.xyz/ip/$(curl -s https://262235.xyz/ip/) | grep 中国)
if [[ ! -z "${china}" ]]; then
        echo $china
        curl -L "https://ghproxy.com/https://github.com/docker/compose/releases/download/v2.21.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
else
        curl -L "https://github.com/docker/compose/releases/download/v2.21.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
fi

chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose