############################################################################
# Azul Zulu Builds of OpenJDK
# https://www.azul.com
############################################################################

#***************************************************************************
# Default Group
#***************************************************************************
group "default" {
    targets = [
        "openjdk-ubuntu",
        "openjdk-alpine"
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
        "org.opencontainers.image.title" = "openjdk"
        "org.opencontainers.image.description" = "OpenJDK packaged by CentralX"
        "org.opencontainers.image.vendor" = "CentralX"
        "org.opencontainers.image.maintainer" = "Alan Yeh <alan.yeh.cn>"
        "org.opencontainers.image.version" = "${OPENJDK_FULL_VERSION}"
    }
}

#***************************************************************************
# Global Argument
#***************************************************************************
# OpenJDK 短版本号
variable "OPENJDK_SHORT_VERSION" {
    default = null
}

# OpenJDK 完整版本号
variable "OPENJDK_FULL_VERSION" {
    default = null
}

# OpenJDK AMD64 架构程序包
variable "OPENJDK_AMD64_PACKAGE" {
    default = null
}

# OpenJDK ARM64 架构程序包
variable "OPENJDK_ARM64_PACKAGE" {
    default = null
}

#***************************************************************************
# Targets
#***************************************************************************
target "openjdk-ubuntu" {
    contexts = {
        image = "docker-image://ubuntu:jammy"
    }
    inherits = ["_platforms", "_labels"]
    dockerfile = "Dockerfile"
    labels = {
        "org.opencontainers.image.distribution" = "Ubuntu Jammy"
    }
    args = {
        SHORT_VERSION = "${OPENJDK_SHORT_VERSION}"
        FULL_VERSION  = "${OPENJDK_FULL_VERSION}"
        AMD64_PACKAGE = "${OPENJDK_AMD64_PACKAGE}"
        ARM64_PACKAGE = "${OPENJDK_ARM64_PACKAGE}"
    }
    tags = [
        "docker.io/centralx/openjdk:latest",
        "docker.io/centralx/openjdk:${OPENJDK_SHORT_VERSION}",
        "docker.io/centralx/openjdk:${OPENJDK_SHORT_VERSION}-ubuntu",
        "docker.io/centralx/openjdk:${OPENJDK_FULL_VERSION}",
        "docker.io/centralx/openjdk:${OPENJDK_FULL_VERSION}-ubuntu"
    ]
}

target "openjdk-alpine" {
    contexts = {
        image = "docker-image://alpine:3"
    }
    labels = {
        "org.opencontainers.image.distribution" = "Alpine 3"
    }
    inherits = ["_platforms", "_labels"]
    dockerfile = "Dockerfile"
    args = {
        SHORT_VERSION = "${OPENJDK_SHORT_VERSION}"
        FULL_VERSION  = "${OPENJDK_FULL_VERSION}"
        AMD64_PACKAGE = "${OPENJDK_AMD64_PACKAGE}"
        ARM64_PACKAGE = "${OPENJDK_ARM64_PACKAGE}"
    }
    tags = [
        "docker.io/centralx/openjdk:${OPENJDK_SHORT_VERSION}-alpine",
        "docker.io/centralx/openjdk:${OPENJDK_FULL_VERSION}-alpine"
    ]
}