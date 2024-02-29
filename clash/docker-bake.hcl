############################################################################
# Clash
# https://central-x.com
############################################################################

#***************************************************************************
# Default Group
#***************************************************************************
group "default" {
  targets = [
    "clash"
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
    "org.opencontainers.image.title" = "clash"
    "org.opencontainers.image.description" = "Clash with Dashboard"
    "org.opencontainers.image.vendor" = "CentralX"
    "org.opencontainers.image.maintainer" = "Alan Yeh <alan@yeh.cn>"
  }
}

#***************************************************************************
# Global Argument
#***************************************************************************
variable "IMAGE_VERSION" {
  default = "1.18.0"
}

variable "GOSU_VERSION" {
  default = "1.17"
}

#***************************************************************************
# Targets
#***************************************************************************
target "clash" {
  contexts = {
    image = "docker-image://ubuntu:jammy"
  }
  inherits = ["_platforms", "_labels"]
  dockerfile = "Dockerfile"
  labels = {
    "org.opencontainers.image.version" = "${IMAGE_VERSION}"
  }
  args = {
    GOSU_VERSION  = "${GOSU_VERSION}"
  }
  tags = [
    "docker.io/centralx/clash:latest",
    "docker.io/centralx/clash:${IMAGE_VERSION}"
  ]
}