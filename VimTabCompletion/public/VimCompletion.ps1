<#
.SYNOPSIS
    Provide PowerShell completion for Vim Native applications

.DESCRIPTION
     Provide completion for vim, vimdiff, gvim, gvimdiff, and evim similar to
    /usr/share/zsh/functions/Completion/Unix/_vim in zsh.

.PARAMETER wordToComplete
    This parameter is set to value the user has provided before they pressed
    Tab. Used to determine tab completion values.

.PARAMETER commandAst
    This parameter is set to the Abstract Syntax Tree (AST) for the current
    input line.

    CommandElements    : {vim, --remote, -}
    InvocationOperator : Unknown
    DefiningKeyword    :
    Redirections       : {}
    Extent             : vim --remote -
    Parent             : vim --remote -

.PARAMETER cursorPosition
    This parameter is set to the position of the cursor when the user pressed
    Tab.

.EXAMPLE
    PS C:\> vim - <Ctrl-Space>
    --                    -D                    --literal             -O                    --remote-tab          -T                    -x
    -A                    -e                    -m                    -p                    --remote-wait         --ttyfail             -y
    -b                    -E                    -M                    -r                    --remote-wait-silent  -u                    -Z
    -c                    -h                    -n                    -R                    -s                    -v
    -C                    -H                    -N                    --remote              -S                    -V
    --clean               -i                    --noplugin            --remote-expr         --serverlist          --version
    --cmd                 -l                    --not-a-term          --remote-send         --servername          -w
    -d                    -L                    -o                    --remote-silent       --startuptime         -W

    --                      Only file names after this

.LINK
    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters

.LINK
    https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.language.ast
#>

function VimCompletion {
    param($wordToComplete, $commandAst, $cursorPosition)

    $global:dude = $commandAst

    if ($commandAst.CommandElements[-1].Value -match "^--remote$") {
        Get-VimChildItem
        return
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
        # New-TabItem -CompletionText $completionText -ListItemText $listItemText `
        #     -ResultType ParameterName -ToolTip $_.ToolTip
    }
}

$Vim = @( 'vim', 'vimdiff', 'gvim', 'gvimdiff', 'evim')

Register-ArgumentCompleter `
    -Command $Vim `
    -Native `
    -ScriptBlock $function:VimCompletion
