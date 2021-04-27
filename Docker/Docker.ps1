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
	Invoke-Expression "docker push $($ContainerRegistry)$($Tag):$($Version)"
}