# Spring Runner
## 概述
&emsp;&emsp;本镜像主要用于运行基于 Spring Boot 的可执行程序。

## 版本号
### 命名规范
&emsp;&emsp;本镜像的 tag 遵循 `[jdk/jre]${java}[-${os}]` 的命名规则，如：

- `centralx/spring-runner:8`: Spring Runner With OpenJDK 8 in Ubuntu
- `centralx/spring-runner:jdk11`: Spring Runner With OpenJDK 11 in Ubuntu
- `centralx/spring-runner:jre17-alpine`: Spring Runner With OpenJRE 17 in Alpine

### 支持的版本号
&emsp;&emsp;本镜像支持以下 OpenJDK [[链接](https://hub.docker.com/r/centralx/openjdk)]版本号:

- OpenJDK 8: `8`
- OpenJDK 11: `11`
- OpenJDK 17: `17`
- OpenJDK 21: `21`

&emsp;&emsp;本镜像支持以下系统:

- Ubuntu Jammy: `ubuntu`
- Alpine 3: `alpine`

## 镜像标准
&emsp;&emsp;本镜像遵守以下构建标准：

- 非 root 容器: 镜像在构建过程中已创建用户 `runner`（uid 1000）和用户组 `runner`（gid 1000），并将使用该用户运行程序。使用非 root 运行程序可以为容器添加一层额外的安全保障；
- 时区: 镜像支持设置时区，默认为 `Asia/Shanghai`。使用环境变量 `TZ` 修改时区。
- 工作目录: 镜像默的工作目录为 `/workspace`，工作目录下常设以下目录:
  - `/workspace/data`: 数据目录
  - `/workspace/cache`: 缓存/临时目录
  - `/workspace/config`: 配置目录
  - `/workspace/logs`: 日志目录

## 使用说明
### 声明子镜像

```dockerfile
# 继承 Spring Runner
FROM centralx/spring-runner:17

# 将可执行程序复制到工作目录，并重命名为 application.jar
COPY application-1.0.0.RELEASE.jar application.jar

# 声明暴露端口
EXPOSE 8080
```

### 编译子镜像

```bash
$ docker build -t application:latest .
```

### 运行子镜像

```bash
$ docker run -p 8080:8080 application:latest
```

##  配置镜像
### 修改可执行文件名称
&emsp;&emsp;本镜像默认可执行文件的名称是 `application.jar`，因此开发者在使用本镜像时，应参考使用说明里的 Dockerfile，将复制进来的可执行文件名修改为 `application.jar`。如果需要修改默认的可执行文件名称，可以添加一个 `RUNNER_EXECUTABLE` 环境变量，声明新的可执行文件名称，如下：

```dockerfile
FROM centralx/spring-runner:17

# 修改可执行文件名称
ENV RUNNER_EXECUTABLE=spring-application.war

# 将可执行程序复制进来，并重命名为指定的可执行文件名称
COPY application-1.0.0.RELEASE.war spring-application.war

EXPOSE 8080
```

### JVM 调优
&emsp;&emsp;本镜像默认为 JVM 设置 `-Xms256m -Xmx256m` 调优参数。如果子镜像需要定制调优参数，可以通过以下方法：

- **修改镜像默认调优参数**

```dockerfile
FROM centralx/spring-runner:17
COPY application-1.0.0.RELEASE.jar application.jar
EXPOSE 8080

# 修改启动时的 JVM 调优参数
CMD ["-Xms512m", "-Xmx512m", "-XX:+UseG1GC"]
```

- **在运行时添加调优参数**

&emsp;&emsp;你也可以在启动 Docker 镜像时添加调优参数，如下：

```bash
$ docker run -p 8080:8080 application:latest -Xms512m -Xmx512m -XX:+UseG1GC
```

## 镜像逻辑
### 编译逻辑
- 添加容器启动辅助工具 `entrypoint.sh`、`gosu`
- 创建 `runner` 用户和 `runner` 用户组
- 创建工作目录 `/workspace`
    - 创建配置目录：`/workspace/config`
    - 创建日志目录：`/workspace/logs`
    - 创建数据目录：`/workspace/data`
- 执行启动脚本 `entrypoint.sh`

### 运行逻辑
- 如果设置了 `TZ` 环境变量，则变更镜像的时区信息
- 将 `/workspace` 及子目录授权给 `runner` 用户，保证可执行文件可以正常通用 `runner` 用户运行
- 生成 Java 运行参数、Spring 运行参数
- 以 `runner` 用户运行可执行文件。