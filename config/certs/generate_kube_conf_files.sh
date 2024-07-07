#!/bin/bash
set -ex

SCRIPT_DIR=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_DIR")
OUT="${BASE_DIR}/generated"

SERVER="un100d00"
for host in rpi500 rpi501 rpi502 rpi503 rpi504 rpi505 un100d01 un100d02 un100d03; do
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=${OUT}/ca.crt \
    --embed-certs=true \
    --server=https://${SERVER}:6443 \
    --kubeconfig=${OUT}/${host}.kubeconfig

  kubectl config set-credentials system:node:${host} \
    --client-certificate=${OUT}/${host}.crt \
    --client-key=${OUT}/${host}.key \
    --embed-certs=true \
    --kubeconfig=${OUT}/${host}.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:node:${host} \
    --kubeconfig=${OUT}/${host}.kubeconfig

  kubectl config use-context default \
    --kubeconfig=${OUT}/${host}.kubeconfig
done

kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=${OUT}/ca.crt \
    --embed-certs=true \
    --server=https://${SERVER}:6443 \
    --kubeconfig=${OUT}/kube-proxy.kubeconfig

kubectl config set-credentials system:kube-proxy \
    --client-certificate=${OUT}/kube-proxy.crt \
    --client-key=${OUT}/kube-proxy.key \
    --embed-certs=true \
    --kubeconfig=${OUT}/kube-proxy.kubeconfig

kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-proxy \
    --kubeconfig=${OUT}/kube-proxy.kubeconfig

kubectl config use-context default \
    --kubeconfig=${OUT}/kube-proxy.kubeconfig

kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=${OUT}/ca.crt \
    --embed-certs=true \
    --server=https://${SERVER}:6443 \
    --kubeconfig=${OUT}/kube-controller-manager.kubeconfig

kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=${OUT}/kube-controller-manager.crt \
    --client-key=${OUT}/kube-controller-manager.key \
    --embed-certs=true \
    --kubeconfig=${OUT}/kube-controller-manager.kubeconfig

kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-controller-manager \
    --kubeconfig=${OUT}/kube-controller-manager.kubeconfig

kubectl config use-context default \
    --kubeconfig=${OUT}/kube-controller-manager.kubeconfig

kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=${OUT}/ca.crt \
    --embed-certs=true \
    --server=https://${SERVER}:6443 \
    --kubeconfig=${OUT}/kube-scheduler.kubeconfig

kubectl config set-credentials system:kube-scheduler \
    --client-certificate=${OUT}/kube-scheduler.crt \
    --client-key=${OUT}/kube-scheduler.key \
    --embed-certs=true \
    --kubeconfig=${OUT}/kube-scheduler.kubeconfig

kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-scheduler \
    --kubeconfig=${OUT}/kube-scheduler.kubeconfig

kubectl config use-context default \
    --kubeconfig=${OUT}/kube-scheduler.kubeconfig


kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=${OUT}/ca.crt \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=${OUT}/${SERVER}.kubeconfig

kubectl config set-credentials admin \
    --client-certificate=${OUT}/${SERVER}.crt \
    --client-key=${OUT}/${SERVER}.key \
    --embed-certs=true \
    --kubeconfig=${OUT}/${SERVER}.kubeconfig

kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=admin \
    --kubeconfig=${OUT}/${SERVER}.kubeconfig

kubectl config use-context default \
    --kubeconfig=${OUT}/${SERVER}.kubeconfig
