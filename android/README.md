# Android
## 概述
&emsp;&emsp;本镜像提供了 Android [[链接](https://developer.android.com)]的编译环境。本镜像主要封装了 Android SDK 命令行工具（`cmdline-tools`）[[链接](https://developer.android.com/tools/releases/cmdline-tools?hl=zh-cn)]，该工具可以用它来查看、安装、更新和卸载 Android SDK 的软件包，并可以在编译项目时自动下载所需的编译工具。

## 版本号

| 镜像版本号  | tools 版本号 | cmdline-tools 文件                           | Java 版本号 |
|--------|-----------|--------------------------------------------|----------|
| latest | 13.0      | commandlinetools-linux-11479570_latest.zip | 17       |
| 13.0   | 13.0      | commandlinetools-linux-11479570_latest.zip | 17       |
| 12.0   | 12.0      | commandlinetools-linux-11076708_latest.zip | 17       |
| 11.0   | 11.0      | commandlinetools-linux-10406996_latest.zip | 17       |
| 10.0   | 10.0      | commandlinetools-linux-9862592_latest.zip  | 11       |
| 9.0    | 9.0       | commandlinetools-linux-9477386_latest.zip  | 11       |
| 8.0    | 8.0       | commandlinetools-linux-9123335_latest.zip  | 8        |

## 镜像标准
&emsp;&emsp;本镜像遵守以下构建标准：

- 非 root 容器: 镜像在构建过程中已创建用户 `runner`（uid 1000）和用户组 `runner`（gid 1000），并将使用该用户运行程序。使用非 root 运行程序可以为容器添加一层额外的安全保障；
- 时区: 镜像支持设置时区，默认为 `Asia/Shanghai`。使用环境变量 `TZ` 修改时区。
- 工作目录: 镜像默的工作目录为 `/workspace`。

## 使用
&emsp;&emsp;将项目目录挂载到镜像的 `/workspace` 目录。注意，项目下面的 `local.properties` 的 `sdk.dir` 属性值需修改为 `/usr/local/android`。


```bash
# 在 /workspace 目录下执行 ./gradlew assembleRelease 命令
# gradlew 会自动下载项目所需的 gradle 环境
# 在运行的过程中，android gradle plugin 会自动通过 cmdline-tools 下载需要的编译环境
$ docker run --rm -v <path-to-project>:/workspace \
  --name=android \
  centralx/android:latest \
  ./gradlew assembleRelease
```

&emsp;&emsp;为了复用编译过程相关数据，开发者可以将以下目录挂载出来，加速后续编译过程:

- `/usr/local/android`: Android SDK 目录，将该目录挂载出来可以复用 `platform-tools`、`build-tools` 等等
- `/home/runner/.gradle`: Gradle 缓存目录，将该目录挂载出来可以复用 gradle 安装包缓存、依赖缓存等
- `/home/runner/.android`: Android 缓存目录，将该目录挂载出来可以复用 Android SDK 相关缓存

```bash
# 创建缓存目录
$ mkdir -p ./cache/android ./cache/.gradle ./cache/.android
# 设置权限
# 由于镜像运行的用户为 runner，因此需要将这些目录的权限设置为 runner 用户
$ chown -R 1000:1000 ./cache

# 运行镜像
$ docker run --rm \
  -v <path-to-project>:/workspace \
  -v ./cache/android:/usr/local/android \
  -v ./cache/.gradle:/home/runner/.gradle \
  -v ./cache/.android:/home/runner/.android \
  --name=android \
  centralx/android:latest \
  ./gradlew assembleRelease
```