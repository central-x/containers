# Clash
## 概述
&emsp;&emsp;本镜像封装了 Clash 及 Clash Dashboard。部署本项目后，可以直接通过网页管理代理。

## 镜像标准
&emsp;&emsp;本镜像遵守以下构建标准：

- 非 root 容器: 镜像在构建过程中已创建用户 `runner`（uid 1000）和用户组 `runner`（gid 1000），并将使用该用户运行程序。使用非 root 运行程序可以为容器添加一层额外的安全保障；
- 时区: 镜像支持设置时区，默认为 `Asia/Shanghai`。使用环境变量 `TZ` 修改时区。
- 字符集: 镜像字符集为 `UTF-8`。

## 使用说明
### 部署
&emsp;&emsp;准备好配置文件 `config.yaml`，然后运行以下命令，即可部署 clash。

```bash
$ docker run --rm 
  --name=clash \
  -p 80:80 \
  -p 7890:7890 \
  -v ./config.yaml:/home/runner/.config/clash/config.yaml \
  centralx/clash:1.18.0
```

&emsp;&emsp;部署后，通过 80 端口访问 Clash Dashboard。

### 使用代理
&emsp;&emsp;如果 Linux 需要使用代理，可以使用以下命令设置:

```bash
export no_proxy=localhost,127.0.0.1
export http_proxy=http://<host>:7890
export https_proxy=http://<host>:7890
export all_proxy=socks://<host>:7890
```

&emsp;&emsp;也可以在 `~/.bash_profile` 定义 `proxy_on` 和 `proxy_off` 函数，用于快速开启和关闭代理:

```bash
function proxy_off() {
    unset no_proxy
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo -e "Proxy Disabled"
}

function proxy_on() {
    # CIDR 网段表示法只在部份受支持的程序里起效
    # 如果不起效，那么需要直接设置具体的 IP 地址
    export no_proxy=localhost,127.0.0.1,127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16
    export http_proxy=http://<host>:7890
    export https_proxy=http://<host>:7890
    export all_proxy=socks://<host>:7890
    echo -e "Proxy Enabled"
}
```