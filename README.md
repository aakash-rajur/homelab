# homelab

setup for personal homelab

## apps

1. transmission
2. sabnzbd
3. radarr
4. sonarr
5. bazarr
6. jellyfin
7. jellyseerr
8. homepage
9. postgresql

### os

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

1. install [metallb](https://metallb.io/installation/#installation-by-manifest)
2. configure metallb with manifest in [metallb/config.yaml](services/gateway/metallb/config.yaml)
3. install [envoy](https://gateway.envoyproxy.io/docs/install/install-yaml/)
4. configure envoy with manifest in [envoy/config.yaml](services/gateway/envoy/config.yaml)

### sealed secrets

1. generate template from helm chart
   in [bitnami-labs/sealed-secrets](https://github.com/bitnami-labs/sealed-secrets?tab=readme-ov-file#helm-chart)
2. add CRDs in generated template
   from [ref](https://github.com/bitnami-labs/sealed-secrets/blob/main/helm/sealed-secrets/crds/bitnami.com_sealedsecrets.yaml)
   and install sealed secrets
3. use [secrets/seal.sh](services/secrets/seal.sh) to generate encrypted secrets, can be commited safely within your
   repo

### tls

1. install [cert-manager](https://cert-manager.io/docs/installation/helm/)
2. configure cluster issuer with your domain
3. verify by issuing a certificate

### graphics acceleration

1. install `linux-firmware`, `mesa`, `intel-media-driver`
2. follow
   instructions [jellyfin/intel](https://jellyfin.org/docs/general/post-install/transcoding/hardware-acceleration/intel/#configure-and-verify-lp-mode-on-linux)
