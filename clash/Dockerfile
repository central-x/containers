########################################################
# Stage 1
# 获取构建需要用到的安装包
########################################################
FROM centralx/busybox:latest as builder
ARG TARGETARCH
ARG GOSU_VERSION

WORKDIR /workspace

# 下载 gosu
ADD "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${TARGETARCH}" ./gosu
# 复制 clash 需要的包
ADD ./stage/target/amd64/clash          ./amd64/clash
ADD ./stage/target/arm64/clash          ./arm64/clash
ADD ./stage/target/Country.mmdb         ./Country.mmdb
ADD ./stage/target/html.tar.gz          ./
ADD ./stage/target/entrypoint.sh        ./entrypoint.sh
ADD ./stage/target/nginx/nginx.conf     ./nginx/nginx.conf
ADD ./stage/target/nginx/default.conf   ./nginx/default.conf

########################################################
# Stage 2
# 只复制指定架构的包
# 设置相关环境变量
########################################################
FROM image
ARG TARGETARCH

# 时区和字符集
ENV TZ=Asia/Shanghai
ENV LANG C.UTF-8
RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata ca-certificates nginx curl telnet iputils-ping nano vim && \
    rm -rf /var/lib/apt/lists/*

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

# 添加脚本，并授予可执行权限
COPY --from=builder /workspace/Country.mmdb          /home/runner/.config/clash/Country.mmdb
COPY --from=builder "/workspace/$TARGETARCH/clash"   /usr/local/bin/clash
COPY --from=builder /workspace/html                  /workspace/html
COPY --from=builder /workspace/entrypoint.sh         /usr/local/bin/entrypoint.sh
COPY --from=builder /workspace/gosu                  /usr/local/bin/gosu
RUN chmod +x /usr/local/bin/*

# 添加 nginx 配置
COPY --from=builder /workspace/nginx/nginx.conf      /etc/nginx/nginx.conf
COPY --from=builder /workspace/nginx/default.conf    /etc/nginx/conf.d/default.conf

# 80: Clash 管理端口
# 7890: 流量代理端口
EXPOSE 80/tcp
EXPOSE 7890/tcp

# 启动脚本
ENTRYPOINT ["entrypoint.sh"]