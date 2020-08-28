$Script:ModuleRoot = Resolve-Path "$PSScriptRoot\..\output\$Env:BHProjectName"
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
# $scripts = Get-ChildItem $Script:ModuleRoot -Include *.ps1, *.psm1, *.psd1 -Recurse

# $modulePath = Convert-Path $PSScriptRoot\..\src
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
$moduleManifestPath = "$Script:ModuleRoot\$Script:ModuleName.psd1"

Remove-Module $Script:ModuleName -Force *>$null

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
$module = Import-Module $moduleManifestPath -Force -PassThru

# Define these variables since they are not defined in WinPS 5.x
if ($PSVersionTable.PSVersion.Major -lt 6) {
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $IsWindows = $true
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $IsLinux = $false
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $IsMacOS = $false
}
