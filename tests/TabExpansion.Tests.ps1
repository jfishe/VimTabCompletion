Describe "Vim TabExpansion Tests" {
    Context "Vim OPTIONS TabExpansion Tests" {
        BeforeAll {
            . $PSScriptRoot\Shared.ps1
        }
        It "Tab completes all long options" {
            $result = & $module TabExpansion 'vim --' ' '
            $result.CompletionText -contains '--' |
            Should -BeTrue
            $result.CompletionText -contains '--clean' |
            Should -BeTrue
            $result.CompletionText -contains '--cmd' |
            Should -BeTrue
            $result.CompletionText -contains '--help' |
            Should -BeTrue
            $result.CompletionText -contains '--literal' |
            Should -BeTrue
            $result.CompletionText -contains '--nofork' |
            Should -BeTrue

            if ($IsWindows) {
                $result.CompletionText -contains '--windowid' |
                Should -BeTrue
            } else {
                $result.CompletionText -contains '--windowid' |
                Should -BeFalse
            }

            $result.CompletionText -contains '--noplugin' |
            Should -BeTrue
            $result.CompletionText -contains '--not-a-term' |
            Should -BeTrue
            $result.CompletionText -contains '--remote' |
            Should -BeTrue
            $result.CompletionText -contains '--remote-expr' |
            Should -BeTrue
            $result.CompletionText -contains '--remote-send' |
            Should -BeTrue
            $result.CompletionText -contains '--remote-silent' |
            Should -BeTrue
            $result.CompletionText -contains '--remote-tab' |
            Should -BeTrue
            $result.CompletionText -contains '--remote-tab-silent' |
            Should -BeTrue
            $result.CompletionText -contains '--remote-tab-wait' |
            Should -BeTrue
            $result.CompletionText -contains '--remote-tab-wait-silent' |
            Should -BeTrue
            $result.CompletionText -contains '--remote-wait' |
            Should -BeTrue
            $result.CompletionText -contains '--remote-wait-silent' |
            Should -BeTrue
            $result.CompletionText -contains '--serverlist' |
            Should -BeTrue
            $result.CompletionText -contains '--servername' |
            Should -BeTrue
            $result.CompletionText -contains '--startuptime' |
            Should -BeTrue
            $result.CompletionText -contains '--ttyfail' |
            Should -BeTrue
            $result.CompletionText -contains '--version' |
            Should -BeTrue
        }
        It "Tab completes all short options" {
            $result = & $module TabExpansion 'vim -' ' '
            $result.CompletionText -ccontains '-' |
            Should -BeTrue
            $result.CompletionText -ccontains '-A' |
            Should -BeTrue
            $result.CompletionText -ccontains '-b' |
            Should -BeTrue
            $result.CompletionText -ccontains '-c' |
            Should -BeTrue
            $result.CompletionText -ccontains '-C' |
            Should -BeTrue
            $result.CompletionText -ccontains '-D' |
            Should -BeTrue
            $result.CompletionText -ccontains '-e' |
            Should -BeTrue
            $result.CompletionText -ccontains '-E' |
            Should -BeTrue
            $result.CompletionText -ccontains '-f' |
            Should -BeTrue
            $result.CompletionText -ccontains '-F' |
            Should -BeTrue
            $result.CompletionText -ccontains '-h' |
            Should -BeTrue
            $result.CompletionText -ccontains '-H' |
            Should -BeTrue
            $result.CompletionText -ccontains '-i' |
            Should -BeTrue
            $result.CompletionText -ccontains '-l' |
            Should -BeTrue
            $result.CompletionText -ccontains '-L' |
            Should -BeTrue
            $result.CompletionText -ccontains '-m' |
            Should -BeTrue
            $result.CompletionText -ccontains '-M' |
            Should -BeTrue
            $result.CompletionText -ccontains '-n' |
            Should -BeTrue
            $result.CompletionText -ccontains '-N' |
            Should -BeTrue
            $result.CompletionText -ccontains '-o' |
            Should -BeTrue
            $result.CompletionText -ccontains '-O' |
            Should -BeTrue
            $result.CompletionText -ccontains '-p' |
            Should -BeTrue
            $result.CompletionText -ccontains '-q' |
            Should -BeTrue
            $result.CompletionText -ccontains '-r' |
            Should -BeTrue
            $result.CompletionText -ccontains '-s' |
            Should -BeTrue
            $result.CompletionText -ccontains '-S' |
            Should -BeTrue
            $result.CompletionText -ccontains '-t' |
            Should -BeTrue
            $result.CompletionText -ccontains '-T' |
            Should -BeTrue
            $result.CompletionText -ccontains '-u' |
            Should -BeTrue
            $result.CompletionText -ccontains '-U' |
            Should -BeTrue

            if ($IsWindows) {
                $result.CompletionText -ccontains '-P' |
                Should -BeTrue
            } else {
                $result.CompletionText -ccontains '-P' |
                Should -BeFalse
            }

            $result.CompletionText -ccontains '-v' |
            Should -BeTrue
            $result.CompletionText -ccontains '-V' |
            Should -BeTrue
            $result.CompletionText -ccontains '-w' |
            Should -BeTrue
            $result.CompletionText -ccontains '-W' |
            Should -BeTrue
            $result.CompletionText -ccontains '-x' |
            Should -BeTrue
            $result.CompletionText -ccontains '-y' |
            Should -BeTrue
        }
    }
    Context "Vim --servername TabExpansion Tests" {
        BeforeAll {
            # Start Vim server
            $ArgumentList = @('--clean', '--servername', 'VIMTABEXP')
            [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '$VimProcess used in AfterAll block.')]
            $VimProcess = Start-Process -FilePath $StartVim `
                -ArgumentList $ArgumentList  -PassThru -WindowStyle Minimized `
                -Verbose
        }

        It "Tab completes --servername <space>" {
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
                '--remote-send', '<C-\><C-N>:qa!<CR>'
            )
            Start-Process -FilePath $StartVim `
                -ArgumentList $ArgumentList  -PassThru `
                -WindowStyle Minimized -Verbose
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
            Start-Process -FilePath $StartVim `
                -ArgumentList $ArgumentList  -PassThru -WindowStyle Minimized `
                -Verbose
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
                '--remote-send', '<C-\><C-N>:qa!<CR>'
            )
            Start-Process -FilePath $StartVim `
                -ArgumentList $ArgumentList  -PassThru `
                -WindowStyle Minimized -Verbose
        }
    }

    Context "Vim -t tag TabExpansion Tests" {
        BeforeAll {
            $TestPath = "TestDrive:\"
            Push-Location $TestPath
            $TestPath = Join-Path $TestPath 'tags'
            Set-Content -Path $TestPath -Value $Tags -Encoding utf8
        }
        It "Vim -t completes tags" {
            $result = & $module TabExpansion 'vim -t ' ' '
            $result.CompletionText -ccontains 'ArgumentList' |
            Should -BeTrue
            $result.CompletionText -ccontains 'Building' |
            Should -BeTrue
            $result.CompletionText -ccontains 'ConfirmPreference' |
            Should -BeTrue
            $result.CompletionText -ccontains 'DeployParams' |
            Should -BeTrue
            $result.CompletionText -ccontains 'Destination' |
            Should -BeTrue
        }
        It "Vim -t Argument only completes ArgumentList" {
            $result = & $module TabExpansion 'vim -t Argument' ' '
            $result.CompletionText -ccontains 'ArgumentList' |
            Should -BeTrue
            $result.CompletionText -ccontains 'Building' |
            Should -BeFalse
        }
        AfterAll {
            Pop-Location
        }
    }
    Context "Vim -T terminal TabExpansion Tests" {
        It "Vim -T <space> completes internal terminals" {
            $result = & $module TabExpansion 'vim -T ' ' '
            $result.CompletionText -ccontains 'win32' |
            Should -BeTrue
        }
        It "Vim -T completes nothing" {
            $result = & $module TabExpansion 'vim -T' ' '
            $result | Should -BeNullOrEmpty
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
