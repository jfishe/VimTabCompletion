<#
.SYNOPSIS
Short Description

.DESCRIPTION
Full Description

.PARAMETER wordToComplete
A description of a parameter.

.PARAMETER commandAst
A description of a parameter.

.PARAMETER cursorPosition
A description of a parameter.

.EXAMPLE
Example
.NOTES
notes
.LINK
online help
#>

function Get-VimArguments {
    param($wordToComplete, $commandAst, $cursorPosition)

    if (Get-Command -Name vim -ErrorAction SilentlyContinue) {
        $VimArguments = & vim --help | Select-String -Pattern '^\s*[-+]'
    } else {
        return ''
    }

    $VimArguments | ForEach-Object -Process {
        $ToolTip = $_.ToString()
        $Argument = ($ToolTip -Split '\t+', 0, "RegexMatch")
        $Length = [int] $Argument.Length
        if ($Length -eq 2) {
            $Argument = $Argument[0].Trim()
        } else {
            $Argument = $Argument.Trim().Split()[0]
        }
        $Argument = ($Argument -Split '[[<( ]')[0]
        $ToolTip = $ToolTip.Trim()

        [PSCustomObject]@{
            Argument = "$Argument"
            ToolTip  = "$ToolTip"
        }
    }
}
