source "docker" "debian-systemd" {
  image  = "example.com/debian-systemd:11"
  commit = true
  pull = false
  changes = [
    "STOPSIGNAL SIGRTMIN+3",
    "VOLUME [ \"/tmp\", \"/run\", \"/run/lock\" ]",
    "ENTRYPOINT [  \"/sbin/init\", \"log-level=info\", \"unit=sysinit.target\" ]", # it seems that we need to override this
    "CMD [ ]"
  ]
  run_command = [
    "-d",
    "-t",
    "--tmpfs=/run",
    "--tmpfs=/run/lock",
#    "--tmpfs=/tmp", # packer put installation script there, so we disable tmpfs on /tmp
    "--privileged",
    "--cap-add=SYS_ADMIN",
    "--cgroup-parent=docker.slice",
    "--cgroupns=private",
    "--security-opt=seccomp=unconfined",
    "--env=container=docker",
    "{{.Image}}"
  ]
}
