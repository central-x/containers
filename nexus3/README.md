# Sonatype Nexus Repository
## 概述
&emsp;&emsp;本镜像封装了 Sonatype Nexus3 repository[[链接](https://sonatype.com)]。

## 镜像标准
&emsp;&emsp;本镜像遵守以下构建标准：

- 非 root 容器: 镜像在构建过程中已创建用户 `runner`（uid 1000）和用户组 `runner`（gid 1000），并将使用该用户运行程序。使用非 root 运行程序可以为容器添加一层额外的安全保障；
- 时区: 镜像支持设置时区，默认为 `Asia/Shanghai`。使用环境变量 `TZ` 修改时区。
- 工作目录: 镜像默的工作目录为 `/workspace`，工作目录下常设以下目录:
    - `/workspace/data`: 数据目录

## 使用说明
### 运行镜像

```yaml
$ docker run --rm -p 8081:8081 --name nexus centralx/nexus3:latest
```

### 持久化数据
&emsp;&emsp;本镜像默认将数据保存在 `/workspace/data` 目录，开发者可以将该目录挂载出来以实现数据持久化。

```yaml
$ mkdir ./nexus-data
# 系统以 runner 用户运行，因此需要将持久化目录授权给 1000:1000 以保证数据目录可以被 runner 用户读写
$ chown -R 1000:1000 ./nexus-data
$ docker run --rm -p 8081:8081 -v ./nexus-data:/workspace/data --name nexus centralx/nexus3:latest
```

### 其它说明
- 系统默认用户为 `admin`，在第一次启动时，会在 `/workspace/data/admin.password` 生成密码文件。
- 系统第一次启动时，可能需要一定的时间启动（约 2 ~ 3 分钟），可以通过 `docker logs -f nexus` 查看日志以确认容器是否启动完成。
- 系统默认安装在 `/workspace/nexus` 目录下。