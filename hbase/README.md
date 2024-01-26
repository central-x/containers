# Apache HBase
## 概述
&emsp;&emsp;本镜像封装了 Apache HBase[[链接](https://hbase.apache.org)]。

```bash
$ docker run centralx/hbase:latest
```

## 版本发布
- latest(1.7.2)
- 1.7.2

## 镜像标准
&emsp;&emsp;本镜像遵守以下构建标准：

- 非 root 容器: 镜像在构建过程中已创建用户 `runner`（uid 1000）和用户组 `runner`（gid 1000），并将使用该用户运行程序。使用非 root 运行程序可以为容器添加一层额外的安全保障； 
- 时区: 镜像支持设置时区，默认为 `Asia/Shanghai`。使用环境变量 `TZ` 修改时区。
- 工作目录: 镜像默的工作目录为 `/workspace`，工作目录下常设以下目录:
  - `/workspace/data`: 数据目录
  - `/workspace/cache`: 缓存/临时目录
  - `/workspace/config`: 配置目录
  - `/workspace/logs`: 日志目录
  - `/workspace/init`: 数据初始化目录

## 使用
&emsp;&emsp;HBase 应用程序存放在 `/workspace/hbase` 目录下。

### 修改配置文件
&emsp;&emsp;HBase 的配置文件一般存放在 `hbase/conf` 目录下。本镜像在启动时，会将存放在 `/workspace/config` 目录下的配置文件复制到 `hbase/conf` 目录。如果存在同名文件时，将会覆盖原文件。

### 初始化
&emsp;&emsp;本镜像在启动后，会自动执行存放在 `/workspace/init` 目录下的 `*.hbase` 文件来初始化，因此可以将相关初始化文件挂载到该目录下。