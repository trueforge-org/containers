target "docker-metadata-action" {}

variable "APP" {
  default = "emby"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=MediaBrowser/Emby.Releases versioning=loose
  default = "4.9.2.5"
}

group "default" {
  targets = ["image-local"]
}

variable "LICENSE" {
  default = "MIT"
}


variable "SOURCE" {
  default = "https://github.com/MediaBrowser/Emby.Releases"
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION}"
  }
  labels = {
    "org.opencontainers.image.source" = "${SOURCE}"
    "org.opencontainers.image.licenses" = "${LICENSE}"
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
