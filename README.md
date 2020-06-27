# VimTabCompletion

Powershell Tab Completion for Vim

Author: jdfenw@gmail.com

## Building

`.\build.ps1`

## Publish to LocalRepo1

`deploy.PSDeploy.ps1` uses a `PSRepository` defined by `Set-PSRepository`, e.g.,
`LocalRepo1`. To publish to a different location than `PSGallery`, change to
the project root directory:

``` powershell
$Env:PublishToRepo = 'LocalRepo1' # Default: 'PSGallery'

# Default: 'Unknown' when building locally
$Env:BUILD_REPOSITORY_URI = 'LocalRepo1'

# Not required if you ran .\build.ps1 in the current shell
$Env:PSModulePath = "$(pwd)\_build_dependencies_\;$env:PSModulePath"

Set-BuildEnvironment -Force
.\build.ps1 -Task Distribute
```

## Testing

`.\build.ps1 -Task Test`


