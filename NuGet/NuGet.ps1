function Unlist-NuGet-Package {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$PackageName,
		[Parameter(Mandatory)]
		[string]$ApiKey,
		[Parameter(ValueFromPipeline)]
		[int]$ThrottleLimit=16
    )


	$json = Invoke-WebRequest -Uri "https://api.nuget.org/v3-flatcontainer/$PackageName/index.json" | ConvertFrom-Json

	[PsObject[]]$packages = @()
	
	foreach($version in $json.versions)
	{
		$packages += [PsObject]@{ Name = $PackageName; ApiKey = $ApiKey; Version = $version }
	}

	$packages | ForEach-Object -Parallel {
		Write-Host "Unlisting $($_.Name) $($_.Version)"
		Invoke-Expression "dotnet nuget delete $($_.Name) $($_.Version) --api-key $($_.ApiKey) --non-interactive --source https://api.nuget.org/v3/index.json"
	} -ThrottleLimit $ThrottleLimit
}