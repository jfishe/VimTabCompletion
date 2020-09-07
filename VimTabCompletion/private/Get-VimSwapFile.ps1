<#
.SYNOPSIS
    Use vim -L to provide CompletionResult for swap files.
.DESCRIPTION
    Use vim -L to provide CompletionResult for swap files. ToolTip contains swap file information reported by vim -L.
.EXAMPLE
    PS C:\> Get-VimSwapFile
    CompletionText      ToolTip
    ______________      _______
    .gutctags.swp        1.     .gutctags.swp
                                      dated: Sat Aug 08 12:12:16 2020
                                  file name: C:/Users/fishe/GitHub/VimTabCompletion/.gutctags
                                   modified: no
                                  user name: fishe   host name: JOHN-AUD9AR3
                                 process ID: 17364 (STILL RUNNING)
.INPUTS
    None.
.NOTES
    Vim writes to stderr which polutes $Error in PowerShell. Open issue: https://github.com/PowerShell/PowerShell/issues/3996#issuecomment-667326937
#>

function Get-VimSwapFile {
    param()

    $SwapFile = Invoke-Vim -Raw -RedirectStandardError -RedirectStandardOutput -L

    $Search = 'In directory', 'In current directory'

    $Pattern = '('
    $Pattern += $Search -join '|'
    $Pattern += ')|(^\d{1,2})'

    # PS Core by default adds escape characters to colorize Select-String output.
    # PS 5 does not implement -NoEmphasis.
    if ( $PSVersionTable.PSVersion.Major -lt 6 ) {
        $SwapFile = $SwapFile.Error |
        Select-String -Context 0, 5 -Pattern $Pattern
    } else {
        $SwapFile = $SwapFile.Error |
        Select-String -NoEmphasis -Context 0, 5 -Pattern $Pattern
    }

    $VimSwapFile = @()
    $SwapFile | ForEach-Object -Process {
        if ($_.Matches.Groups[1].Success) {
            if ($_.Line -cmatch $Search[0]) {
                $InDirectory = $_.Line.TrimEnd().Split()
                $InDirectory = $InDirectory[-1]
                $InDirectory = $InDirectory.Substring(0, $InDirectory.Length - 1)
            } else {
                $InDirectory = $null
            }
        } elseif ($_.Matches.Groups[2].Success) {
            $CompletionText = $_.Line.TrimEnd().Split()

            # PowerShell strips whitespace from first line in ToolTip, which
            # breaks : alignment in ToolTip.  Add swap file name and newline to
            # retain left padding of swap file information.
            $ToolTip = "$CompletionText`n"

            $CompletionText = $CompletionText[-1]

            if ($null -ne $InDirectory) {
                $InDirectory = Convert-Path $InDirectory
                $CompletionText = Join-Path $InDirectory $CompletionText
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
