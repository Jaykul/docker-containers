Push-Location $PSScriptRoot -StackName PreBuild
foreach ($DockerFile in Get-ChildItem -Recurse Dockerfile | Split-Path | Resolve-Path -relative) {
    Push-Location $DockerFile
    $Tag, $Name = ($DockerFile -split "[\\\/](?=[^\\\/]*$)", 2 ) -replace "[\\\/]", "-" -replace "^.-"

    # $Tag, $Name = $DockerFile -replace "[\\\/]", "-" -replace "^.-" -split "-(?=[^-]*$)", 2
    Write-Host "`n`n`nBuilding $DockerFile" -ForegroundColor Cyan
    Write-Host "jaykul/$($Name):$($Tag)`n" -ForegroundColor Cyan
    if(Get-Command gitversion) {
        $version = gitversion | convertfrom-json
        docker build -t "jaykul/$($Name):latest" -t "jaykul/$($Name):$($Tag)" -t "jaykul/$($Name):$($version.SemVer)" -t "jaykul/$($Name):$($version.Sha.Substring(0,9))" --label org.label-schema.vcs-ref=$($Version.SHA) --label org.label-schema.version=$($Version.SemVer) .
    } else {
        docker build -t "jaykul/$($Name):latest" -t "jaykul/$($Name):$($Tag)" .
    }
    Pop-Location
}
Pop-Location -StackName PreBuild