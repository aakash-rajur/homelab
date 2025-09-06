# homelab

setup for personal homelab

## apps

1. jellyfin
2. radarr
3. sonarr
4. jellyseer
5. homepage
6. postgresql

## os setup
1. fresh arch linux install
2. install `git`, `extra/bind`, `core/inetutils`, `core/net-tools`, `jq`, `yq`
3. setup RAID [ref](https://www.digitalocean.com/community/tutorials/how-to-create-raid-arrays-with-mdadm-on-ubuntu) and update fstab using [genfstab](https://github.com/glacion/genfstab/tree/master)
4. install [k0s](https://docs.k0sproject.io/stable/install/)
5. run the following to configure `k0s` systemd service correctly
   ```shell
   k0s install controller --enable-worker --no-taints -c /etc/k0s/k0s.yaml
   ```
6. verify by running `busybox`
