#!/bin/bash

#ln -s /projects /codewind-workspace
KUBE_MASTER_IP=`kubectl get node --selector='node-role.kubernetes.io/master' --output=wide|awk '{print $6}'|grep -e '^[0-9]'`
echo export KUBE_MASTER_IP=$KUBE_MASTER_IP > /etc/profile.d/setkubeip.sh
chmod 755 /etc/profile.d/setkubeip.sh
. /etc/profile
sleep 1d