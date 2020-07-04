@{
    PSDependOptions = @{
        Target    = '$DependencyFolder/_build_dependencies_/'
        AddToPath = $true
    }
    InvokeBuild     = '5.6.0'
    PSDeploy        = '1.0.4'
    BuildHelpers    = '2.0.15'
    Pester          = '4.3.1'
    PSScriptAnalyzer = '1.19.0'
    # TabExpansionPlusPlus = '1.2'
    sthArgumentCompleter = '1.0'
}
