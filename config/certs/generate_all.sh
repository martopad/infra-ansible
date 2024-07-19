#!/bin/bash
# TODO: This set of scripts needs to be "ansible"-fy so that inventoery.yaml is the
#       single source of truth when topology changes.
SCRIPT_DIR=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_DIR")
OUT="${BASE_DIR}/generated"

# Creates ca.crt and ca.key
${BASE_DIR}/generate_ca_authority.sh

${BASE_DIR}/generate_client_and_server_certs.sh

# TODO: check if DNS names can be used
LOADBALANCER="192.168.1.27" #rpi500 LoadBalancer
ADDITIONAL_ALT_NAMES_FOR_K8_API_SERVER=(
     '10.96.0.1'    #         API Server
     '192.168.1.29' #rpi501 ControlPlane00
     '192.168.1.31' #rpi502 ControlPlane01
     "${LOADBALANCER}"
     '127.0.0.1')

ADDITIONAL_ALT_NAMES_FOR_ETCD=(
     '192.168.1.22' #un100d00 etcd00
     '192.168.1.21' #un100d01 etcd01
     '127.0.0.1')

${BASE_DIR}/generate_kubernetes_api_certs.sh \
	"${ADDITIONAL_ALT_NAMES_FOR_K8_API_SERVER[*]}" \
	"${ADDITIONAL_ALT_NAMES_FOR_ETCD[*]}"

${BASE_DIR}/generate_kube_conf_files.sh "${LOADBALANCER}"

${BASE_DIR}/generate_kubeconf_to_be_admin.sh

${BASE_DIR}/generate_worker_certs.sh "${LOADBALANCER}" "un100d02" "192.168.1.34"

