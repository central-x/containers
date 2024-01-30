########################################################
# Stage 1
# 获取构建需要用到的安装包
########################################################
FROM centralx/busybox:latest as builder
ARG TARGETARCH
ARG GOSU_VERSION
ARG NEXUS_PACKAGE

WORKDIR /workspace

# 下载 Nexus 应用包
ADD ./stage/build/script.sh ./script.sh
RUN chmod +x ./script.sh && ./script.sh --target=/workspace/nexus --package=$NEXUS_PACKAGE

# 下载 gosu
ADD "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${TARGETARCH}" ./gosu
# 添加 entrypoint.sh
ADD ./stage/target/entrypoint.sh ./entrypoint.sh

########################################################
# Stage 2
# 安装时区
# 复制 gosu 和 entrypoint.sh
# 创建用户
# 创建工作目录、挂载点
# 执行启动脚本
########################################################
FROM image

ARG NEXUS_VERSION

ENV NEXUS_HOME=/workspace/nexus
ENV PATH=$PATH:$NEXUS_HOME/bin
ENV NEXUS_DATA=/workspace/data
ENV NEXUS_CONTEXT=''

# 时区
ENV TZ=Asia/Shanghai
RUN apt-get update && \
apt-get install -y --no-install-recommends tzdata ca-certificates curl telnet iputils-ping nano vim && \
rm -rf /var/lib/apt/lists/*

# 复制启动可执行文件要用到的辅助工具
COPY --from=builder   /workspace/gosu            /usr/local/bin/gosu
COPY --from=builder   /workspace/entrypoint.sh   /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/*

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

COPY --from=builder /workspace/nexus/nexus-${NEXUS_VERSION} ${NEXUS_HOME}
COPY --from=builder /workspace/nexus/sonatype-work          /workspace/sonatype-work

# 暴露端口
EXPOSE 8081

RUN mkdir -p $NEXUS_DATA && \
    mv /workspace/sonatype-work/* "$NEXUS_DATA" && \
    ln -s "$NEXUS_DATA" /workspace/sonatype-work/nexus3

# 启动脚本
ENTRYPOINT ["entrypoint.sh"]