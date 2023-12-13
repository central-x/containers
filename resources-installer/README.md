# Resources Installer
## 概述
&emsp;&emsp;本镜像主要功能是通过向目标镜像的指定路径复制资源的方式添加额外的功能。本镜像常用于 Kubernetes 集群 Pod 的 Init Containers 功能。

&emsp;&emsp;使用本镜像可以将这些外部资源进行版本化管理，让资源可以独立更新。

&emsp;&emsp;一部份资源在安装之后，需要执行脚本才能生效时，可以配合 Pod 的 LifeCycle[[链接](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#LifecycleHandler)]完成。

&emsp;&emsp;Pod 在使用 Resources Installer 时，可以参考以下：

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: runner
spec:
  initContainers:
    - name: install-font
      image: resources:version
      volumeMounts:
        - name: font-volume # 将资源安装目录挂载出来，字体将安装到该卷
          mountPath: /usr/local/share/fonts
  containers:
    - name: runner
      image: busybox:latest
      volumeMounts: 
        - name: font-volume # 与 install-font 挂载同一个目录，从而让 init containers 安装的资源挂载到本镜像
          mountPath: /usr/local/share/fonts
      lifecycle:
        # 在容器启动后刷新字体缓存
        postStart:
          exec:
            command:
              - "fc-cache"
              - "-vf"
  volumes:
    - name: font-volume # 声明卷以共享
      emptyDir: {}
```

## 使用说明
&emsp;&emsp;Resources Installer 的设计思路是将资源镜像化（同时也版本化）。开发者在将资源镜像化时，可以选择将所有资源都做成一个镜像，也可以将每种资源分别做成不同的镜像。一般情况下，建议将资源分别做成不同的镜像，从而更好地管理资源的版本信息。

&emsp;&emsp;镜像在启动时会遍历工作目录（`/resources`）下的所有资源文件夹，并在资源文件夹的一级目录上查找 `install.txt` 文件，获取安装路径。接下来将文件夹下所有的文件复制到 `install.txt` 文件指定的路径。完成所有的复制操作后，结束进程。

### 编译镜像
&emsp;&emsp;开发者根据以下目录组织方式，将待安装的资源整理到镜像编译目录:

```
<docker-image>
  ├── Dockerfile                     # 子镜像 Dockerfile
  └── resources
      ├── font-resources             # 字体资源
      │   ├── framd.ttf              # 待安装字体
      │   ├── georgia.ttf            # 待安装字体
      │   └── install.txt            # 安装路径配置
      └── other-resoruces            # 其它资源（可以只有一个资源）
          ├── agent.jar
          └── install.txt
```

&emsp;&emsp;`install.txt` 主要用于记录待安装的资源的安装目录。其格式如下：

```text
/usr/local/share/fonts
```

> Resources Installer 会先通过 `mkdir -p` 的方式创建目录，再将资源目录下所有文件（除了 install.txt）文件复制到这个目录下。

&emsp;&emsp;Dockerfile 的文件内容如下：

```dockerfile
# 继承 Resources Installer
FROM centralx/resources-installer:latest

# 将需要安装的资源复制到当前工作目录（工作目录默认为 /resources）
COPY ./resources ./
```

&emsp;&emsp;将子镜像编译并推送到镜像仓库，就可以在 Pod 的 Init Containers 中使用了。

```bash
$ docker build -t <resources>:<version> .
```