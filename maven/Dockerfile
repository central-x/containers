########################################################
# Stage 1
# 获取构建需要用到的安装包
########################################################
FROM centralx/busybox:latest as builder
ARG MAVEN_PACKAGE

WORKDIR /workspace

ADD ./stage/build/script.sh ./script.sh
RUN chmod +x ./script.sh && ./script.sh --target=/workspace/maven --package=$MAVEN_PACKAGE

########################################################
# Stage 2
# 只复制指定架构的包
# 设置相关环境变量
########################################################
FROM image

ARG VERSION

COPY --from=builder /workspace/maven /usr/local/maven

ENV MAVEN_VERSION=$VERSION
ENV MAVEN_HOME=/usr/local/maven
ENV PATH=$PATH:$MAVEN_HOME/bin

ENTRYPOINT ["mvn"]
CMD ["-version"]