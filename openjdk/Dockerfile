########################################################
# Stage 1
# 获取构建需要用到的安装包
########################################################
FROM ubuntu:jammy as builder
ARG AMD64_PACKAGE
ARG ARM64_PACKAGE

WORKDIR /workspace

# amd64 package
ADD $AMD64_PACKAGE ./amd64/jdk.tar.gz
RUN tar -zxvf ./amd64/jdk.tar.gz -C ./amd64 && \
    mkdir -p ./amd64/jdk && \
    mv ./amd64/*/* ./amd64/jdk

# arm64 package
ADD $ARM64_PACKAGE ./arm64/jdk.tar.gz
RUN tar -zxvf ./arm64/jdk.tar.gz -C ./arm64 && \
    mkdir -p ./arm64/jdk && \
    mv ./arm64/*/* ./arm64/jdk

########################################################
# Stage 2
# 只复制指定架构的包
# 设置相关环境变量
########################################################
FROM image

ARG TARGETARCH
ARG FULL_VERSION

COPY --from=builder /workspace/$TARGETARCH/jdk /usr/local/jdk

ENV JAVA_HOME=/usr/local/jdk
ENV JAVA_VERSION=$FULL_VERSION
ENV PATH=/usr/local/jdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG C.UTF-8

ENTRYPOINT ["java"]
CMD ["-version"]