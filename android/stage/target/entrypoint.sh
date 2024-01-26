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
if [ -n "$TZ" ]; then
    ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone
fi

#===========================================================================================
# Create Android Home
#
# 将 /usr/android 下的文件复制到开发者指定的 ANDROID_HOME
# 这样开发者就可以将 ANDROID_HOME 挂载出来而不会出问题
#===========================================================================================
mkdir -p "$ANDROID_HOME"
cp -r /usr/android/* "$ANDROID_HOME"

#===========================================================================================
# Grant Permissions
#
# 1. $ANDROID_HOME: 由于 Android SDK Manager 会在运行期下载文件，因此需要授权该目录
# 2. /workspace: 待编译应用所在目录
# 3. ./gradlew: gradlew 文件添加可执行权限
#===========================================================================================
set +o errexit
find . \! -user runner -exec chown runner:runner '{}' +
find "$ANDROID_HOME" \! -user runner -exec chown runner:runner '{}' +
chmod +x ./gradlew
set -o errexit

#===========================================================================================
# RUN
#===========================================================================================
if [ "$#" == "0" ]; then
    # 用户没有输入命令，则默认输出 sdkmanager 版本号
    exec gosu runner sdkmanager --version
else
    # 以 runner 用户运行开发者指定的命令
    exec gosu runner "$@"
fi