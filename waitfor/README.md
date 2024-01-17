# Wait for
## 概述
&emsp;&emsp;本镜像主要用于 Kubernetes 集群 Pod 的 InitContainer[[链接](https://kubernetes.io/zh-cn/docs/concepts/workloads/pods/init-containers/)]功能，用于等待指定条件满足后再启动 Pod。

## 更新日志
### 1.0.0
&emsp;&emsp;发布镜像，支持以下功能：

- `time <seconds>`: 等待指定时间；
- `service <svc>`: 等待指定服务名/域名可以解域；
- `api <url>`: 等待指定 URL 返回 200 状态码；
- `cmd <command ...>`: 等待指定命令返回 0 状态码。

### 1.1.0
&emsp;&emsp;此版本作出以下改变：

1. 新增 `tcp`、`udp` 指令：等待指定服务的端口开放；
2. 优化所有指令的日志输出，方便查看日志

### 1.2.0
&emsp;&emsp;此版本作出以下改变：

1. `service` 指令修改为 `lookup`；
2. `api` 指令变更为 `get`；
3. 完善日志

### 1.2.1
&emsp;&emsp;此版本作出以下改变：

1. 修复 tcp 指令工作不正常的问题
2. 完善日志显示方式
3. 修复 get 指令超时状态码的判断
4. 用户输入不支持的指令时提示错误

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
    - name: wait
      image: "centralx/waitfor:latest"
      imagePullPolicy: Always
      args:
        - "time"
        - "60"
  containers:
    - name: spring-application-runner
      image: application:latest
```

### 等待指定命令成功
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
    - name: waitfor-mysql
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

### 等待解析指定服务/域名（Since 1.2.0）
&emsp;&emsp;等待指定服务创建后再启动 Pod。

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: runner
spec:
  initContainers:
    # 等待 myservice 可以解析后启动 spring-application-runner 容器
    - name: waitfor-myservice
      image: "centralx/waitfor:latest"
      imagePullPolicy: Always
      args:
        - "lookup"
        - "myservice"
  containers:
    - name: spring-application-runner
      image: application:latest
```

### 等待指定接口（Since 1.2.0）
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
    - name: waitfor-http
      image: "centralx/waitfor:latest"
      imagePullPolicy: Always
      args:
        - "get"
        - "http://example.com/api/healthy"
  containers:
    - name: spring-application-runner
      image: application:latest
```