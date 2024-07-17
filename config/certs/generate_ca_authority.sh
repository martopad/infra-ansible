#!/bin/bash
set -ex

gen_certs() {
    local PRIV_KEY=$1
    local CSR=$2
    local CA=$3
    local SUBJ=$4
    openssl genrsa -out "${PRIV_KEY}" 4096
    openssl req -new -sha512 -noenc -key "${PRIV_KEY}" -subj "/CN=KUBERNETES-CA/O=Kubernetes" -out "${CSR}"
    openssl x509 -req  -days 3650 -in "${CSR}" -signkey "${PRIV_KEY}" -CAcreateserial -out "${CA}"
}

SCRIPT_DIR=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_DIR")
OUT="${BASE_DIR}/generated"

# ca.crt = K8 Certificate Authority Certificate
# ca.key = K8 Certificate Authority Private Key
# ca.csr = Certificate Signing Request
mkdir -p "${OUT}"
gen_certs \
    "${OUT}/ca.key" \
    "${OUT}/ca.csr" \
    "${OUT}/ca.crt" \
    "/CN=KUBERNETES-CA/O=Kubernetes"


#openssl genrsa -out "${K8_CA_PRIVATE_KEY}" 4096
#openssl req -new -sha512 -noenc -key "${K8_CA_PRIVATE_KEY}" -subj "/CN=KUBERNETES-CA/O=Kubernetes" -out "${K8_CSR}"
#openssl x509 -req  -days 3650 -in "${K8_CSR}" -signkey "${K8_CA_PRIVATE_KEY}" -CAcreateserial -out "${K8_CA}"

