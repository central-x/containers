# OpenJDK
## 概述
&emsp;&emsp;本镜像封装了 Azul Zulu OpenJDK[[链接](https://www.azul.com)]，为 Java 可执行程序提供运行环境。

## 版本号
### 命名规则
&emsp;&emsp;本镜像的 tag 遵循 `[jdk/jre]${major/version}[-${os}]` 的命名规则，如:

- `centralx/openjdk:8`: OpenJDK 8(JDK) in Ubuntu
- `centralx/openjdk:jre11`: OpenJDK 11(JRE) in Ubuntu
- `centralx/openjdk:jdk17.0.9-alpine`: OpenJDK 17.0.9(JDK) in Alpine
- `centralx/openjdk:21-ubuntu`: OpenJDK 21(JDK) in Ubuntu

### 支持的版本号
&emsp;&emsp;本镜像支持以下 OpenJDK 版本号:

- OpenJDK 8: `8`、`8.0.442`、`8.0.432`、`8.0.422`、`8.0.402`、`8.0.392`
- OpenJDK 11: `11`、`11.0.26`、`11.0.25`、`11.0.24`、`11.0.22`、`11.0.21`
- OpenJDK 17: `17`、`17.0.14`、`17.0.13`、`17.0.12`、`17.0.10`、`17.0.9`
- OpenJDK 21: `21`、`21.0.6`、`21.0.5`、`21.0.4`、`21.0.2`、`21.0.1`

&emsp;&emsp;本镜像支持以下系统:

- Ubuntu Jammy: `ubuntu`
- Alpine 3: `alpine`