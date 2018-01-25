FROM ubuntu:16.04

ARG KUBERNETES_VERSION

ENV DEBIAN_FRONTEND=noninteractive \
    container=docker \
    KUBERNETES_DOWNLOAD_ROOT=https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64 \
    KUBERNETES_COMPONENT=kube-controller-manager

RUN set -x \
    && apt-get update \
    && apt-get install -y \
        curl apt-transport-https

RUN curl 'https://download.ceph.com/keys/release.asc' | apt-key add -
RUN echo "deb https://download.ceph.com/debian-luminous/ xenial main" > /etc/apt/sources.list.d/ceph.list

RUN set -x \
    && apt-get update \
    && apt-get install -y \
        ceph-common \
    && curl -L ${KUBERNETES_DOWNLOAD_ROOT}/${KUBERNETES_COMPONENT} -o /usr/bin/${KUBERNETES_COMPONENT} \
    && chmod +x /usr/bin/${KUBERNETES_COMPONENT} \
    && apt-get autoremove -y \
    && apt-get purge -y --auto-remove \
        curl \
    && rm -rf /var/lib/apt/lists/*
