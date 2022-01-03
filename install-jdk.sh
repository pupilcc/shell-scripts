#!/bin/bash

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

#系统版本
os_num=0

#Java安装目录
java_home=/usr/local/java

# 文件地址
use_file() {
    file="https://dl.pupil.cc/software/jdk/jdk-8u171-linux-x64.tar.gz"
}

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

# 系统检测
check_system()
{
    source /etc/os-release
    case $ID in
        debian|ubuntu)
            os_num=1
            ;;
        centos)
            os_num=2
            ;;
    esac
}

# 安装所需的依赖包
install_dependency(){
    echo -e "${Info} 安装所需的依赖包"
    check_system
    if [ $os_num == 1 ]; then
        apt-get install -y wget
    elif [ $os_num == 2 ]; then
        yum install -y wget
    fi
}

# 安装
install_soft(){
    echo -e "${Info} 正在安装 JDK"
    mkdir ${java_home}
    wget $file
    tar xzf jdk-8u171-linux-x64.tar.gz -C ${java_home}
    echo "#set java environment" >> /etc/profile
    echo "export JAVA_HOME=${java_home}/jdk8" >> /etc/profile
    echo "export CLASSPATH=\$JAVA_HOME/lib/tools.jar:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib" >> /etc/profile
    echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile
    source /etc/profile
}

main() {
    is_root
    install_dependency
    use_file
    install_soft
}

main