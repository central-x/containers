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
    default = "8.0.382"
}

variable "OPENJDK_SHORT_VERSION" {
    default = "8"
}

target "openjdk" {
    inherits = ["_platforms"]
    dockerfile = "Dockerfile"
    context = "./openjdk"
    args = {
        OPENJDK_SHORT_VERSION = "${OPENJDK_SHORT_VERSION}"
        OPENJDK_VERSION = "${OPENJDK_VERSION}"

        AMD64_PACKAGE = "zulu8.72.0.17-ca-jdk8.0.382-linux_musl_x64"
        ARM64_PACKAGE = "zulu8.72.0.17-ca-jdk8.0.382-linux_musl_aarch64"
    }
    tags = [
        "docker.io/centralx/openjdk:latest",
        "docker.io/centralx/openjdk:${OPENJDK_SHORT_VERSION}",
        "docker.io/centralx/openjdk:${OPENJDK_SHORT_VERSION}-alpine",
        "docker.io/centralx/openjdk:${OPENJDK_VERSION}",
        "docker.io/centralx/openjdk:${OPENJDK_VERSION}-alpine"
    ]
}