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
    "org.opencontainers.image.maintainer"  = "Alan Yeh <alan.yeh.cn>"
  }
}

#***************************************************************************
# Global Function
#***************************************************************************
function "if" {
  params = [condition, true_return]
  result = condition ? true_return : ""
}

#***************************************************************************
# Targets
#***************************************************************************
target "gradle" {
  name   = "gradle-${replace(gradle.code, ".", "_")}-jdk${openjdk}-${os}"
  matrix = {
    gradle = [
      {
        major = "5"
        // "5.0", "5.1", "5.1.1", "5.2", "5.2.1", "5.3", "5.3.1", "5.4", "5.4.1", "5.5", "5.5.1", "5.6", "5.6.1", "5.6.2",
        // "5.6.3", "5.6.4",
        code  = "5.5.1"
      }, {
        major = "6"
        // "6.0", "6.0.1", "6.1", "6.1.1", "6.2", "6.2.1", "6.2.2", "6.3", "6.4", "6.4.1", "6.5", "6.5.1", "6.6", "6.6.1",
        // "6.7", "6.7.1", "6.8", "6.8.1", "6.8.2", "6.8.3", "6.9", "6.9.1", "6.9.2", "6.9.3", "6.9.4",
        code  = "6.5"
      }, {
        major = "7"
        // "7.0", "7.0.1", "7.0.2", "7.1", "7.1.1", "7.2", "7.3", "7.3.1", "7.3.2", "7.3.3", "7.4", "7.4.1", "7.4.2", "7.5",
        // "7.5.1", "7.6", "7.6.1", "7.6.2", "7.6.3",
        code  = "7.4"
      }, {
        major = "8"
        // "8.0", "8.0.1", "8.0.2", "8.1", "8.1.1", "8.2", "8.2.1", "8.3", "8.4", "8.5"
        code  = "8.5"
      }
    ]
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
  tags = [
    // ubuntu 才有的 tag，alpine 没有
    if(equal("ubuntu", os), "docker.io/centralx/gradle:${gradle.major}-jdk${openjdk}"),
    if(equal("ubuntu", os), "docker.io/centralx/gradle:${gradle.code}-jdk${openjdk}"),

    "docker.io/centralx/gradle:${gradle.major}-jdk${openjdk}-${os}",
    "docker.io/centralx/gradle:${gradle.code}-jdk${openjdk}-${os}",
  ]
}