Push-Location $PSScriptRoot
foreach ($DockerFile in Get-ChildItem -Recurse Dockerfile | Split-Path | Resolve-Path -relative) {
    Push-Location $DockerFile
    $Tag, $Name = ($DockerFile -split "[\\\/](?=[^\\\/]*$)", 2 ) -replace "[\\\/]", "-" -replace "^.-"

    # $Tag, $Name = $DockerFile -replace "[\\\/]", "-" -replace "^.-" -split "-(?=[^-]*$)", 2
    Write-Host "`n`n`nBuilding $DockerFile" -ForegroundColor Cyan
    Write-Host "jaykul/$($Name):$($Tag)`n" -ForegroundColor Cyan
    docker build -t "jaykul/$($Name):$($Tag)" .
    if(Get-Command gitversion) {
        $version = gitversion | convertfrom-json
        docker tag  "jaykul/$($Name):$($Tag)" "jaykul/powershell-notebook:$($version.SemVer)"
        docker tag  "jaykul/$($Name):$($Tag)" "jaykul/powershell-notebook:$($version.Sha.Substring(0,9))"
    }
    Pop-Location
}