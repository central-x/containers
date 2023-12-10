############################################################################
# Spring Application Runner
# https://spring.io
############################################################################

#***************************************************************************
# Default Group
#***************************************************************************
group "default" {
    targets = [
        "spring-runner-jdk-ubuntu",
        "spring-runner-jre-ubuntu",
        "spring-runner-jdk-alpine",
        "spring-runner-jre-alpine"
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
target "spring-runner-jdk-ubuntu" {
    name = "spring-runner-${replace(OPENJDK_VERSION, ".", "-")}-jdk-ubuntu"
    matrix = {
        OPENJDK_VERSION = ["8", "8.0.392", "11", "11.0.21", "17", "17.0.9", "21", "21.0.1"]
    }
    contexts = {
        image = "docker-image://centralx/openjdk:${OPENJDK_VERSION}-jdk-ubuntu"
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
        "docker.io/centralx/spring-runner:${OPENJDK_VERSION}",
        "docker.io/centralx/spring-runner:${OPENJDK_VERSION}-jdk",
        "docker.io/centralx/spring-runner:${OPENJDK_VERSION}-ubuntu",
        "docker.io/centralx/spring-runner:${OPENJDK_VERSION}-jdk-ubuntu",
    ]
}

target "spring-runner-jre-ubuntu" {
    name = "spring-runner-${replace(OPENJDK_VERSION, ".", "-")}-jre-ubuntu"
    matrix = {
        OPENJDK_VERSION = ["8", "8.0.392", "11", "11.0.21", "17", "17.0.9", "21", "21.0.1"]
    }
    contexts = {
        image = "docker-image://centralx/openjdk:${OPENJDK_VERSION}-jre-ubuntu"
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
        "docker.io/centralx/spring-runner:${OPENJDK_VERSION}-jre",
        "docker.io/centralx/spring-runner:${OPENJDK_VERSION}-jre-ubuntu",
    ]
}

target "spring-runner-jdk-alpine" {
    name = "spring-runner-${replace(OPENJDK_VERSION, ".", "-")}-jdk-alpine"
    matrix = {
        OPENJDK_VERSION = ["8", "8.0.392", "11", "11.0.21", "17", "17.0.9", "21", "21.0.1"]
    }
    contexts = {
        image = "docker-image://centralx/openjdk:${OPENJDK_VERSION}-jdk-alpine"
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
        "docker.io/centralx/spring-runner:${OPENJDK_VERSION}-alpine",
        "docker.io/centralx/spring-runner:${OPENJDK_VERSION}-jdk-alpine",
    ]
}

target "spring-runner-jre-alpine" {
    name = "spring-runner-${replace(OPENJDK_VERSION, ".", "-")}-jre-alpine"
    matrix = {
        OPENJDK_VERSION = ["8", "8.0.392", "11", "11.0.21", "17", "17.0.9", "21", "21.0.1"]
    }
    contexts = {
        image = "docker-image://centralx/openjdk:${OPENJDK_VERSION}-jre-alpine"
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
        "docker.io/centralx/spring-runner:${OPENJDK_VERSION}-jre-alpine",
    ]
}