# https://tjaddison.com/blog/2018/12/adding-caching-to-your-powershell-scripts/
function Set-Caching-ScriptBlockResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Key,
        [Parameter(Mandatory)]
        [ScriptBlock]$Func
    )

    $CACHE_VARIABLE_NAME = "PS_Cache"

    if (-not (Get-Variable -Name $CACHE_VARIABLE_NAME -Scope Global)) {
        Set-Variable -Name $CACHE_VARIABLE_NAME -Scope Global -Value @{}
    }

    $cache = Get-Variable -Name $CACHE_VARIABLE_NAME -Scope Global
    if (-not $cache.Value.ContainsKey($Key)) {
        $cachedValue = &$Func
        $cache.Value[$Key] = $cachedValue
    }
}

function Get-Caching-ScriptBlockResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Key
    )

    $CACHE_VARIABLE_NAME = "PS_Cache"

    if (-not (Get-Variable -Name $CACHE_VARIABLE_NAME -Scope Global)) {
        Set-Variable -Name $CACHE_VARIABLE_NAME -Scope Global -Value @{}
    }

    $cache = Get-Variable -Name $CACHE_VARIABLE_NAME -Scope Global
    return $cache.Value[$Key]
}