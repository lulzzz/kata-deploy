FROM microsoft/azure-cli:2.0.47

LABEL version="0.0.0"
LABEL maintainer="eric and sai"
LABEL com.github.actions.name="Test kata-deploy in an AKS cluster"
LABEL com.github.actions.description="Wow.  Where do i start.  Create an AKS cluster with containerd+runtimeclass, then deploys kata onto it and even might start a workload. nbd"

ARG AKS_ENGINE_VER="v0.32.0"

ENV GITHUB_ACTION_NAME="Test kata-deploy in an AKS cluster"
ARG K8S_VER="v1.12.0"

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${K8S_VER}/bin/linux/amd64/kubectl \
  && chmod +x ./kubectl \
  && mv ./kubectl /usr/local/bin/kubectl

RUN curl -LO https://github.com/Azure/aks-engine/releases/download/${AKS_ENGINE_VER}/aks-engine-${AKS_ENGINE_VER}-linux-amd64.tar.gz \
  && tar xvf aks-engine-${AKS_ENGINE_VER}-linux-amd64.tar.gz \
  && mv aks-engine-${AKS_ENGINE_VER}-linux-amd64/aks-engine /usr/local/bin/aks-engine \
  && rm aks-engine-${AKS_ENGINE_VER}-linux-amd64.tar.gz

COPY kubernetes-containerd.json /
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
