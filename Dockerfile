###############################################################################
#### Builder
###############################################################################
FROM golang:alpine AS builder

ARG BCRYPT_TOOL_VERSION="latest"

#### the module path of today's releases - the old gophers.dev path ends at 1.1.1
RUN case "${BCRYPT_TOOL_VERSION}" in latest|v*) query="${BCRYPT_TOOL_VERSION}" ;; *) query="v${BCRYPT_TOOL_VERSION}" ;; esac \
 && CGO_ENABLED=0 go install -trimpath -ldflags "-s -w" "github.com/shoenig/bcrypt-tool@${query}"

###############################################################################
#### Image
###############################################################################
FROM busybox:latest

ARG BCRYPT_TOOL_VERSION="latest"
ARG BUILD_DATE="development"
LABEL org.label-schema.name="bcrypt" \
      org.label-schema.description="bcrypt-tool on BusyBox to hash passwords and check bcrypt hashes - amd64 and arm64, rebuilt weekly" \
      org.label-schema.vendor="epicsoft LLC / Alexander Schwarz <info@epicsoft.one>" \
      org.label-schema.url="https://gitlab.com/epicsoft-networks/bcrypt" \
      org.label-schema.vcs-url="https://gitlab.com/epicsoft-networks/bcrypt/-/tree/master" \
      org.label-schema.version=${BCRYPT_TOOL_VERSION} \
      org.label-schema.schema-version="1.0" \
      org.label-schema.build-date=${BUILD_DATE}

LABEL image.name="epicsoft_bcrypt" \
      image.description="bcrypt-tool on BusyBox to hash passwords and check bcrypt hashes - amd64 and arm64, rebuilt weekly" \
      image.bcrypt-tool.version=${BCRYPT_TOOL_VERSION} \
      maintainer="epicsoft LLC" \
      maintainer.name="Alexander Schwarz <info@epicsoft.one>" \
      maintainer.copyright="Copyright 2017-2026 epicsoft LLC / Alexander Schwarz" \
      license="MIT"

COPY --from=builder /go/bin/bcrypt-tool /usr/local/bin/bcrypt

ENTRYPOINT ["bcrypt"]

CMD ["help"]
