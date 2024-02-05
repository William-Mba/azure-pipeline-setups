FROM alpine:3.19.1

RUN apk update && apk upgrade
RUN apk --no-cache --update add bash curl git jq icu-libs zip docker openrc docker-cli-compose
RUN rc-update add docker boot

ENV TARGETARCH="linux-musl-x64"

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

# Another option is to run the agent as root.
ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT ./start.sh