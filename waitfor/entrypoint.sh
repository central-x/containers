#!/bin/sh

# 脚本执行失败时脚本终止执行
set -o errexit
# 遇到未声明变量时脚本终止执行
set -o nounset
# 执行管道命令时，只要有一个子命令失败，则脚本终止执行
set -o pipefail
# 打印执行过程，主要用于调试
#set -o xtrace

#===========================================================================================
# TimeZone Configuration
#===========================================================================================
if [ -n "$TZ" ]; then
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi

#===========================================================================================
# Script
#===========================================================================================
case "$1" in
    time)
        echo "⏱ Wait $2 seconds"
        for i in $(seq 1 $2)
        do
            echo "💗 Remaining $(($2 - $i)) seconds..."
            sleep 1
        done
        echo "✅ Time's up!"
        exit 0
    ;;
    service)
        echo "⏱ Wait for service: $2.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local"
        while [ 1 ]; do
            # 执行命令
            set +o errexit
            output=$(nslookup "$2.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local")
            status=$?
            set -o errexit

            # 输出命令信息
            echo ""
            echo "============== $(date) =============="
            echo "\$ nslookup $2.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local"
            echo "$output"
            echo ""

            # 检查返回的状态码
            if [ "$status" == "0" ]; then
                echo "✅ Service Found"
                exit 0
            else
                echo "❌ Service Not Found"
                sleep 2
            fi
        done
        exit 0
    ;;
    api)
        echo "⏱ Wait for api: $2"
        while [ 1 ]; do
            # 发送 curl 请求，设置超时时间为 5 秒
            set +o errexit
            response=$(curl -s -m 5 -o /dev/null -w "%{http_code}" "$2")
            set -o errexit

            # 输出命令信息
            echo ""
            echo "============== $(date) =============="
            echo "\$ curl -s -m 5 -o /dev/null -w %{http_code} $2"
            echo ""

            # 检查返回的状态码
            if [ "$response" == "200" ]; then
                echo "✅ Response Status: 200"
                exit 0
            elif [ "$response" == "0" ]; then
                echo "❌ Response Timeout"
                sleep 2
            elif [ "$response" == "7" ]; then
                echo "❌ Server Not Reachable"
                sleep 2
            else
                echo "❌ Response Status: $response"
                sleep 2
            fi
        done
    ;;
    cmd)
        shift
        echo "⏱ Wait for cmd: $@"
        while [ 1 ]; do
            # 执行命令
            set +o errexit
            output=$($@)
            status=$?
            set -o errexit

            # 输出命令信息
            echo ""
            echo "============== $(date) =============="
            echo "\$ $@"
            echo "$output"
            echo ""

            # 检查返回的状态码
            if [ "$status" == "0" ]; then
                echo "✅ Exit Status: 0"
                exit 0
            else
                echo "❌ Exit Status: $status"
                sleep 2
            fi
        done
    ;;
esac