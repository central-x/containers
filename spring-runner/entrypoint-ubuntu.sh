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
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi

#===========================================================================================
# Grant Permissions
#===========================================================================================
set +o errexit
find . \! -user runner -exec chown runner '{}' +
set -o errexit

#===========================================================================================
# Build JAVA Options
#===========================================================================================
JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom"

#===========================================================================================
# Build Spring Options
#===========================================================================================
SPRING_OPTS="-Dspring.config.additional-location=optional:./config/"

#===========================================================================================
# Run Application
#===========================================================================================
EXECUTABLE="application.jar"
if [ -v RUNNER_EXECUTABLE ]; then
    EXECUTABLE="$RUNNER_EXECUTABLE"
fi

exec gosu runner java "$JAVA_OPTS" "$SPRING_OPTS" "$@" -jar "$EXECUTABLE"