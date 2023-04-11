# Gost 代理相关配置说明

使用 [gost](https://github.com/ginuerzh/gost) 搭建基于 kcp 和 Websocket 的 Shadowsocks 协议的代理。


## 依赖安装

确保 vps 中已经安装 gost，如果没有安装可以使用下面的脚本安装

```shell
git clone https://github.com/jimyag/init-scripts.git
curl -L https://github.com/ginuerzh/gost/releases/download/v2.11.5/gost-linux-amd64-2.11.5.gz | gunzip -c > gost && chmod +x gost &&  sudo mv gost /usr/local/bin/
```

## 创建 gost 运行目录

给 Gost 运行目录添加软链接

```shell
ln -s /root/init-scripts/gost /root/gost
```

`/root/init-scripts` 是 clone 项目的目录,下面也是一样

## 修改密钥和端口号

`44444` 和 `44445` 是修改的端口号，`key` 是修改的密钥，根据自己的要求填写即可。
在防火墙打开相应的端口
```shell
cd /root/init-scripts
find . -type f -not -name "*.md" -exec sed -i 's/yourport1/44444/g' {} +
find . -type f -not -name "*.md" -exec sed -i 's/yourport2/44445/g' {} +
find . -type f -not -name "*.md" -exec sed -i 's/yourkey/key/g' {} +
```
## 注册服务，开机自启动

```shell
ln -s /root/gost/gost.service /etc/systemd/system/gost.service
systemctl daemon-reload
systemctl enable gost.service
systemctl start gost.service
```

## 懒人版脚本

在 44444 端口启动基于 mws 传输协议，加密算法为chacha20-ietf-poly1305，密钥为 key 的 Shadowsocks 代理
在 44445 端口启动基于 kcp 传输协议，加密算法为chacha20-ietf-poly1305，密钥为 key 的 Shadowsocks 代理
！！！在防火墙打开对应的端口

```shell
curl -fsSL https://raw.githubusercontent.com/jimyag/init-scripts/main/gost/gost.run | sh
```

或者使用 自定义端口和密钥 参数分别为 mws 的端口 ，kcp的端口，加密的密钥。
```shell
curl -fsSL https://raw.githubusercontent.com/jimyag/init-scripts/main/gost/gost.run | sh -s -- 11111 11112 mykey
```
