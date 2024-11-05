# About

Discover nodes in cloud environments

https://github.com/hashicorp/go-discover

## Usage

```Dockerfile
FROM swarmlibs/go-discover:main AS go-discover

FROM your-base-image
COPY --from=go-discover /discover /usr/bin/discover
```
