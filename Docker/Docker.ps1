function Clear-Docker-Objects
{
    docker image prune -f
    docker container prune -f
}

function Build-Docker-Image {
    [CmdletBinding()]
    param(
		[Parameter(Mandatory, Position=0)]
		[string]$Tag,
		[Parameter(Mandatory, Position=1)]
		[string[]]$Version,
		[Parameter(Position=2, ValueFromPipeline)]
		[string]$ContainerRegistry="",
		[Parameter(Position=3, ValueFromPipeline)]
		[string]$DockerFile="Dockerfile",
		[Parameter(Position=4)]
		[string[]]$BuildArgs=@()
    )

	$primaryVersion = $Version[0]
	$buildArgStr = ($BuildArgs | ForEach-Object { "--build-arg $_" }) -join " "
	Invoke-Expression "docker build -t $($Tag):$($primaryVersion) $buildArgStr -f $DockerFile .".Trim()
	foreach ($v in $Version) {
		Invoke-Expression "docker tag $($Tag):$($primaryVersion) $($ContainerRegistry)$($Tag):$($v)"
	}
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
		[Parameter(Mandatory, Position=0)]
		[string]$Tag,
		[Parameter(Mandatory, Position=1)]
		[string[]]$Version,
		[Parameter(Position=2, ValueFromPipeline)]
		[string]$ContainerRegistry="",
		[Parameter(Position=3, ValueFromPipeline)]
		[string]$Platform="linux/arm64,linux/amd64",
		[Parameter(Position=4, ValueFromPipeline)]
		[string]$DockerFile="Dockerfile",
		[Parameter(Position=5)]
		[string[]]$BuildArgs=@()
    )

	$primaryVersion = $Version[0]
	$buildArgStr = ($BuildArgs | ForEach-Object { "--build-arg $_" }) -join " "
	Invoke-Expression "docker buildx build -t $($Tag):$($primaryVersion) --platform $($Platform) --load $buildArgStr -f $DockerFile .".Trim()
	foreach ($v in $Version) {
		Invoke-Expression "docker tag $($Tag):$($primaryVersion) $($ContainerRegistry)$($Tag):$($v)"
	}
}

function Push-Docker-Image {
    [CmdletBinding()]
    param(
		[Parameter(Mandatory, Position=0)]
		[string]$Tag,
		[Parameter(Mandatory, Position=1)]
		[string[]]$Version,
		[Parameter(Position=2, ValueFromPipeline)]
		[string]$ContainerRegistry=""
    )

	foreach ($v in $Version) {
		Invoke-Expression "docker push $($ContainerRegistry)$($Tag):$($v)"
	}
}

function Build-And-Push-Docker-Image {
    [CmdletBinding()]
    param(
		[Parameter(Mandatory, Position=0)]
		[string]$Tag,
		[Parameter(Mandatory, Position=1)]
		[string[]]$Version,
		[Parameter(Position=2, ValueFromPipeline)]
		[string]$ContainerRegistry="",
		[Parameter(Position=3, ValueFromPipeline)]
		[string]$DockerFile="Dockerfile",
		[Parameter(Position=4)]
		[string[]]$BuildArgs=@()
    )

	$primaryVersion = $Version[0]
	$buildArgStr = ($BuildArgs | ForEach-Object { "--build-arg $_" }) -join " "
	Invoke-Expression "docker build -t $($Tag):$($primaryVersion) $buildArgStr -f $DockerFile .".Trim()
	foreach ($v in $Version) {
		Invoke-Expression "docker tag $($Tag):$($primaryVersion) $($ContainerRegistry)$($Tag):$($v)"
		Invoke-Expression "docker push $($ContainerRegistry)$($Tag):$($v)"
	}
}

function BuildX-And-Push-Docker-Image {
    [CmdletBinding()]
    param(
		[Parameter(Mandatory, Position=0)]
		[string]$Tag,
		[Parameter(Mandatory, Position=1)]
		[string[]]$Version,
		[Parameter(Position=2, ValueFromPipeline)]
		[string]$ContainerRegistry="",
		[Parameter(Position=3, ValueFromPipeline)]
		[string]$Platform="linux/arm64,linux/amd64",
		[Parameter(Position=4, ValueFromPipeline)]
		[string]$DockerFile="Dockerfile",
		[Parameter(Position=5)]
		[string[]]$BuildArgs=@()
    )

	$primaryVersion = $Version[0]
	$buildArgStr = ($BuildArgs | ForEach-Object { "--build-arg $_" }) -join " "
	Invoke-Expression "docker buildx build -t $($Tag):$($primaryVersion) --platform $($Platform) --load $buildArgStr -f $DockerFile .".Trim()
	foreach ($v in $Version) {
		Invoke-Expression "docker tag $($Tag):$($primaryVersion) $($ContainerRegistry)$($Tag):$($v)"
		Invoke-Expression "docker push $($ContainerRegistry)$($Tag):$($v)"
	}
}