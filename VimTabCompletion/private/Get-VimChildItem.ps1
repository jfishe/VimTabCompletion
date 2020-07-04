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

function Get-VimChildItem {
    param($wordToComplete, $commandAst, $cursorPosition)

    Get-ChildItem |
    Where-Object { $_.Name -like "$wordToComplete*" } |
    Sort-Object -Property Argument -Unique -CaseSensitive |
    ForEach-Object -Process {
        $completionText = $_.Name
        $listItemText = $_.FullName

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
