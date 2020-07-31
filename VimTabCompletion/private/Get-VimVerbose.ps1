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
    From vim normal mode, enter :help 'verbose"


    'verbose' 'vbs'		number	(default 0)
                global
        When bigger than zero, Vim will give messages about what it is doing.
        Currently, these messages are given:
        =  0	Don't display any messages.
        >= 1	When the viminfo file is read or written.
        >= 2	When a file is ":source"'ed.
        >= 4	Shell commands.
        >= 5	Every searched tags file and include file.
        >= 8	Files for which a group of autocommands is executed.
        >= 9	Every executed autocommand.
        >= 11	Finding items in a path
        >= 12	Every executed function.
        >= 13	When an exception is thrown, caught, finished, or discarded.
        >= 14	Anything pending in a ":finally" clause.
        >= 15	Every executed Ex command (truncated at 200 characters).

        This option can also be set with the "-V" argument.  See |-V|.
        This option is also set by the |:verbose| command.

        When the 'verbosefile' option is set then the verbose messages are not
        displayed.
#>

function Get-VimVerbose {
    param ()

    $ToolTip = @(
            "-V[N][fname]`tBe verbose [level N] (default: 10)",
            "[log messages to fname]`n",
            "When bigger than zero, Vim will give messages about what it is doing.`n "
            ) -join ' '
    $Argument = @(
        [PSCustomObject]@{
            CompletionText = 0
            ToolTip        = "${ToolTip}Don't display any messages"
        }
        [PSCustomObject]@{
            CompletionText = 1
            ToolTip        = "${ToolTip}Display when the viminfo file is read or written."
        }
        [PSCustomObject]@{
            CompletionText = 2
            ToolTip        = "${ToolTip}Display when a file is "":source""'ed."
        }
        [PSCustomObject]@{
            CompletionText = 4
            ToolTip        = "${ToolTip}Display shell commands."
        }
        [PSCustomObject]@{
            CompletionText = 5
            ToolTip        = "${ToolTip}Display every searched tags file and include file."
        }
        [PSCustomObject]@{
            CompletionText = 8
            ToolTip        = "${ToolTip}Display files for which a group of autocommands is executed."
        }
        [PSCustomObject]@{
            CompletionText = 9
            ToolTip        = "${ToolTip}Display every executed autocommand."
        }
        [PSCustomObject]@{
            CompletionText = 11
            ToolTip        = "${ToolTip}Display finding items in a path"
        }
        [PSCustomObject]@{
            CompletionText = 12
            ToolTip        = "${ToolTip}Display every executed function."
        }
        [PSCustomObject]@{
            CompletionText = 13
            ToolTip        = "${ToolTip}Display when an exception is thrown, caught, finished, or discarded."
        }
        [PSCustomObject]@{
            CompletionText = 14
            ToolTip        = "${ToolTip}Display anything pending in a "":finally"" clause."
        }
        [PSCustomObject]@{
            CompletionText = 15
            ToolTip        = "${ToolTip}Every executed Ex command (truncated at 200 characters)."
        }
    )

    return $Argument
}
