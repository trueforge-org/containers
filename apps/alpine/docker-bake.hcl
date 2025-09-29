target "docker-metadata-action" {}

variable "APP" {
  default = "alpine"
}

variable "VERSION" {
  // renovate: datasource=docker depName=docker.io/library/alpine
  default = "3.22.1"
}

variable "SOURCE" {
  default = "https://hub.docker.com/_/alpine"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION}"
  }
  labels = {
    "org.opencontainers.image.source" = "${SOURCE}"
  }
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
  tags = ["${APP}:${VERSION}"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
