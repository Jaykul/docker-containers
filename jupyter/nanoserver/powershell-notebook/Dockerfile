# escape=`

# In this image, the SHELL is cmd
# We literally just need this image to work around the fact that miniconda doesn't have a .zip
FROM microsoft/windowsservercore as download
WORKDIR /tmp
ADD https://repo.continuum.io/miniconda/Miniconda3-latest-Windows-x86_64.exe Miniconda3.exe
RUN .\Miniconda3.exe /InstallationType=JustMe /RegisterPython=0 /S /D=C:\Miniconda3

# Note that in this image, the SHELL is pwsh
FROM jaykul/nano-powershell as builder

RUN git clone https://github.com/Jaykul/Jupyter-PowerShell.git; `
    # TO USE DEV BRANCH: set-location Jupyter-PowerShell; git checkout dev; `
    pwsh /Users/ContainerUser/Jupyter-PowerShell/build.ps1 -Platform Windows; `
    $kernel = "'/Users/ContainerUser/Jupyter-PowerShell/Output/Release/Windows/kernel.json'"; `
    set-content $kernel ((get-content $kernel) -replace "'PowerShell-Kernel'", "'C:\\Program Files\\Jupyter-PowerShell\\PowerShell-Kernel'"); 


# But in this image, the SHELL is cmd
# FROM microsoft/nanoserver as jupyter-base

FROM microsoft/nanoserver as runtime

# Set Up JUPYTER
COPY --from=download ["/Miniconda3", "/Miniconda3"]
RUN setx /M PATH "%PATH%;C:\Miniconda3;C:\Miniconda3\Scripts;C:\Miniconda3\Library\bin"
RUN conda config --system --prepend channels conda-forge && `
    conda config --system --set auto_update_conda false && `
    conda config --system --set show_channel_urls true && `
    conda update --all --quiet --yes && `
    conda install --quiet --yes notebook jupyterlab && `
    #    conda remove tornado --force && `
    conda clean -tipsy



# Copy the kernel itself
COPY --from=builder ["/Users/ContainerUser/Jupyter-PowerShell/Output/Release/Windows", "/Program Files/Jupyter-PowerShell"]
# Copy the kernel registration file
COPY --from=builder ["/Users/ContainerUser/Jupyter-PowerShell/Output/Release/Windows/kernel.json", "/Users/ContainerUser/AppData/Roaming/jupyter/kernels/powershell/kernel.json"]
# And some notebooks to start with. Wildcard doesn't seem to work here
COPY --from=builder ["/Users/ContainerUser/Jupyter-PowerShell/ReadMe.ipynb", "/Users/ContainerUser/Documents/ReadMe.ipynb"]
COPY --from=builder ["/Users/ContainerUser/Jupyter-PowerShell/Features.ipynb", "/Users/ContainerUser/Documents/Features.ipynb"]

EXPOSE 8888
WORKDIR /Users/ContainerUser/Documents
CMD jupyter notebook
# TODO: Install Python and Jupyter 
# RUN conda install -c conda-forge ipywidgets

LABEL maintainer="Joel Bennett <Jaykul@HuddledMasses.org>" 
LABEL org.label-schema.description="An Ubuntu image with Jupyter and the Jupyter-PowerShell kernel"
LABEL org.label-schema.name="powershell-notebook"
LABEL org.label-schema.docker.cmd="docker run -it --rm -p 8888:8888 jaykul/powershell-notebook" 
LABEL org.label-schema.schema-version="1.0.0-rc.1"
LABEL org.label-schema.vcs-url="https://github.com/Jaykul/Jupyter-PowerShell"