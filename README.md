# shell-scripts

自己写的一些 Shell 脚本

## 必读

在下载脚本之前，务必先安装 `ca-certificates` 包，以避免出现证书错误。

```bash
# Debian / Ubuntu
apt-get install -y ca-certificates wget

# CentOS
yum install -y ca-certificates wget
```

## vps-init.sh

* 作用：自动设置新 VPS 的一些常用操作
* 适用系统： Debian

#### 内容

* 修改密码
* 修改主机名
* 修改时区为中国上海
* 使用 Chrony 同步时间
* 更新软件
* 安装常用软件包
* 拉取远端 vimrc
* 自动配置 SSH 密钥 （使用的是 [P3TERX/SSH_Key_Installer](https://github.com/P3TERX/SSH_Key_Installer))

#### 自动配置 ssh 密钥

前往 [https://github.com/settings/keys](https://github.com/settings/keys) 绑定公钥，即可在 VPS 使用该公钥。

#### 使用方法

必须依次输入三个参数：

* 是否修改密码。值为 `1` 则是修改密码，`0` 则是不修改密码。
* 主机名
* 公钥 URL 地址。如果是 GitHub 用户的公钥，则地址是 `https://github.com/{username}.keys`

```bash
wget https://fastly.jsdelivr.net/gh/pupilcc/shell-scripts@master/vps-init.sh && bash vps-init.sh [是否修改密码] [主机名] [公钥 URL 地址]
```

## install-rclone.sh

* 作用：安装 rclone，默认安装最新版，也可指定版本。
* 适用系统： Ubuntu / Debian / Centos 7+

#### 使用方法

安装最新版本：

```bash
wget https://fastly.jsdelivr.net/gh/pupilcc/shell-scripts@master/install-rclone.sh && bash install-rclone.sh
```

安装指定版本：

```bash
wget https://fastly.jsdelivr.net/gh/pupilcc/shell-scripts@master/install-rclone.sh && bash install-rclone.sh [版本号]
```

例如安装 `1.41` 版本：

```bash
wget https://fastly.jsdelivr.net/gh/pupilcc/shell-scripts@master/install-rclone.sh  && bash install-rclone.sh 1.41
```

## install-jdk.sh

* 作用：安装 jdk，默认安装 Oracle jdk-8u171
* 适用系统： Ubuntu / Debian / Centos 7+

#### 使用方法

```bash
wget https://fastly.jsdelivr.net/gh/pupilcc/shell-scripts@master/install-jdk.sh && source install-jdk.sh
```

## install-docker.sh

* 作用：安装 docker 和 docker-compose
* 适用系统： Ubuntu / Debian / Centos 7+

#### 使用方法

```bash
wget https://fastly.jsdelivr.net/gh/pupilcc/shell-scripts@master/install-docker.sh && bash install-docker.sh
```

## firewalld-to-iptables.sh

* 作用：禁用 firewalld，然后启用 iptables
* 适用系统： Centos 7+

#### 使用方法

```bash
wget https://fastly.jsdelivr.net/gh/pupilcc/shell-scripts@master/firewalld-to-iptables.sh && bash firewalld-to-iptables.sh
```

## debian10-use-iptables.sh

* 作用：切换到 iptables-legacy，以使用 iptables。
* 适用系统： Debian 10

#### 使用方法

```bash
wget https://fastly.jsdelivr.net/gh/pupilcc/shell-scripts@master/debian10-use-iptables.sh && bash debian10-use-iptables.sh
```

## debian11-use-iptables.sh

* 作用：使用 iptables
* 适用系统： Debian 11

#### 使用方法

```bash
wget https://fastly.jsdelivr.net/gh/pupilcc/shell-scripts@master/debian11-use-iptables.sh && bash debian11-use-iptables.sh
```

## cert.sh

* 作用：使用 [acme.sh](https://acme.sh) 生成证书
* 要点：
  - 使用 [Let's Encrypt](https://letsencrypt.org) 作为默认 CA
  - 使用 DNS API 来验证域名
  - 域名托管在 [CloudFlare](https://www.cloudflare.com)
* 适用系统： Ubuntu / Debian / Centos 7+

#### 使用方法

* 下载脚本: 
```bash
wget https://fastly.jsdelivr.net/gh/pupilcc/shell-scripts@master/cert.sh
```
* 更新脚本中的 13 至 20 行内容
* `bash cert.sh`