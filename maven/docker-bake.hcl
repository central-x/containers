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
# Global Function
#***************************************************************************
function "if" {
  params = [condition, true_return]
  result = condition ? true_return : ""
}

#***************************************************************************
# Targets
#***************************************************************************
target "maven" {
  name   = "maven-${replace(maven.code, ".", "_")}-jdk${openjdk}-${os}"
  matrix = {
    maven = [
      {
        major = "3"
        code  = "3.9.9"
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
    "org.opencontainers.image.title"        = "maven"
    "org.opencontainers.image.distribution" = "Ubuntu Jammy"
    "org.opencontainers.image.version"      = "${maven.code}"
  }
  args = {
    VERSION       = "${maven.code}"
    MAVEN_PACKAGE = "https://dlcdn.apache.org/maven/maven-3/${maven.code}/binaries/apache-maven-${maven.code}-bin.tar.gz"
  }
  tags = [
    // ubuntu 才有的 tag，alpine 没有
    if(equal("ubuntu", os), "docker.io/centralx/maven:${maven.major}-jdk${openjdk}"),
    if(equal("ubuntu", os), "docker.io/centralx/maven:${maven.code}-jdk${openjdk}"),

    "docker.io/centralx/maven:${maven.major}-jdk${openjdk}-${os}",
    "docker.io/centralx/maven:${maven.code}-jdk${openjdk}-${os}",
  ]
}