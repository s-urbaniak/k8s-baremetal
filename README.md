## Introduction

This provisions a CoreOS based Kubernetes cluster using [bootcfg](https://github.com/coreos/coreos-baremetal/blob/master/Documentation/bootcfg.md).

## Prerequisites 

- rkt
- libvirt/virt-install (KVM)

## Installation

```
# cp net.d/20-metal.conf /etc/rkt/net.d
```

Download CoreOS assets

```
$ ./get-coreos beta 1185.2.0 ./assets
```

Generate tls assets

```
# ./cluster tls
```

Run bootcfg, and dnsmasq

```
# systemd-run --unit=k8s-dnsmasq -p WorkingDirectory=$(pwd) $(pwd)/cluster dnsmasq
# systemd-run --unit=k8s-bootcfg -p WorkingDirectory=$(pwd) $(pwd)/cluster bootcfg
```

Create master node

```
# ./cluster create-master
```

Create worker node

```
# ./cluster create-worker workerN
```

Replace `workerN` with `worker1`, `worker2`, ...

## IP addresses

```
172.15.0.1   host bridge IP
172.15.0.2   bootcfg server
172.15.0.3   dnsmasq server
172.15.0.10  k8s master node

172.15.0.50-
172.15.0.99  dhcp IP range for k8s worker nodes

172.15.0.100 traefik ingress
```
