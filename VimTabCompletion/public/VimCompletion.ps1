<#
.SYNOPSIS
    Provide PowerShell completion for Vim Native applications

.DESCRIPTION
     Provide completion for vim, vimdiff, gvim, gvimdiff, and evim similar to
     zsh. See LINK for `compdef vim`.

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
.LINK
    https://sourceforge.net/p/zsh/code/ci/master/tree/Completion/Unix/Command/_vim
#>

function VimCompletion {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.CompletionResult[]])]
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

    # $Command = $commandAst.CommandElements[0].Extent.Text

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

    switch -Regex -CaseSensitive ($previousWord) {
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
        '^-[rL]$' {
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
        '^-[uU]$' {
            $ToolTip = 'Skip initialization from files and environment variables'
            $Argument = @(
                # Doesn't appear to work on Windows. Still sources vimrc.
                # However, either correclty doesn't source gvimrc.
                [PSCustomObject]@{
                    CompletionText = 'NONE'
                    ToolTip        = $ToolTip
                }
                [PSCustomObject]@{
                    CompletionText = 'NORC'
                    ToolTip        = "${ToolTip}, but load plugins"
                }
            )
            if ($Matches[0] -ceq '-u') {
                # gvim only supports -U NONE to skip GUI initialization.
                $Argument += @(
                    [PSCustomObject]@{
                        CompletionText = 'DEFAULTS'
                        ToolTip        = "${ToolTip}, but load defaults.vim"
                    }
                )
            }

            $Argument |
            Where-Object { $_.CompletionText -clike "$wordToComplete*" } |
            Sort-Object -Property CompletionText -Unique -CaseSensitive |
            New-TabItem -ResultType 'ParameterValue' -CommandAst $commandAst

            # Complete [g]vimrc files.
            $Argument = Get-VimOption |
            Where-Object { $_.CompletionText -clike $Matches[0] }
            $toolTip = $Argument.ToolTip

            Get-VimChildItem -Path "$wordToComplete*" -ToolTip $toolTip |
            New-TabItem -CommandAst $commandAst
        }
    }

    # Complete parameters starting with -|+ or default to Path completion.
    switch -Regex -CaseSensitive ($wordToComplete) {
        '^-[oOp]$' {
            $resultType = 'ParameterName'

            $Argument = Get-VimOption |
            Where-Object { $_.CompletionText -clike $Matches[0] }
            $toolTip = $Argument.ToolTip

            1..4 | ForEach-Object -Process {
                $completionText = "$($Matches[0])$_"
                $listItemText = $completionText
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
            New-TabItem -ResultType 'ParameterName' -CommandAst $commandAst -VimOption "${VimOption}"
        }
        '^-V\d{1,2}' {
            $Argument = Get-VimOption |
            Where-Object { $_.CompletionText -clike '-V' }
            $toolTip = $Argument.ToolTip
            $toolTip += "`n Always quote [fname]--e.g., 'C:\' or 'tst.log'"

            $VimOption = $Matches[0]
            $FileToComplete = $wordToComplete.Substring($VimOption.Length)

            Get-VimChildItem -Path "$FileToComplete*" -Quote -ToolTip $toolTip |
            New-TabItem -CommandAst $commandAst -VimOption "${VimOption}"
        }
        '^-|^\+' {
            Get-VimOption |
            Where-Object { $_.CompletionText -clike "$wordToComplete*" } |
            Sort-Object -Property CompletionText -Unique -CaseSensitive |
            New-TabItem -ResultType 'ParameterName' -CommandAst $commandAst
        }
        Default { return }
    }
}

$Vim = @( 'vim', 'vimdiff', 'gvim', 'gvimdiff', 'evim')

Register-ArgumentCompleter `
    -Command $Vim `
    -Native `
    -ScriptBlock $function:VimCompletion
