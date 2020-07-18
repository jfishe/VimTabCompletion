<#
.SYNOPSIS
    Convert Vim OPTIONS into PSCustomObject with CompletionText and ToolTip
    properties. ExcludeArgument property lists incompatible OPTIONS.
.DESCRIPTION
    Convert Vim OPTIONS into PSCustomObject with CompletionText and ToolTip
    properties. ExcludeArgument property lists incompatible OPTIONS separated
    with the Regex 'or', '|', operator.

    CompletionText and ToolTip are required.
.EXAMPLE
    None
.INPUTS
    None
.OUTPUTS
    An arrary of

    [PSCustomObject]@{
        CompletionText = "Vim OPTION"
        ToolTip  = "Vim OPTION with help"
        ExcludeArgument = '-v|-E|-d|-y'
    }
.NOTES
    CompletionText should end with a space to allow default file completion or
    subcommand expansion.

    function Get-VimArguments {

        if (Get-Command -Name vim -ErrorAction SilentlyContinue) {
            $VimArguments = & vim --help | Select-String -Pattern '^\s*[-+]'
        } else {
            return ''
        }

        $VimArguments | ForEach-Object -Process {
            $ToolTip = $_.ToString()
            $CompletionText = ($ToolTip -Split '\t+', 0, "RegexMatch")
            $Length = [int] $CompletionText.Length
            if ($Length -eq 2) {
                $CompletionText = $CompletionText[0].Trim()
            } else {
                $CompletionText = $CompletionText.Trim().Split()[0]
            }
            $CompletionText = ($CompletionText -Split '[[<( ]')[0]
            $ToolTip = $ToolTip.Trim()

            [PSCustomObject]@{
                Argument = "$CompletionText"
                ToolTip  = "$ToolTip"
            }
        }
    }
#>

