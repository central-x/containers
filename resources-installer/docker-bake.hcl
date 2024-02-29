############################################################################
# Resources Installer
# https://central-x.com
############################################################################

#***************************************************************************
# Default Group
#***************************************************************************
group "default" {
    targets = [
        "resources-installer"
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
        "org.opencontainers.image.title" = "resources-installer"
        "org.opencontainers.image.description" = "Install resources"
        "org.opencontainers.image.vendor" = "CentralX"
        "org.opencontainers.image.maintainer" = "Alan Yeh <alan@yeh.cn>"
    }
}

#***************************************************************************
# Global Argument
#***************************************************************************
variable "IMAGE_VERSION" {
    default = "1.0.0"
}

#***************************************************************************
# Targets
#***************************************************************************
target "resources-installer" {
    contexts = {
        image = "docker-image://alpine:3"
    }
    inherits = ["_platforms", "_labels"]
    dockerfile = "Dockerfile"
    labels = {
        "org.opencontainers.image.version" = "${IMAGE_VERSION}"
    }
    tags = [
        "docker.io/centralx/resources-installer:latest",
        "docker.io/centralx/resources-installer:${IMAGE_VERSION}"
    ]
}