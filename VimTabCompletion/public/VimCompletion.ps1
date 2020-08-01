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

    --                      Only file names after this (does not work with default installed Windows *vim*.bat files)

.EXAMPLE
    PS C:\> vim -V10'C:\ <Ctrl-Space>
    -V10'C:\data'                 -V10'C:\SWSETUP'
    -V10'C:\ESD'                  -V10'C:\Symbols'
    -V10'C:\SymCache'             -V10'C:\inetpub'
    -V10'C:\tools'
    -V10'C:\Intel'                -V10'C:\Users'
    -V10'C:\PerfLogs'             -V10'C:\Windows'
    -V10'C:\Program Files'        -V10'C:\msdia80.dll'
    -V10'C:\Program Files (x86)'

    PowerShell interprets : as a switch and . as a property. Surround the file
    name with single quotes, 'fname', to prevent this.

.LINK
    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters

.LINK
    https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.language.ast
#>

function VimCompletion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $wordToComplete,
        [Parameter(Mandatory = $true, Position = 1)]
        [System.Management.Automation.Language.CommandAst]
        $commandAst,
        [Parameter(Mandatory = $true, Position = 2)]
        [Int32]
        $cursorPosition
    )

    # $global:dude = @("$wordToComplete", $commandAst, $cursorPosition)
    # $global:dude = [System.Management.Automation.Language.CommandAst] $commandAst

    # TODO:  <19-07-20, jdfenw@gmail.com> Bug: repeated prompt one space after re-inserts same completion#

    # mikebattista / PowerShell-WSL-Interop developed snippet to locate
    # previousWord based on cursorPosition.
    # https://github.com/mikebattista/PowerShell-WSL-Interop/blob/2dd31622200b12032febdff45fd9ef4bd69c15f9/WslInterop.psm1#L137
    # $COMP_LINE = "`"$($commandAst.Extent.Text.PadRight($cursorPosition))`""
    # $COMP_WORDS = $commandAst.CommandElements.Extent.Text
    # $previousWord = $commandAst.CommandElements[0].Value
    # $COMP_CWORD = 1
    for ($i = 1; $i -lt $commandAst.CommandElements.Count; $i++) {
        $extent = $commandAst.CommandElements[$i].Extent
        if ($cursorPosition -lt $extent.EndColumnNumber) {
            # The cursor is in the middle of a word to complete.
            $previousWord = $commandAst.CommandElements[$i - 1].Extent.Text
            # $COMP_CWORD = $i
            break
        } elseif ($cursorPosition -eq $extent.EndColumnNumber) {
            # The cursor is immediately after the current word.
            $previousWord = $extent.Text
            # $COMP_CWORD = $i + 1
            break
        } elseif ($cursorPosition -lt $extent.StartColumnNumber) {
            # The cursor is within whitespace between the previous and current words.
            $previousWord = $commandAst.CommandElements[$i - 1].Extent.Text
            # $COMP_CWORD = $i
            break
        } elseif ($i -eq $commandAst.CommandElements.Count - 1 -and $cursorPosition -gt $extent.EndColumnNumber) {
            # The cursor is within whitespace at the end of the line.
            $previousWord = $extent.Text
            # $COMP_CWORD = $i + 1
            break
        }
    }

    switch -Regex ($previousWord) {
        '--servername' {
            & vim --serverlist |
            Where-Object { $_ -like "$wordToComplete*" } |
            Sort-Object -Unique |
            ForEach-Object {
                $completionText = $_
                $listItemText = $_

                New-Object System.Management.Automation.CompletionResult `
                    $completionText, $listItemText, 'ParameterValue', $listItemText
            }
            return
        }
        '^-r$|^-L$' {
            Get-VimSwapFile |
            Where-Object { $_.CompletionText -like "*$wordToComplete*" } |
            ForEach-Object -Process {
                $completionText = $_.CompletionText
                $listItemText = $_.ListItemText
                $toolTip = $_.ToolTip

                New-Object System.Management.Automation.CompletionResult `
                    $completionText, $listItemText, 'ProviderItem', $toolTip
            }

            return
        }
    }

    # Complete parameters starting with -|+ or default to Path completion.
    switch -Regex -CaseSensitive ($wordToComplete) {
        '^-V\d{1,2}' {
            $toolTip = @(
                    '-V[N][fname]`tBe verbose [level N]',
                    "[log messages to fname]`n",
                    'Always quote file path--e.g., ''C:\'' or ''tst.log'' '
                    ) -join ' '

            $VimOption = $Matches[0]
            $FileToComplete = $wordToComplete.Substring($VimOption.Length)
            $Parent = Get-Location

            Get-ChildItem "$FileToComplete*" |
            ForEach-Object -Process {

                if ( $_.FullName.StartsWith($Parent) ) {
                    $completionText = $_ | Resolve-Path -Relative
                } else {
                    $completionText = $_ | Resolve-Path
                }

                # Quote 'file path' to prevent PowerShell string and property
                # expansion.  Otherwise file.log will pass to vim as
                # `vim -V10file .log`
                $completionText = "${VimOption}'${completionText}'"
                $listItemText = $completionText
                $resultType = 'ParameterName'

                New-Object System.Management.Automation.CompletionResult `
                    $completionText, $listItemText, $resultType, $toolTip
            }
        }
        '^-V' {
            # -V[N]`tBe verbose [level N]
            $VimOption = $Matches[0]
            $OptionToComplete = $wordToComplete.Substring($VimOption.Length)

            Get-VimVerbose |
            Where-Object { $_.CompletionText -like "$OptionToComplete*" } |
            Sort-Object -Property CompletionText -Unique |
            ForEach-Object -Process {
                $completionText = "${VimOption}$($_.CompletionText)"
                $listItemText = $completionText
                $toolTip = $_.ToolTip

                New-Object System.Management.Automation.CompletionResult `
                    $completionText, $listItemText, 'ParameterName', $toolTip
            }
        }
        '^-|^\+' {
            Get-VimOption |
            Where-Object { $_.CompletionText -clike "$wordToComplete*" } |
            Sort-Object -Property CompletionText -Unique -CaseSensitive |
            ForEach-Object -Process {
                $completionText = $_.CompletionText
                $listItemText = $_.CompletionText

                if ($null -ne $_.ResultType) {
                    $resultType = $_.ResultType
                } else {
                    $resultType = 'Text'
                }

                $toolTip = $_.ToolTip

                if ($completionText -eq $previousCompletionText) {
                    # Differentiate completions that differ only by case
                    # otherwise PowerShell will view them as duplicate.
                    $listItemText += ' '
                }
                $previousCompletionText = $completionText

                if ($_.ExcludeArgument) {
                    $excludePattern = [Regex]::new($_.ExcludeArgument)
                    if ($excludePattern.IsMatch($commandAst.Parent)) {
                        return
                    }
                }
                New-Object System.Management.Automation.CompletionResult `
                    $completionText, $listItemText, $resultType, $toolTip
            }
        }
        Default { return }
    }
}

$Vim = @( 'vim', 'vimdiff', 'gvim', 'gvimdiff', 'evim')

Register-ArgumentCompleter `
    -Command $Vim `
    -Native `
    -ScriptBlock $function:VimCompletion
