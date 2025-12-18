#!/usr/bin/env bash

sudo k0s kubeconfig create $(whoami) --groups 'system:masters' --config /root/.k0s/k0s.yaml > ~/.kube/config
