Describe "Vim TabExpansion Tests" {
    Context "Vim OPTIONS TabExpansion Tests" {
        BeforeAll {
            . $PSScriptRoot\Shared.ps1
        }
        It "Tab completes all long options" {
            $BeExactly = @(
                '--',
                '--clean',
                '--cmd',
                '--help',
                '--literal',
                '--nofork',
                '--noplugin',
                '--not-a-term',
                '--remote',
                '--remote-expr',
                '--remote-send',
                '--remote-silent',
                '--remote-tab',
                '--remote-tab-silent',
                '--remote-tab-wait',
                '--remote-tab-wait-silent',
                '--remote-wait',
                '--remote-wait-silent',
                '--serverlist',
                '--servername',
                '--startuptime',
                '--ttyfail',
                '--version'
            )
            if ($IsWindows) {
                $BeExactly += '--windowid'
            }
            $result = & $module TabExpansion 'vim --' ' '
            $result.CompletionText | Should -BeExactly $BeExactly
        }
        It "Tab completes all short options" {
            # TODO Decide whether to include long options with short.
            $BeExactly = @(
                '-',
                '--',
                '-A',
                '-b',
                '-c',
                '-C',
                '--clean',
                '--cmd',
                '-D',
                '-e',
                '-E',
                '-f',
                '-F',
                '-h',
                '-H',
                '--help',
                '-i',
                '-l',
                '-L',
                '--literal',
                '-m',
                '-M',
                '-n',
                '-N',
                '--nofork',
                '--noplugin',
                '--not-a-term',
                '-o',
                '-O',
                '-p',
                '-P',
                '-q',
                '-r',
                '--remote',
                '--remote-expr',
                '--remote-send',
                '--remote-silent',
                '--remote-tab',
                '--remote-tab-silent',
                '--remote-tab-wait',
                '--remote-tab-wait-silent',
                '--remote-wait',
                '--remote-wait-silent',
                '-s',
                '-S',
                '--serverlist',
                '--servername',
                '--startuptime',
                '-t',
                '--ttyfail',
                '-u',
                '-U',
                '-v',
                '-V',
                '--version',
                '-w',
                '-W'
            )
            if ($IsWindows) {
                $BeExactly += '--windowid'
            }
            $BeExactly += @(
                '-x',
                '-y'
            )
            $result = & $module TabExpansion 'vim -' ' '
            $result.CompletionText |
            Should -BeExactly $BeExactly
        }
    }
    Context "Vim --servername TabExpansion Tests" {
        BeforeAll {
            # Start Vim server
            $ArgumentList = @('--clean', '--servername', 'VIMTABEXP')
            $VimProcess = Start-Process -FilePath $StartVim `
                -ArgumentList $ArgumentList  -PassThru -WindowStyle Minimized `
                -Verbose
            while (-not ($VimProcess.Responding)) {
                Start-Sleep -Milliseconds 500 -Verbose
            }
        }

        It "Tab --servername <space> completes VIMTABEXP" {
            $result = & $module TabExpansion 'vim --servername ' ' '
            $result.CompletionText -ccontains 'VIMTABEXP' |
            Should -BeTrue
        }
        It "Tab does not complete --servername" {
            $result = & $module TabExpansion 'vim --servername' ' '
            $result.CompletionText -ccontains 'VIMTABEXP' |
            Should -BeFalse
        }

        AfterAll {
            # Shutdown Vim server
            $ArgumentList = @( $ArgumentList[1], $ArgumentList[2],
                '--remote-send', '''<C-\><C-N>:qa!<CR>'''
            )
            Start-Process -FilePath $StartVim `
                -ArgumentList $ArgumentList  `
                -WindowStyle Minimized -Verbose
            while (-not ($VimProcess.HasExited)) {
                Start-Sleep -Milliseconds 500 -Verbose
            }
        }
    }
    Context "Vim -rL TabExpansion Tests" {
        BeforeAll {
            $TestFile = "$(Get-Random).txt"
            $TestPath = "TestDrive:\$TestFile"
            # Start Vim server
            $ArgumentList = @('--clean', '--servername', 'VIMTABEXP',
                "$TestPath"
            )
            $VimProcess = Start-Process -FilePath $StartVim `
                -ArgumentList $ArgumentList  -PassThru -WindowStyle Minimized `
                -Verbose
            while (-not ($VimProcess.Responding)) {
                Start-Sleep -Milliseconds 500 -Verbose
            }
        }

        It "-r Tab completes $TestFile.swp" {
            $result = & $module TabExpansion 'vim -r ' ' ' |
            Select-Object -ExpandProperty CompletionText |
            ForEach-Object -Process {
                $_ -match "$TestFile.swp"
            }
            $result -contains $true |
            Should -BeTrue
        }
        It "-L Tab completes $TestFile.swp" {
            $result = & $module TabExpansion 'vim -L ' ' ' |
            Select-Object -ExpandProperty CompletionText |
            ForEach-Object -Process {
                $_ -match "$TestFile.swp"
            }
            $result -contains $true |
            Should -BeTrue
        }

        AfterAll {
            # Shutdown Vim server
            $ArgumentList = @( $ArgumentList[1], $ArgumentList[2],
                '--remote-send', '''<C-\><C-N>:qa!<CR>'''
            )
            Start-Process -FilePath $StartVim `
                -ArgumentList $ArgumentList  `
                -WindowStyle Minimized -Verbose
            while (-not ($VimProcess.HasExited)) {
                Start-Sleep -Milliseconds 500 -Verbose
            }
        }
    }

    Context "Vim -t tag TabExpansion Tests" {
        BeforeAll {
            $TestPath = "TestDrive:\tags"
            Copy-Item $PSScriptRoot\VimTags $TestPath
            Push-Location ((Get-Item $TestPath).DirectoryName)
        }
        It "Vim -t completes tags" {
            $result = & $module TabExpansion 'vim -t ' ' '
                $CompletionText = @(
                    'ArgumentList' ,
                    'Building' ,
                    'ConfirmPreference' ,
                    'DeployParams' ,
                    'Destination'
                )
                $result.CompletionText |
                Should -BeExactly $CompletionText
        }
        It "Vim -t Argument only completes ArgumentList" {
            $result = & $module TabExpansion 'vim -t Argument' ' '
                $CompletionText = 'ArgumentList'
                $result.CompletionText |
                Should -BeExactly $CompletionText
        }
        AfterAll {
            Pop-Location
        }
    }
    Context "Vim -uU TabExpansion Tests" {
        It "Vim -u completes NONE NORC DEFAULTS ProviderItem ProviderContainer" {
            $result = & $module TabExpansion 'vim -u ' ' '
            $result.CompletionText -ccontains 'NONE' |
            Should -BeTrue
            $result.CompletionText -ccontains 'NORC' |
            Should -BeTrue
            $result.CompletionText -ccontains 'DEFAULTS' |
            Should -BeTrue
            $result.ResultType -contains 'ProviderItem' |
            Should -BeTrue
            $result.ResultType -contains 'ProviderContainer' |
            Should -BeTrue
        }
        It "Vim -U completes NONE NORC ProviderItem ProviderContainer" {
            $result = & $module TabExpansion 'vim -U ' ' '
            $result.CompletionText -ccontains 'NONE' |
            Should -BeTrue
            $result.CompletionText -ccontains 'NORC' |
            Should -BeTrue
            $result.CompletionText -ccontains 'DEFAULTS' |
            Should -BeFalse
            $result.ResultType -contains 'ProviderItem' |
            Should -BeTrue
            $result.ResultType -contains 'ProviderContainer' |
            Should -BeTrue
        }
    }
    Context "Vim -oOp TabExpansion Tests" {
        It "Vim -o[N] completes N=1..4" {
            $result = & $module TabExpansion 'vim -o' ' '
            $BeExactly = (1..4).ForEach( { "-o$_" }) + '-o'
            $result.CompletionText | Should -BeExactly $BeExactly
        }
        It "Vim -O[N] completes N=1..4" {
            $result = & $module TabExpansion 'vim -O' ' '
            $BeExactly = (1..4).ForEach( { "-O$_" }) + '-O'
            $result.CompletionText | Should -BeExactly $BeExactly
        }
        It "Vim -p[N] completes N=1..4" {
            $result = & $module TabExpansion 'vim -p' ' '
            $BeExactly = (1..4).ForEach( { "-p$_" }) + '-p'
            $result.CompletionText | Should -BeExactly $BeExactly
        }
    }
    Context "Vim -V TabExpansion Tests" {
        It "Vim -V[N] completes N=0 1 2 4 5 8 9 11 12 13 14 15" {
            $result = & $module TabExpansion 'vim -V' ' '
            $BeExactly = @(0, 1, 2, 4, 5, 8, 9, 11, 12, 13, 14, 15)
            $BeExactly = $BeExactly.ForEach( { "-V$_" }) + '-V'
            $result.CompletionText | Should -BeExactly $BeExactly
        }
        It "Vim -V10 completes ProviderItem ProviderContainer" {
            $result = & $module TabExpansion 'vim -V10' ' '
            $result.ResultType -contains 'ProviderItem' |
            Should -BeTrue
            $result.ResultType -contains 'ProviderContainer' |
            Should -BeTrue
        }
        It "Vim -V0 completes ProviderItem ProviderContainer" {
            $result = & $module TabExpansion 'vim -V0' ' '
            $result.ResultType -contains 'ProviderItem' |
            Should -BeTrue
            $result.ResultType -contains 'ProviderContainer' |
            Should -BeTrue
        }
    }
}
