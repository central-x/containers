########################################################
# Stage 1
# 获取构建需要用到的安装包
########################################################
FROM alpine:3.18.2 as builder
ARG AMD64_PACKAGE
ARG ARM64_PACKAGE

WORKDIR /workspace

# amd64 package
ADD https://cdn.azul.com/zulu/bin/$AMD64_PACKAGE.tar.gz ./linux/amd64/jdk.tar.gz
RUN tar -zxvf ./linux/amd64/jdk.tar.gz -C ./linux/amd64 && \
    mkdir -p ./linux/amd64/jdk && \
    mv ./linux/amd64/$AMD64_PACKAGE/* ./linux/amd64/jdk

# arm64 package
ADD https://cdn.azul.com/zulu/bin/$ARM64_PACKAGE.tar.gz ./linux/arm64/jdk.tar.gz
RUN tar -zxvf ./linux/arm64/jdk.tar.gz -C ./linux/arm64 && \
    mkdir -p ./linux/arm64/jdk && \
    mv ./linux/arm64/$ARM64_PACKAGE/* ./linux/arm64/jdk

########################################################
# Stage 2
# 只复制指定架构的包
# 设置相关环境变量
########################################################
FROM --platform=$TARGETPLATFORM alpine:3.18.2
MAINTAINER Alan Yeh "alan@yeh.cn"

ARG TARGETPLATFORM
ARG OPENJDK_VERSION

COPY --from=builder /workspace/$TARGETPLATFORM/jdk /usr/local/jdk

ENV JAVA_HOME=/usr/local/jdk
ENV JAVA_VERSION=$OPENJDK_VERSION
ENV PATH=/usr/local/jdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG C.UTF-8

ENV TZ "Asia/Shanghai"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

CMD ["jshell"]