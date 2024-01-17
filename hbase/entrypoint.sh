#!/bin/bash

# 脚本执行失败时脚本终止执行
set -o errexit
# 遇到未声明变量时脚本终止执行
set -o nounset
# 执行管道命令时，只要有一个子命令失败，则脚本终止执行
set -o pipefail
# 打印执行过程
set -o xtrace

#===========================================================================================
# TimeZone Configuration
#===========================================================================================
if [ -v TZ ]; then
    ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone
fi

#===========================================================================================
# Application Configuration
#===========================================================================================
# 将 /workspace/config 目录下的配置文件复制到 /workspace/hbase/conf 目录下
cp ./config/* /workspace/hbase/conf

#===========================================================================================
# Grant Permissions
#===========================================================================================
set +o errexit
find . \! -user runner -exec chown runner:runner '{}' +
chmod +x ./hbase/bin/*
set -o errexit

#===========================================================================================
# Run HBase
#===========================================================================================
# 启动程序
gosu runner start-hbase.sh

# 等待节点初始化
sleep 30

# 初始化表结构
for file in ./init/*.hbase; do
gosu runner hbase shell "$file"
done

# 监听退出信号
trap "gosu runner stop-hbase.sh" SIGTERM

# 保持进程不退出
tail -f /dev/null