############################################################################
# Busybox
# https://central-x.com
############################################################################

#***************************************************************************
# Default Group
#***************************************************************************
group "default" {
  targets = [
    "busybox"
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
    "org.opencontainers.image.title" = "busybox"
    "org.opencontainers.image.description" = "Busybox"
    "org.opencontainers.image.vendor" = "CentralX"
    "org.opencontainers.image.maintainer" = "Alan Yeh <alan.yeh.cn>"
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
target "busybox" {
  contexts = {
    image = "docker-image://ubuntu:jammy"
  }
  inherits = ["_platforms", "_labels"]
  dockerfile = "Dockerfile"
  labels = {
    "org.opencontainers.image.version" = "${IMAGE_VERSION}"
  }
  tags = [
    "docker.io/centralx/busybox:latest",
    "docker.io/centralx/busybox:${IMAGE_VERSION}"
  ]
}