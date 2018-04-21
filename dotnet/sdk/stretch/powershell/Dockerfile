FROM microsoft/dotnet:sdk as base

ARG LANGUAGE=en_US

WORKDIR /root

LABEL maintainer="Joel Bennett <Jaykul@HuddledMasses.org>" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.name="jupyter-powershell-builder"\
    description="Builds the latest Jupyter-PowerShell kernel."

# Fix locales (on debian, locale-gen doesn't take parameters)
ENV LANG C.UTF-8
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        apt-utils \
        libc-l10n \
        locales \
        ca-certificates \
        curl \
        apt-transport-https \
 && localedef -i ${LANGUAGE} -c -f UTF-8 -A /usr/share/locale/locale.alias ${LANGUAGE}.UTF-8
ENV LANG ${LANGUAGE}.UTF-8

# Import the public repository GPG keys for Microsoft
# Register the Microsoft Debian 9 (aka Stretch) repository
# And then install powershell from Microsoft Repo
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
 && curl https://packages.microsoft.com/config/debian/9/prod.list | tee /etc/apt/sources.list.d/microsoft.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends powershell \
 && rm -rf /var/lib/apt/lists/* \