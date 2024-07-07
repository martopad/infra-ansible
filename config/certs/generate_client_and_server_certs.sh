#!/bin/bash 
set -ex

SCRIPT_DIR=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_DIR")
OUT="${BASE_DIR}/generated"

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

for i in ${certs[*]}; do
  openssl genrsa -out "${OUT}/${i}.key" 4096

  openssl req -new -key "${OUT}/${i}.key" -sha256 \
    -config "${BASE_DIR}/ca.conf" -section ${i} \
    -out "${OUT}/${i}.csr"
  
  openssl x509 -req -days 3653 -in "${OUT}/${i}.csr" \
    -copy_extensions copyall \
    -sha256 -CA "${OUT}/ca.crt" \
    -CAkey "${OUT}/ca.key" \
    -CAcreateserial \
    -out "${OUT}/${i}.crt"
done
