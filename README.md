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

### csi setup
1. install `extra/open-iscsi`, `core/nfs-utils`, `core/cryptsetup` and `core/device-mapper`
2. update kernel modules by updating/appending the following and then rebuild your kernel with `mkinitcpio -P`. verify by issuing `lsmod | grep dm_crypt`
   ```/etc/mkinitcpio.conf
   MODULES=(dm_mod dm_crypt)
   ```
3. install [rancher/local-path-provisioner](https://github.com/rancher/local-path-provisioner)

### gateway setup
1. install [metallb](https://metallb.io/installation/#installation-by-manifest)
2. configure metallb with manifest in [metallb/config.yaml](gateway/metallb/config.yaml)
3. install [envoy](https://gateway.envoyproxy.io/docs/install/install-yaml/)
