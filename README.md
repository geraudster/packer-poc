# Build systemd containers with Packer

This project build an image width Debian + systemd and an image embedding lighttpd.

Build images with:
```
ansible-playbook play-build.yml
```
or
```
packer build -only='build-systemd.docker.debian' .
packer build -only='build-lighttpd.docker.debian-systemd' .
```

Run lighttpd container with:
```
docker run -d -t \
    --name lighttpd \
    -p 8000:80 \
    --tmpfs /run \
    --tmpfs /run/lock \
    --tmpfs /tmp \
    --privileged \
    --cap-add SYS_ADMIN \
    --cgroup-parent=docker.slice \
    --cgroupns private \
    --security-opt seccomp=unconfined \
    -e container=docker \
    example.com/lighttpd
```

Run multiservice container with:
```
docker run -d -t \
    --name multiservice \
    -p 8000:80 \
    -p 19999:19999 \
    --tmpfs /run \
    --tmpfs /run/lock \
    --tmpfs /tmp \
    --privileged \
    --cap-add SYS_ADMIN \
    --cgroup-parent=docker.slice \
    --cgroupns private \
    --security-opt seccomp=unconfined \
    -e container=docker \
    example.com/multiservice
```
