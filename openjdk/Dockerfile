########################################################
# Stage 1
# 获取构建需要用到的安装包
########################################################
FROM ubuntu:jammy as builder
ARG AMD64_PACKAGE
ARG ARM64_PACKAGE
ARG DIST

WORKDIR /workspace

# amd64 package
ADD $AMD64_PACKAGE ./amd64/$DIST.tar.gz
RUN tar -zxvf ./amd64/$DIST.tar.gz -C ./amd64 && \
    mkdir -p ./amd64/$DIST && \
    mv ./amd64/*/* ./amd64/$DIST

# arm64 package
ADD $ARM64_PACKAGE ./arm64/$DIST.tar.gz
RUN tar -zxvf ./arm64/$DIST.tar.gz -C ./arm64 && \
    mkdir -p ./arm64/$DIST && \
    mv ./arm64/*/* ./arm64/$DIST

########################################################
# Stage 2
# 只复制指定架构的包
# 设置相关环境变量
########################################################
FROM image

ARG TARGETARCH
ARG FULL_VERSION
ARG DIST

COPY --from=builder /workspace/$TARGETARCH/$DIST /usr/local/$DIST

ENV JAVA_HOME=/usr/local/$DIST
ENV JAVA_VERSION=$FULL_VERSION
ENV PATH=/usr/local/$DIST/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG C.UTF-8

ENTRYPOINT ["java"]
CMD ["-version"]