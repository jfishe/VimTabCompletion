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

    Get-VimArguments $wordToComplete $commandAst $cursorPosition |
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

$Vim = @( 'vim', 'vimdiff', 'gvim', 'gvimdiff', 'evim')

Register-ArgumentCompleter `
    -Command $Vim `
    -Native `
    -ScriptBlock $function:VimCompletion
