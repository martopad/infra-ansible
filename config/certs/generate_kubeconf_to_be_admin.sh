#!/bin/bash

set -ex

SCRIPT_DIR=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_DIR")
OUT="${BASE_DIR}/generated"

kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=${OUT}/ca.crt \
  --embed-certs=true \
  --server=https://127.0.0.1:6443 \
  --kubeconfig=${OUT}/admin.kubeconfig

kubectl config set-credentials admin \
  --client-certificate=${OUT}/admin.crt \
  --client-key=${OUT}/admin.key \
  --embed-certs=true \
  --kubeconfig=${OUT}/admin.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=admin \
  --kubeconfig=${OUT}/admin.kubeconfig

kubectl config use-context default --kubeconfig=${OUT}/admin.kubeconfig
