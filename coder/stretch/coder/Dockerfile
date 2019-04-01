FROM codercom/code-server as coder
FROM jaykul/powershell:sdk-stretch as base

WORKDIR /root/project

# For now, I'm moving coder's server over to my base image because it's easiest
COPY --from=coder /usr/local/bin/code-server /usr/local/bin/code-server
EXPOSE 8443

ENV LC_ALL=en_US.UTF-8
SHELL ["/bin/bash","-c"]

ENTRYPOINT ["code-server"]

LABEL maintainer="Joel Bennett <Jaykul@HuddledMasses.org>"
LABEL org.label-schema.description="A Debian image of coder-server with the .NET Core SDK and PowerShell"
LABEL org.label-schema.name="powershell"
LABEL org.label-schema.docker.cmd="docker run -it jaykul/powershell"
LABEL org.label-schema.vcs-url="https://github.com/Jaykul/docker-containers"