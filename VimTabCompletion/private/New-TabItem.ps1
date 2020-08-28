<#
.SYNOPSIS
    Generate [System.Management.Automation.CompletionResult].
.DESCRIPTION
    Generate [System.Management.Automation.CompletionResult].
.PARAMETER CompletionText
    The completion result text for CompletionResult.
.PARAMETER ListItemText
    CompletionResult case sensitive list of matching completions. Defaults to CompletionText.
.PARAMETER ResultType
    Result type: [System.Management.Automation.CompletionResultType[]]
.PARAMETER ToolTip
    Tool tip for CompletionResult.
.PARAMETER ExcludeArgument
    A Regex string matching previous CompletionResults to exclude matches that cannot occur with already selected CompletionResults
.PARAMETER VimOption
    A prefix for the CompletionResult, e.g., -V.
.EXAMPLE
    PS C:\>Get-VimOption | Where-Object { $_.CompletionText -clike "--server*" } | New-TabItem -CommandAst $CommandAst

    CompletionText ListItemText ResultType ToolTip
    -------------- ------------ ---------- -------
    --serverlist   --serverlist       Text --serverlist     List available Vim server names and exit
    --servername   --servername       Text --servername <name>      Send to/become the Vim server <name>. Tab to expand running server names
.NOTES
    None.
#>

Function New-TabItem {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.CompletionResult])]
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $CompletionText
        ,
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [String[]]
        $ListItemText = $null
        ,
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.Management.Automation.CompletionResultType[]]
        $ResultType = "Text"
        ,
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [String[]]
        $ToolTip = $null
        ,
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [String[]]
        $ExcludeArgument = $null
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Line
        ,
        [Parameter()]
        [String]
        $VimOption = ''
    )

    process {
        # Skip completion for parameters that can't occur together, e.g., -H
        # and -F
        if ($null -ne $ExcludeArgument) {
            $ExcludePattern = [Regex]::new($ExcludeArgument)
            if ($ExcludePattern.IsMatch($Line)) {
                return
            }
        }

        $Argument = @{
            ResultType = $ResultType
            CompletionText = "${VimOption}${CompletionText}"
        }

        if ($null -ne $ListItemText) {
            $Argument.ListItemText = $ListItemText
        } else {
            $Argument.ListItemText = $Argument.CompletionText
        }

        if ($null -ne $ToolTip) {
            $Argument.ToolTip = $ToolTip
        } else {
            $Argument.ToolTip = $Argument.CompletionText
        }

        # Differentiate completions that differ only by case otherwise
        # PowerShell will view them as duplicate.
        if ($Argument.CompletionText -eq $previousCompletionText) {
            $Argument.ListItemText += ' '
        }
        $previousCompletionText = $Argument.CompletionText

        New-Object System.Management.Automation.CompletionResult `
            $Argument.CompletionText, $Argument.ListItemText, `
            $Argument.ResultType, $Argument.ToolTip
    }
}
