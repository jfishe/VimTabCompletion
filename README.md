# VimTabCompletion

Powershell Tab Completion for Vim

Author: jdfenw@gmail.com

VimTabCompletion was tested against Windows PowerShell 5.1 and PowerShell Core
7.0.3 on Windows. Refer to
[about_VimTabCompletion](VimTabCompletion/en-US/about_VimTabCompletion) for
features and limitations.

## Installation

### Vim

VimTabCompletion requires Vim in `$env:PATH` or `$Env:VIMRUNTIME` and recommends
[vim / vim-win32-installer](https://github.com/vim/vim-win32-installer).

To install with Chocolatey:

```PowerShell
choco install vim
```

### Ctags

VimTabCompletion requires `readtags` for tag completion and recommends
[universal-ctags / ctags](https://github.com/universal-ctags/ctags).

To install with [Chocolatey](https://chocolatey.org/):

```PowerShell
choco install universal-ctags
```

### VimTabCompletion Module

VimTabCompletion exports PowerShell function TabExpansion but does not
interfere with existing TabExpansion functions.

To install from [PowerShell Gallery](https://go.microsoft.com/fwlink/?linkid=2118474):

```PowerShell
Find-Module -Name VimTabCompletion

# Version              Name                                Repository
# -------              ----                                ----------
# 1.2.0                VimTabCompletion                    PSGallery

# Use AllowClobber to update TabExpansion
Install-Module -Name VimTabCompletion -AllowClobber

# WARNING: The externally managed, dependent module 'vim' is not installed on
# this computer. To use the current module 'VimTabCompletion', ensure that its
# dependent module 'vim' is installed.
# WARNING: The externally managed, dependent module 'ctags' is not installed on
# this computer. To use the current module 'VimTabCompletion', ensure that its
# dependent module 'vim' is installed.
```

## Building

`.\build.ps1`

## Publish to LocalRepo1

`deploy.PSDeploy.ps1` uses a `PSRepository` defined by `Set-PSRepository`, e.g.,
`LocalRepo1`. To publish to a different location than `PSGallery`, change to
the project root directory:

``` powershell
$Env:PublishToRepo = 'LocalRepo1' # Default: 'PSGallery'

# Not required if you ran .\build.ps1 in the current shell
$Env:PSModulePath = "$(pwd)\_build_dependencies_\;$env:PSModulePath"

Set-BuildEnvironment -Force

# Default: 'Unknown' when building locally. Reset by build.ps1.
$Env:BHBuildSystem = 'LocalRepo1'

# Override
.\build.ps1 -Task Distribute
```

## Testing

VimTabCompletion requires Vim and readtags.

`.\build.ps1 -Task Test`

## License

- MIT License: [LICENSE](LICENSE)
- [RamblingCookieMonster / BuildHelpers](https://github.com/RamblingCookieMonster/BuildHelpers)
  created `Invoke-Git` under the MIT License:
  [ThirdPartyNotice](ThirdPartyNotice.md#invoke-git)
