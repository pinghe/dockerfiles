FROM alpine:3.4

# This is the release of https://github.com/hashicorp/docker-base to pull in order
# to provide HashiCorp-built versions of basic utilities like dumb-init and gosu.
ENV DOCKER_BASE_VERSION=0.0.4

# Create an unprivileged user and group first so the IDs get set the same way, even as
# the rest of this may change over time.
RUN addgroup app && \
    adduser -S -G app app

RUN \
    apk add --no-cache ca-certificates gnupg wget && \
    gpg --recv-keys 91A6E7F85D05C65630BEF18951852D87348FFC4C && \
    mkdir -p /tmp/build && \
    cd /tmp/build && \
    wget https://releases.hashicorp.com/docker-base/${DOCKER_BASE_VERSION}/docker-base_${DOCKER_BASE_VERSION}_linux_amd64.zip && \
    wget https://releases.hashicorp.com/docker-base/${DOCKER_BASE_VERSION}/docker-base_${DOCKER_BASE_VERSION}_SHA256SUMS && \
    wget https://releases.hashicorp.com/docker-base/${DOCKER_BASE_VERSION}/docker-base_${DOCKER_BASE_VERSION}_SHA256SUMS.sig && \
    gpg --batch --verify docker-base_${DOCKER_BASE_VERSION}_SHA256SUMS.sig docker-base_${DOCKER_BASE_VERSION}_SHA256SUMS && \
    grep ${DOCKER_BASE_VERSION}_linux_amd64.zip docker-base_${DOCKER_BASE_VERSION}_SHA256SUMS | sha256sum -c && \
    unzip docker-base_${DOCKER_BASE_VERSION}_linux_amd64.zip && \
    cp bin/gosu bin/dumb-init /bin && \
    cd /tmp && \
    rm -rf /tmp/build && \
    apk del gnupg && \
    rm -rf /root/.gnupg

# Default to UTF-8 file.encoding
# RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
