build {
  name = "build-lighttpd"
  sources = [
    "source.docker.debian-systemd"
  ]
  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "container=docker"
    ]
    inline = [
      "apt-get update",
      "apt-get install -y --no-install-recommends lighttpd",
      "apt-get clean",
      "rm -rf /var/lib/apt/lists/*"
    ]
  }
  post-processors {
    post-processor "docker-tag" {
      repository =  "example.com/lighttpd"
    }
  }
}
