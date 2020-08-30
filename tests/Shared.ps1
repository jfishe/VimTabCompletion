$Script:ModuleRoot = Resolve-Path "$PSScriptRoot\..\output\$Env:BHProjectName"
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
# $scripts = Get-ChildItem $Script:ModuleRoot -Include *.ps1, *.psm1, *.psd1 -Recurse

# $modulePath = Convert-Path $PSScriptRoot\..\src
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
$Script:moduleManifestPath = Join-Path $Script:ModuleRoot "$Script:ModuleName.psd1"

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


# Universal ctags file content
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
$Tags = @'
!_TAG_FILE_FORMAT	2	/extended format; --format=1 will not append ;" to lines/
!_TAG_FILE_SORTED	1	/0=unsorted, 1=sorted, 2=foldcase/
!_TAG_OUTPUT_FILESEP	slash	/slash or backslash/
!_TAG_OUTPUT_MODE	u-ctags	/u-ctags or e-ctags/
!_TAG_PATTERN_LENGTH_LIMIT	96	/0 for no limit/
!_TAG_PROGRAM_AUTHOR	Universal Ctags Team	//
!_TAG_PROGRAM_NAME	Universal Ctags	/Derived from Exuberant Ctags/
!_TAG_PROGRAM_URL	https://ctags.io/	/official site/
!_TAG_PROGRAM_VERSION	0.0.0	/631690ad/
ArgumentList	tests/TabExpansion.Tests.ps1	/^            $ArgumentList = @( $ArgumentList[1], $ArgumentList[2],$/;"	v
ArgumentList	tests/TabExpansion.Tests.ps1	/^            $ArgumentList = @('--clean', '--servername', 'VIMTABEXP')$/;"	v
ArgumentList	tests/TabExpansion.Tests.ps1	/^            $ArgumentList = @('--clean', '--servername', 'VIMTABEXP',$/;"	v
Building	README.md	/^## Building$/;"	s	chapter:VimTabCompletion
ConfirmPreference	VimTabCompletion.Build.ps1	/^    $Global:ConfirmPreference = $origConfirmPreference$/;"	v
ConfirmPreference	VimTabCompletion.Build.ps1	/^    $Global:ConfirmPreference = 'None'$/;"	v
DeployParams	VimTabCompletion.Build.ps1	/^        $DeployParams = @{$/;"	v
Destination	VimTabCompletion.Build.ps1	/^    $Script:Destination = Join-Path -Path $Script:Output -ChildPath $Script:ModuleName$/;"	v
'@
