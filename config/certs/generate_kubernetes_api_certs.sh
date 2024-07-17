!/bin/bash
set -ex

SCRIPT_DIR=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_DIR")
OUT="${BASE_DIR}/generated"
CA_CRT="${OUT}/ca.crt"
CA_PRIV_KEY="${OUT}/ca.key"

ARG_ADDITIONAL_ALT_NAMES_API_SERVER=( $1 )
ARG_ADDITIONAL_ALT_NAMES_ETCD=( $2 )

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

SSL_CONF="${OUT}/openssl.cnf"

cat > "${SSL_CONF}" <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[v3_req]
basicConstraints = critical, CA:FALSE
keyUsage = critical, nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster
DNS.5 = kubernetes.default.svc.cluster.local
EOF

for index in ${!ARG_ADDITIONAL_ALT_NAMES_API_SERVER[@]}
do
    # +1 is needed becuase bash array index starts at 0 while ssl conf starts at 1
    echo "IP.$(($index+1)) = ${ARG_ADDITIONAL_ALT_NAMES_API_SERVER[$index]}" >> "${SSL_CONF}"
done

gen_certs \
    "${OUT}/kube-apiserver.key" \
    "${OUT}/kube-apiserver.csr" \
    "${OUT}/kube-apiserver.crt" \
    "/CN=kube-apiserver/O=Kubernetes" \
    "${SSL_CONF}"

SSL_CONF_KUBELET="${OUT}/openssl-kubelet.cnf"
cat > "${SSL_CONF_KUBELET}" <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[v3_req]
basicConstraints = critical, CA:FALSE
keyUsage = critical, nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth
EOF

gen_certs \
    "${OUT}/apiserver-kubelet-client.key" \
    "${OUT}/apiserver-kubelet-client.csr" \
    "${OUT}/apiserver-kubelet-client.crt" \
    "/CN=kube-apiserver-kubelet-client/O=system:masters" \
    "${SSL_CONF_KUBELET}"


SSL_CONF_ETCD="${OUT}/openssl-etcd.cnf"
cat > "${SSL_CONF_ETCD}" <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
EOF

for index in ${!ARG_ADDITIONAL_ALT_NAMES_ETCD[@]}
do
    # +1 is needed becuase bash array index starts at 0 while ssl conf starts at 1
    echo "IP.$(($index+1)) = ${ARG_ADDITIONAL_ALT_NAMES_ETCD[$index]}" >> "${SSL_CONF_ETCD}"
done

gen_certs \
    "${OUT}/etcd-server.key" \
    "${OUT}/etcd-server.csr" \
    "${OUT}/etcd-server.crt" \
    "/CN=etcd-server/O=Kubernetes" \
    "${SSL_CONF_ETCD}"

