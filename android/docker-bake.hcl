############################################################################
# Android
# https://www.android.com
# https://developer.android.com
############################################################################

#***************************************************************************
# Default Group
#***************************************************************************
group "default" {
  targets = [
    "android"
  ]
}

#***************************************************************************
# Global inheritable target
#***************************************************************************
target "_platforms" {
  platforms = [
    # Android 编译环境在 Linux 下只支持 amd64 架构
    # "linux/arm64",
    "linux/amd64"
  ]
}

target "_labels" {
  labels = {
    "org.opencontainers.image.description" = "Android Packaged by CentralX"
    "org.opencontainers.image.vendor"      = "CentralX"
    "org.opencontainers.image.maintainer"  = "Alan Yeh <alan.yeh.cn>"
  }
}

#***************************************************************************
# Global Argument
#***************************************************************************
variable "GOSU_VERSION" {
  default = "1.17"
}

#***************************************************************************
# Targets
#***************************************************************************
target "android" {
  contexts = {
    image = "docker-image://centralx/openjdk:jdk11-ubuntu"
  }
  inherits   = ["_platforms", "_labels"]
  dockerfile = "Dockerfile"
  labels     = {
    "org.opencontainers.image.title"        = "android"
    "org.opencontainers.image.version"      = "9.0"
  }
  args = {
    GOSU_VERSION  = "${GOSU_VERSION}"
    CMDLINE_PACKAGE = "https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip"
  }
  tags = [
    "docker.io/centralx/android:latest",
    "docker.io/centralx/android:9.0"
  ]
}