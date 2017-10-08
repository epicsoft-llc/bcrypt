FROM golang:alpine AS buildenv
RUN apk add --no-cache git \
 && go get "github.com/shoenig/bcrypt-tool" \
 && chmod +x /go/bin/bcrypt-tool

FROM alpine
LABEL image.name="bcrypt" \
      image.description="bcrypt CLI for generating and matching bcrypt hashes" \
      maintainer="epicsoft.de" \
      maintainer.name="Alexander Schwarz <schwarz@epicsoft.de>" \
      maintainer.copyright="Copyright 2017 epicsoft.de / Alexander Schwarz" \
      license="MIT"
COPY --from=buildenv /go/bin/bcrypt-tool /usr/local/bin/bcrypt
ENTRYPOINT ["bcrypt"]