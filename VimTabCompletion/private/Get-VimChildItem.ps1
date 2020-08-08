<#
.SYNOPSIS
    Return an arrary of objects containing CompletionText, ListItemText, ResultType and ToolTip for files and directories returned by Get-ChildItem -Path "$Path".
.DESCRIPTION
    Return an arrary of objects containing CompletionText, ListItemText, ResultType and ToolTip for files and directories returned by Get-ChildItem -Path "$Path".
.PARAMETER Path
    Specifies a path to one location. Wildcards are accepted. The default location is the current directory (`.`).
.PARAMETER Quote
    A switch to enable quoting of a file path, e.g., `-V10'C:\Users\startup.log`.  Paths containing whitespace are quoted by default.
.PARAMETER ToolTip
    Provide a ToolTip. Defaults to the file path.
.EXAMPLE
    PS> Get-VimChildItem -Path C:\ -VimOption '-V10' -Quote -ToolTip  "-u <vimrc>`tUse <vimrc> instead of any .vimrc"

    CompletionText               ListItemText                 ResultType        ToolTip
    --------------               ------------                 ----------        -------
    -V10'C:\Program Files'       -V10'C:\Program Files'       ProviderContainer -u <vimrc>  Use <vimrc> instead of any .vimrc
    -V10'C:\msdia80.dll'         -V10'C:\msdia80.dll'         ProviderItem      -u <vimrc>  Use <vimrc> instead of any .vimrc
.NOTES
    None.
.LINK
    None
#>

function Get-VimChildItem {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSObject[]])]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $Path
        ,
        [Parameter(Mandatory = $false, Position = 1)]
        [switch]
        $Quote = $false
        ,
        [Parameter(Mandatory = $false, Position = 2)]
        [string]
        $ToolTip = $null
    )

    begin {
        $Parent = Get-Location
    }

    process {
        $Output = Get-ChildItem -Path "$Path" |
        ForEach-Object -Process {

            if ( $_.FullName.StartsWith($Parent) ) {
                $completionText = $_ | Resolve-Path -Relative
            } else {
                $completionText = $_
            }

            # Quote 'file path' to prevent PowerShell string and property
            # expansion.  Otherwise file.log will pass to vim as
            # `vim -V10file .log`
            if ($Quote -or "$completionText" -match '\s') {
                $completionText = "'${completionText}'"
            } else {
                $completionText = "${completionText}"
            }

            if ($_.PSIsContainer) {
                $resultType = 'ProviderContainer'
            } else {
                $resultType = 'ProviderItem'
            }

            if ( $null -eq $ToolTip ) {
                $toolTip = $completionText
            } else {
                $toolTip = $ToolTip
            }

            [PSCustomObject]@{
                CompletionText = $completionText
                ResultType     = $resultType
                ToolTip        = $toolTip
            }
        }
    }

    end {
        return $Output
    }
}
