## LEGACY TAB COMPLETION ##############################################################
# We borrow the approach used by posh-git, in which we override any existing
# functions named TabExpansion, look for commands we can complete on, and then
# default to the previously defined TabExpansion function for everything else.

if (Test-Path Function:\TabExpansion) {
    # Since this technique is common, we encounter an infinite loop if it's
    # used more than once unless we give our backup a unique name.
    Rename-Item Function:\TabExpansion VimTabExpansionBackup
}

<#
.SYNOPSIS
    Override builtin TabExpansion function.
.DESCRIPTION
    Override builtin TabExpansion function. If there are no matches, call the original TabExpansion, renamed VimTabExpansionBackup.

    Only complete the last block, delimited by | or ;, using `VimCompletion -LastBlock $LastBlock`.
.PARAMETER Line
     The entire command line so far.
.PARAMETER LastWord
     The last whitespace delimited word in the command line.

     The function ignores LastWord, since PowerShell 5.1 does not populate it correcly for words starting with - or --.
.EXAMPLE
    PS C:\> TabExpansion 'vim --' ' '

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
    Posh-Git developed the design. (https://github.com/dahlbyk/posh-git/blob/66b46b4393d2a11d696b6f4776405a3ad4809a46/src/GitTabExpansion.ps1)
.LINK
    Conda added a unique name for TabExpansionBackup to avoid name collisions. (https://github.com/conda/conda/blob/9584d79f978f5c319fa2e0252db07e866e796ffe/conda/shell/condabin/Conda.psm1#L188)
#>

function TabExpansion {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.CompletionResult[]])]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [string]
        $Line
        ,
        [Parameter(
            Mandatory = $true,
            Position = 1
        )]
        [string]
        $LastWord
    )
    $LastBlock = [regex]::Split($line, '[|;]')[-1].TrimStart()

    switch -regex ($LastBlock) {
        '^[eg]?vim(diff)? (.*)' {
            VimCompletion -LastBlock "$LastBlock"
            break;
        }
        # '^Invoke-Vim (.*)' {
        #     VimCompletion -LastBlock "$LastBlock"
        #     break;
        # }
        # Finally, fall back on existing tab expansion.
        default {
            if (Test-Path Function:\VimTabExpansionBackup) {
                VimTabExpansionBackup "$Line" "$LastWord"
            }
        }
    }
}
