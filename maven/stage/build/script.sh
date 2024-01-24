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
target=""
package=""

for arg in "$@" ; do
    case "$arg" in
        --target=*)
            target="${arg#*=}"
        ;;
        --package=*)
            package="${arg#*=}"
        ;;
    esac
done

# 下载安装包
wget -O ./maven.tar.gz "$package"

# 解压
mkdir ./cache
tar -zxvf ./maven.tar.gz -C ./cache
# 删除安装包，释放空间
rm -f ./maven.tar.gz
# 将安装包复制到指定路径
mkdir -p "$target"
mv ./cache/*/* "$target"