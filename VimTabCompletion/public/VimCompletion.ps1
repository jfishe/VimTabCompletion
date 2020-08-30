# Define these variables since they are not defined in WinPS 5.x
if ($PSVersionTable.PSVersion.Major -lt 6) {
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $IsWindows = $true
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $IsLinux = $false
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $IsMacOS = $false
}

<#
.SYNOPSIS
    Provide PowerShell completion for Vim Native applications
.DESCRIPTION
     Provide completion for vim, vimdiff, gvim, gvimdiff, and evim similar to zsh. See LINK for `compdef vim`.

     For PowerShell Core 6 and above, rely on TabExpansion2.

     For Windows PowerShell 5.1 and below, override TabExpansion to handle -, -- & + correclty.
.PARAMETER WordToComplete
    TabExpansion2 sets WordToComplete to value the user has provided before they pressed Tab. Used to determine tab completion values. It may be an empty string.
.PARAMETER CommandAst
    This parameter is set to the Abstract Syntax Tree (AST) for the current input line.

    CommandElements    : {vim, --remote, -}
    InvocationOperator : Unknown
    DefiningKeyword    :
    Redirections       : {}
    Extent             : vim --remote -
    Parent             : vim --remote -
.PARAMETER CursorPosition
    This parameter is set to the position of the cursor when the user pressed Tab.
.PARAMETER LastBlock
    The legacy TabExpansion function sets this parameter to the last block, as delimited by | or ;, or otherwise to the entire command line, when the user presses Tab.

    See Get-Help TabExpansion -Full for additional detail.
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
.EXAMPLE
    PS C:\> vim -V10'C:\ <Ctrl-Space>

    -V10'C:\data'                 -V10'C:\SWSETUP'
    -V10'C:\ESD'                  -V10'C:\Symbols'
    -V10'C:\GENuclearEnergy'      -V10'C:\SymCache'
    -V10'C:\inetpub'              -V10'C:\tools'
    -V10'C:\Intel'                -V10'C:\Users'
    -V10'C:\PerfLogs'             -V10'C:\Windows'
    -V10'C:\Program Files'        -V10'C:\msdia80.dll'
    -V10'C:\Program Files (x86)'

    -V[N][fname]    Be verbose [level N] (default: 10) [log messages to fname]
     When bigger than zero, Vim will give messages about what it is doing.
      Always quote [fname]--e.g., 'C:\' or 'tst.log'