function Get-VimOption {
    param()

    $Argument = @(
        [PSCustomObject]@{
            CompletionText = '-'
            ToolTip        = "-`tRead text from stdin"
        }
        [PSCustomObject]@{
            CompletionText = '--'
            ToolTip        = "--`tOnly file names after this"
        }
    )

    $Argument += @(
        [PSCustomObject]@{
            CompletionText = '-m'
            ToolTip        = "-m`tModifications (writing files) not allowed"
        }
        [PSCustomObject]@{
            CompletionText = '-M'
            ToolTip        = "-M`tModifications in text not allowed"
        }
        [PSCustomObject]@{
            CompletionText = '-b'
            ToolTip        = "-b`tBinary mode"
        }
        [PSCustomObject]@{
            CompletionText = '-l'
            ToolTip        = "-l`tLisp mode"
        }
        [PSCustomObject]@{
            CompletionText = '-V'
            ToolTip        = "-V[N][fname]`tBe verbose [level N] [log messages to fname]"
        }
        [PSCustomObject]@{
            CompletionText = '-D'
            ToolTip        = "-D`tDebugging mode"
        }
        [PSCustomObject]@{
            CompletionText = '-n'
            ToolTip        = "-n`tNo swap file, use memory only"
        }
        # Add space at end to allow expansion of swap files from vim -L|-r
        [PSCustomObject]@{
            CompletionText = '-r '
            ToolTip        = "-r [swap file]`tList swap files and exit or recover from a swap file. Tab to list swap files"
        }
        # Add space at end to allow expansion of swap files from vim -L|-r
        [PSCustomObject]@{
            CompletionText = '-L '
            ToolTip        = "-L [swap file]`tList swap files and exit or recover from a swap file. Tab to list swap files"
        }
        [PSCustomObject]@{
            CompletionText  = '-A'
            ToolTip         = 'Start in Arabic mode'
            ExcludeArgument = '-H|-F'
        }
        [PSCustomObject]@{
            CompletionText  = '-H'
            ToolTip         = 'Start in Hebrew mode'
            ExcludeArgument = '-A|-F'
        }
        [PSCustomObject]@{
            CompletionText  = '-F'
            ToolTip         = 'Start in Farsi mode'
            ExcludeArgument = '-A|-H'
        }
        [PSCustomObject]@{
            CompletionText = '-u'
            ToolTip        = "-u <vimrc>`tUse <vimrc> instead of any .vimrc:config:->config"
        }
        [PSCustomObject]@{
            CompletionText = '--noplugin'
            ToolTip        = "--noplugin`tDon't load plugin scripts"
        }
        [PSCustomObject]@{
            CompletionText = '-o'
            ToolTip        = "-o[N]`tOpen N windows (default: one for each file)::window count: "
        }
        [PSCustomObject]@{
            CompletionText = '-O'
            ToolTip        = "-O[N]`tOpen N windows split vertically (default: one for each file)::window count: "
        }
        [PSCustomObject]@{
            CompletionText = '-p'
            ToolTip        = "-p[N]`tOpen N tab pages (default: one for each file)::tab count: "
        }
        [PSCustomObject]@{
            CompletionText = '-q '
            ToolTip        = "-q [errorfile]`tEdit file with first error quickfix file]::file:_files"
        }
        [PSCustomObject]@{
            CompletionText = '--cmd '
            ToolTip        = "--cmd <command>`tExecute <command> before loading any vimrc file"
        }
        [PSCustomObject]@{
            CompletionText = '-c '
            ToolTip        = "-c <command>`tExecute <command> after loading the first file"
        }
        [PSCustomObject]@{
            CompletionText = '-S '
            ToolTip        = "-S <session>`tSource file <session> after loading the first file::session file:_files"
        }
        [PSCustomObject]@{
            CompletionText = '-s '
            ToolTip        = "-s <scriptin>`tRead Normal mode commands from file <scriptin>:script file:_files"
        }
        [PSCustomObject]@{
            CompletionText = '-w'
            ToolTip        = "-w <scriptout>`tAppend all typed commands to file <scriptout>:output file:_files"
        }
        [PSCustomObject]@{
            CompletionText = '-W'
            ToolTip        = "-W <scriptout>`tWrite all typed commands to file <scriptout>:output file:_files"
        }
        [PSCustomObject]@{
            CompletionText = '--startuptime'
            ToolTip        = "--startuptime <file>`tWrite startup timing messages to <file>:log file:_files"
        }
        [PSCustomObject]@{
            CompletionText = '--help'
            ToolTip        = "-h  or  --help`tPrint Help and exit"
        }
        [PSCustomObject]@{
            CompletionText = '-h'
            ToolTip        = "-h  or  --help`tPrint Help and exit"
        }
        [PSCustomObject]@{
            CompletionText = '--version'
            ToolTip        = "--version`tPrint version information and exit"
        }
        [PSCustomObject]@{
            CompletionText = '-t'
            ToolTip        = "-t`tEdit file where tag is defined:tag:_complete_tag"
        }
    )

    $Argument += @(
        [PSCustomObject]@{
            CompletionText  = '-e'
            ToolTip         = "-e`tEx mode (like ""ex"")"
            ExcludeArgument = '-v|-E|-d|-y'
        }
        [PSCustomObject]@{
            CompletionText  = '-E'
            ToolTip         = "-E`tImproved Ex mode"
            ExcludeArgument = '-v|-e|-d|-y'
        }
        [PSCustomObject]@{
            CompletionText  = '-v'
            ToolTip         = "-v`tVi mode (like ""vi"")"
            ExcludeArgument = '-e|-E|-s|-d|-y'
        }
        [PSCustomObject]@{
            CompletionText  = '-y'
            ToolTip         = "-y`tEasy mode (like ""evim"", modeless)"
            ExcludeArgument = '-v|-e|-E|-s|-d'
        }
        [PSCustomObject]@{
            CompletionText = '-C'
            ToolTip        = "-C`tCompatible with Vi: 'compatible'"
        }
        [PSCustomObject]@{
            CompletionText = '-N'
            ToolTip        = "-N`tNot fully Vi compatible: 'nocompatible'"
        }
        [PSCustomObject]@{
            CompletionText = '-T '
            ToolTip        = "-T <terminal>`tSet terminal type to <terminal>:::_terminals"
        }
        [PSCustomObject]@{
            CompletionText = '--not-a-term'
            ToolTip        = "--not-a-term`tSkip warning for input/output not being a terminal"
        }
        [PSCustomObject]@{
            CompletionText = '--ttyfail'
            ToolTip        = "--ttyfail`tExit if input or output is not a terminal"
        }
        # Not implemented on Windows
        # [PSCustomObject]@{
        #     CompletionText = '-X'
        #     ToolTip        = 'Do not connect to X server'
        # }
        [PSCustomObject]@{
            CompletionText = '-x '
            ToolTip        = "-x`tEdit encrypted files"
        }
        [PSCustomObject]@{
            CompletionText = '--remote '
            ToolTip        = "--remote <files>`tEdit <files> in a Vim server if possible"
        }
        [PSCustomObject]@{
            CompletionText = '--remote-silent '
            ToolTip        = "--remote-silent <files>  Same as --remote, but don't complain if there is no server"
        }
        [PSCustomObject]@{
            CompletionText = '--remote-wait '
            ToolTip        = "--remote-wait <files>  Same as --remote but wait for files to have been edited"
        }
        [PSCustomObject]@{
            CompletionText = '--remote-wait-silent '
            ToolTip        = "--remote-wait-silent <files>  Same as --remote-wait, but don't complain if there is no server"
        }
        [PSCustomObject]@{
            CompletionText = '--remote-send '
            ToolTip        = "--remote-send <keys>`tSend <keys> to a Vim server and exit"
        }
        [PSCustomObject]@{
            CompletionText = '--remote-tab '
            ToolTip        = "--remote-tab`Same as --remote but open tab page for each file"
        }
        [PSCustomObject]@{
            CompletionText = '--remote-tab-silent '
            ToolTip        = "--remote-tab-silent`tSame as --remote-silent but open tab page for each file"
        }
        [PSCustomObject]@{
            CompletionText = '--remote-tab-wait '
            ToolTip        = "--remote-tab-wait`tSame as --remote-wait but open tab page for each file"
        }
        [PSCustomObject]@{
            CompletionText = '--remote-tab-wait-silent '
            ToolTip        = "--remote-tab-wait-silent`tSame as --remote-wait-silent but open tab page for each file"
        }
        [PSCustomObject]@{
            CompletionText = '--remote-expr '
            ToolTip        = "--remote-expr <expr>`tEvaluate <expr> in a Vim server and print result"
        }
        [PSCustomObject]@{
            CompletionText = '--literal '
            ToolTip        = "--literal`tDon't expand wildcards"
        }
        [PSCustomObject]@{
            CompletionText = '--serverlist'
            ToolTip        = "--serverlist`tList available Vim server names and exit"
        }
        [PSCustomObject]@{
            CompletionText = '--servername '
            ToolTip        = "--servername <name>`tSend to/become the Vim server <name>. Tab to expand running server names"
        }
        [PSCustomObject]@{
            CompletionText = '-i'
            ToolTip        = "-i <viminfo>`tUse <viminfo> instead of .viminfo"
        }
        [PSCustomObject]@{
            CompletionText = '--clean'
            ToolTip        = "--clean`t'nocompatible', Vim defaults, no plugins, no viminfo"
        }
    )
    $Argument += @(
        [PSCustomObject]@{
            CompletionText = '+'
            ToolTip        = "+<lnum>`tStart at line <lnum>"
        }
        [PSCustomObject]@{
            CompletionText = '+ '
            ToolTip        = "+`tStart at end of file"
        }
    )

    return $Argument
}
