############################################################################
# Global inheritable target
############################################################################
group "default" {
    targets = [
        "openjdk"
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
variable "OPENJDK_VERSION" {
    default = "17.0.9"
}

variable "OPENJDK_SHORT_VERSION" {
    default = "17"
}

target "openjdk" {
    inherits = ["_platforms"]
    dockerfile = "Dockerfile"
    context = "./openjdk"
    args = {
        OPENJDK_SHORT_VERSION = "${OPENJDK_SHORT_VERSION}"
        OPENJDK_VERSION = "${OPENJDK_VERSION}"

        AMD64_PACKAGE = "https://cdn.azul.com/zulu/bin/zulu17.46.19-ca-jdk17.0.9-linux_musl_x64.tar.gz"
        ARM64_PACKAGE = "https://cdn.azul.com/zulu/bin/zulu17.46.19-ca-jdk17.0.9-linux_musl_aarch64.tar.gz"
    }
    tags = [
        "docker.io/centralx/openjdk:latest",
        "docker.io/centralx/openjdk:${OPENJDK_SHORT_VERSION}",
        "docker.io/centralx/openjdk:${OPENJDK_SHORT_VERSION}-alpine",
        "docker.io/centralx/openjdk:${OPENJDK_VERSION}",
        "docker.io/centralx/openjdk:${OPENJDK_VERSION}-alpine"
    ]
}