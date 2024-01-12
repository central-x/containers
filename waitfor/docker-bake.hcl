############################################################################
# Wait for
# https://central-x.com
############################################################################

#***************************************************************************
# Default Group
#***************************************************************************
group "default" {
    targets = [
        "waitfor"
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
        "org.opencontainers.image.title" = "waitfor"
        "org.opencontainers.image.description" = "Wait for"
        "org.opencontainers.image.vendor" = "CentralX"
        "org.opencontainers.image.maintainer" = "Alan Yeh <alan.yeh.cn>"
    }
}

#***************************************************************************
# Global Argument
#***************************************************************************
variable "IMAGE_VERSION" {
    default = "1.2.0"
}

#***************************************************************************
# Targets
#***************************************************************************
target "waitfor" {
    contexts = {
        image = "docker-image://alpine:3"
    }
    inherits = ["_platforms", "_labels"]
    dockerfile = "Dockerfile"
    labels = {
        "org.opencontainers.image.version" = "${IMAGE_VERSION}"
    }
    tags = [
        "docker.io/centralx/waitfor:latest",
        "docker.io/centralx/waitfor:${IMAGE_VERSION}"
    ]
}