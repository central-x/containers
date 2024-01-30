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
# Application Configuration
#===========================================================================================
echo "-Djava.util.prefs.userRoot=${NEXUS_DATA}/javaprefs" >> "$NEXUS_HOME/bin/nexus.vmoptions"
# 修改上下文
sed -e '/^nexus-context/ s:$:${NEXUS_CONTEXT}:' -i "${NEXUS_HOME}/etc/nexus-default.properties"

#===========================================================================================
# Grant Permissions
#===========================================================================================
set +o errexit
find . \! -user runner -exec chown runner:runner '{}' +
set -o errexit

#===========================================================================================
# Run Application
#===========================================================================================
if [ "$#" == "0" ]; then
    exec gosu runner nexus run
else
    # 运行开发人员指定的程序
    exec gosu runner "$@"
fi