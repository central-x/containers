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

variable "ENV_VERSION" {
    default = "all"
}

variable "ENV_JAVA" {
    default = "all"
}

variable "ENV_OS" {
    default = "all"
}

#***************************************************************************
# Global Function
#***************************************************************************
function "if" {
    params = [condition, true_return]
    result =  condition ? [true_return] : []
}

#***************************************************************************
# Targets
#***************************************************************************
target "spring-runner" {
    name = "spring-runner-${java}${version}-${os}"
    matrix = {
        // 版本
        version = flatten([
            if(contains(["all", "8"], "${ENV_VERSION}"), "8"),
            if(contains(["all", "11"], "${ENV_VERSION}"), "11"),
            if(contains(["all", "17"], "${ENV_VERSION}"), "17"),
            if(contains(["all", "21"], "${ENV_VERSION}"), "21")
        ])
        // java 类型
        java = flatten([
            if(contains(["all", "jdk"], "${ENV_JAVA}"), "jdk"),
            if(contains(["all", "jre"], "${ENV_JAVA}"), "jre")
        ])
        // 基础镜像发行版类型
        os = flatten([
            if(contains(["all", "ubuntu"], "${ENV_OS}"), "ubuntu"),
            if(contains(["all", "alpine"], "${ENV_OS}"), "alpine")
        ])
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
    tags = flatten([
        // ubuntu 且 jdk 时才有的 tag
        if(and(equal("ubuntu", os), equal("jdk", java)), "docker.io/centralx/spring-runner:${version}"),
        // ubuntu 才有的 tag，alpine 没有
        if(equal("ubuntu", os), "docker.io/centralx/spring-runner:${java}${version}"),
        // 通用
        "docker.io/centralx/spring-runner:${java}${version}-${os}",
    ])
}