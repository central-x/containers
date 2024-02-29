############################################################################
# Hbase
# https://hbase.apache.org
############################################################################

#***************************************************************************
# Default Group
#***************************************************************************
group "default" {
  targets = [
    "hbase"
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
    "org.opencontainers.image.title"       = "hbase"
    "org.opencontainers.image.description" = "Apache HBase"
    "org.opencontainers.image.vendor"      = "CentralX"
    "org.opencontainers.image.maintainer"  = "Alan Yeh <alan@yeh.cn>"
  }
}

#***************************************************************************
# Global Argument
#***************************************************************************
variable "IMAGE_VERSION" {
  default = "1.7.2"
}

variable "GOSU_VERSION" {
  default = "1.17"
}

#***************************************************************************
# Targets
#***************************************************************************
target "hbase" {
  contexts = {
    image = "docker-image://centralx/openjdk:8"
  }
  inherits   = ["_platforms", "_labels"]
  dockerfile = "Dockerfile"
  labels     = {
    "org.opencontainers.image.version" = "${IMAGE_VERSION}"
  }
  args = {
    GOSU_VERSION  = "${GOSU_VERSION}"
    IMAGE_VERSION = "${IMAGE_VERSION}"
  }
  tags = [
    "docker.io/centralx/hbase:latest",
    "docker.io/centralx/hbase:${IMAGE_VERSION}"
  ]
}