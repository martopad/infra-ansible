#!/bin/bash

SCRIPT_DIR=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_DIR")
OUT="${BASE_DIR}/generated"

# Creates ca.crt and ca.key
${BASE_DIR}/generate_ca_authority.sh

${BASE_DIR}/generate_client_and_server_certs.sh

# TODO: check if DNS names can be used
ADDITIONAL_ALT_NAMES_FOR_K8_API_SERVER=( 
     '10.96.0.1'    #         API Server
     '192.168.1.22' #un100d00 ControlPlane01
     '192.168.1.21' #un100d01 ControlPlane02
     '192.168.1.34' #un100d02 LoadBalancer
     '127.0.0.1')

ADDITIONAL_ALT_NAMES_FOR_ETCD=( 
     '192.168.1.22' #un100d00 ControlPlane01
     '192.168.1.21' #un100d01 ControlPlane02
     '127.0.0.1')

${BASE_DIR}/generate_kubernetes_api_certs.sh \
	"${ADDITIONAL_ALT_NAMES_FOR_K8_API_SERVER[*]}" \
	"${ADDITIONAL_ALT_NAMES_FOR_ETCD[*]}"

${BASE_DIR}/generate_kube_conf_files.sh

${BASE_DIR}/generate_kubeconf_to_be_admin.sh
