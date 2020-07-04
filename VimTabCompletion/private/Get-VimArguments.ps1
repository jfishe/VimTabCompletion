<#
.SYNOPSIS
    Convert Vim OPTIONS into PSCustomObject with Argument and ToolTip properties.
.DESCRIPTION
    Parse vim --help into a list of PSCustomObject with Argument and ToolTip
    properties.
.EXAMPLE
    None
.INPUTS
    None
.OUTPUTS
    A list of

    [PSCustomObject]@{
        Argument = "Vim OPTION"
        ToolTip  = "Vim OPTION with help"
    }
.NOTES
    None
#>

function Get-VimArguments {
    param()

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
