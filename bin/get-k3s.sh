#!/bin/sh

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --no-deploy traefik" sh


# Install dashboard
#https://rancher.com/docs/k3s/latest/en/installation/kube-dashboard/
