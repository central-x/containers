FROM image

# 时区
ENV TZ=Asia/Shanghai
RUN apk add --no-cache tzdata curl busybox busybox-extras

ADD ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/*

# 启动脚本
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]