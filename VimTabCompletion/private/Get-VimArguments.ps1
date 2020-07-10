<#
.SYNOPSIS
    Convert Vim OPTIONS into PSCustomObject with Argument and ToolTip properties.
.DESCRIPTION
    Parse vim --help into a list of PSCustomObject with Argument and ToolTip
    properties.
.EXAMPLE
    None
.INPUTS
    None
.OUTPUTS
    A list of

    [PSCustomObject]@{
        Argument = "Vim OPTION"
        ToolTip  = "Vim OPTION with help"
    }
.NOTES
    None
#>

function Get-VimArguments {
    param()

    $Argument = @(
        [PSCustomObject]@{
            Argument = '--'
            ToolTip  = 'Only file names after this'
        }
    )

    $Argument += @(
        [PSCustomObject]@{
            Argument = '-m'
            ToolTip  = 'modifications (writing files) not allowed]'
        }
        [PSCustomObject]@{
            Argument = '-M'
            ToolTip  = 'modifications in text not allowed]'
        }
        [PSCustomObject]@{
            Argument = '-b'
            ToolTip  = 'binary mode]'
        }
        [PSCustomObject]@{
            Argument = '-l'
            ToolTip  = 'lisp mode]'
        }
        [PSCustomObject]@{
            Argument = '-V'
            ToolTip  = 'verbosity level]::verbosity [10]:->verbosity'
        }
        [PSCustomObject]@{
            Argument = '-D'
            ToolTip  = 'debugging mode]'
        }
        [PSCustomObject]@{
            Argument = '-n'
            ToolTip  = 'no swap file (memory only)]'
        }
        [PSCustomObject]@{
            Argument = '-r'
            ToolTip  = 'list swap files and exit or recover from a swap file]::swap file:_vim_files -g "*.sw?(-.)"'
        }
        [PSCustomObject]@{
            Argument = '-L'
            ToolTip  = 'list swap files and exit or recover from a swap file]::swap file:_vim_files -g "*.sw?(-.)"'
        }
        [PSCustomObject]@{
            Argument        = '-A'
            ToolTip         = 'start in Arabic mode]'
            ExcludeArgument = '-H|-F'
        }
        [PSCustomObject]@{
            Argument        = '-H'
            ToolTip         = 'start in Hebrew mode]'
            ExcludeArgument = '-A|-F'
        }
        [PSCustomObject]@{
            Argument        = '-F'
            ToolTip         = 'start in Farsi mode]'
            ExcludeArgument = '-A|-H'
        }
        [PSCustomObject]@{
            Argument = '-u'
            ToolTip  = 'use given vimrc file instead of default .vimrc]:config:->config'
        }
        [PSCustomObject]@{
            Argument = '--noplugin'
            ToolTip  = "don't load plugin scripts"
        }
        [PSCustomObject]@{
            Argument = '-o'
            ToolTip  = 'number of windows to open (default: one for each file)]::window count: '
        }
        [PSCustomObject]@{
            Argument = '-O'
            ToolTip  = 'number of windows to vertically split open (default is one for each file)]::window count: '
        }
        [PSCustomObject]@{
            Argument = '-p'
            ToolTip  = 'number of tabs to open (default: one for each file)]::tab count: '
        }
        [PSCustomObject]@{
            Argument = '-q'
            ToolTip  = 'quickfix file]::file:_files'
        }
        [PSCustomObject]@{
            Argument = '--cmd'
            ToolTip  = 'execute given command before loading any RC files]:command: '
        }
        [PSCustomObject]@{
            Argument = '-c'
            ToolTip  = 'execute given command after loading the first file]:command: '
        }
        [PSCustomObject]@{
            Argument = '-S'
            ToolTip  = 'source a session file after loading the first file]::session file:_files'
        }
        [PSCustomObject]@{
            Argument = '-s'
            ToolTip  = 'read normal-mode commands from script file]:script file:_files'
        }
        [PSCustomObject]@{
            Argument = '-w'
            ToolTip  = 'append all typed commands to given file]:output file:_files'
        }
        [PSCustomObject]@{
            Argument = '-W'
            ToolTip  = 'write all typed commands to given file, overwriting existing file]:output file:_files'
        }
        [PSCustomObject]@{
            Argument = '--startuptime'
            ToolTip  = 'write startup timing messages to given file]:log file:_files'
        }
        [PSCustomObject]@{
            Argument = '--help'
            ToolTip  = 'print help and exit]'
        }
        [PSCustomObject]@{
            Argument = '-h'
            ToolTip  = 'print help and exit]'
        }
        [PSCustomObject]@{
            Argument = '--version'
            ToolTip  = 'print version information and exit'
        }
        [PSCustomObject]@{
            Argument = '-t'
            ToolTip  = 'edit file where tag is defined]:tag:_complete_tag'
        }
    )

    $Argument += @(
        [PSCustomObject]@{
            Argument        = '-e'
            ToolTip         = 'ex mode]'
            ExcludeArgument = '-v|-E|-d|-y'
        }
        [PSCustomObject]@{
            Argument        = '-E'
            ToolTip         = 'improved ex mode]'
            ExcludeArgument = '-v|-e|-d|-y'
        }
        [PSCustomObject]@{
            Argument        = '-v'
            ToolTip         = 'vi mode]'
            ExcludeArgument = '-e|-E|-s|-d|-y'
        }
        [PSCustomObject]@{
            Argument        = '-y'
            ToolTip         = 'easy mode]'
            ExcludeArgument = '-v|-e|-E|-s|-d'
        }
        [PSCustomObject]@{
            Argument = '-C'
            ToolTip  = 'start in compatible mode]'
        }
        [PSCustomObject]@{
            Argument = '-N'
            ToolTip  = 'start in incompatible mode]'
        }
        [PSCustomObject]@{
            Argument = '-T'
            ToolTip  = 'set terminal type]:::_terminals'
        }
        [PSCustomObject]@{
            Argument = '--not-a-term'
            ToolTip  = 'skip warning for input/output not being a terminal]'
        }
        [PSCustomObject]@{
            Argument = '--ttyfail'
            ToolTip  = 'exit if input or output is not a terminal]'
        }
        [PSCustomObject]@{
            Argument = '-X'
            ToolTip  = 'do not connect to X server]'
        }
        [PSCustomObject]@{
            Argument = '-x'
            ToolTip  = 'edit encrypted files]'
        }
        [PSCustomObject]@{
            Argument = '--remote'
            ToolTip  = 'edit given files in a vim server if possible]:*:file:_vim_files'
        }
        [PSCustomObject]@{
            Argument = '--remote-silent'
            ToolTip  = 'as --remote but without complaining if not possible]:*:file:_vim_files'
        }
        [PSCustomObject]@{
            Argument = '--remote-wait'
            ToolTip  = 'as --remote but wait for files to have been edited]:*:file:_vim_files'
        }
        [PSCustomObject]@{
            Argument = '--remote-wait-silent'
            ToolTip  = 'as --remote-wait but without complaining if not possible]:*:file:_vim_files'
        }
        [PSCustomObject]@{
            Argument = '--remote-send'
            ToolTip  = 'send given keys to vim server if possible]:keys: '
        }
        [PSCustomObject]@{
            Argument = '--remote-tab'
            ToolTip  = 'as --remote but open tab page for each file]:*:file:_vim_files'
        }
        [PSCustomObject]@{
            Argument = '--remote-tab-silent'
            ToolTip  = 'as --remote-silent but open tab page for each file]:*:file:_vim_files'
        }
        [PSCustomObject]@{
            Argument = '--remote-tab-wait'
            ToolTip  = 'as --remote-wait but open tab page for each file]:*:file:_vim_files'
        }
        [PSCustomObject]@{
            Argument = '--remote-tab-wait-silent'
            ToolTip  = 'as --remote-wait-silent but open tab page for each file]:*:file:_vim_files'
        }
        [PSCustomObject]@{
            Argument = '--remote-expr'
            ToolTip  = 'evaluate given expression in a vim server and print result]:expression: '
        }
        [PSCustomObject]@{
            Argument = '--literal'
            ToolTip  = 'do not expand wildcards in arguments (this is useless with ZSH)]'
        }
        [PSCustomObject]@{
            Argument = '--serverlist'
            ToolTip  = 'list available vim servers and exit]'
        }
        [PSCustomObject]@{
            Argument = '--servername'
            ToolTip  = 'name of vim server to send to or name of server to become]:server name:->server'
        }
        [PSCustomObject]@{
            Argument = '-i'
            ToolTip  = 'use specified viminfo file]:viminfo file [~/.viminfo]:_files'
        }
        [PSCustomObject]@{
            Argument = '--clean'
            ToolTip  = 'start with defaults in non-compatible mode]'
        }
    )
    $Argument += @(
        [PSCustomObject]@{
            Argument = '+'
            ToolTip  = 'Start at line <lnum>'
        }
        [PSCustomObject]@{
            Argument = '+ '
            ToolTip  = 'Start at end of file'
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
