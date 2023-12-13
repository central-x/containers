# Install Pinpoint Java Agent
## 概述
&emsp;&emsp;本镜像是基于 Resources Installer 镜像[[链接](https://hub.docker.com/r/centralx/resources-installer)]为基础构建而成，本镜像的主要功能是向 `/opt/java/agents` 目录安装 `pinpoint-agent` 插件[[文档](https://pinpoint-apm.gitbook.io/pinpoint/getting-started/quickstart)]。镜像执行完毕后，会生成以下目录结构：

```text
/opt/java/agents
  └── pinpoint
      ├── pinpoint-bootstrap.jar             # Pinpoint agent 插件
      ├── pinpoint-bootstrap-2.5.3.jar       # Pinpoint agent 插件
      └── ...                                # 其它文件
```

## 使用说明
### 修改 Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: runner
spec:
  initContainers:
    - name: install-pinpoint-agent
      image: "centralx/install-pinpoint-java-agent:latest"
      imagePullPolicy: Always
      volumeMounts:
        - name: plugin-volume # 挂载插件目录，install-pinpoint-java-agent 镜像会将 pinpoint 插件复制到该目录下
          mountPath: /opt/java/agents
  containers:
    - name: spring-application-runner
      image: application:latest
      volumeMounts: 
        - name: plugin-volume # 与 install-pinpoint-agent 挂载同一个目录，从而让 init containers 安装的资源挂载到本镜像
          mountPath: /opt/java/agents
      args: # 添加 pinpoint 代理参数
        - "-javaagent:/opt/java/agents/pinpoint/pinpoint-bootstrap.jar"
        - "-Dpinpoint.agentId=spring-application-runner"
        - "-Dpinpoint.applicationName=runner"
        - "-Dpinpoint.profiler.profiles.active=release"
  volumes:
    - name: plugin-volume # 声明卷以共享
      emptyDir: {}
```

&emsp;&emsp;以上示例中，spring-application-runner 是基于 Spring Runner 镜像[[链接](https://hub.docker.com/r/centralx/spring-runner)]构建成而。其它镜像应视具体情况添加 pinpoint 代理参数。