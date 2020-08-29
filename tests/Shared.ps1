$Script:ModuleRoot = Resolve-Path "$PSScriptRoot\..\output\$Env:BHProjectName"
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
# $scripts = Get-ChildItem $Script:ModuleRoot -Include *.ps1, *.psm1, *.psd1 -Recurse

# $modulePath = Convert-Path $PSScriptRoot\..\src
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
$Script:moduleManifestPath = "$Script:ModuleRoot\$Script:ModuleName.psd1"

Remove-Module $Script:ModuleName -Force *>$null

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
$module = Import-Module $Script:moduleManifestPath -Force -PassThru

# Define these variables since they are not defined in WinPS 5.x
if ($PSVersionTable.PSVersion.Major -lt 6) {
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $IsWindows = $true
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $IsLinux = $false
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $IsMacOS = $false
}

# Pester will use the alias instead of $StartVim with Start-Process.
Remove-Item Alias:\Vim -Force -ErrorAction Ignore

# Locate the Vim executable for Start-Process.
$StartVim = Get-Command -CommandType Application -Name vim
if ($StartVim.Extension -eq '.bat') {
    $StartVim = $StartVim | Get-Content |
    Select-String -Pattern '^set VIM_EXE_DIR='

    $Env:VIM_EXE_DIR = ($StartVim -split '=')[1]

    $VimVersion = Split-Path $Env:VIM_EXE_DIR -Leaf

    if ($Env:VIM -and (Test-Path "$Env:VIM\$VimVersion\vim.exe")) {
        $Env:VIM_EXE_DIR = "$Env:VIM\$VimVersion"
    }
    if ($Env:VIMRUNTIME -and (Test-Path "$Env:VIMRUNTIME\vim.exe")) {
        $Env:VIM_EXE_DIR = "$Env:VIMRUNTIME"
    }

    $StartVim = Join-Path $Env:VIM_EXE_DIR 'vim.exe'
}
