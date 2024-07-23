# infra-ansible-kubernetes
My automated infrastructure deployment
1. automates kubernetes deployment (Based on mmumshad/kubernetes-the-hard-way)
    - Note: cni pod networking, dns, ingress controller, and loadbalancer are not yet included in code.
2. also has glusterfs -- Not yet finished.

Steps:
1. Create the topology in both
    - *inventory.yaml* and *config/certs/generate_all.sh*
    - Nodes will be needed for etcd, control plane, load balancer, and worker nodes.
2. *config/certs/generate_all.sh*
*ansible-playbook -i inventory.yaml playbooks/kubernetes/\**
3. etcd.yaml
4. control_plane.yaml
5. load_balancer.yaml
6. worker_pre.yaml
either:
7. worker.yaml
or (if with tls-bootstratpping) (currently not working)
7. tls_bootstrapping.yaml
7. worker_with_tls_bootstrap.yaml
9. *kubectl apply -f kube-flannel CNI pod networking*
10. init_rbac_kubelet_authorization.yaml
11. *kubectl apply -f coredns.yaml*
12. *istioctl install --set profile=default -f ../istio_examples/overrides.yaml*
13. *kubectl apply -f metallb-native.yaml*
     - Note about WA: kubectl delete validatingwebhookconfigurations.admissionregistration.k8s.io metallb-webhook-configuration


Things to improve:
1. server, node0, and node1 are still hardcoded names and is set in my router's dns settings.
   The scripts needs to adapt based on the inventory file. Currently, this wont work when I
   provision my next 2 (3+3) raspberry pi 5 cluster. I think majority of that work should is on
   the certs and kubeconfig generation.
2. DNS stuff. I am bound by my ISP's provided router-- Orange funbox. Setting the DNS names
   here are less than ideal (dashes are not supported and subdomains does not work). It also
   doesn't have support for alternative DNS provides. So additional configuration is needed
   if I want to have private DNS servers (like making it a DHCP server also).
3. The generation of certificates and kubeconfig needs to be "ansible-fy". It is handled by
   bash scripts.
4. Refactor "init_server.yaml" to be 3 multiple playbooks. Currently, all of the functionalities
   of server (api-server, controller-manager, and scheduler) are all in one playbook. But in
   production environments these can be ran on different hosts and it should be decoupled for flexibility.
5. Encryption at rest is still not implemented.
6. Override ~/.kube/config generation behavior.
7. Refactor glusterfs provisioning code. It feels like the vars are unorganized and the playbooks are a mess
8. Add revert counterparts to glusterfs playbooks.

