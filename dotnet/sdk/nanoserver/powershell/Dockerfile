# escape=`
# Use server core as an installer container to download and extract files until nano gets curl and tar
FROM microsoft/windowsservercore AS source
# Arguments for installing powershell, must be defined in the container they are used
ARG PS_VERSION=6.0.2
ARG GIT_VERSION=2.17.0

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN if (!($env:PS_VERSION -match '^\d+\.\d+\.\d+(-\w+(\.\d+)?)?$' )) {throw ('PS_Version ({0}) must match the regex "^\d+\.\d+\.\d+(-\w+(\.\d+)?)?$"' -f $env:PS_VERSION)}

ADD https://github.com/PowerShell/PowerShell/releases/download/v$PS_VERSION/PowerShell-$PS_VERSION-win-x64.zip /powershell.zip
ADD https://github.com/git-for-windows/git/releases/download/v$GIT_VERSION.windows.1/MinGit-$GIT_VERSION-64-bit.zip /git.zip

RUN Expand-Archive powershell.zip -DestinationPath \PowerShell; `
    Expand-Archive git.zip -DestinationPath \Git; `
    Remove-Item *.zip

# This image is just the dotnet SDK with PowerShell preinstalled
FROM microsoft/dotnet:2.0-sdk-nanoserver-1709 as release

COPY --from=source ["PowerShell", "C:\\Program Files\\PowerShell"]
COPY --from=source ["git", "C:\\Program Files\\git"]

RUN setx /M PATH "%PATH%;%ProgramFiles%\PowerShell;%ProgramFiles%\git\cmd"
WORKDIR /Users/ContainerUser

SHELL ["pwsh", "-command"]
ENTRYPOINT ["pwsh"]

LABEL maintainer="Joel Bennett <Jaykul@HuddledMasses.org>" 
LABEL org.label-schema.description="A nanoserver image with the .NET Core SDK and PowerShell"
LABEL org.label-schema.name="nano-powershell"
LABEL org.label-schema.docker.cmd="docker run -it jaykul/nano-powershell"
LABEL org.label-schema.schema-version="1.0.0-rc.1"
LABEL org.label-schema.vcs-url="https://github.com/Jaykul/docker-containers"