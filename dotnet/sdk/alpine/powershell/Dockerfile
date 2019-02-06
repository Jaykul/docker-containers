FROM microsoft/dotnet:2.2-sdk-alpine as build

ARG PS_VERSION=6.1.2
ARG PS_INSTALL_VERSION=6

ADD https://github.com/PowerShell/PowerShell/releases/download/v$PS_VERSION/powershell-$PS_VERSION-linux-alpine-x64.tar.gz /tmp/powershell.tar.gz

# define the folder we will be installing PowerShell to
ENV PS_INSTALL_FOLDER=/opt/microsoft/powershell/$PS_INSTALL_VERSION

# Create the install folder
RUN mkdir -p ${PS_INSTALL_FOLDER}

# Unzip the Linux tar.gz
RUN tar zxf /tmp/powershell.tar.gz -C ${PS_INSTALL_FOLDER}

# This image is just the dotnet SDK with PowerShell preinstalled
FROM microsoft/dotnet:2.2-sdk-alpine as release
ARG PS_INSTALL_VERSION=6

# Copy the files we need from the previous stage
COPY --from=build ["/opt/microsoft/powershell", "/opt/microsoft/powershell"]

# set a fixed location for the Module analysis cache
ENV PSModuleAnalysisCachePath=/var/cache/microsoft/powershell/PSModuleAnalysisCache/ModuleAnalysisCache \
    PS_INSTALL_FOLDER=/opt/microsoft/powershell/$PS_INSTALL_VERSION

# Update the core
RUN apk update \
    && apk add --no-cache \
    ca-certificates \
    # less \
    # curl \
    \
    # PowerShell dependencies (which aren't .NET Core dependencies)
    ncurses-terminfo-base \
    icu-libs \
 # Create the pwsh symbolic link that points to powershell
 && ln -s ${PS_INSTALL_FOLDER}/pwsh /usr/bin/pwsh \
 # intialize powershell module cache
 && pwsh \
    -NoLogo \
    -NoProfile \
    -Command " \
    \$ErrorActionPreference = 'Stop' ; \
    \$ProgressPreference = 'SilentlyContinue' ; \
    while(!(Test-Path -Path \$env:PSModuleAnalysisCachePath)) {  \
    Write-Host "'Waiting for $env:PSModuleAnalysisCachePath'" ; \
    Start-Sleep -Seconds 6 ; \
    }"

SHELL ["pwsh", "-command"]
ENTRYPOINT ["pwsh"]

LABEL maintainer="Joel Bennett <Jaykul@HuddledMasses.org>"
LABEL org.label-schema.description="An Ubuntu image with the .NET Core SDK and PowerShell"
LABEL org.label-schema.name="powershell"
LABEL org.label-schema.docker.cmd="docker run -it jaykul/powershell"
LABEL org.label-schema.vcs-url="https://github.com/Jaykul/docker-containers"