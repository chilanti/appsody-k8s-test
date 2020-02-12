#!/bin/bash
export APPSODY_K8S_EXPERIMENTAL=TRUE
export PVC_NAME=appsody-workspace
export APPSODY_MOUNT_CONTROLLER=/workspace123/.extensions/codewind-appsody-extension/bin/appsody-controller
export CHE_INGRESS_HOST=che-ingress-host.9.42.9.149.nip.io
export APPSODY_MOUNT_PROJECT=/workspace123/projects/$1
export CODEWIND_PROJECT_ID=codewindprojectid
export CODEWIND_OWNER_NAME=che-emulator
export CODEWIND_OWNER_UID=$2