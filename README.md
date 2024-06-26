# infra-ansible-kubernetes
Leaning ansible and kubernetes.
This aims to automate kubernetes-the-hard-way by kelseyhightower.


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

