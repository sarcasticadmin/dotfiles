# Bhyve

## Config

Install required packages
```
pkg install vm-bhyve grub2-bhyve
```

Set configuration for byhve-vm
```
sysrc vm_enable="YES"
sysrc vm_dir="zfs:zroot/vm"
sysrc vm_delay="5"
```

Setup ZFS
```
zfs create -o mountpoint=/vm zroot/vm
vm init
```
> NOTE: Assuming the pool on the system is zroot

Copy over config templates:
```
cp /usr/local/share/examples/vm-bhyve/* /vm/.templates/
```

Since `bridge0` exists for jails, well just leverage it for vms too:

```
vm switch create -t manual -b bridge0 public
```

## Datastore

You can add iso to the default datastore for later use:
```
vm iso <URL or path>
```

Confirm its been added:

```
ls -lah /vm/.iso/
```

## Provision vms

Leverage cloud imgs if possible, since `bhyve-vm` supports cloud-init and adding public keys out of the box

### Fresh

Create the vm and disk:

```
vm create -t debian -s 20G deb1
```

Configure it if necessary:
```
vm configure deb1
```
> NOTE: On debian the defaults worked fine

Install using iso from datastore:

```
vm install deb1 debian-10.0.0-amd64-netinst.iso
```

Then get a console up:

```
vm console deb1
```
> NOTE: Follow install prompts
> Additionally I did need to install grub on /dev/sda1

### Snapshot

Currently theres a default snapshot for debian:

```
vm clone deb1@debianbase:v1 deb2
```

Once online youll need to force the regen of the ssh keys:

```
dpkg-reconfigure openssh-server
sudo systemctl restart ssh
```


## Cloudinit

Create a cloudinit vm from nothing (doesnt work with -s yet):

```
vm create -t ubuntu -i ubuntu-18.04-server-cloudimg-amd64.img -s 80G -C -k /root/robs.key robstest4
```
> NOTE: Make sure -k <key> has correct read permissions


## Refs:

1. Good `vm-bhyve` guide: https://www.davd.io/install-ubuntu-on-freebsd-with-bhyve/
