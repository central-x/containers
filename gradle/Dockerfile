########################################################
# Stage 1
# 获取构建需要用到的安装包
########################################################
FROM centralx/busybox:latest as builder
ARG GRADLE_PACKAGE

WORKDIR /workspace

ADD ./stage/build/script.sh ./script.sh
RUN chmod +x ./script.sh && ./script.sh --target=/workspace/gradle --package=$GRADLE_PACKAGE

########################################################
# Stage 2
# 只复制指定架构的包
# 设置相关环境变量
########################################################
FROM image

ARG VERSION

COPY --from=builder /workspace/gradle /usr/local/gradle

ENV GRADLE_VERSION=$VERSION
ENV GRADLE_HOME=/usr/local/gradle
ENV PATH=$PATH:$GRADLE_HOME/bin

ENTRYPOINT ["gradle"]
CMD ["-version"]