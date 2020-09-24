#!/bin/sh

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --no-deploy traefik --docker" sh

#Using Docker as the Container Runtime
#K3s includes and defaults to containerd, an industry-standard container runtime.
#If you want to use Docker instead of containerd then you simply need to run the agent with the --docker flag.

# Install dashboard
#https://rancher.com/docs/k3s/latest/en/installation/kube-dashboard/
