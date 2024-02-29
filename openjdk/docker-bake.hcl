############################################################################
# Azul Zulu Builds of OpenJDK
# https://www.azul.com
############################################################################

#***************************************************************************
# Groups
#***************************************************************************
group "default" {
  targets = [
    "openjdk"
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
    "org.opencontainers.image.vendor"     = "CentralX"
    "org.opencontainers.image.maintainer" = "Alan Yeh <alan@yeh.cn>"
  }
}

#***************************************************************************
# Global Function
#***************************************************************************
variable "ENV_VERSION" {
  default = "all"
}

variable "ENV_JAVA" {
  default = "all"
}

variable "ENV_OS" {
  default = "all"
}

#***************************************************************************
# Global Function
#***************************************************************************
function "if" {
  params = [condition, true_return]
  result = condition ? [true_return] : []
}

#***************************************************************************
# Targets
#***************************************************************************
target "openjdk" {
  name   = "openjdk-${java}${replace(version.code, ".", "_")}-${os.name}"
  matrix = {
    // 版本
    version = flatten([
      // 8
      if(contains(["all", "8"], "${ENV_VERSION}"), {
        major = "8"
        code  = "8.0.402"
        zulu  = "8.76.0.17"
      }),
      // 11
      if(contains(["all", "11"], "${ENV_VERSION}"), {
        major = "11"
        code  = "11.0.22"
        zulu  = "11.70.15"
      }),
      // 17
      if(contains(["all", "17"], "${ENV_VERSION}"), {
        major = "17"
        code  = "17.0.10"
        zulu  = "17.48.15"
      }),
      // 21
      if(contains(["all", "21"], "{$ENV_VERSION}"), {
        major = "21"
        code  = "21.0.2"
        zulu  = "21.32.17"
      })
    ])
    // java 类型
    java = flatten([
      if(contains(["all", "jdk"], "${ENV_JAVA}"), "jdk"),
      if(contains(["all", "jre"], "${ENV_JAVA}"), "jre")
    ])
    // 基础镜像发行版类型
    os = flatten([
      // ubuntu
      if(contains(["all", "ubuntu"], "${ENV_OS}"), {
        name        = "ubuntu"
        image       = "docker-image://ubuntu:jammy"
        description = "Ubuntu Jammy"
        suffix      = ""
      }),
      // alpine
      if(contains(["all", "alpine"], "${ENV_OS}"), {
        name        = "alpine"
        image       = "docker-image://alpine:3"
        description = "Alpine 3"
        suffix      = "_musl"
      })
    ])
  }
  contexts = {
    image = os.image
  }
  inherits   = ["_platforms", "_labels"]
  dockerfile = "Dockerfile"
  labels     = {
    "org.opencontainers.image.title"        = "open${java}"
    "org.opencontainers.image.description"  = "Azul Zulu Builds of Open${upper(java)} Packaged by CentralX"
    "org.opencontainers.image.distribution" = os.description
    "org.opencontainers.image.version"      = version.code
  }
  args = {
    VERSION       = version.code
    TARGET        = "${java}"
    AMD64_PACKAGE = "https://cdn.azul.com/zulu/bin/zulu${version.zulu}-ca-${java}${version.code}-linux${os.suffix}_x64.tar.gz"
    ARM64_PACKAGE = "https://cdn.azul.com/zulu/bin/zulu${version.zulu}-ca-${java}${version.code}-linux${os.suffix}_aarch64.tar.gz"
  }
  tags = flatten([
    // ubuntu 且 jdk 时才有的 tag
    if(and(equal("ubuntu", os.name), equal("jdk", java)), "docker.io/centralx/openjdk:${version.major}"),
    if(and(equal("ubuntu", os.name), equal("jdk", java)), "docker.io/centralx/openjdk:${version.code}"),

    // ubuntu 才有的 tag，alpine 没有
    if(equal("ubuntu", os.name), "docker.io/centralx/openjdk:${java}${version.major}"),
    if(equal("ubuntu", os.name), "docker.io/centralx/openjdk:${java}${version.code}"),

    "docker.io/centralx/openjdk:${java}${version.major}-${os.name}",
    "docker.io/centralx/openjdk:${java}${version.code}-${os.name}"
  ])
}