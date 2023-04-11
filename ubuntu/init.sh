#!/bin/sh

# 修改 hostname
if [ -n "$1" ]; then
  sudo hostnamectl set-hostname "$1"
  echo "The new hostname will take effect after rebooting."
fi

# 判断是否有 sudo 权限
if ! groups ${USER} | grep -qE '\bsudo\b|\broot\b' ; then
    echo "Please ensure that you have sudo privileges."
    exit 1
fi

# 判断是否为 Ubuntu 系列
if [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    if [ "$DISTRIB_ID" = "Ubuntu" ]; then
        echo "System is Ubuntu"
    else
        echo "At the moment, only Ubuntu-based systems are supported."
        exit 1
    fi
else
    echo "At the moment, only Ubuntu-based systems are supported."
    exit 1
fi

# 判断是否为64位系统
if [ $(getconf WORD_BIT) != '32' ] && [ $(getconf LONG_BIT) != '64' ]; then
    echo "Currently, only 64-bit systems are supported."
    exit 1
fi

# 添加 hstr 的 PPA
echo -e "\n" | sudo add-apt-repository ppa:ultradvorka/ppa
# 添加 neovim 的 PPA
echo -e "\n" | sudo add-apt-repository ppa:neovim-ppa/stable

# 升级软件
sudo apt-get update && sudo  apt-get upgrade -y

# 安装必要的软件
sudo apt-get install -y wget curl unzip git htop vnstat neovim zsh hstr

# 切换默认终端为 zsh
chsh -s $(which zsh)

# 安装 ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 配置 hstr
# refer https://github.com/dvorka/hstr/blob/master/INSTALLATION.md#ubuntu
hstr --show-configuration >> ~/.bashrc && . ~/.bashrc

# 安装 ohmyzsh 的插件
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting extract)/' ~/.zshrc

# 下载 gost
curl -L https://github.com/ginuerzh/gost/releases/download/v2.11.5/gost-linux-amd64-2.11.5.gz | gunzip -c > gost && chmod +x gost &&  sudo mv gost /usr/local/bin/

# 删除 Please login as the user “ubuntu” rather than the user “root”
# 当前角色是 root
# 在 /root/.ssh/authorized_keys 中删除 上面内容即可


