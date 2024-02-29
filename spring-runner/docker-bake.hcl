############################################################################
# Spring Application Runner
# https://spring.io
############################################################################

#***************************************************************************
# Default Group
#***************************************************************************
group "default" {
    targets = [
        "spring-runner"
    ]
}

#***************************************************************************
# Global inheritable target
#***************************************************************************
target "_platforms" {
    platforms = [
        "linux/arm64",
        "linux/amd64"
    ]
}

target "_labels" {
    labels = {
        "org.opencontainers.image.title" = "spring-runner"
        "org.opencontainers.image.description" = "Spring Application Runner packaged by CentralX"
        "org.opencontainers.image.vendor" = "CentralX"
        "org.opencontainers.image.maintainer" = "Alan Yeh <alan@yeh.cn>"
    }
}

#***************************************************************************
# Global Argument
#***************************************************************************
variable "GOSU_VERSION" {
    default = "1.17"
}

#***************************************************************************
# Global Function
#***************************************************************************
function "if" {
    params = [condition, true_return]
    result =  condition ? true_return : ""
}

#***************************************************************************
# Targets
#***************************************************************************
target "spring-runner" {
    name = "spring-runner-${java}${version}-${os}"
    matrix = {
        // 版本
        version = ["8", "11", "17", "21"]
        // java 类型
        java = ["jdk", "jre"]
        // 基础镜像发行版类型
        os = ["ubuntu", "alpine"]
    }
    contexts = {
        image = "docker-image://centralx/openjdk:${java}${version}-${os}"
    }
    inherits = ["_platforms", "_labels"]
    dockerfile = "Dockerfile-${os}"
    labels = {
        "org.opencontainers.image.version" = "${version}"
    }
    args = {
        GOSU_VERSION  = "${GOSU_VERSION}"
    }
    tags = [
        // ubuntu 且 jdk 时才有的 tag
        if(and(equal("ubuntu", os), equal("jdk", java)), "docker.io/centralx/spring-runner:${version}"),
        // ubuntu 才有的 tag，alpine 没有
        if(equal("ubuntu", os), "docker.io/centralx/spring-runner:${java}${version}"),
        // 通用
        "docker.io/centralx/spring-runner:${java}${version}-${os}",
    ]
}