########################################################
# Stage 1
# 获取构建需要用到的安装包
########################################################
FROM centralx/busybox:latest as builder
ARG TARGETARCH
ARG TARGET
ARG AMD64_PACKAGE
ARG ARM64_PACKAGE

WORKDIR /workspace

ADD ./stage/build/script.sh ./script.sh
RUN chmod +x ./script.sh && \
    ./script.sh --arch=$TARGETARCH --target=/workspace/$TARGET --amd64=$AMD64_PACKAGE --arm64=$ARM64_PACKAGE

########################################################
# Stage 2
# 只复制指定架构的包
# 设置相关环境变量
########################################################
FROM image

ARG VERSION
ARG TARGET

COPY --from=builder /workspace/$TARGET /usr/local/$TARGET

ENV JAVA_VERSION=$VERSION
ENV JAVA_HOME=/usr/local/$TARGET
ENV PATH=$JAVA_HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG C.UTF-8

ENTRYPOINT ["java"]
CMD ["-version"]