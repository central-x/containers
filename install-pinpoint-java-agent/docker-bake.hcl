############################################################################
# Install Pinpoint Java Agent
# https://central-x.com
############################################################################

#***************************************************************************
# Default Group
#***************************************************************************
group "default" {
    targets = [
        "install-pinpoint-java-agent"
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
        "org.opencontainers.image.title" = "install-pinpoint-java-agent"
        "org.opencontainers.image.description" = "Install Pinpoint Java Agent"
        "org.opencontainers.image.vendor" = "CentralX"
        "org.opencontainers.image.maintainer" = "Alan Yeh <alan.yeh.cn>"
    }
}

#***************************************************************************
# Global Argument
#***************************************************************************
variable "AGENT_VERSION" {
    default = "2.5.3"
}

#***************************************************************************
# Targets
#***************************************************************************
target "install-pinpoint-java-agent" {
    contexts = {
        image = "docker-image://centralx/resources-installer:latest"
    }
    inherits = ["_platforms", "_labels"]
    dockerfile = "Dockerfile"
    labels = {
        "org.opencontainers.image.version" = "${AGENT_VERSION}"
    }
    tags = [
        "docker.io/centralx/install-pinpoint-java-agent:latest",
        "docker.io/centralx/install-pinpoint-java-agent:${AGENT_VERSION}"
    ]
}