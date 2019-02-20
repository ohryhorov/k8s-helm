#!/bin/bash -xv

REPO_URL="https://github.com/ohryhorov/k8s-helm"
REPO_DIR="/srv/k8s-helm"
git clone ${REPO_URL} ${REPO_DIR}
cd ${REPO_DIR}

SCRIPTS_DIR="${REPO_DIR}/scripts"
export HOME=/root/

chmod +x ${SCRIPTS_DIR}/* -R

${SCRIPTS_DIR}/0.install_k8s_prereq.sh

${SCRIPTS_DIR}/10.install_docker_ce.sh

${SCRIPTS_DIR}/20.install_cri-o.sh

${SCRIPTS_DIR}/30.install_containerd.sh

${SCRIPTS_DIR}/40.install_kubeadm.sh

${SCRIPTS_DIR}/50.init_k8s_helm.sh

