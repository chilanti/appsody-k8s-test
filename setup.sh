#/bin/bash
oc new-project appsody-k8s
oc adm policy add-scc-to-group privileged system:serviceaccounts:appsody-k8s
oc adm policy add-scc-to-group anyuid system:serviceaccounts:appsody-k8s
oc apply -f ./service-account.yaml
oc apply -f ./cluster-role-binding.yaml
oc apply -f ./pvc.yaml