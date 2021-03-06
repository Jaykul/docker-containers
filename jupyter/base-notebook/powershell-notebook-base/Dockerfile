# Note that in this image, the SHELL is pwsh
FROM jaykul/powershell:sdk-stretch as builder

RUN git clone https://github.com/Jaykul/Jupyter-PowerShell.git; \
    pwsh /root/Jupyter-PowerShell/build.ps1 -Platform Linux \
    sed -i -e "s.PowerShell-Kernel./usr/src/jupyter-powershell/PowerShell-Kernel." /root/Jupyter-PowerShell/Output/Release/Linux/kernel.json

# But in this image, the SHELL is /bin/sh
FROM jupyter/base-notebook:latest as runtime

USER root
# Do this up front because it can be cached
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    libc6 libgcc1 libgssapi-krb5-2 liblttng-ust0 libstdc++6 libcurl3 libunwind8 libuuid1 zlib1g libssl1.0.0 libicu55 \
    && rm -rf /var/lib/apt/lists/*

# Copy the kernel itself
COPY --from=builder /root/Jupyter-PowerShell/Output/Release/Linux /usr/src/jupyter-powershell
# And some notebooks to start with
COPY --from=builder /root/Jupyter-PowerShell/*.ipynb ${HOME}/

RUN chown -R ${NB_UID} ${HOME} \
    && chmod +x /usr/src/jupyter-powershell/PowerShell-Kernel \
    && copy /usr/src/jupyter-powershell/kernel.json /usr/local/share/jupyter/kernels/powershell/kernel.json

USER ${NB_USER}
RUN conda install -c conda-forge ipywidgets

LABEL maintainer="Joel Bennett <Jaykul@HuddledMasses.org>"
LABEL org.label-schema.description="An Ubuntu image with Jupyter and the Jupyter-PowerShell kernel"
LABEL org.label-schema.name="powershell-notebook-base"
LABEL org.label-schema.docker.cmd="docker run -it --rm -p 8888:8888 jaykul/powershell-notebook-base"
LABEL org.label-schema.schema-version="1.0.0-rc.1"
LABEL org.label-schema.vcs-url="https://github.com/Jaykul/Jupyter-PowerShell"