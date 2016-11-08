## Introduction

This provisions a CoreOS based Kubernetes cluster using [bootcfg](https://github.com/coreos/coreos-baremetal/blob/master/Documentation/bootcfg.md).

## Prerequisites 

- rkt
- libvirt/virt-install (KVM)

## Installation

1. Download CoreOS assets

  $ ./get-coreos beta 1185.2.0 ./assets

2. Generate tls assets

  # ./cluster tls

3. Run bootcfg, and dnsmasq

  # systemd-run -p WorkingDirectory=$(pwd) $(pwd)/cluster dnsmasq
  # systemd-run -p WorkingDirectory=$(pwd) $(pwd)/cluster bootcfg

4. Create master node

  # ./cluster create-master

5. Create worker node

  # ./cluster create-worker workerN

Replace `workerN` with `worker1`, `worker2`, ...

## IP addresses

172.15.0.1   host bridge IP
172.15.0.2   bootcfg server
172.15.0.3   dnsmasq server
172.15.0.10  k8s master node

172.15.0.50-
172.15.0.99  dhcp IP range for k8s worker nodes

172.15.0.100 traefik ingress