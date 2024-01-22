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
        "org.opencontainers.image.vendor" = "CentralX"
        "org.opencontainers.image.maintainer" = "Alan Yeh <alan.yeh.cn>"
    }
}

#***************************************************************************
# Global Function
#***************************************************************************
function "if" {
    params = [condition, true_return]
    result =  condition ? true_return : ""
}

#***************************************************************************
# Targets
#***************************************************************************
target "openjdk" {
    name = "openjdk-${replace(version.code, ".", "_")}-${type}-${os.name}"
    matrix = {
        // 版本
        version = [{
            // 8
            major = "8"
            code = "8.0.392"
            zulu = "8.74.0.17"
        }, {
            // 11
            major = "11"
            code = "11.0.21"
            zulu = "11.68.17"
        }, {
            // 17
            major = "17"
            code = "17.0.9"
            zulu = "17.46.19"
        }, {
            // 21
            major = "21"
            code = "21.0.1"
            zulu = "21.30.15"
        }]
        type = ["jdk", "jre"]
        // 基础镜像发行版类型
        os = [{
            // ubuntu
            name = "ubuntu"
            image = "docker-image://ubuntu:jammy"
            description = "Ubuntu Jammy"
            suffix = ""
        }, {
            // alpine
            name = "alpine"
            image = "docker-image://alpine:3"
            description = "Alpine 3"
            suffix = "_musl"
        }]
    }
    contexts = {
        image = os.image
    }
    inherits = ["_platforms", "_labels"]
    dockerfile = "Dockerfile"
    labels = {
        "org.opencontainers.image.title" = "openjdk-${type}"
        "org.opencontainers.image.description" = "Azul Zulu Builds of Open${upper(type)} Packaged by CentralX"
        "org.opencontainers.image.distribution" = os.description
        "org.opencontainers.image.version" = version.code
    }
    args = {
        VERSION  = version.code
        TARGET = "${type}"
        AMD64_PACKAGE = "https://cdn.azul.com/zulu/bin/zulu${version.zulu}-ca-${type}${version.code}-linux${os.suffix}_x64.tar.gz"
        ARM64_PACKAGE = "https://cdn.azul.com/zulu/bin/zulu${version.zulu}-ca-${type}${version.code}-linux${os.suffix}_aarch64.tar.gz"
    }
    tags = [
        // ubuntu 且 jdk 时才有的 tag
        if(and(equal("ubuntu", os.name), equal("jdk", type)), "docker.io/centralx/openjdk:${version.major}"),
        if(and(equal("ubuntu", os.name), equal("jdk", type)), "docker.io/centralx/openjdk:${version.code}"),

        // jdk 才有的 tag，jre 没有
        if(equal("jdk", type), "docker.io/centralx/openjdk:${version.major}-${os.name}"),
        if(equal("jdk", type), "docker.io/centralx/openjdk:${version.code}-${os.name}"),

        // ubuntu 才有的 tag，alpine 没有
        if(equal("ubuntu", os.name), "docker.io/centralx/openjdk:${version.major}-${type}"),
        if(equal("ubuntu", os.name), "docker.io/centralx/openjdk:${version.code}-${type}"),

        "docker.io/centralx/openjdk:${version.major}-${type}-${os.name}",
        "docker.io/centralx/openjdk:${version.code}-${type}-${os.name}"
    ]
}