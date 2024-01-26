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

# 下载 cmdline-tools
mkdir -p ./cache
wget -O ./package.zip "$package"
unzip ./package.zip -d ./cache
# 将 cmdline-tools 挪到指定位置
mkdir -p "$target/cmdline-tools/latest"
mv ./cache/*/* "$target/cmdline-tools/latest"

# 删除缓存
rm -rf ./cache