.EXAMPLE
    PS C:\> TabExpansion2 -inputScript 'vim --' -cursorColumn 6 | Select-Object -ExpandProperty CompletionMatches

    CompletionText           ListItemText                ResultType ToolTip
    --------------           ------------                ---------- -------
    --                       --                       ParameterName --      Only file names after this
    --clean                  --clean                  ParameterName --clean 'nocompatible', Vim defaults, no plugins, no viminfo
    --cmd                    --cmd                    ParameterName --cmd <command> Execute <command> before loading any vimrc file
    --help                   --help                   ParameterName -h  or  --help  Print Help and exit
    --literal                --literal                ParameterName --literal       Don't expand wildcards
    --nofork                 --nofork                 ParameterName --nofork        Foreground: Don't fork when starting GUI
    --noplugin               --noplugin               ParameterName --noplugin      Don't load plugin scripts
    --not-a-term             --not-a-term             ParameterName --not-a-term    Skip warning for input/output not being a terminal
    --remote                 --remote                 ParameterName --remote <files>        Edit <files> in a Vim server if possible
    --remote-expr            --remote-expr            ParameterName --remote-expr <expr>    Evaluate <expr> in a Vim server and print result
    --remote-send            --remote-send            ParameterName --remote-send <keys>    Send <keys> to a Vim server and exit
    --remote-silent          --remote-silent          ParameterName --remote-silent <files> Edit <files> in a Vim server if possible and don't complain if t...
    --remote-tab             --remote-tab             ParameterName --remote-tab    Edit <files> in a Vim server if possible, but open tab page for each file
    --remote-tab-silent      --remote-tab-silent      ParameterName --remote-tab-silent     Edit <files> in a Vim server if possible, but open tab page for each...
    --remote-tab-wait        --remote-tab-wait        ParameterName --remote-tab-wait       Edit <files> in a Vim server if possible, but open tab page for each f...
    --remote-tab-wait-silent --remote-tab-wait-silent ParameterName --remote-tab-wait-silent        Edit <files> in a Vim server if possible, but open tab page for...
    --remote-wait            --remote-wait            ParameterName --remote-wait <files>   Edit <files> in a Vim server if possible and wait for files to hav...
    --remote-wait-silent     --remote-wait-silent     ParameterName --remote-wait-silent <files>    Edit <files> in a Vim server if possible, wait for files to...
    --serverlist             --serverlist             ParameterName --serverlist    List available Vim server names and exit

    --servername             --servername             ParameterName --servername <name>     Send to/become the Vim server <name>. Tab to expand running server n...
    --startuptime            --startuptime            ParameterName --startuptime <file>    Write startup timing messages to <file>

    --ttyfail                --ttyfail                ParameterName --ttyfail       Exit if input or output is not a terminal

    --version                --version                ParameterName --version       Print version information and exit
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
        [Parameter(
            ParameterSetName = 'AstInputSet',
            Mandatory = $true,
            Position = 0
        )]
        [string]
        $WordToComplete
        ,
        [Parameter(
            ParameterSetName = 'AstInputSet',
            Mandatory = $true,
            Position = 1
        )]
        [System.Management.Automation.Language.CommandAst]
        $CommandAst
        ,
        [Parameter(
            ParameterSetName = 'AstInputSet',
            Mandatory = $true,
            Position = 2
        )]
        [Int32]
        $CursorPosition
        ,
        [Parameter(
            ParameterSetName = 'LegacyTabExpansion',
            Mandatory = $true,
            Position = 0
        )]
        [string]
        $LastBlock
    )

    # mikebattista / PowerShell-WSL-Interop developed snippet to locate
    # PreviousWord based on CursorPosition.
    # https://github.com/mikebattista/PowerShell-WSL-Interop/blob/2dd31622200b12032febdff45fd9ef4bd69c15f9/WslInterop.psm1#L137
    if ( $LastBlock ) {
        # Match space except enclosed in ' or ", and split on unquoted space.
        # Does not handle orphan quotes.
        # $Pattern = "\s(?=(?:['""][^'^""]*['""]|[^'""])*$)"
        # $Words =  [regex]::Split($LastBlock, $Pattern)

        $Words = [System.Management.Automation.PSParser]::Tokenize($LastBlock, [ref]$null) |
        Select-Object -ExpandProperty Content

        if ( $Words[-1] -match '^[-\+]' ) {
            # Lastword starts with - or +
            if ($LastBlock[-1] -eq ' ') {
                # LastBlock ends with space as in `--servernam `
                $WordToComplete = ''
            } else {
                # LastBlock ends without space as in `-V10`
                $WordToComplete = $Words[-1]
            }
            $PreviousWord = $Words[-1]
        } elseif ( $Words[-2] -match '^[-\+]' ) {
            # Penultimate word starts with - or +
            $PreviousWord = $Words[-2]
            $WordToComplete = $Words[-1]
        } else {
            $PreviousWord = ''
            $WordToComplete = $Words[-1]
        }
        # $PreviousWord = $PreviousWord -replace "'",""
        # $WordToComplete = $WordToComplete -replace "'",""
    } else {
        $LastBlock = $CommandAst.Parent
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
                # The cursor is within whitespace between the previous and
                # current words.
                $PreviousWord = $CommandAst.CommandElements[$i - 1].Extent.Text
                break
            } elseif (
                $i -eq $CommandAst.CommandElements.Count - 1 -and `
                    $CursorPosition -gt $Extent.EndColumnNumber
            ) {
                # The cursor is within whitespace at the end of the line.
                $PreviousWord = $Extent.Text
                break
            }
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
                    $CompletionText, $ListItemText, 'ParameterValue', `
                    $ListItemText
            }
            return
        }
        '^-[rL]$' {
            if ( $PSVersionTable.PSVersion.Major -lt 6 ) {
                # PS 5 corrupts NativeCommandError, when 2>&1 redirects stderr
                # from vim -r.
                return
            }
            Get-VimSwapFile |
            Where-Object { $_.CompletionText -like "*$WordToComplete*" } |
            New-TabItem -Line $LastBlock -ResultType 'ProviderItem' `

            return
        }
        '^-t$' {
            # https://stackoverflow.com/questions/8761888/capturing-standard-out-and-error-with-start-process
            try {
                # Look for readtags executable.
                $Command = Get-Command readtags -ErrorAction Stop

                # Look for tags in current directory.
                $TagFile = Get-ChildItem -Path .\ tags -ErrorAction Ignore

                if ($null -eq $TagFile) {
                    # Look for tags in project root.
                    $TagFile = Invoke-Git rev-parse --show-toplevel `
                        -ErrorAction Stop
                    $TagFile = Get-ChildItem -Path "$TagFile" tags `
                        -ErrorAction Stop
                }
            } catch {
                return
            }

            $CompletionText = & $Command -t "$TagFile" -l |
            ForEach-Object -Process {
                ($_.Split())[0]
            } |
            Sort-Object -Unique -CaseSensitive |
            ForEach-Object -Process {
                [PSCustomObject]@{
                    CompletionText = $_
                }
            }

            $ToolTip = Get-VimOption |
            Where-Object { $_.CompletionText -clike $Matches[0] }
            $ToolTip = $ToolTip.ToolTip

            $CompletionText |
            Where-Object { $_.CompletionText -like "$WordToComplete*" } |
            New-TabItem -Line $LastBlock `
                -ResultType 'ParameterValue' -ToolTip $ToolTip

            return
        }
        '^-T$' {
            # Expand <terminal> in -T <terminal> Set terminal type to <terminal>
            #
            # Vim writes to stderr which polutes $Error in PowerShell. Open issue:
            # https://github.com/PowerShell/PowerShell/issues/3996#issuecomment-667326937
            #
            # PS 5 corrupts NativeCommandError, when 2>&1 redirects stderr
            # from vim -r.
            if ($IsWindows -and $PSVersionTable.PSVersion.Major -ge 6 ) {
                $ToolTip = Get-VimOption |
                Where-Object { $_.CompletionText -clike $Matches[0] }
                $ToolTip = $ToolTip.ToolTip
                $ToolTip += " (default: win32)"

                # Strip the PowerShell exception wrapper from Stream 2.
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
                New-TabItem -Line $LastBlock `
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
            # Expand [g]vimrc
            # -u <vimrc> Use <vimrc> instead of any .vimrc
            # -U <gvimrc> Use <gvimrc> instead of any .gvimrc
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
            New-TabItem -ResultType 'ParameterValue' -Line $LastBlock

            # Complete [g]vimrc files.
            $Argument = Get-VimOption |
            Where-Object { $_.CompletionText -clike $Matches[0] }
            $ToolTip = $Argument.ToolTip

            Get-VimChildItem -Path "$WordToComplete*" -ToolTip $ToolTip |
            New-TabItem -Line $LastBlock

            return
        }
    }

    # Complete parameters starting with -|+ or default to Path completion.
    switch -Regex -CaseSensitive ($WordToComplete) {
        '^-[oOp]$' {
            # Expand N:
            # -o[N] Open N windows (default: one for each file)
            # -O[N] Open N windows split vertically (default: one for each file)
            # -p[N] Open N tab pages (default: one for each file)
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
            # Expand N in
            # -V[N] Be verbose [level N]
            $VimOption = $Matches[0]
            $OptionToComplete = $WordToComplete.Substring($VimOption.Length)

            Get-VimVerbose |
            Where-Object { $_.CompletionText -like "$OptionToComplete*" } |
            Sort-Object -Property CompletionText -Unique |
            New-TabItem -ResultType 'ParameterName' -Line $LastBlock `
                -VimOption "${VimOption}"
        }
        '^-V\d{1,2}' {
            # Expand fname in
            # -V[N][fname] Be verbose [level N]
            $Argument = Get-VimOption |
            Where-Object { $_.CompletionText -clike '-V' }
            $ToolTip = $Argument.ToolTip
            $ToolTip += "`n Always quote [fname]--e.g., 'C:\' or 'tst.log'"

            $VimOption = $Matches[0]
            $FileToComplete = $WordToComplete.Substring($VimOption.Length)

            $result = Get-VimChildItem -Path "$FileToComplete*" -Quote -ToolTip $ToolTip
            if ($WordToComplete -match '\s') {
                $result | New-TabItem -Line $LastBlock
            } else {
                $result | New-TabItem -Line $LastBlock -VimOption "${VimOption}"
            }
        }
        '^[-+]' {
            # Expand -, -- and + OPTIONS
            Get-VimOption |
            Where-Object { $_.CompletionText -clike "$WordToComplete*" } |
            Sort-Object -Property CompletionText -Unique -CaseSensitive |
            New-TabItem -ResultType 'ParameterName' -Line $LastBlock
        }
        Default { return }
    }
}

## POWERSHELL CORE TAB COMPLETION ##############################################################
if (!$UseLegacyTabExpansion -and ($PSVersionTable.PSVersion.Major -ge 6)) {
    $Vim = @( 'vim', 'vimdiff', 'gvim', 'gvimdiff', 'evim')
    Microsoft.PowerShell.Core\Register-ArgumentCompleter `
        -Command $Vim `
        -Native `
        -ScriptBlock $function:VimCompletion
}

