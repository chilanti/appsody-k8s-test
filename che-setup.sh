#!/bin/bash
cd /workspaces
rm -rf * .*
mkdir -p /workspaces/workspace123/.extensions/codewind-appsody-extension/bin
mkdir -p /workspaces/workspace123/projects
cp /tmp/appsody-controller /workspaces/workspace123/.extensions/codewind-appsody-extension/bin/appsody-controller
chmod ugo+rx /workspaces/workspace123/.extensions/codewind-appsody-extension/bin/appsody-controller
ln -s /workspaces/workspace123 /workspace123

KUBE_MASTER_IP=`kubectl get node --selector='node-role.kubernetes.io/master' --output=wide|awk '{print $6}'|grep -e '^[0-9]'`
echo export KUBE_MASTER_IP=$KUBE_MASTER_IP > /etc/profile.d/setkubeip.sh
chmod 755 /etc/profile.d/setkubeip.sh
. /etc/profile
sleep 1d