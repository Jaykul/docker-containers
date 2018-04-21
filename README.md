# Jaykul's Docker Images

This is just a repository of dockerfiles. It currently consists mostly of images I made during the building and testing of my [Jupyter PowerShell Kernel](https://github.com/Jaykul/Jupyter-PowerShell), including one for a container with the latest .NET Core SDK and PowerShell, and some compiled output images with jupyter configured to auto-start.

## PowerShell

The base image here is the latest .NET Core SDK image (on debian stretch), with the latest PowerShell release installed on top, and _set as shell_.

It's important to realize that this image is running PowerShell Core as the `SHELL` in docker, so if you use it, any thing you `RUN` in it runs in PowerShell by default.

## Jupyter

The base images here are [jupyter's `-notebook` images](https://hub.docker.com/r/jupyter) and they run bash. These are the base and minimal notebook images from jupyter, with my [PowerShell Kernel](https://github.com/Jaykul/Jupyter-PowerShell) installed and registered.

The dockerfiles here are actually Multi-Stage files, they start with the PowerShell image I mentioned above, `git clone` the kernel and compile it, and then copy the compiled kernel into the jupyter base images...