# Maven
## 概述
&emsp;&emsp;本镜像封装了 Maven [[链接](https://maven.apache.org)]运行环境。

## 版本号
### 命名规则
&emsp;&emsp;本镜像的 tag 遵循 `${maven.major/code}-jdk${openjdk}[-${os}]` 的命名规则，如：

- `centralx/maven:3-jdk8`: Maven 3（latest）With OpenJDK 8 in Ubuntu
- `centralx/maven:3.9.6-jdk17-alpine`: Maven 3.9.6 With OpenJDK 17 in Alpine

### 支持的版本号
&emsp;&emsp;本镜像支持以下 Maven 版本号:

- Maven 3: `3`, `3.9.9`, `3.9.6`

&emsp;&emsp;本镜像支持以下 OpenJDK [[链接](https://hub.docker.com/r/centralx/openjdk)]版本号:

- OpenJDK 8: `8`
- OpenJDK 11: `11`
- OpenJDK 17: `17`
- OpenJDK 21: `21`

&emsp;&emsp;本镜像支持以下系统:

- Ubuntu Jammy: `ubuntu`
- Alpine 3: `alpine`