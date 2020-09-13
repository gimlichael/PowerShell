function Set-Environment {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Name,
        [Parameter(Mandatory)]
        [string]$Value,
        [ValidateSet("Process", "User", "Machine")]
        [string]$Target="Process"
    )
    process {
        $osp = Get-OS-Platform
        if ($osp -contains "Linux" -or $osp -contains "MacOS") {
            [Environment]::SetEnvironmentVariable($Name, $Value)
        }
        else {
            [Environment]::SetEnvironmentVariable($Name, $Value, $Target)
        }
    }
}

function Get-Environment {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Name,
        [ValidateSet("Process", "User", "Machine")]
        [string]$Target="Process"
    )
    process {
        $osp = Get-OS-Platform
        if ($osp -contains "Linux" -or $osp -contains "MacOS") {
            return [Environment]::GetEnvironmentVariable($Name)
        }
        else {
            return [Environment]::GetEnvironmentVariable($Name, $Target)
        }
    }
}