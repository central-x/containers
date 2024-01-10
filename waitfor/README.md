# Wait for
## 概述
&emsp;&emsp;本镜像主要用于 Kubernetes 集群 Pod 的 InitContainer[[链接](https://kubernetes.io/zh-cn/docs/concepts/workloads/pods/init-containers/)]功能，用于等待指定条件满足后再启动 Pod。

## 使用
### 等待指定时间后启动
&emsp;&emsp;等待指定时间（秒）后再启动 Pod。

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: runner
spec:
  initContainers:
    # 等待 60s 后启动 spring-application-runner 容器
    - name: waitfor
      image: "centralx/waitfor:latest"
      imagePullPolicy: Always
      args:
        - "time"
        - "60"
  containers:
    - name: spring-application-runner
      image: application:latest
```

### 等待指定服务（Service）
&emsp;&emsp;等待指定服务创建后再启动 Pod。

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: runner
spec:
  initContainers:
    # 等待 myservice.<namespace>.svc.cluster.local 可以解析后启动 spring-application-runner 容器
    - name: waitfor
      image: "centralx/waitfor:latest"
      imagePullPolicy: Always
      args:
        - "service"
        - "myservice"
  containers:
    - name: spring-application-runner
      image: application:latest
```

### 等待指定接口
&emsp;&emsp;使用 GET 方法访问指定接口，等待该接口返回 200 状态码。由于一些微服务在启动之后还要一段时间才能完成启动，因此这种方式更能确保指定服务已经完成启动并能正常对外提供服务。

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: runner
spec:
  initContainers:
    # 等待 http://example.com/api/healthy 接口返回 200 状态码后启动 spring-application-runner 容器
    # 注意，这里只解析状态码（Status），不解析消息体
    - name: waitfor
      image: "centralx/waitfor:latest"
      imagePullPolicy: Always
      args:
        - "api"
        - "http://example.com/api/healthy"
  containers:
    - name: spring-application-runner
      image: application:latest
```

### 等待指定命令返回 0
&emsp;&emsp;等待指定命令返回 0 状态码。

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: runner
spec:
  initContainers:
    # 等待 nslookup myservice.pre.svc.cluster.local 命令返回状态码 0 后启动 spring-application-runner 容器
    # 注意，这里只解析命令的退出状态码（Exit Code），不解析命令输出的内容
    - name: waitfor
      image: "centralx/waitfor:latest"
      imagePullPolicy: Always
      args:
        - "cmd"
        - "nslookup"
        - "myservice.pre.svc.cluster.local"
  containers:
    - name: spring-application-runner
      image: application:latest
```

### 等待指定端口（Since 1.1.0）
&emsp;&emsp;等待指定服务器的指定端口开放。

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: runner
spec:
  initContainers:
    # 等待 mysql 容器的 3306 端口活动后启动 spring-application-runner 容器
    # 注意，这里只解析通过 netcat 测试端口是否监听，不监听应用是否正常工作
    - name: waitfor
      image: "centralx/waitfor:latest"
      imagePullPolicy: Always
      args:
        - "tcp" # 使用指定协议连接，可选用 tcp 或 udp
        - "mysql"
        - "3306"
  containers:
    - name: spring-application-runner
      image: application:latest
```