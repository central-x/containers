########################################################
# Stage 1
# 获取构建需要用到的安装包
########################################################
FROM ubuntu:jammy as builder

ARG TARGETARCH
ARG IMAGE_VERSION
ARG GOSU_VERSION

WORKDIR /workspace

# 下载依赖
ADD "https://archive.apache.org/dist/hbase/${IMAGE_VERSION}/hbase-${IMAGE_VERSION}-bin.tar.gz" "./hbase-${IMAGE_VERSION}-bin.tar.gz"
# 下载 gosu
ADD "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${TARGETARCH}" ./gosu

RUN mkdir ./cache && \
    tar -zxvf ./hbase-${IMAGE_VERSION}-bin.tar.gz -C ./cache && \
    mkdir ./hbase && \
    mv ./cache/*/* ./hbase

# 下载 gosu
#RUN apt-get update;
#RUN apt-get install -y --no-install-recommends ca-certificates wget nano vim;
#RUN wget -O ./gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${TARGETARCH}";

# 添加 entrypoint.sh
ADD ./entrypoint.sh ./entrypoint.sh

########################################################
# Stage 2
# 安装时区
# 复制 gosu 和 entrypoint.sh
# 创建用户
# 创建工作目录、挂载点
# 执行启动脚本
########################################################
FROM image

# 工作目录
WORKDIR /workspace

# 安装时区、常用工具
ENV TZ=Asia/Shanghai
RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata ca-certificates curl telnet iputils-ping nano vim net-tools && \
    rm -rf /var/lib/apt/lists/*

# 复制启动可执行文件要用到的辅助工具
COPY --from=builder   /workspace/gosu            /usr/local/bin/gosu
COPY --from=builder   /workspace/entrypoint.sh   /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/*

# 复制 Hbase 程序文件和设置环境变量
COPY --from=builder   /workspace/hbase           ./hbase
ENV HBASE_HOME        /workspace/hbase
ENV HBASE_VERSION     $IMAGE_VERSION
ENV PATH=$HBASE_HOME/bin:$PATH

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

# /workspace/init: 应用初始化脚本目录，存放 .hbase 初始化文件
# /workspace/data: 应用数据目录
# /workspace/cache: 应用缓存/临时目录
RUN mkdir /workspace/init && mkdir /workspace/data && mkdir /workspace/cache
VOLUME ["/workspace/init", "/workspace/data", "/workspace/cache"]

# HBASE UI 入口
EXPOSE 16010

# 启动脚本
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]