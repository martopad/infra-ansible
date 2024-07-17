#!/bin/bash
set -ex

SCRIPT_DIR=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_DIR")
OUT="${BASE_DIR}/generated"

gen_kubeconf() {
    local node_ip=$1
    local role=$2
    local credential=$3
    local kubeconfig=$4
    kubectl config set-cluster kubernetes-the-hard-way \
        --certificate-authority=/var/lib/kubernetes/pki/ca.crt \
        --server=https://${node_ip}:6443 \
        --kubeconfig="${kubeconfig}"

    kubectl config set-credentials "${credential}" \
        --client-certificate="/var/lib/kubernetes/pki/${role}.crt" \
        --client-key="/var/lib/kubernetes/pki/${role}.key" \
        --kubeconfig="${kubeconfig}"

    kubectl config set-context default \
        --cluster=kubernetes-the-hard-way \
        --user="${credential}" \
        --kubeconfig="${kubeconfig}"

    kubectl config use-context default --kubeconfig="${kubeconfig}"
}

gen_kubeconf \
    "192.168.1.34" \
    "kube-proxy" \
    "system:kube-proxy" \
    "${OUT}/kube-proxy.kubeconfig"

gen_kubeconf \
    "127.0.0.1" \
    "kube-controller-manager" \
    "system:kube-controller-manager" \
    "${OUT}/kube-controller-manager.kubeconfig"

gen_kubeconf \
    "127.0.0.1" \
    "kube-scheduler" \
    "system:kube-scheduler" \
    "${OUT}/kube-scheduler.kubeconfig"

