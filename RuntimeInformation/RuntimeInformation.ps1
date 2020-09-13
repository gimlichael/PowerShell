function Get-OS-Description()
{
    return [System.Runtime.InteropServices.RuntimeInformation]::OSDescription
}

function Get-OS-Platform()
{
    if ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Windows))
    {
        return @("Windows")
    }
    elseif ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::OSX))
    {
        return @("MacOS")
    }
    elseif ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Linux))
    {
        $result = @("Linux")
        $osd = Get-OS-Description
        if ($osd -like "*-azure*")
        {
            $result += "Azure"
        }
        return $result
    }
}