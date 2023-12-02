############################################################################
# Global inheritable target
############################################################################
group "default" {
    targets = [
        "openjdk-alpine",
        "openjdk-ubuntu"
    ]
}

############################################################################
# Global inheritable target
############################################################################
target "_platforms" {
    platforms = [
        "linux/arm64", 
        "linux/amd64"
    ]
}

############################################################################
# Azul Zulu Builds of OpenJDK
# https://www.azul.com
############################################################################
variable "OPENJDK_SHORT_VERSION" {
    default = null
}

variable "OPENJDK_FULL_VERSION" {
    default = null
}

variable "OPENJDK_AMD64_PACKAGE" {
    default = null
}

variable "OPENJDK_ARM64_PACKAGE" {
    default = null
}

target "openjdk-alpine" {
    inherits = ["_platforms"]
    dockerfile = "Dockerfile-alpine"
    args = {
        SHORT_VERSION = "${OPENJDK_SHORT_VERSION}"
        FULL_VERSION  = "${OPENJDK_FULL_VERSION}"
        AMD64_PACKAGE = "${OPENJDK_AMD64_PACKAGE}"
        ARM64_PACKAGE = "${OPENJDK_ARM64_PACKAGE}"
    }
    tags = [
        "docker.io/centralx/openjdk:latest",
        "docker.io/centralx/openjdk:${OPENJDK_SHORT_VERSION}",
        "docker.io/centralx/openjdk:${OPENJDK_SHORT_VERSION}-alpine",
        "docker.io/centralx/openjdk:${OPENJDK_FULL_VERSION}",
        "docker.io/centralx/openjdk:${OPENJDK_FULL_VERSION}-alpine"
    ]
}

target "openjdk-ubuntu" {
    inherits = ["_platforms"]
    dockerfile = "Dockerfile-ubuntu"
    args = {
        SHORT_VERSION = "${OPENJDK_SHORT_VERSION}"
        FULL_VERSION  = "${OPENJDK_FULL_VERSION}"
        AMD64_PACKAGE = "${OPENJDK_AMD64_PACKAGE}"
        ARM64_PACKAGE = "${OPENJDK_ARM64_PACKAGE}"
    }
    tags = [
        "docker.io/centralx/openjdk:${OPENJDK_SHORT_VERSION}-ubuntu",
        "docker.io/centralx/openjdk:${OPENJDK_FULL_VERSION}-ubuntu"
    ]
}