function Set-Location-Development
{
    $osp = Get-OS-Platform
    if ($osp -contains "Windows")
    {
        Set-Location -Path "C:\Source"
    }
}

function Set-Location-Profile
{
    Set-Location -Path $PROFILEHOME
}