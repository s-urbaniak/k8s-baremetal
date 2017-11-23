## Introduction

This provides the possibility to provision a CoreOS based Kubernetes cluster using the [Tectonic installer](https://github.com/coreos/tectonic-installer) and the bare metal provider leveraging [matchbox](https://github.com/matchbox).

## Prerequisites 

- rkt
- libvirt/virt-install (KVM)
- terraform for provisioning matchbox certificates

## Installation

```
# cp net.d/20-metal.conf /etc/rkt/net.d
```

Download CoreOS assets

```
$ ./get-coreos beta 1185.2.0 ./assets
```

Generate matchbox tls assets

```
# ./cluster certs
```

Run matchbox and dnsmasq

```
# ./cluster matchbox
```

Create nodes

```
# ./cluster create-nodes
```
## IP addresses

```
10.1.1.1     host bridge IP
10.1.1.2     matchbox server
10.1.1.3     dnsmasq server
10.1.1.10    master1
10.1.1.50    worker1
10.1.1.51    worker2
```
