# Latest buildah is buggy use v1.9.0 until this is resolved:
# https://github.com/containers/buildah/issues/1821
FROM quay.io/buildah/stable:v1.9.0
RUN yum -y install wget

ENV KUBE_LATEST_VERSION="v1.11.1"

COPY appsody-0.0.0-1.x86_64.rpm ./appsody-0.0.0-1.x86_64.rpm
RUN yum localinstall -y ./appsody-0.0.0-1.x86_64.rpm
RUN wget https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl
RUN mv ./kubectl /usr/local/bin
RUN chmod 755 /usr/local/bin/kubectl

COPY ./pfe-setup.sh /tmp/pfe-setup.sh
RUN chmod 755 /tmp/pfe-setup.sh
COPY ./che-setup.sh /tmp/che-setup.sh
RUN chmod 755 /tmp/che-setup.sh
COPY ./set-cw-env.sh ./set-cw-env.sh
RUN chmod 755 ./set-cw-env.sh