FROM mcr.microsoft.com/dotnet/core/sdk:2.2-bionic as base

ARG LANGUAGE=en_US
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /root

# Fix locales
ENV LANG C.UTF-8
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        apt-transport-https \
        apt-utils \
        less \
        locales \
        net-tools \
 && apt-get dist-upgrade -y \
 #&& localedef -i ${LANGUAGE} -c -f UTF-8 -A /usr/share/locale/locale.alias ${LANGUAGE}.UTF-8 \
 && locale-gen ${LANGUAGE}.UTF-8 && update-locale
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false \
    LANG=${LANGUAGE}.UTF-8 \
    LC_ALL=${LANGUAGE}.UTF-8

# Import the public repository GPG keys for Microsoft
# Register the Microsoft Debian 9 (aka Stretch) repository
# And then install powershell from Microsoft Repo
RUN curl -O https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb \
 && dpkg -i packages-microsoft-prod.deb \
 && apt-get update \
 && apt-get install -y --no-install-recommends powershell \
 && rm -rf /var/lib/apt/lists/*

SHELL ["pwsh", "-command"]
ENTRYPOINT ["pwsh"]

LABEL maintainer="Joel Bennett <Jaykul@HuddledMasses.org>"
LABEL org.label-schema.description="An Ubuntu image with the .NET Core SDK and PowerShell"
LABEL org.label-schema.name="powershell"
LABEL org.label-schema.docker.cmd="docker run -it jaykul/powershell"
LABEL org.label-schema.vcs-url="https://github.com/Jaykul/docker-containers"