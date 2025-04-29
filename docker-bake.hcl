variable "GO_VERSION" { default = "1.24" }
variable "ALPINE_VERSION" { default = "" }

target "docker-metadata-action" {}
target "github-metadata-action" {}

target "default" {
    inherits = [ "discover" ]
    platforms = [
        "linux/amd64",
        "linux/arm64"
    ]
}

target "local" {
    inherits = [ "discover" ]
    tags = [ "swarmlibs/discover:local" ]
}

target "binaries" {
    inherits = [ "discover" ]
    output = ["./bin"]
    platforms = ["local"]
    target = "binaries"
}

target "discover" {
    inherits = [
        "docker-metadata-action",
        "github-metadata-action",
    ]
    args = {
        GO_VERSION = "${GO_VERSION}"
        ALPINE_VERSION = "${ALPINE_VERSION}"
    }
}
