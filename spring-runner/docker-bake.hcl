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
        "org.opencontainers.image.maintainer" = "Alan Yeh <alan.yeh.cn>"
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
    name = "spring-runner-${replace(version.code, ".", "_")}-${type}-${os}"
    matrix = {
        // 版本
        version = [{
            major = "8"
            code  = "8.0.392"
        },{
            major = "11"
            code  = "11.0.21"
        }, {
            major = "17"
            code  = "17.0.9"
        }, {
            major = "21"
            code  = "21.0.1"
        }]
        // jdk 还是 jre
        type = ["jdk", "jre"]
        // 基础镜像发行版类型
        os = ["ubuntu", "alpine"]
    }
    contexts = {
        image = "docker-image://centralx/openjdk:${version.code}-${type}-${os}"
    }
    inherits = ["_platforms", "_labels"]
    dockerfile = "Dockerfile-${os}"
    labels = {
        "org.opencontainers.image.version" = "${version.code}"
    }
    args = {
        GOSU_VERSION  = "${GOSU_VERSION}"
    }
    tags = [
        // ubuntu 且 jdk 时才有的 tag
        if(and(equal("ubuntu", os), equal("jdk", type)), "docker.io/centralx/spring-runner:${version.major}"),
        if(and(equal("ubuntu", os), equal("jdk", type)), "docker.io/centralx/spring-runner:${version.code}"),

        // jdk 才有的 tag，jre 没有
        if(equal("jdk", type), "docker.io/centralx/spring-runner:${version.major}-${os}"),
        if(equal("jdk", type), "docker.io/centralx/spring-runner:${version.code}-${os}"),

        // ubuntu 才有的 tag，alpine 没有
        if(equal("ubuntu", os), "docker.io/centralx/spring-runner:${version.major}-${type}"),
        if(equal("ubuntu", os), "docker.io/centralx/spring-runner:${version.code}-${type}"),

        "docker.io/centralx/spring-runner:${version.major}-${type}-${os}",
        "docker.io/centralx/spring-runner:${version.code}-${type}-${os}"
    ]
}