# Spring Runner
## 概述
&emsp;&emsp;本镜像主要用于运行基于 Spring Boot 的可执行程序。

## 版本说明
### JDK
* Spring Runner with OpenJDK 8: `8`, `8-jdk`, `8.0.392`, `8.0.392-jdk`, `8-ubuntu`, `8-jdk-ubuntu`, `8.0.392-ubuntu`, `8.0.392-jdk-ubuntu`, `8-alpine`, `8-jdk-alpine`, `8.0.392-alpine`, `8.0.392-jdk-alpine`
* Spring Runner with OpenJDK 11: `11`, `11-jdk`, `11.0.21`, `11.0.21-jdk`, `11-ubuntu`, `11-jdk-ubuntu`, `11.0.21-ubuntu`, `11.0.21-jdk-ubuntu`, `11-alpine`, `11-jdk-alpine`, `11.0.21-alpine`, `11.0.21-jdk-alpine`
* Spring Runner with OpenJDK 17: `17`, `17-jdk`, `17.0.9`, `17.0.9-jdk`, `17-ubuntu`, `17-jdk-ubuntu`, `17.0.9-ubuntu`, `17.0.9-jdk-ubuntu`, `17-alpine`, `17-jdk-alpine`, `17.0.9-alpine`, `17.0.9-jdk-alpine`
* Spring Runner with OpenJDK 21: `21`, `21-jdk`, `21.0.1`, `21.0.1-jdk`, `21-ubuntu`, `21-jdk-ubuntu`, `21.0.1-ubuntu`, `21.0.1-jdk-ubuntu`, `21-alpine`, `21-jdk-alpine`, `21.0.1-alpine`, `21.0.1-jdk-alpine`

### JRE
* Spring Runner with OpenJDK 8(JRE): `8-jre`, `8.0.392-jre`, `8-jre-ubuntu`, `8.0.392-jre-ubuntu`, `8-jre-alpine`, `8.0.392-jre-alpine`
* Spring Runner with OpenJDK 11(JRE): `11-jre`, `11.0.21-jre`, `11-jre-ubuntu`, `11.0.21-jre-ubuntu`, `11-jre-alpine`, `11.0.21-jre-alpine`
* Spring Runner with OpenJDK 17(JRE): `17-jre`, `17.0.9-jre`, `17-jre-ubuntu`, `17.0.9-jre-ubuntu`, `17-jre-alpine`, `17.0.9-jre-alpine`
* Spring Runner with OpenJDK 21(JRE): `21-jre`, `21.0.1-jre`, `21-jre-ubuntu`, `21.0.1-jre-ubuntu`, `21-jre-alpine`, `21.0.1-jre-alpine`

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
### 修改时区
&emsp;&emsp;本镜像默认时区为 `Asia/Shanghai`，如果开发者需要修改时区，可以通过添加环境变量修改，如下：

```bash
$ docker run -p 8080:8080 -e TZ=Europe/London application:latest
```

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