ARG GO_VERSION
ARG ALPINE_VERSION

# buildkit
ARG TARGETOS="linux"
ARG TARGETARCH="amd64"
ARG BUILDPLATFORM="linux/amd64"

FROM --platform=${BUILDPLATFORM} golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS builder
RUN apk add --no-cache git make
ARG GO_SOCKADDR_VERSION="master"
ADD https://github.com/hashicorp/go-discover.git#${GO_SOCKADDR_VERSION} /tmp/source
RUN --mount=type=cache,target=/go/pkg/mod \
    <<EOT
    set -ex
    cd /tmp/source/cmd/discover
    export CGO_ENABLED=0
    export GOOS=linux
    for GOARCH in amd64 arm64; do
        export GOARCH
        go build -o /discover-$GOOS-$GOARCH
    done
EOT

FROM scratch
ARG TARGETOS
ARG TARGETARCH
COPY --from=builder /discover-$TARGETOS-$TARGETARCH /discover
