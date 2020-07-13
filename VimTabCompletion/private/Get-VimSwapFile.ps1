<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>

function Get-VimSwapFile {
    param()

    $Search = 'In directory', 'In current directory'
    # $EmptyDirectory = '-- none --'

    $SwapFile = & { vim -L } 2>&1 | ForEach-Object -Process { $_.ToString() } |
    Where-Object { $_ -ne 'System.Management.Automation.RemoteException' }

    # $VimSwapDirectory = $SwapFile | Select-String -CaseSensitive -Pattern @(
    #     $Search -join '|')

    $Pattern = '('
    $Pattern += $Search -join '|'
    $Pattern += ')|(^\d)'

    $SwapFile = $SwapFile |
    Select-String -NoEmphasis -Context 0, 5 -Pattern $Pattern
    # return $VimSwapFile


    $VimSwapFile = @()
    $SwapFile | ForEach-Object -Process {
        if ($_.Matches.Groups[1].Success) {
            if ($_.Line -cmatch $Search[1]) {
                $InDirectory = '.\'
            } else {
                $InDirectory = $_.Line.Substring(16)
                $InDirectory = $InDirectory.Substring(0, $InDirectory.Length - 1)
            }
        } elseif ($_.Matches.Groups[2].Success) {
            $completionText = Convert-Path $InDirectory
            $completionText += $_.Line.Substring(6)
            $listItemText = $_.Line.Substring(6)
            $toolTip = $_.Context.DisplayPostContext -join "`n"

            $VimSwapFile += [PSCustomObject]@{
                CompletionText = $completionText
                ListItemText   = $listItemText
                ToolTip        = $toolTip
            }
        }
    }
    return $VimSwapFile
}
