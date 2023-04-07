#!/bin/sh


# 判断是否有 sudo 权限
if ! groups ${USER} | grep -qE '\bsudo\b|\broot\b' ; then
    echo "请确保您拥有 sudo 权限"
    exit 1
fi


# 判断是否为 Ubuntu 系列
if [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    if [ "$DISTRIB_ID" = "Ubuntu" ]; then
        echo "System is Ubuntu"
    else
        echo "暂不支持非 Ubuntu 系列系统"
        exit 1
    fi
else
    echo "暂不支持非 Ubuntu 系列系统"
    exit 1
fi



# 判断是否为64位系统
if [ $(getconf WORD_BIT) != '32' ] && [ $(getconf LONG_BIT) != '64' ]; then
    echo "Error: 暂不支持非64位系统"
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

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# refer https://github.com/dvorka/hstr/blob/master/INSTALLATION.md#ubuntu
hstr --show-configuration >> ~/.bashrc && . ~/.bashrc

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


# 修改当前的 hostname 重启之后生效
sudo hostnamectl set-hostname aws3

# 切换到 root 用户
sudo su

plugins=(git zsh-autosuggestions zsh-syntax-highlighting extract)


## 下载gost
curl -L https://github.com/ginuerzh/gost/releases/download/v2.11.5/gost-linux-amd64-2.11.5.gz | gunzip -c > gost && chmod +x gost &&  sudo mv gost /usr/local/bin/

# 删除 Please login as the user “ubuntu” rather than the user “root”
# 当前角色是 root
# 在 /root/.ssh/authorized_keys 中删除 上面内容即可


