<#
.SYNOPSIS
    Start vim
.DESCRIPTION
    Locate and start a vim or gvim excutable passing arguments that are not
    used by Invoke-Vim.

    By default, start vim in the current shell.
.PARAMETER Arguments
    Arguments to pass to Vim executable. Defaults to the remaining parameters
    on the command line.
.PARAMETER Path
    Path to working directory. Defaults to current directory.
.PARAMETER VimPath
    Path to specify vim excutable. E.g., 'vim' usually resolves to vim.bat,
    which is read to locate vim.exe. The path to the excecutable may be
    specified.
.PARAMETER g
    Start gvim instead of vim.
.PARAMETER NoWindow
    Do not open a window. Similar to start hidden.
.PARAMETER RedirectStandardError
    Capture stderr stream.
.PARAMETER RedirectStandardOutput
    Capture stdout stream.
.PARAMETER Raw
    Return a PSCustomObject. Defaults to Write-Output and Write-Error, respectively.
    [pscustomobject]@{
        Command = $Command # Invocation string used to start Vim.
        Output  = $stdout
        Error   = $stderr

    Defaults to return stdout and stderr steams.
.PARAMETER Quiet
    Discard stdout and stderr streams.
.PARAMETER UseShellExecute
    True if the shell should be used when starting the process; false if the
    process should be created directly from the executable file. The default is
    true on .NET Framework apps and false on .NET Core apps.

    Setting this property to false enables you to redirect input, output, and
    error streams.

    The word "shell" in this context (UseShellExecute) refers to a graphical shell
    (similar to the Windows shell) rather than command shells (for example, bash or
    sh) and lets users launch graphical applications or open documents.

    See RELATED LINKS for more information.
.PARAMETER Split
    Character used to split stderr and stdout. Defaults to newline character.
.EXAMPLE
    PS C:\> $SwapFile = Invoke-Vim -Raw -RedirectStandardError -RedirectStandardOutput -L
    PS C:\> $SwapFile.Error

    Capture stderr from `vim -L` without updating $Error.
.LINK
    Capturing standard out and error with Start-Process (http://stackoverflow.com/questions/8761888/powershell-capturing-standard-out-and-error-with-start-process)
.LINK
    ProcessStartInfo.UseShellExecute Property (https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.processstartinfo.useshellexecute?view=netcore-3.1)
.LINK
   System.Diagnostics.ProcessStartInfo (https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.processstartinfo.useshellexecute?view=netcore-3.1)
#>

function Invoke-Vim {
    [cmdletbinding(DefaultParameterSetName = 'UseShellExecute')]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        $Arguments
        ,
        [string]$Path = $PWD.Path
        ,
        [string]$VimPath = 'vim'
        ,
        [Parameter(ParameterSetName = 'Gvim')]
        [switch]$g
        ,
        [Parameter(ParameterSetName = 'RedirectIO')]
        [switch]$CreateNoWindow = $false
        ,
        [Parameter(ParameterSetName = 'RedirectIO')]
        [switch]$RedirectStandardError = $false
        ,
        [Parameter(ParameterSetName = 'RedirectIO')]
        [switch]$RedirectStandardOutput = $false
        ,
        [Parameter(ParameterSetName = 'RedirectIO')]
        [switch]$Raw
        ,
        [Parameter(ParameterSetName = 'RedirectIO')]
        [switch]$Quiet
        ,
        [Parameter(ParameterSetName = 'Gvim')]
        [Parameter(ParameterSetName = 'UseShellExecute')]
        [switch]$UseShellExecute = $false
        ,
        [Parameter(ParameterSetName = 'RedirectIO')]
        [Parameter(ParameterSetName = 'UseShellExecute')]
        [string]$Split = "`n"
    )

    if ($PSBoundParameters.ContainsKey('g')) {
        $VimExecutable = 'gvim.exe'
        if ( $PSBoundParameters.ContainsKey('Arguments') -and ($PSBoundParameters['Arguments'] -match '--nofork') ) {
            $NoFork = $true
        }
        else {
            $NoFork = $false
        }
    } else {
        $VimExecutable = 'vim.exe'
        $NoFork = $true
    }
    if ( $VimCommand = Get-Command -CommandType Application -Name $VimPath `
            -ErrorAction Ignore
    ) {
        if ($VimCommand.Extension -eq '.bat') {
            $Pattern = @( '^set VIM_EXE_DIR=', '^"%VIM_EXE_DIR%\\[a-zA-Z].*\.exe')
            $VimCommand = $VimCommand | Get-Content |
            Select-String -Pattern $Pattern

            $Env:VIM_EXE_DIR = ($VimCommand -split '=')[1]

            $VimVersion = Split-Path $Env:VIM_EXE_DIR -Leaf

            if ($Env:VIM -and (Test-Path "$Env:VIM\$VimVersion\$VimExecutable")) {
                $Env:VIM_EXE_DIR = "$Env:VIM\$VimVersion"
            }
        }
    } elseif ($Env:VIMRUNTIME -and (Test-Path "$Env:VIMRUNTIME\$VimExecutable")) {
        Write-Warning "Could not find Vim at VimPath [$VimPath]"
    } else {
        $Exception = "Could not find Vim at VimPath [$VimPath] or "
        $Exception += 'in $Env:VIMRUNTIME.'
        throw "$Exception"
    }
    if ($Env:VIMRUNTIME -and (Test-Path "$Env:VIMRUNTIME\$VimExecutable")) {
        $Env:VIM_EXE_DIR = "$Env:VIMRUNTIME"
    }

    $VimCommand = Join-Path $Env:VIM_EXE_DIR $VimExecutable

    $Path = (Resolve-Path $Path).Path
    # http://stackoverflow.com/questions/8761888/powershell-capturing-standard-out-and-error-with-start-process
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $VimCommand
    $Command = $VimCommand
    $pinfo.CreateNoWindow = $NoWindow
    $pinfo.RedirectStandardError = $RedirectStandardError
    $pinfo.RedirectStandardOutput = $RedirectStandardOutput
    $pinfo.UseShellExecute = $UseShellExecute
    $pinfo.WorkingDirectory = $Path
    if ($PSBoundParameters.ContainsKey('Arguments')) {
        $pinfo.Arguments = $Arguments
        $Command = "$Command $Arguments"
    }
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $null = $p.Start()
    if ( $NoFork ) { $p.WaitForExit() }
    if ($Quiet) {
        return
    } else {
        #there was a newline in output...
        if ($null -ne $p.StandardOutput -and (
                $stdout = $p.StandardOutput.ReadToEnd())
        ) {
            if ($split) {
                $stdout = $stdout -split "`n"  | Where-Object { $_ }
            }
            $stdout = foreach ($item in @($stdout)) {
                # $item.trim()
                $item
            }
        }
        if ($null -ne $p.StandardError -and (
                $stderr = $p.StandardError.ReadToEnd())
        ) {
            if ($split) {
                $stderr = $stderr -split "`n" | Where-Object { $_ }
            }
            $stderr = foreach ($item in @($stderr)) {
                # $item.trim()
                $item
            }
        }

        if ($Raw) {
            [pscustomobject]@{
                Command = $Command
                Output  = $stdout
                Error   = $stderr
            }
        } else {
            if ($stdout) {
                $stdout
            }
            if ($stderr) {
                foreach ($errLine in $stderr) {
                    # Write-Error $errLine.trim()
                    Write-Error $errLine
                }
            }
        }
    }
}
