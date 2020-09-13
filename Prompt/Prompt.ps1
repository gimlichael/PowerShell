function prompt {
    $cacheKey = "k8s-currentcontext"
    try {
        $kubernetesContext = Get-Caching-ScriptBlockResult -Key $cacheKey
        if ([string]::IsNullOrEmpty($kubernetesContext)) {
            Set-Caching-ScriptBlockResult -Key $cacheKey -Func { Get-Kubernetes-CurrentContext }
            $kubernetesContext = Get-Caching-ScriptBlockResult -Key $cacheKey
        }
        $hasKubectl = ![string]::IsNullOrEmpty($kubernetesContext)
    }
    catch {
        $hasKubectl = $false
    }

    $os = Get-OS-Description
    $azureSubscription = Get-Environment -Name "AZURE_SUBSCRIPTION"
    $userProfile = Get-Environment -Name "USERPROFILE"
    $getLocation = Get-Location
    $hasDefaultLocation = [string]$getLocation -eq [string]$userProfile
    if ($hasDefaultLocation)
    {
         Set-Location-Development
    }
    $created = (Get-Date).ToString("s")

    $Host.UI.RawUI.WindowTitle = "$pwd  <[ $os - $created"
    if ($hasKubectl) { $Host.UI.RawUI.WindowTitle += " - K8S: $kubernetesContext" }
    if (![string]::IsNullOrEmpty($azureSubscription)) { $Host.UI.RawUI.WindowTitle += " - Azure: $azureSubscription" }
    $Host.UI.RawUI.WindowTitle += " ]>"

    return "$ "
}