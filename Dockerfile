FROM golang:alpine AS buildenv
RUN apk add --no-cache git \
 && go install gophers.dev/cmds/bcrypt-tool@latest \
 && chmod +x /go/bin/bcrypt-tool

FROM busybox:latest
LABEL image.name="epicsoft_bcrypt" \
      image.description="bcrypt CLI for generating and matching bcrypt hashes" \
      maintainer="epicsoft.de" \
      maintainer.name="Alexander Schwarz <schwarz@epicsoft.de>" \
      maintainer.copyright="Copyright 2017-2021 epicsoft.de / Alexander Schwarz" \
      license="MIT"

COPY --from=buildenv /go/bin/bcrypt-tool /usr/local/bin/bcrypt

ENTRYPOINT ["bcrypt"]

CMD ["help"]
