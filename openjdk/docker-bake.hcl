############################################################################
# Azul Zulu Builds of OpenJDK
# https://www.azul.com
############################################################################

#***************************************************************************
# Default Group
#***************************************************************************
group "default" {
    targets = [
        "openjdk-jdk-ubuntu",
        "openjdk-jre-ubuntu",
        "openjdk-jdk-alpine",
        "openjdk-jre-alpine"
    ]
}

group "openjdk-ubuntu" {
    targets = [
        "openjdk-jdk-ubuntu",
        "openjdk-jre-ubuntu"
    ]
}

group "openjdk-alpine" {
    targets = [
        "openjdk-jdk-alpine",
        "openjdk-jre-alpine"
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

# OpenJDK AMD64 架构 JDK 程序包
variable "OPENJDK_AMD64_JDK_PACKAGE" {
    default = null
}

# OpenJDK ARM64 架构 JDK 程序包
variable "OPENJDK_ARM64_JDK_PACKAGE" {
    default = null
}

# OpenJDK AMD64 架构 JRE 程序包
variable "OPENJDK_AMD64_JRE_PACKAGE" {
    default = null
}

# OpenJDK ARM64 架构 JRE 程序包
variable "OPENJDK_ARM64_JRE_PACKAGE" {
    default = null
}

#***************************************************************************
# Targets
#***************************************************************************
target "openjdk-jdk-ubuntu" {
    contexts = {
        image = "docker-image://ubuntu:jammy"
    }
    inherits = ["_platforms", "_labels"]
    dockerfile = "Dockerfile"
    labels = {
        "org.opencontainers.image.title" = "openjdk"
        "org.opencontainers.image.distribution" = "Ubuntu Jammy"
    }
    args = {
        SHORT_VERSION = "${OPENJDK_SHORT_VERSION}"
        FULL_VERSION  = "${OPENJDK_FULL_VERSION}"
        AMD64_PACKAGE = "${OPENJDK_AMD64_JDK_PACKAGE}"
        ARM64_PACKAGE = "${OPENJDK_ARM64_JDK_PACKAGE}"
        DIST = "jdk"
    }
    tags = [
        "docker.io/centralx/openjdk:${OPENJDK_SHORT_VERSION}",
        "docker.io/centralx/openjdk:${OPENJDK_SHORT_VERSION}-jdk",
        "docker.io/centralx/openjdk:${OPENJDK_FULL_VERSION}",
        "docker.io/centralx/openjdk:${OPENJDK_FULL_VERSION}-jdk",
        "docker.io/centralx/openjdk:${OPENJDK_SHORT_VERSION}-ubuntu",
        "docker.io/centralx/openjdk:${OPENJDK_SHORT_VERSION}-jdk-ubuntu",
        "docker.io/centralx/openjdk:${OPENJDK_FULL_VERSION}-ubuntu",
        "docker.io/centralx/openjdk:${OPENJDK_FULL_VERSION}-jdk-ubuntu"
    ]
}

target "openjdk-jre-ubuntu" {
    contexts = {
        image = "docker-image://ubuntu:jammy"
    }
    inherits = ["_platforms", "_labels"]
    dockerfile = "Dockerfile"
    labels = {
        "org.opencontainers.image.title" = "openjdk-jre"
        "org.opencontainers.image.distribution" = "Ubuntu Jammy"
    }
    args = {
        SHORT_VERSION = "${OPENJDK_SHORT_VERSION}"
        FULL_VERSION  = "${OPENJDK_FULL_VERSION}"
        AMD64_PACKAGE = "${OPENJDK_AMD64_JRE_PACKAGE}"
        ARM64_PACKAGE = "${OPENJDK_ARM64_JRE_PACKAGE}"
        DIST = "jre"
    }
    tags = [
        "docker.io/centralx/openjdk:${OPENJDK_SHORT_VERSION}-jre",
        "docker.io/centralx/openjdk:${OPENJDK_FULL_VERSION}-jre",
        "docker.io/centralx/openjdk:${OPENJDK_SHORT_VERSION}-jre-ubuntu",
        "docker.io/centralx/openjdk:${OPENJDK_FULL_VERSION}-jre-ubuntu"
    ]
}

target "openjdk-jdk-alpine" {
    contexts = {
        image = "docker-image://alpine:3"
    }
    labels = {
        "org.opencontainers.image.title" = "openjdk"
        "org.opencontainers.image.distribution" = "Alpine 3"
    }
    inherits = ["_platforms", "_labels"]
    dockerfile = "Dockerfile"
    args = {
        SHORT_VERSION = "${OPENJDK_SHORT_VERSION}"
        FULL_VERSION  = "${OPENJDK_FULL_VERSION}"
        AMD64_PACKAGE = "${OPENJDK_AMD64_JDK_PACKAGE}"
        ARM64_PACKAGE = "${OPENJDK_ARM64_JDK_PACKAGE}"
        DIST = "jdk"
    }
    tags = [
        "docker.io/centralx/openjdk:${OPENJDK_SHORT_VERSION}-alpine",
        "docker.io/centralx/openjdk:${OPENJDK_SHORT_VERSION}-jdk-alpine",
        "docker.io/centralx/openjdk:${OPENJDK_FULL_VERSION}-alpine",
        "docker.io/centralx/openjdk:${OPENJDK_FULL_VERSION}-jdk-alpine"
    ]
}

target "openjdk-jre-alpine" {
    contexts = {
        image = "docker-image://alpine:3"
    }
    labels = {
        "org.opencontainers.image.title" = "openjdk-jre"
        "org.opencontainers.image.distribution" = "Alpine 3"
    }
    inherits = ["_platforms", "_labels"]
    dockerfile = "Dockerfile"
    args = {
        SHORT_VERSION = "${OPENJDK_SHORT_VERSION}"
        FULL_VERSION  = "${OPENJDK_FULL_VERSION}"
        AMD64_PACKAGE = "${OPENJDK_AMD64_JRE_PACKAGE}"
        ARM64_PACKAGE = "${OPENJDK_ARM64_JRE_PACKAGE}"
        DIST = "jre"
    }
    tags = [
        "docker.io/centralx/openjdk:${OPENJDK_SHORT_VERSION}-jre-alpine",
        "docker.io/centralx/openjdk:${OPENJDK_FULL_VERSION}-jre-alpine"
    ]
}