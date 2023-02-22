build {
  name = "build-multiservice"
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
      "apt-get install -y --no-install-recommends lighttpd netdata",
      "apt-get clean",
      "rm -rf /var/lib/apt/lists/*",
      "sed -i 's/bind socket to IP = 127.0.0.1/bind socket to IP = 0.0.0.0/' /etc/netdata/netdata.conf",
      "systemctl enable lighttpd",
      "systemctl start lighttpd",
      "systemctl enable netdata",
      "systemctl start  netdata"
    ]
  }
  post-processors {
    post-processor "docker-tag" {
      repository =  "example.com/multiservice"
    }
  }
}
