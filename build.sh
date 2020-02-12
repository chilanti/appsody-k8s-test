#!/bin/bash
# Takes one parm: the image tag
set -e

docker build -t chilantim/appsody-k8s:$1 .
docker push chilantim/appsody-k8s:$1