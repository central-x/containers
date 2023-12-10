############################################################################
# Spring Application Runner
# https://spring.io
############################################################################

#***************************************************************************
# Default Group
#***************************************************************************
group "default" {
    targets = [
        "spring-runner-ubuntu",
        "spring-runner-alpine"
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
# Targets
#***************************************************************************
target "spring-runner-ubuntu" {
    name = "spring-runner-ubuntu-${OPENJDK_VERSION}-${DIST}"
    matrix = {
        OPENJDK_VERSION = ["8", "11", "17", "21"]
        DIST = ["jdk", "jre"]
    }
    contexts = {
        image = "docker-image://centralx/openjdk:${OPENJDK_VERSION}-${DIST}-ubuntu"
    }
    inherits = ["_platforms", "_labels"]
    dockerfile = "Dockerfile-ubuntu"
    labels = {
        "org.opencontainers.image.version" = "${OPENJDK_VERSION}"
    }
    args = {
        GOSU_VERSION  = "${GOSU_VERSION}"
    }
    tags = [
        "docker.io/centralx/spring-runner:${OPENJDK_VERSION}-${DIST}",
        "docker.io/centralx/spring-runner:${OPENJDK_VERSION}-${DIST}-ubuntu",
    ]
}

target "spring-runner-alpine" {
    name = "spring-runner-alpine-${OPENJDK_VERSION}-${DIST}"
    matrix = {
        OPENJDK_VERSION = ["8", "11", "17", "21"]
        DIST = ["jdk", "jre"]
    }
    contexts = {
        image = "docker-image://centralx/openjdk:${OPENJDK_VERSION}-${DIST}-alpine"
    }
    labels = {
        "org.opencontainers.image.version" = "${OPENJDK_VERSION}"
    }
    inherits = ["_platforms", "_labels"]
    dockerfile = "Dockerfile-alpine"
    args = {
        GOSU_VERSION  = "${GOSU_VERSION}"
    }
    tags = [
        "docker.io/centralx/spring-runner:${OPENJDK_VERSION}-${DIST}-alpine",
    ]
}