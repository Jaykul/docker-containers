FROM jaykul/powershell:dotnet-sdk-stretch as builder
WORKDIR /root

# Use array to avoid Docker prepending /bin/sh -c
RUN git clone https://github.com/Jaykul/Jupyter-PowerShell.git \
    && pwsh /root/Jupyter-PowerShell/build.ps1 -Platform Linux

FROM jupyter/minimal-notebook:latest as runtime

LABEL maintainer="Joel Bennett <Jaykul@HuddledMasses.org>" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.name="jupyter-powershell" \
    org.label-schema.vcs-url="https://github.com/Jaykul/Jupyter-PowerShell" \
    description="This Dockerfile includes jupyter and the Jupyter-PowerShell kernel."

USER root
# Do this up front because it can be cached
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    libc6 libgcc1 libgssapi-krb5-2 liblttng-ust0 libstdc++6 libcurl3 libunwind8 libuuid1 zlib1g libssl1.0.0 libicu55 \
    && rm -rf /var/lib/apt/lists/*

# Copy the kernel itself
COPY --from=builder /root/Jupyter-PowerShell/Output/Release/Linux /usr/src/jupyter-powershell
# And the kernel registration file
COPY --from=builder /root/Jupyter-PowerShell/Output/Release/Linux/kernel.json /usr/local/share/jupyter/kernels/powershell/kernel.json
# And some notebooks to start with
COPY --from=builder /root/Jupyter-PowerShell/*.ipynb ${HOME}/

RUN chown -R ${NB_UID} ${HOME} \
    && chmod +x /usr/src/jupyter-powershell/PowerShell-Kernel \
    && sed -i -e "s.PowerShell-Kernel./usr/src/jupyter-powershell/PowerShell-Kernel." /usr/local/share/jupyter/kernels/powershell/kernel.json \
    && ls ${HOME} -fl

USER ${NB_USER}