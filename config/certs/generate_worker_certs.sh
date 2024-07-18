!/bin/bash
set -ex

SCRIPT_DIR=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_DIR")
OUT="${BASE_DIR}/generated"
CA_CRT="${OUT}/ca.crt"
CA_PRIV_KEY="${OUT}/ca.key"

ARG_LOAD_BALANCER_IP=$1
ARG_WORKER_NODE_NAME=$2
ARG_WORKER_NODE_IP=$3

gen_certs() {
    local PRIV_KEY=$1
    local CSR=$2
    local CA=$3
    local SUBJ=$4
    local SSL=$5
    openssl genrsa -out "${PRIV_KEY}" 4096
    openssl req -new -sha512 -noenc \
	    -key "${PRIV_KEY}" \
	    -subj "${SUBJ}" \
	    -out "${CSR}" \
	    -config "${SSL}"
    openssl x509 -req -days 3650 -CAcreateserial \
	    -CA "${CA_CRT}" -CAkey "${CA_PRIV_KEY}" \
	    -in "${CSR}" \
	    -out "${CA}" \
	    -extensions v3_req \
	    -extfile "${SSL}"
}

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

SSL_CONF="${OUT}/openssl-${ARG_WORKER_NODE_NAME}.cnf"

cat > "${SSL_CONF}" <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = ${ARG_WORKER_NODE_NAME}
IP.1 = ${ARG_WORKER_NODE_IP}
EOF

gen_certs \
    "${OUT}/node-${ARG_WORKER_NODE_NAME}.key" \
    "${OUT}/node-${ARG_WORKER_NODE_NAME}.csr" \
    "${OUT}/node-${ARG_WORKER_NODE_NAME}.crt" \
    "/CN=system:node:${ARG_WORKER_NODE_NAME}/O=system:nodes" \
    "${SSL_CONF}"


gen_kubeconf \
    "${ARG_LOAD_BALANCER_IP}" \
    "node-${ARG_WORKER_NODE_NAME}" \
    "system:node:${ARG_WORKER_NODE_NAME}" \
    "${OUT}/node-${ARG_WORKER_NODE_NAME}.kubeconfig"

