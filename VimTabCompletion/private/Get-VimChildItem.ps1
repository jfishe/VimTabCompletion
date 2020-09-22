using namespace System.Management.Automation

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
    [OutputType([CompletionResult])]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $Path
        ,
        [Parameter(Position = 1)]
        [switch]
        $Quote = $false
        ,
        [Parameter(Position = 2)]
        [string]
        $ToolTip = $null
    )

    [CompletionCompleters]::CompleteFilename("$Path") |
    ForEach-Object -Process {
        # [CompletionCompleters] have ReadOnly properties. To use the
        # nonpublic SetValue and avoid InvalidOperation: 'CompletionText'
        # is a ReadOnly property. Follow the instructions at
        # https://learn-powershell.net/2016/06/27/quick-hits-writing-to-a-read-only-property/
        if ($Quote -and ($_.CompletionText -notmatch "'")) {
            # Quote 'file path' to prevent PowerShell string and property
            # expansion.  Otherwise file.log will pass to vim as
            # `vim -V10file .log`
            $Field = $_.GetType().GetField('_completionText', 'static,nonpublic,instance')
            if ( $null -eq $Field ) {
                $Field = $_.GetType().GetField('completionText', 'static,nonpublic,instance')
            }
            $Field.SetValue($_, "'$($_.CompletionText)'")
        }
        if ( $null -ne $ToolTip ) {
            $Field = $_.GetType().GetField('_toolTip', 'static,nonpublic,instance')
            if ( $null -eq $Field ) {
                $Field = $_.GetType().GetField('toolTip', 'static,nonpublic,instance')
            }
            $Field.SetValue($_, "$ToolTip")
        }
        $_
    }
}
