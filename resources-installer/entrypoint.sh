#!/bin/sh

# 脚本执行失败时脚本终止执行
set -o errexit
# 遇到未声明变量时脚本终止执行
set -o nounset
# 执行管道命令时，只要有一个子命令失败，则脚本终止执行
set -o pipefail
# 打印执行过程
set -o xtrace

# 遍历 /resources 目录下所有的子文件夹
for dir in /resources/*; do
    # 获取 install.txt 文件。如果子文件内没有 install.txt 文件，则跳过
    if [ -f "$dir/install.txt" ]; then
        # 获取目标目录
        target_dir=$(cat "$dir/install.txt")

        # 创建目标目录
        mkdir -p "$target_dir"

        # 将资源文件夹下的所有文件复制到目标目录
        cp -r $dir/* "$target_dir"

        # 删除目标目录下的 install.txt 文件
        rm -f "$target_dir/install.txt"
    fi
done