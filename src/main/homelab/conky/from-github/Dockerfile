FROM alpine:3.17.2
LABEL maintainer="sebastian@sommerfeld.io"

RUN apk add github-cli=2.20.2-r2

ARG USER=githubcli
RUN adduser -D $USER

USER $USER

ENTRYPOINT [ "/usr/bin/gh" ]
