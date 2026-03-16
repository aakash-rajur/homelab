# homelab

setup for personal homelab

1. transmission
2. sabnzbd
3. radarr
4. sonarr
5. bazarr
6. jellyfin
7. jellyseerr
8. homepage
9. postgresql

## os

1. fresh arch linux install
2. install `git`, `extra/bind`, `core/inetutils`, `core/net-tools`, `jq`, `yq`
3. setup RAID [ref](https://www.digitalocean.com/community/tutorials/how-to-create-raid-arrays-with-mdadm-on-ubuntu) and
   update fstab using [genfstab](https://github.com/glacion/genfstab/tree/master)
4. install [k0s](https://docs.k0sproject.io/stable/install/)
5. run the following to configure `k0s` systemd service correctly
   ```shell
   k0s install controller --enable-worker --no-taints -c /etc/k0s/k0s.yaml
   ```
6. verify by running `busybox`

### csi

> this was removed as we're using hostPath. keeping it around for reference

1. install `extra/open-iscsi`, `core/nfs-utils`, `core/cryptsetup` and `core/device-mapper`
2. update kernel modules by updating/appending the following and then rebuild your kernel with `mkinitcpio -P`. verify
   by issuing `lsmod | grep dm_crypt`
   ```/etc/mkinitcpio.conf
   MODULES=(dm_mod dm_crypt)
   ```
3. install [rancher/local-path-provisioner](https://github.com/rancher/local-path-provisioner)

### gateway

1. install [cilium](https://docs.cilium.io/en/latest/installation/k0s/)
2. install [haproxy-ingress](https://haproxy-ingress.github.io/docs/getting-started/)
configure gateway with manifest in [here](https://haproxy-ingress.github.io/docs/configuration/gateway-api/)

### sealed secrets

1. generate template from helm chart
   in [bitnami-labs/sealed-secrets](https://github.com/bitnami-labs/sealed-secrets?tab=readme-ov-file#helm-chart)
2. add CRDs in generated template
   from [ref](https://github.com/bitnami-labs/sealed-secrets/blob/main/helm/sealed-secrets/crds/bitnami.com_sealedsecrets.yaml)
   and install sealed secrets
3. use [secrets/seal.sh](services/secrets/seal.sh) to generate encrypted secrets, can be commited safely within your
   repo

### tls

> this was removed as cloudflare does not support tls passthrough in tunnels, keeping it around for reference

1. install [cert-manager](https://cert-manager.io/docs/installation/helm/)
2. configure cluster issuer with your domain
3. verify by issuing a certificate

### graphics acceleration

1. install `linux-firmware`, `mesa`, `intel-media-driver`
2. follow
   instructions [jellyfin/intel](https://jellyfin.org/docs/general/post-install/transcoding/hardware-acceleration/intel/#configure-and-verify-lp-mode-on-linux)

## apps

### transmission and sabnzbd

1. [charts/torrent](charts/torrent) deploy transmission and sabnzbd
2. we're generating sabnzbd.ini from secrets through init containers before booting
3. all credentials are configured through sealed secrets

### servarr

1. apps deployed include `prowlarr`, `radarr`, `sonarr` and `bazarr`
2. directory mounts need to be carefully configured
3. chart located in [charts/servarr](charts/servarr)

### jellyfin

1. deploys `jellyfin` and `jellyseerr`
2. directory mounts need to be carefully configured
3. chart located in [charts/jellyfin](charts/jellyfin)

### cloudflare tunnel
1. all traffic is exposed through http routes attached to [primary-gateway](services/gateway/envoy/config.yaml)
2. [cloudflare tunnel](charts/cloudflare-tunnel) forwards traffic to [primary-gateway](services/gateway/envoy/config.yaml)
