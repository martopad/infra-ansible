#!/bin/bash

set -ex

SCRIPT_DIR=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_DIR")
OUT="${BASE_DIR}/generated"

ARG_LOAD_BALANCER_IP=$1

kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=${OUT}/ca.crt \
  --embed-certs=true \
  --server=https://${ARG_LOAD_BALANCER_IP}:6443 \

kubectl config set-credentials admin \
  --client-certificate=${OUT}/admin.crt \
  --client-key=${OUT}/admin.key \
  --embed-certs=true \

kubectl config set-context kubernetes-the-hard-way \
  --cluster=kubernetes-the-hard-way \
  --user=admin \

kubectl config use-context kubernetes-the-hard-way
