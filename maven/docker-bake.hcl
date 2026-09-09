############################################################################
# Maven with Azul Zulu OpenJDK
# https://maven.apache.org
# https://www.azul.com
############################################################################

#***************************************************************************
# Default Group
#***************************************************************************
group "default" {
  targets = [
    "maven"
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
    "org.opencontainers.image.description" = "Maven Packaged by CentralX"
    "org.opencontainers.image.vendor"      = "CentralX"
    "org.opencontainers.image.maintainer"  = "Alan Yeh <alan@yeh.cn>"
  }
}

#***************************************************************************
# Global Argument
#***************************************************************************
variable "ENV_MAVEN" {
  default = "all"
}

variable "ENV_OPENJDK" {
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
target "maven" {
  name   = "maven-${replace(maven.code, ".", "_")}-jdk${openjdk}-${os}"
  matrix = {
    // maven 版本
    maven = flatten([
      // 3
      if(contains(["all", "3"], "${ENV_MAVEN}"), {
        major = "3"
        code  = "3.9.16"
      })
    ])
    // openjdk 版本
    openjdk = flatten([
      // 8
      if(contains(["all", "8"], "${ENV_OPENJDK}"), "8"),
      // 11
      if(contains(["all", "11"], "${ENV_OPENJDK}"), "11"),
      // 17
      if(contains(["all", "17"], "${ENV_OPENJDK}"), "17"),
      // 21
      if(contains(["all", "21"], "${ENV_OPENJDK}"), "21")
    ])
    // 基础镜像发行版类型
    os = flatten([
      // ubuntu
      if(contains(["all", "ubuntu"], "${ENV_OS}"), "ubuntu"),
      // alpine
      if(contains(["all", "alpine"], "${ENV_OS}"), "alpine")
    ])
  }
  contexts = {
    image = "docker-image://centralx/openjdk:jdk${openjdk}-${os}"
  }
  inherits   = ["_platforms", "_labels"]
  dockerfile = "Dockerfile"
  labels     = {
    "org.opencontainers.image.title"        = "maven"
    "org.opencontainers.image.distribution" = "Ubuntu Jammy"
    "org.opencontainers.image.version"      = "${maven.code}"
  }
  args = {
    VERSION       = "${maven.code}"
    MAVEN_PACKAGE = "https://dlcdn.apache.org/maven/maven-3/${maven.code}/binaries/apache-maven-${maven.code}-bin.tar.gz"
  }
  tags = flatten([
    // ubuntu 才有的 tag，alpine 没有
    if(equal("ubuntu", os), "docker.io/centralx/maven:${maven.major}-jdk${openjdk}"),
    if(equal("ubuntu", os), "docker.io/centralx/maven:${maven.code}-jdk${openjdk}"),

    "docker.io/centralx/maven:${maven.major}-jdk${openjdk}-${os}",
    "docker.io/centralx/maven:${maven.code}-jdk${openjdk}-${os}",
  ])
}