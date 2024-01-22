FROM image

# 安装工具
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates wget curl telnet iputils-ping nano vim zip unzip && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash"]