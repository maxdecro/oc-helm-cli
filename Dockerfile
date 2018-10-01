FROM debian as builder

ARG OPENSHIFT_CLI_SOURCE="https://github.com/openshift/origin/releases/download/v3.10.0/openshift-origin-client-tools-v3.10.0-dd10d17-linux-64bit.tar.gz"
ARG HELM_CLIENT_SOURCE="https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-rc.4-linux-amd64.tar.gz"

ENV WORKDIR="~/download"
WORKDIR $WORKDIR

RUN apt-get update && \
    apt-get install -y ca-certificates curl && \
    curl -SsL -o oc-cli.tar.gz ${OPENSHIFT_CLI_SOURCE} && \
    tar xzf oc-cli.tar.gz && \
    mv openshift-origin-client-tools* openshift-origin-client-tools && \
    curl -SsL -o helm-cli.tar.gz ${HELM_CLIENT_SOURCE} && \
    tar xzf helm-cli.tar.gz && \
    mv linux-amd64 helm-cli
    

FROM debian

RUN apt-get update &&  \
    apt-get install -y ca-certificates curl git

COPY --from=builder "~/download/helm-cli/helm" "/usr/local/bin/helm"
RUN chmod +x /usr/local/bin/helm

COPY --from=builder "~/download/openshift-origin-client-tools/oc" "/usr/local/bin/oc"
RUN chmod +x /usr/local/bin/oc

CMD bash