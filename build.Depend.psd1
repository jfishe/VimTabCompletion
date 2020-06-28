@{
    PSDependOptions = @{
        Target    = '$DependencyFolder/_build_dependencies_/'
        AddToPath = $true
    }
    InvokeBuild     = '5.6.0'
    PSDeploy        = '1.0.4'
    BuildHelpers    = '2.0.11'
    Pester          = '5.0.2'
    PSScriptAnalyzer = '1.19.0'
    TabExpansionPlusPlus = '1.2'
}
