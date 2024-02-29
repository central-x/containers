############################################################################
# Install Fonts
# https://central-x.com
############################################################################

#***************************************************************************
# Default Group
#***************************************************************************
group "default" {
    targets = [
        "install-fonts"
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
        "org.opencontainers.image.title" = "install-fonts"
        "org.opencontainers.image.description" = "Install Fonts"
        "org.opencontainers.image.vendor" = "CentralX"
        "org.opencontainers.image.maintainer" = "Alan Yeh <alan@yeh.cn>"
    }
}

#***************************************************************************
# Global Argument
#***************************************************************************
variable "FONT_VERSION" {
    default = "1.0.0"
}

#***************************************************************************
# Targets
#***************************************************************************
target "install-fonts" {
    contexts = {
        image = "docker-image://centralx/resources-installer:latest"
    }
    inherits = ["_platforms", "_labels"]
    dockerfile = "Dockerfile"
    labels = {
        "org.opencontainers.image.version" = "${FONT_VERSION}"
    }
    tags = [
        "docker.io/centralx/install-fonts:latest",
        "docker.io/centralx/install-fonts:${FONT_VERSION}"
    ]
}