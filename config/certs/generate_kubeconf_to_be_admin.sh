#!/bin/bash

set -ex

SCRIPT_DIR=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_DIR")
OUT="${BASE_DIR}/generated"

kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=${OUT}/ca.crt \
  --embed-certs=true \
  --server=https://un100d00:6443

kubectl config set-credentials admin \
  --client-certificate=${OUT}/un100d00.crt \
  --client-key=${OUT}/un100d00.key

kubectl config set-context kubernetes-the-hard-way \
  --cluster=kubernetes-the-hard-way \
  --user=admin

kubectl config use-context kubernetes-the-hard-way
