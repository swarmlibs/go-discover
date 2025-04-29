ARG GO_VERSION
ARG ALPINE_VERSION

FROM --platform=${BUILDPLATFORM} golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS builder
RUN apk add --no-cache git make
RUN --mount=type=bind,source=./go-discover,target=/tmp/go-discover \
    --mount=type=cache,target=/go/pkg/mod \
    <<EOT
    set -ex
    mkdir -p /output
    cd /tmp/go-discover && {
        export CGO_ENABLED=0
        export GOOS=linux
        for GOARCH in amd64 arm64; do
            export GOARCH
            go build -o /output/discover-$GOOS-$GOARCH
        done
    }
EOT

FROM scratch
ARG TARGETOS
ARG TARGETARCH
COPY --from=builder /output/discover-$TARGETOS-$TARGETARCH /discover

# Cross-Platform Binaries
FROM --platform=${BUILDPLATFORM} golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS cross-platforms
RUN apk add --no-cache git make
RUN --mount=type=bind,source=./go-discover,target=/tmp/go-discover \
    --mount=type=cache,target=/go/pkg/mod \
    <<EOT
    set -ex
    mkdir -p /output
    cd /tmp/go-discover && {
        export CGO_ENABLED=0
        for GOOS in linux darwin; do
            export GOOS
            for GOARCH in amd64 arm64; do
                export GOARCH
                go build -o /output/discover-$GOOS-$GOARCH
            done
        done
    }
EOT

FROM scratch AS binaries
COPY --from=cross-platforms /output/discover-* /
