############################################################################
# Nexus Repository Manager
# https://sonatype.com
############################################################################

#***************************************************************************
# Default Group
#***************************************************************************
group "default" {
  targets = [
    "nexus3"
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
    "org.opencontainers.image.title"       = "Nexus Repository Manager"
    "org.opencontainers.image.description" = "The Nexus Repository Manager server with universal support for popular component formats."
    "org.opencontainers.image.vendor"      = "CentralX"
    "org.opencontainers.image.maintainer"  = "Alan Yeh <alan@yeh.cn>"
  }
}

#***************************************************************************
# Global Argument
#***************************************************************************
variable "GOSU_VERSION" {
  default = "1.17"
}

variable "VERSION" {
  default = "3.54.1-01"
}

#***************************************************************************
# Targets
#***************************************************************************
target "nexus3" {
  contexts = {
    image = "docker-image://centralx/openjdk:jdk8-ubuntu"
  }
  inherits   = ["_platforms", "_labels"]
  dockerfile = "Dockerfile"
  labels     = {
    "org.opencontainers.image.version"      = "${VERSION}"
  }
  args = {
    GOSU_VERSION  = "${GOSU_VERSION}"
    NEXUS_VERSION = "${VERSION}"
    NEXUS_PACKAGE = "https://download.sonatype.com/nexus/3/nexus-${VERSION}-unix.tar.gz"
  }
  tags = [
    "docker.io/centralx/nexus3:latest",
    "docker.io/centralx/nexus3:${substr(VERSION, 0, strlen(VERSION) - 3)}",
  ]
}