<#
.SYNOPSIS
    Use vim -L to provide CompletionResult for swap files.
.DESCRIPTION
    Use vim -L to provide CompletionResult for swap files. ToolTip contains swap file information reported by vim -L.
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    None.
.NOTES
    Vim writes to stderr which polutes $Error in PowerShell. Oppen issue: https://github.com/PowerShell/PowerShell/issues/3996#issuecomment-667326937
#>

function Get-VimSwapFile {
    param()

    $Search = 'In directory', 'In current directory'
    # $EmptyDirectory = '-- none --'

    # Vim writes to stderr which polutes $Error in PowerShell. Oppen issue:
    # https://github.com/PowerShell/PowerShell/issues/3996#issuecomment-667326937
    # Strip the PowerShell exception wrapper from Stream 2.
    $SwapFile = & { vim -L } 2>&1 | ForEach-Object -Process { $_.ToString() } |
    Where-Object { $_ -ne 'System.Management.Automation.RemoteException' }

    $Pattern = '('
    $Pattern += $Search -join '|'
    $Pattern += ')|(^\d{1,2})'

    $SwapFile = $SwapFile |
    Select-String -NoEmphasis -Context 0, 5 -Pattern $Pattern

    $VimSwapFile = @()
    $SwapFile | ForEach-Object -Process {
        if ($_.Matches.Groups[1].Success) {
            if ($_.Line -cmatch $Search[0]) {
                $InDirectory = $_.Line.Split()
                $InDirectory = $InDirectory[-1]
                $InDirectory = $InDirectory.Substring(0, $InDirectory.Length - 1)
            } else {
                $InDirectory = $null
            }
        } elseif ($_.Matches.Groups[2].Success) {
            $CompletionText = $_.Line.Split()

            # PowerShell strips whitespace from first line in ToolTip, which
            # breaks : alignment in ToolTip.  Add swap file name and newline to
            # retain left padding of swap file information.
            $ToolTip = "$CompletionText`n"

            $CompletionText = $CompletionText[-1]

            if ($null -ne $InDirectory) {
                $InDirectory = Convert-Path $InDirectory
                $CompletionText = "${InDirectory}${CompletionText}"
            }

            $ToolTip += $_.Context.DisplayPostContext -join "`n"

            $VimSwapFile += [PSCustomObject]@{
                CompletionText = $CompletionText
                ToolTip        = $ToolTip
            }
        }
    }
    return $VimSwapFile
}
