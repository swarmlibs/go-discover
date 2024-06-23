ARG GO_VERSION
ARG ALPINE_VERSION

ARG BUILDPLATFORM="linux/amd64"
ARG GO_SOCKADDR_VERSION="master"

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS builder
RUN apk add --no-cache git make
ARG GO_SOCKADDR_VERSION
ADD https://github.com/hashicorp/go-discover.git#${GO_SOCKADDR_VERSION} /hashicorp/go-discover
RUN <<EOT
    set -ex
    cd /hashicorp/go-discover/cmd/discover
    go build -o /discover
EOT

FROM scratch
COPY --from=builder /hashicorp/go-discover/cmd/discover /discover
