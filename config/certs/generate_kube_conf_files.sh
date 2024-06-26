#!/bin/bash
set -e

SCRIPT_DIR=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_DIR")
OUT="${BASE_DIR}/generated"

for host in node0 node1; do
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=${OUT}/ca.crt \
    --embed-certs=true \
    --server=https://server:6443 \
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
    --server=https://server:6443 \
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
    --server=https://server:6443 \
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
    --server=https://server:6443 \
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

kubectl config use-context default \
    --kubeconfig=${OUT}/admin.kubeconfig
