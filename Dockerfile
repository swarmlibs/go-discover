ARG GO_VERSION
ARG ALPINE_VERSION

FROM --platform=${BUILDPLATFORM} golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS builder
RUN apk add --no-cache git make
RUN --mount=type=bind,source=./go-discover,target=/tmp/go-discover \
    --mount=type=cache,target=/go/pkg/mod \
    <<EOT
    set -ex
    cd /tmp/go-discover
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
