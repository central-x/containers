FROM image

# 添加脚本，并授予可执行权限
ADD ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/*

# 工作目录
WORKDIR /resources

# 启动脚本
ENTRYPOINT ["entrypoint.sh"]