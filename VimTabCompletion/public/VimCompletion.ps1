<#
.SYNOPSIS
    Provide PowerShell completion for Vim Native applications

.DESCRIPTION
     Provide completion for vim, vimdiff, gvim, gvimdiff, and evim similar to
     zsh. See LINK for `compdef vim`.

.PARAMETER WordToComplete
    This parameter is set to value the user has provided before they pressed
    Tab. Used to determine tab completion values.

.PARAMETER CommandAst
    This parameter is set to the Abstract Syntax Tree (AST) for the current
    input line.

    CommandElements    : {vim, --remote, -}
    InvocationOperator : Unknown
    DefiningKeyword    :
    Redirections       : {}
    Extent             : vim --remote -
    Parent             : vim --remote -

.PARAMETER CursorPosition
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
        $WordToComplete,
        [Parameter(Mandatory = $true, Position = 1)]
        [System.Management.Automation.Language.CommandAst]
        $CommandAst,
        [Parameter(Mandatory = $true, Position = 2)]
        [Int32]
        $CursorPosition
    )

    # $global:dude = @("$WordToComplete", $CommandAst, $CursorPosition)
    # $global:dude = [System.Management.Automation.Language.CommandAst] $CommandAst

    # mikebattista / PowerShell-WSL-Interop developed snippet to locate
    # PreviousWord based on CursorPosition.
    # https://github.com/mikebattista/PowerShell-WSL-Interop/blob/2dd31622200b12032febdff45fd9ef4bd69c15f9/WslInterop.psm1#L137
    for ($i = 1; $i -lt $CommandAst.CommandElements.Count; $i++) {
        $Extent = $CommandAst.CommandElements[$i].Extent
        if ($CursorPosition -lt $Extent.EndColumnNumber) {
            # The cursor is in the middle of a word to complete.
            $PreviousWord = $CommandAst.CommandElements[$i - 1].Extent.Text
            break
        } elseif ($CursorPosition -eq $Extent.EndColumnNumber) {
            # The cursor is immediately after the current word.
            $PreviousWord = $Extent.Text
            break
        } elseif ($CursorPosition -lt $Extent.StartColumnNumber) {
            # The cursor is within whitespace between the previous and current words.
            $PreviousWord = $CommandAst.CommandElements[$i - 1].Extent.Text
            break
        } elseif ($i -eq $CommandAst.CommandElements.Count - 1 -and $CursorPosition -gt $Extent.EndColumnNumber) {
            # The cursor is within whitespace at the end of the line.
            $PreviousWord = $Extent.Text
            break
        }
    }

    switch -Regex -CaseSensitive ($PreviousWord) {
        '--servername' {
            & vim --serverlist |
            Where-Object { $_ -like "$WordToComplete*" } |
            Sort-Object -Unique |
            ForEach-Object {
                $CompletionText = $_
                $ListItemText = $_

                New-Object System.Management.Automation.CompletionResult `
                    $CompletionText, $ListItemText, 'ParameterValue', $ListItemText
            }
            return
        }
        '^-[rL]$' {
            Get-VimSwapFile |
            Where-Object { $_.CompletionText -like "*$WordToComplete*" } |
            New-TabItem -CommandAst $CommandAst -ResultType 'ProviderItem' `

            return
        }
        '^-T$' {
            if ($PSVersionTable.Platform -eq 'Win32NT') {
                $Argument = Get-VimOption |
                Where-Object { $_.CompletionText -clike $Matches[0] }
                $ToolTip = $Argument.ToolTip
                $ToolTip += " (default: win32)"

                $Terminal = `
                    & { vim --not-a-term --cmd ':set term=* | :qa!' } 2>&1 |
                ForEach-Object -Process { $_.ToString() } |
                Where-Object { $_ -ne
                    'System.Management.Automation.RemoteException' }

                $Terminal = $Terminal |
                Select-String -NoEmphasis -Pattern '^\s' |
                Where-Object { $_.Line.Trim() -like "$WordToComplete*" } |
                ForEach-Object -Process {
                    [PSCustomObject] @{
                        CompletionText = $_.Line.Trim()
                    }
                }

                $Terminal |
                New-TabItem -CommandAst $CommandAst `
                    -ResultType 'ParameterValue' -ToolTip $ToolTip

                return
            } else {
                # Not Implemented
                # desc=( $TERMINFO ~/.terminfo $TERMINFO_DIRS /usr/{,share/}{,lib/}terminfo /{etc,lib}/terminfo )
                # _wanted terminals expl 'terminal name' \
                #     compadd "$@" - $desc/*/*(N:t)
                return $null
            }
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
            Where-Object { $_.CompletionText -clike "$WordToComplete*" } |
            Sort-Object -Property CompletionText -Unique -CaseSensitive |
            New-TabItem -ResultType 'ParameterValue' -CommandAst $CommandAst

            # Complete [g]vimrc files.
            $Argument = Get-VimOption |
            Where-Object { $_.CompletionText -clike $Matches[0] }
            $ToolTip = $Argument.ToolTip

            Get-VimChildItem -Path "$WordToComplete*" -ToolTip $ToolTip |
            New-TabItem -CommandAst $CommandAst

            return
        }
    }

    # Complete parameters starting with -|+ or default to Path completion.
    switch -Regex -CaseSensitive ($WordToComplete) {
        '^-[oOp]$' {
            $ResultType = 'ParameterName'

            $Argument = Get-VimOption |
            Where-Object { $_.CompletionText -clike $Matches[0] }
            $ToolTip = $Argument.ToolTip

            1..4 | ForEach-Object -Process {
                $CompletionText = "$($Matches[0])$_"
                $ListItemText = $CompletionText
                New-Object System.Management.Automation.CompletionResult `
                    $CompletionText, $ListItemText, $ResultType, $ToolTip
            }

        }
        '^-V' {
            # -V[N] Be verbose [level N]
            $VimOption = $Matches[0]
            $OptionToComplete = $WordToComplete.Substring($VimOption.Length)

            Get-VimVerbose |
            Where-Object { $_.CompletionText -like "$OptionToComplete*" } |
            Sort-Object -Property CompletionText -Unique |
            New-TabItem -ResultType 'ParameterName' -CommandAst $CommandAst -VimOption "${VimOption}"
        }
        '^-V\d{1,2}' {
            # -V[N][fname] Be verbose [level N]
            $Argument = Get-VimOption |
            Where-Object { $_.CompletionText -clike '-V' }
            $ToolTip = $Argument.ToolTip
            $ToolTip += "`n Always quote [fname]--e.g., 'C:\' or 'tst.log'"

            $VimOption = $Matches[0]
            $FileToComplete = $WordToComplete.Substring($VimOption.Length)

            Get-VimChildItem -Path "$FileToComplete*" -Quote -ToolTip $ToolTip |
            New-TabItem -CommandAst $CommandAst -VimOption "${VimOption}"
        }
        '^-|^\+' {
            Get-VimOption |
            Where-Object { $_.CompletionText -clike "$WordToComplete*" } |
            Sort-Object -Property CompletionText -Unique -CaseSensitive |
            New-TabItem -ResultType 'ParameterName' -CommandAst $CommandAst
        }
        Default { return }
    }
}

$Vim = @( 'vim', 'vimdiff', 'gvim', 'gvimdiff', 'evim')

Register-ArgumentCompleter `
    -Command $Vim `
    -Native `
    -ScriptBlock $function:VimCompletion
