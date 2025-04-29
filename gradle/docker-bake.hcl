############################################################################
# Gradle with Azul Zulu OpenJDK
# https://gradle.org
# https://www.azul.com
############################################################################

#***************************************************************************
# Default Group
#***************************************************************************
group "default" {
  targets = [
    "gradle"
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
    "org.opencontainers.image.description" = "Gradle Packaged by CentralX"
    "org.opencontainers.image.vendor"      = "CentralX"
    "org.opencontainers.image.maintainer"  = "Alan Yeh <alan@yeh.cn>"
  }
}

#***************************************************************************
# Global Argument
#***************************************************************************
variable "ENV_VERSION" {
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
target "gradle" {
  name   = "gradle-${replace(gradle.code, ".", "_")}-jdk${openjdk}-${os}"
  matrix = {
    gradle = flatten([
      // 7
      if(contains(["all", "7"], "${ENV_VERSION}"), {
        major = "7"
        code  = "7.6.4"
      }),
      // 8
      if(contains(["all", "8"], "${ENV_VERSION}"), {
        major = "8"
        code  = "8.11.1"
       })
    ])
    openjdk = ["8", "11", "17", "21"]
    os = ["ubuntu", "alpine"]
  }
  contexts = {
    image = "docker-image://centralx/openjdk:jdk${openjdk}-${os}"
  }
  inherits   = ["_platforms", "_labels"]
  dockerfile = "Dockerfile"
  labels     = {
    "org.opencontainers.image.title"        = "gradle"
    "org.opencontainers.image.distribution" = "Ubuntu Jammy"
    "org.opencontainers.image.version"      = "${gradle.code}"
  }
  args = {
    VERSION        = "${gradle.code}"
    GRADLE_PACKAGE = "https://services.gradle.org/distributions/gradle-${gradle.code}-bin.zip"
  }
  tags = flatten([
    // ubuntu 才有的 tag，alpine 没有
    if(equal("ubuntu", os), "docker.io/centralx/gradle:${gradle.major}-jdk${openjdk}"),
    if(equal("ubuntu", os), "docker.io/centralx/gradle:${gradle.code}-jdk${openjdk}"),

    "docker.io/centralx/gradle:${gradle.major}-jdk${openjdk}-${os}",
    "docker.io/centralx/gradle:${gradle.code}-jdk${openjdk}-${os}",
  ])
}