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
    None
#>

function Get-VimArguments {
    param()

    $Argument = @(
        [PSCustomObject]@{
            CompletionText = '--'
            ToolTip        = 'Only file names after this'
        }
    )

    $Argument += @(
        [PSCustomObject]@{
            CompletionText = '-m'
            ToolTip        = 'modifications (writing files) not allowed]'
        }
        [PSCustomObject]@{
            CompletionText = '-M'
            ToolTip        = 'modifications in text not allowed]'
        }
        [PSCustomObject]@{
            CompletionText = '-b'
            ToolTip        = 'binary mode]'
        }
        [PSCustomObject]@{
            CompletionText = '-l'
            ToolTip        = 'lisp mode]'
        }
        [PSCustomObject]@{
            CompletionText = '-V'
            ToolTip        = 'verbosity level]::verbosity [10]:->verbosity'
        }
        [PSCustomObject]@{
            CompletionText = '-D'
            ToolTip        = 'debugging mode]'
        }
        [PSCustomObject]@{
            CompletionText = '-n'
            ToolTip        = 'no swap file (memory only)]'
        }
        [PSCustomObject]@{
            CompletionText = '-r'
            ToolTip        = 'list swap files and exit or recover from a swap file]::swap file:_vim_files -g "*.sw?(-.)"'
        }
        [PSCustomObject]@{
            CompletionText = '-L'
            ToolTip        = 'list swap files and exit or recover from a swap file]::swap file:_vim_files -g "*.sw?(-.)"'
        }
        [PSCustomObject]@{
            CompletionText  = '-A'
            ToolTip         = 'start in Arabic mode]'
            ExcludeArgument = '-H|-F'
        }
        [PSCustomObject]@{
            CompletionText  = '-H'
            ToolTip         = 'start in Hebrew mode]'
            ExcludeArgument = '-A|-F'
        }
        [PSCustomObject]@{
            CompletionText  = '-F'
            ToolTip         = 'start in Farsi mode]'
            ExcludeArgument = '-A|-H'
        }
        [PSCustomObject]@{
            CompletionText = '-u'
            ToolTip        = 'use given vimrc file instead of default .vimrc]:config:->config'
        }
        [PSCustomObject]@{
            CompletionText = '--noplugin'
            ToolTip        = "don't load plugin scripts"
        }
        [PSCustomObject]@{
            CompletionText = '-o'
            ToolTip        = 'number of windows to open (default: one for each file)]::window count: '
        }
        [PSCustomObject]@{
            CompletionText = '-O'
            ToolTip        = 'number of windows to vertically split open (default is one for each file)]::window count: '
        }
        [PSCustomObject]@{
            CompletionText = '-p'
            ToolTip        = 'number of tabs to open (default: one for each file)]::tab count: '
        }
        [PSCustomObject]@{
            CompletionText = '-q'
            ToolTip        = 'quickfix file]::file:_files'
        }
        [PSCustomObject]@{
            CompletionText = '--cmd'
            ToolTip        = 'execute given command before loading any RC files]:command: '
        }
        [PSCustomObject]@{
            CompletionText = '-c'
            ToolTip        = 'execute given command after loading the first file]:command: '
        }
        [PSCustomObject]@{
            CompletionText = '-S'
            ToolTip        = 'source a session file after loading the first file]::session file:_files'
        }
        [PSCustomObject]@{
            CompletionText = '-s'
            ToolTip        = 'read normal-mode commands from script file]:script file:_files'
        }
        [PSCustomObject]@{
            CompletionText = '-w'
            ToolTip        = 'append all typed commands to given file]:output file:_files'
        }
        [PSCustomObject]@{
            CompletionText = '-W'
            ToolTip        = 'write all typed commands to given file, overwriting existing file]:output file:_files'
        }
        [PSCustomObject]@{
            CompletionText = '--startuptime'
            ToolTip        = 'write startup timing messages to given file]:log file:_files'
        }
        [PSCustomObject]@{
            CompletionText = '--help'
            ToolTip        = 'print help and exit]'
        }
        [PSCustomObject]@{
            CompletionText = '-h'
            ToolTip        = 'print help and exit]'
        }
        [PSCustomObject]@{
            CompletionText = '--version'
            ToolTip        = 'print version information and exit'
        }
        [PSCustomObject]@{
            CompletionText = '-t'
            ToolTip        = 'edit file where tag is defined]:tag:_complete_tag'
        }
    )

    $Argument += @(
        [PSCustomObject]@{
            CompletionText  = '-e'
            ToolTip         = 'ex mode]'
            ExcludeArgument = '-v|-E|-d|-y'
        }
        [PSCustomObject]@{
            CompletionText  = '-E'
            ToolTip         = 'improved ex mode]'
            ExcludeArgument = '-v|-e|-d|-y'
        }
        [PSCustomObject]@{
            CompletionText  = '-v'
            ToolTip         = 'vi mode]'
            ExcludeArgument = '-e|-E|-s|-d|-y'
        }
        [PSCustomObject]@{
            CompletionText  = '-y'
            ToolTip         = 'easy mode]'
            ExcludeArgument = '-v|-e|-E|-s|-d'
        }
        [PSCustomObject]@{
            CompletionText = '-C'
            ToolTip        = 'start in compatible mode]'
        }
        [PSCustomObject]@{
            CompletionText = '-N'
            ToolTip        = 'start in incompatible mode]'
        }
        [PSCustomObject]@{
            CompletionText = '-T'
            ToolTip        = 'set terminal type]:::_terminals'
        }
        [PSCustomObject]@{
            CompletionText = '--not-a-term'
            ToolTip        = 'skip warning for input/output not being a terminal]'
        }
        [PSCustomObject]@{
            CompletionText = '--ttyfail'
            ToolTip        = 'exit if input or output is not a terminal]'
        }
        [PSCustomObject]@{
            CompletionText = '-X'
            ToolTip        = 'do not connect to X server]'
        }
        [PSCustomObject]@{
            CompletionText = '-x'
            ToolTip        = 'edit encrypted files]'
        }
        [PSCustomObject]@{
            CompletionText = '--remote'
            ToolTip        = 'edit given files in a vim server if possible]:*:file:_vim_files'
        }
        [PSCustomObject]@{
            CompletionText = '--remote-silent'
            ToolTip        = 'as --remote but without complaining if not possible]:*:file:_vim_files'
        }
        [PSCustomObject]@{
            CompletionText = '--remote-wait'
            ToolTip        = 'as --remote but wait for files to have been edited]:*:file:_vim_files'
        }
        [PSCustomObject]@{
            CompletionText = '--remote-wait-silent'
            ToolTip        = 'as --remote-wait but without complaining if not possible]:*:file:_vim_files'
        }
        [PSCustomObject]@{
            CompletionText = '--remote-send'
            ToolTip        = 'send given keys to vim server if possible]:keys: '
        }
        [PSCustomObject]@{
            CompletionText = '--remote-tab'
            ToolTip        = 'as --remote but open tab page for each file]:*:file:_vim_files'
        }
        [PSCustomObject]@{
            CompletionText = '--remote-tab-silent'
            ToolTip        = 'as --remote-silent but open tab page for each file]:*:file:_vim_files'
        }
        [PSCustomObject]@{
            CompletionText = '--remote-tab-wait'
            ToolTip        = 'as --remote-wait but open tab page for each file]:*:file:_vim_files'
        }
        [PSCustomObject]@{
            CompletionText = '--remote-tab-wait-silent'
            ToolTip        = 'as --remote-wait-silent but open tab page for each file]:*:file:_vim_files'
        }
        [PSCustomObject]@{
            CompletionText = '--remote-expr'
            ToolTip        = 'evaluate given expression in a vim server and print result]:expression: '
        }
        [PSCustomObject]@{
            CompletionText = '--literal'
            ToolTip        = 'do not expand wildcards in arguments (this is useless with ZSH)]'
        }
        [PSCustomObject]@{
            CompletionText = '--serverlist'
            ToolTip        = 'list available vim servers and exit]'
        }
        [PSCustomObject]@{
            CompletionText = '--servername'
            ToolTip        = 'name of vim server to send to or name of server to become]:server name:->server'
        }
        [PSCustomObject]@{
            CompletionText = '-i'
            ToolTip        = 'use specified viminfo file]:viminfo file [~/.viminfo]:_files'
        }
        [PSCustomObject]@{
            CompletionText = '--clean'
            ToolTip        = 'start with defaults in non-compatible mode]'
        }
    )
    $Argument += @(
        [PSCustomObject]@{
            CompletionText = '+'
            ToolTip        = 'Start at line <lnum>'
        }
        [PSCustomObject]@{
            CompletionText = '+ '
            ToolTip        = 'Start at end of file'
        }
    )
    # TODO:  <04-07-20, jdfenw@gmail.com
    # Implement the following options
    #
    # [[ $service != *g* && $service != nvim ]] && arguments+='-g[start with GUI]'
    # [[ $service != r* ]] && arguments+='-Z[restricted mode]'
    # [[ $service != *diff ]] && arguments+='(-v -e -E -es -Es -s -y)-d[diff mode]'
    # [[ $service != *view ]] && arguments+='-R[readonly mode]'
    # [[ $service = *g* ]] || (( ${words[(I)-g]} )) && arguments+=(
    #   '(--nofork -f)'{--nofork,-f}'[do not detach the GUI version from the shell]'
    #   '-font:font:_xft_fonts'
    #   '-geometry:geometry:_x_geometry'
    #   '(-rv -reverse)'{-rv,-reverse}'[use reverse video]'
    #   '-display:display:_x_display'
    #   '--role[set unique role to identify main window]:role'
    #   '--socketid[open vim inside another GTK widget]:xid'
    #   '--echo-wid[echo window ID on stdout]'
    #   '-U[use given gvimrc file instead of default .gvimrc]:gui config:->configgui'
    # )
    #   > #
    return $Argument
}
