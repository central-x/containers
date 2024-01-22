#!/bin/bash
# 脚本执行失败时脚本终止执行
set -o errexit
# 遇到未声明变量时脚本终止执行
set -o nounset
# 执行管道命令时，只要有一个子命令失败，则脚本终止执行
set -o pipefail
# 打印执行过程
set -o xtrace

# 取参数
arch=""
target=""
amd64=""
arm64=""

for arg in "$@" ; do
    case "$arg" in
        --arch=*)
            arch="${arg#*=}"
        ;;
        --target=*)
            target="${arg#*=}"
        ;;
        --amd64=*)
            amd64="${arg#*=}"
        ;;
        --arm64=*)
            arm64="${arg#*=}"
        ;;
    esac
done

# 根据 CPU 架构下载安装包
if [ "$arch" == "arm64" ]; then
    wget -O ./java.tar.gz "$arm64"
else
    wget -O ./java.tar.gz "$amd64"
fi

# 解压
mkdir ./java
tar -zxvf ./java.tar.gz -C ./java
# 删除安装包，释放空间
rm -f java.tar.gz
# 将安装包复制到指定路径
mkdir -p "$target"
mv ./java/*/* "$target"