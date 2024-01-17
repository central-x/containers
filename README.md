# Containers
## 概述
&emsp;&emsp;本仓库用于保存常用的容器镜像。

## 镜像清单

- OpenJDK[[链接](https://hub.docker.com/r/centralx/openjdk)]: 封装了 Azul Zulu OpenJDK
- Spring Runner[[链接](https://hub.docker.com/r/centralx/spring-runner)]: 提供了 Spring Boot 可执行文件的运行环境
- Resources Installer[[链接](https://hub.docker.com/r/centralx/install-pinpoint-java-agent)]: 通过向目标镜像的指定路径复制资源的方式添加额外的功能。本镜像常用于 Kubernetes 集群 Pod 的 Init Containers 功能。
- Install Pinpoint Java Agent[[链接](https://hub.docker.com/r/centralx/install-pinpoint-java-agent)]: 基于 Resources Installer 封装的 Pinpoint java agent 插件，可以向目标容器添加 pinpoint java agent 的相关程序文件。本镜像常用于 Kubernetes 集群 Pod 的 Init Containers 功能。
- Install Fonts[[链接](https://hub.docker.com/r/centralx/install-fonts)]: 基于 Resources Installer 封装的字体安装容器，可以向目标容器添加字体相关文件。本镜像常用于 Kubernetes 集群 Pod 的 Init Containers 功能。
- Wait For[[链接](https://hub.docker.com/r/centralx/waitfor)]: 等待指定条件满足后再启动 Pod。本镜像主要用于 Kubernetes 集群 Pod 的 Init Containers 功能。
- HBase[[链接](https://hub.docker.com/r/centralx/hbase)]: Apache HBase。

## License
[MIT License](./LICENSE)