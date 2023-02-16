source "docker" "debian" {
  image  = "debian:11"
  commit = true
  changes = [
    "STOPSIGNAL SIGRTMIN+3",
    "VOLUME [ \"/tmp\", \"/run\", \"/run/lock\" ]",
    "ENTRYPOINT [  \"/sbin/init\", \"log-level=info\", \"unit=sysinit.target\" ]",
    "CMD [ ]"
  ]
}

build {
  name = "build-systemd"
  sources = [
    "source.docker.debian"
  ]
  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "container=docker"
    ]
    inline = [
      "echo Adding file to Docker Container",
      "echo \"FOO is $FOO\" > example.txt",
      "apt-get update",
      "apt-get install -y systemd systemd-sysv cron anacron --no-install-recommends",
      "systemctl mask -- dev-hugepages.mount sys-fs-fuse-connections.mount",
      "rm -f /lib/systemd/system/multi-user.target.wants/* /etc/systemd/system/*.wants/* /lib/systemd/system/local-fs.target.wants/* /lib/systemd/system/sockets.target.wants/*udev* /lib/systemd/system/sockets.target.wants/*initctl* /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* /lib/systemd/system/systemd-update-utmp*",
      "apt-get install -y --no-install-recommends lighttpd",
      "apt-get clean",
      "rm -rf /var/lib/apt/lists/*"
    ]
  }
  post-processors {
    post-processor "docker-tag" {
      repository =  "example.com/debian-systemd"
      tags = [ "11" ]
    }
  }
}
