FROM golang:alpine AS buildenv
RUN go install gophers.dev/cmds/bcrypt-tool@latest \
 && chmod +x /go/bin/bcrypt-tool

FROM busybox:latest

ARG BUILD_DATE
LABEL org.label-schema.name="BCrypt CLI" \
      org.label-schema.description="BCrypt CLI for generating and matching BCrypt hashes" \
      org.label-schema.vendor="epicsoft.de / Alexander Schwarz <schwarz@epicsoft.de>" \
      org.label-schema.version="latest" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.build-date=${BUILD_DATE}

LABEL image.name="epicsoft_bcrypt" \
      image.description="BCrypt CLI for generating and matching BCrypt hashes" \
      maintainer="epicsoft.de" \
      maintainer.name="Alexander Schwarz <schwarz@epicsoft.de>" \
      maintainer.copyright="Copyright 2017-2022 epicsoft.de / Alexander Schwarz" \
      license="MIT"

COPY --from=buildenv /go/bin/bcrypt-tool /usr/local/bin/bcrypt

ENTRYPOINT ["bcrypt"]

CMD ["help"]
