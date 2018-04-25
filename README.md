# Jaykul's Docker Images

This is just a repository of dockerfiles. It currently consists mostly of images I made during the building and testing of my [Jupyter PowerShell Kernel](https://github.com/Jaykul/Jupyter-PowerShell), including one for a container with the latest .NET Core SDK and PowerShell, and some compiled output images with jupyter configured to auto-start.

## PowerShell

I have two PowerShell base images here which are only special because they have the latest .NET Core SDK image included, with the latest PowerShell release installed on top, and _set as shell_.

It's important to realize that this image is running PowerShell Core as the `SHELL` in docker, so if you use it, any thing you `RUN` in it runs in PowerShell by default.

You can try it by running:

```posh
docker run -it jaykul/powershell
```

One side note: both of these boxes have `git` preinstalled (it comes in the debian stretch image, but I added it to the nanoserver image).

## Jupyter

The base images here are [jupyter's `-notebook` images](https://hub.docker.com/r/jupyter) and they run bash. Note that these are not pure debian stretch, but ubuntu xenial. They are the base and minimal notebook images from jupyter, with my [PowerShell Kernel](https://github.com/Jaykul/Jupyter-PowerShell) installed and registered.

The dockerfiles here are actually Multi-Stage files, they start with the PowerShell image I mentioned above, `git clone` the kernel and compile it, and then copy the compiled kernel into the jupyter base images...

You can try it by running:

```posh
docker run -it --rm -p 8888:8888 jaykul/powershell-notebook-base
```

### A few extra points

* You can use the new Jupyter Labs interface by specifying the `JUPYTER_ENABLE_LAB` environment variable.
* You can map a folder on your computer into the jupyter environment by specifying a subfolder of `/home/jovyan` as the destination
* The `powershell-notebook` image is slighly

```posh
docker run -it --rm -p 8888:8888 -v $pwd:/home/jovyan/work -e JUPYTER_ENABLE_LAB=1 jaykul/powershell-notebook
```