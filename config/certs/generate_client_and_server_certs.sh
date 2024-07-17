#!/bin/bash 
set -ex

SCRIPT_DIR=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_DIR")
OUT="${BASE_DIR}/generated"

# Created from previous script.
CA_CRT="${OUT}/ca.crt"
CA_PRIV_KEY="${OUT}/ca.key"

gen_certs() {
    local PRIV_KEY=$1
    local CSR=$2
    local CA=$3
    local SUBJ=$4
    openssl genrsa -out "${PRIV_KEY}" 4096
    openssl req -new -sha512 -noenc -key "${PRIV_KEY}" -subj "${SUBJ}" -out "${CSR}"
    openssl x509 -req -days 3650 -CAcreateserial \
	    -CA "${CA_CRT}" -CAkey "${CA_PRIV_KEY}" \
	    -in "${CSR}" \
	    -out "${CA}"
}


certs=(
  "rpi500"
  "rpi501"
  "rpi502"
  "rpi503"
  "rpi504"
  "rpi505"
  "un100d00"
  "un100d01"
  "un100d02"
  "un100d03"
  "kube-proxy"
  "kube-scheduler"
  "kube-controller-manager"
  "kube-api-server"
  "service-accounts"
)

#for i in ${certs[*]}; do
#  openssl genrsa -out "${OUT}/${i}.key" 4096
#
#  openssl req -new -key "${OUT}/${i}.key" -sha256 \
#    -config "${BASE_DIR}/ca.conf" -section ${i} \
#    -out "${OUT}/${i}.csr"
#  
#  openssl x509 -req -days 3653 -in "${OUT}/${i}.csr" \
#    -copy_extensions copyall \
#    -sha256 -CA "${OUT}/ca.crt" \
#    -CAkey "${OUT}/ca.key" \
#    -CAcreateserial \
#    -out "${OUT}/${i}.crt"
#done

gen_certs \
    "${OUT}/admin.key" \
    "${OUT}/admin.csr" \
    "${OUT}/admin.crt" \
    "/CN=admin/O=system:masters"

gen_certs \
    "${OUT}/kube-controller-manager.key" \
    "${OUT}/kube-controller-manager.csr" \
    "${OUT}/kube-controller-manager.crt" \
    "/CN=system:kube-controller-manager/O=system:kube-controller-manager"

gen_certs \
    "${OUT}/kube-proxy.key" \
    "${OUT}/kube-proxy.csr" \
    "${OUT}/kube-proxy.crt" \
    "/CN=system:kube-proxy/O=system:node-proxier"

gen_certs \
    "${OUT}/kube-scheduler.key" \
    "${OUT}/kube-scheduler.csr" \
    "${OUT}/kube-scheduler.crt" \
    "/CN=system:kube-scheduler/O=system:kube-scheduler"

gen_certs \
    "${OUT}/service-account.key" \
    "${OUT}/service-account.csr" \
    "${OUT}/service-account.crt" \
    "/CN=service-accounts/O=Kubernetes"

