FROM alpine:3.19.1 AS base

RUN apk update && apk upgrade
RUN apk --no-cache --update add \
    bash curl git jq icu-libs zip \
    docker openrc docker-cli-compose
RUN rc-update add docker boot

FROM base AS setup-tools
ENV DOTNET_SDK_VERSION=7
RUN apk --no-cache --update add \
    nodejs npm \
    dotnet${DOTNET_SDK_VERSION}-sdk

FROM base AS pwsh
COPY --from=mcr.microsoft.com/powershell:alpine-3.17 \
    ["/opt/microsoft/powershell", "/opt/microsoft/powershell"]
RUN chmod +x /opt/microsoft/powershell/7/pwsh
RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

FROM base AS final

ENV TARGETARCH="linux-musl-x64"

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

# Another option is to run the agent as root.
ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT ./start.sh