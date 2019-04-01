# escape=`
# Use server core as an installer container to download and extract files until nano gets curl and tar
FROM microsoft/windowsservercore AS build
# Arguments for installing powershell, must be defined in the container they are used
ARG PS_VERSION=6.1.2
ARG GIT_VERSION=2.20.1

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN if (!($env:PS_VERSION -match '^\d+\.\d+\.\d+(-\w+(\.\d+)?)?$' )) {throw ('PS_Version ({0}) must match the regex "^\d+\.\d+\.\d+(-\w+(\.\d+)?)?$"' -f $env:PS_VERSION)}

ADD https://github.com/PowerShell/PowerShell/releases/download/v$PS_VERSION/PowerShell-$PS_VERSION-win-x64.zip /powershell.zip
ADD https://github.com/git-for-windows/git/releases/download/v$GIT_VERSION.windows.1/MinGit-$GIT_VERSION-64-bit.zip /git.zip

RUN Expand-Archive powershell.zip -DestinationPath \PowerShell; `
    Expand-Archive git.zip -DestinationPath \Git; `
    Remove-Item *.zip

# This image is just the dotnet SDK with PowerShell preinstalled
FROM mcr.microsoft.com/dotnet/core/sdk:2.2-nanoserver-1809 as release
USER Administrator

COPY --from=build ["PowerShell", "C:\\Program Files\\PowerShell"]
COPY --from=build ["git", "C:\\Program Files\\git"]

RUN setx /M PATH "%PATH%;%ProgramFiles%\PowerShell;%ProgramFiles%\git\cmd"
WORKDIR /Users/ContainerUser

SHELL ["pwsh", "-command"]
ENTRYPOINT ["pwsh"]

USER ContainerUser

LABEL maintainer="Joel Bennett <Jaykul@HuddledMasses.org>"
LABEL org.label-schema.description="A nanoserver image with Git, the .NET Core SDK, and PowerShell"
LABEL org.label-schema.name="nano-powershell"
LABEL org.label-schema.docker.cmd="docker run -it jaykul/nano-powershell"
LABEL org.label-schema.vcs-url="https://github.com/Jaykul/docker-containers"