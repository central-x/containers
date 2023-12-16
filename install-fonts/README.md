# Install Fonts
## 概述
&emsp;&emsp;本镜像是基于 Resources Installer 镜像[[链接](https://hub.docker.com/r/centralx/resources-installer)]为基础构建而成，本镜像的主要功能是向 `/usr/local/share/fonts` 目录安装字体文件。镜像执行完毕后，会安装以下字体：

- 思源宋体（SourceHanSerifCN）

> &emsp;&emsp;本镜像仅用于演示如何通过 Resources Installer 安装字体到指定的镜像，如果你需要将以上字体用于商业用途，请自行获取相关商用许可。

&emsp;&emsp;本镜像主要用在 Kubernetes 集群的 Pod Init Containers 中。

## 使用说明
&emsp;&emsp;修改 Pod 的声明，在 `initContainers` 添加 `install-fonts` 的声明。同时为 `containers` 添加 `lifecycle.postStart` 配置，在镜像启动后刷新字体缓存。

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: runner
spec:
  initContainers:
    - name: install-fonts
      image: "centralx/install-fonts:latest"
      imagePullPolicy: Always
      volumeMounts:
        - name: fonts-volume # 挂载字体目录，install-fonts 镜像会将字体复制到该目录下
          mountPath: /usr/local/share/fonts
  containers:
    - name: spring-application-runner
      image: application:latest
      volumeMounts: 
        - name: fonts-volume # 与 install-fonts 挂载同一个目录，从而让 init containers 安装的字体挂载到本镜像
          mountPath: /usr/local/share/fonts
      lifecycle:
        # 在容器启动后刷新字体缓存
        postStart:
          exec:
            command:
              - "fc-cache"
              - "-vf"
  volumes:
    - name: fonts-volume # 声明卷以共享
      emptyDir: {}
```