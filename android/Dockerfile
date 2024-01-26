########################################################
# Stage 1
# 获取构建需要用到的安装包
########################################################
FROM centralx/busybox:latest as builder
ARG TARGETARCH
ARG GOSU_VERSION
ARG CMDLINE_PACKAGE

WORKDIR /workspace
# 下载 gosu
ADD "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${TARGETARCH}" ./gosu
# 添加 entrypoint.sh
ADD ./stage/target/entrypoint.sh    ./entrypoint.sh

ADD ./stage/build/script.sh ./script.sh
RUN chmod +x ./script.sh && ./script.sh --target=/workspace/android --package=$CMDLINE_PACKAGE


########################################################
# Stage 2
# 复制程序包
# 设置相关环境变量
########################################################
FROM image

# 安装时区和常用工具
ENV TZ=Asia/Shanghai
RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata ca-certificates wget curl telnet iputils-ping nano vim zip unzip && \
    rm -rf /var/lib/apt/lists/*

# 复制镜像需要的程序包
COPY --from=builder /workspace/gosu               /usr/local/bin/gosu
COPY --from=builder /workspace/entrypoint.sh      /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/*

# 复制 Android SDK 到 /usr/android 目录下
COPY --from=builder /workspace/android            /usr/android
# 接受所有条款，这样后续在使用 sdkmanager 下载环境时，就不会提示是否接受条款
RUN yes | /usr/android/cmdline-tools/latest/bin/sdkmanager --licenses

# 提前设置 android 环境变量
# 在运行阶段将 /usr/android 复制 Android Home 目录下
# 这样开发者就可以将 Android Home 挂载出来
ENV ANDROID_HOME=/usr/local/android
ENV PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH

# 添加 runner 分组、runner 用户
# groupadd
# -r: 创建系统组
# -g: 指定用户组 GID
# useradd
# -r: 创建系统用户
# -m, --create-home: 创建用户主目录，默认是 /home/<user>
# -g: 指定用户所属组
# -u: 指定用户 UID
RUN groupadd -r -g 1000 runner && useradd -r -m -g runner -u 1000 runner

# 工作目录
WORKDIR /workspace

# 启动脚本
ENTRYPOINT ["entrypoint.sh"]