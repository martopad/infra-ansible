#!/bin/bash
set -e

SCRIPT_DIR=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_DIR")
OUT="${BASE_DIR}/generated"


openssl genrsa -out ${OUT}/ca.key 4096
openssl req -x509 -new -sha512 -noenc \
	-key ${OUT}/ca.key -days 3653 \
	-config ${BASE_DIR}/ca.conf \
	-out ${OUT}/ca.crt

