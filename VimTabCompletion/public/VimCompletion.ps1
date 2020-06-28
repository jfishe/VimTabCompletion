<#
    .SYNOPSIS
    A brief description of this function.

    .DESCRIPTION
    A detailed description of this function.

    .PARAMETER wordToComplete
    A description of a parameter.

    .PARAMETER commandAst
    A description of a parameter.

    .PARAMETER cursorPosition
    A description of a parameter.

    .EXAMPLE
    An example of this function's usage.
#>

function VimCompletion {
    param($wordToComplete, $commandAst, $cursorPosition)

    function Get-VimArguments {

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

    Get-VimArguments |
        Where-Object { $_.Argument -clike "$wordToComplete*" } |
        Sort-Object -Property Argument -Unique -CaseSensitive |
        ForEach-Object -Process {
        $completionText = $_.Argument
        $listItemText = $_.Argument

        if ($completionText -eq $previousCompletionText) {
            # Differentiate completions that differ only by case otherwise
            # PowerShell will view them as duplicate.
            $listItemText += ' '
        }
        $previousCompletionText = $completionText

        New-Object System.Management.Automation.CompletionResult `
            $completionText, $listItemText, 'ParameterValue', $_.ToolTip
    }
}

$Vim = @( 'vim', 'vimdiff', 'gvim', 'gvimdiff')

Register-ArgumentCompleter `
    -Command $Vim `
    -Native `
    -ScriptBlock $function:VimCompletion
