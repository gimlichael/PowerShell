function Clear-Docker-Objects
{
    docker image prune -f
    docker container prune -f
}

function Build-Docker-Image {
    [CmdletBinding()]
    param(
		[Parameter(Mandatory)]
		[string]$Tag,
		[Parameter(Mandatory)]
		[string]$Version,
		[Parameter(ValueFromPipeline)]
		[string]$ContainerRegistry="",
		[Parameter(ValueFromPipeline)]
		[string]$DockerFile="Dockerfile"
    )

	Invoke-Expression "docker build -t $($Tag):$($Version) -f $DockerFile ."
	Invoke-Expression "docker tag $($Tag):$($Version) $($ContainerRegistry)$($Tag):$($Version)"
}

function BuildX-Initialize {
    [CmdletBinding()]
    param(
		[Parameter(ValueFromPipeline)]
		[string]$Platform="linux/arm64,linux/amd64"
    )

	Invoke-Expression "docker buildx create --use --platform=$($Platform) --name builder --driver docker-container"
	Invoke-Expression "docker buildx inspect --bootstrap"
}

function BuildX-Docker-Image {
    [CmdletBinding()]
    param(
		[Parameter(Mandatory)]
		[string]$Tag,
		[Parameter(Mandatory)]
		[string]$Version,
		[Parameter(ValueFromPipeline)]
		[string]$ContainerRegistry="",
		[Parameter(ValueFromPipeline)]
		[string]$Platform="linux/arm64,linux/amd64",
		[Parameter(ValueFromPipeline)]
		[string]$DockerFile="Dockerfile"
    )

	Invoke-Expression "docker buildx build -t $($Tag):$($Version) --platform $($Platform) --load -f $DockerFile ."
	Invoke-Expression "docker tag $($Tag):$($Version) $($ContainerRegistry)$($Tag):$($Version)"
}

function Push-Docker-Image {
    [CmdletBinding()]
    param(
		[Parameter(Mandatory)]
		[string]$Tag,
		[Parameter(Mandatory)]
		[string]$Version,
		[Parameter(ValueFromPipeline)]
		[string]$ContainerRegistry=""
    )

	Invoke-Expression "docker push $($ContainerRegistry)$($Tag):$($Version)"
}

function Build-And-Push-Docker-Image {
    [CmdletBinding()]
    param(
		[Parameter(Mandatory)]
		[string]$Tag,
		[Parameter(Mandatory)]
		[string]$Version,
		[Parameter(ValueFromPipeline)]
		[string]$ContainerRegistry="",
		[Parameter(ValueFromPipeline)]
		[string]$DockerFile="Dockerfile"
    )

	Invoke-Expression "docker build -t $($Tag):$($Version) -f $DockerFile ."
	Invoke-Expression "docker tag $($Tag):$($Version) $($ContainerRegistry)$($Tag):$($Version)"
	Invoke-Expression "docker push $($ContainerRegistry)$($Tag):$($Version)"
}

function BuildX-And-Push-Docker-Image {
    [CmdletBinding()]
    param(
		[Parameter(Mandatory)]
		[string]$Tag,
		[Parameter(Mandatory)]
		[string]$Version,
		[Parameter(ValueFromPipeline)]
		[string]$ContainerRegistry="",
		[Parameter(ValueFromPipeline)]
		[string]$DockerFile="Dockerfile"
    )

	Invoke-Expression "docker buildx build -t $($Tag):$($Version) -f $DockerFile ."
	Invoke-Expression "docker tag $($Tag):$($Version) $($ContainerRegistry)$($Tag):$($Version)"
	Invoke-Expression "docker push $($ContainerRegistry)$($Tag):$($Version)"
}