Describe "Vim TabExpansion2 Tests $($PSVersionTable.PSVersion) $($PSVersionTable.PSEdition)" {
    Context "Vim OPTIONS TabExpansion2 Tests" {
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
            $result = & $module TabExpansion2 -inputScript 'vim --' `
                -cursorColumn 6
            $result.CompletionMatches.CompletionText |
            Should -BeExactly $BeExactly
        }
        It "Tab completes all short options" {
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
            $result = & $module TabExpansion2 -inputScript 'vim - ' `
                -cursorColumn 5
            $result.CompletionMatches.CompletionText |
            Should -BeExactly $BeExactly
        }
    }
    Context "Vim --servername TabExpansion2 Tests" {
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

        It "Vim --servername VIMTAB Column 23 completes VIMTABEXP" {
            $result = & $module TabExpansion2 `
                -inputScript 'vim --servername VIMTAB' -cursorColumn 23
            $result.CompletionMatches.CompletionText |
            Should -BeExactly 'VIMTABEXP'
        }
        It "Vim --servername VIMTAB Column 16 completes --servername" {
            $result = & $module TabExpansion2 `
                -inputScript 'vim --servername VIMTAB' -cursorColumn 16
            $result.CompletionMatches.CompletionText |
            Should -BeExactly '--servername'
        }
        It "Vim --servername VIMTAB Column 17 completes VIMTABEXP" {
            $result = & $module TabExpansion2 `
                -inputScript 'vim --servername VIMTAB' -cursorColumn 17
            $result.CompletionMatches.CompletionText |
            Should -Contain 'VIMTABEXP'
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
    Context "Vim -rL without swapfile TabExpansion2 Tests" {
        It "-r Tab completes nothing" {
            $result = & $module TabExpansion2 `
                -inputScript 'vim -r ' -cursorColumn 7
            $result.CompletionMatches.CompletionText |
            Should -BeExactly ' '
        }
        It "-L Tab completes nothing" {
            $result = & $module TabExpansion2 `
                -inputScript 'vim -L ' -cursorColumn 7
            $result.CompletionMatches.CompletionText |
            Should -BeExactly ' '
        }
    }
    Context "Vim -rL TabExpansion2 Tests" {
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
            $result = & $module TabExpansion2 `
                -inputScript 'vim -r ' -cursorColumn 7
            $result.CompletionMatches.CompletionText |
            ForEach-Object -Process {
                $_ -match "$TestFile.swp"
            } |
            Should -Contain $true
        }
        It "-L Tab completes $TestFile.swp" {
            $result = & $module TabExpansion2 `
                -inputScript 'vim -L ' -cursorColumn 7
            $result.CompletionMatches.CompletionText |
            ForEach-Object -Process {
                $_ -match "$TestFile.swp"
            } |
            Should -Contain $true
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
    Context "Vim -t without tags TabExpansion2 Tests" {
        BeforeAll {
            $TestPath = "TestDrive:\"
            Push-Location $TestPath
        }
        It "Vim -t completes nothing" {
            $result = & $module TabExpansion2 `
                -inputScript 'vim -t ' -cursorColumn 7
            $CompletionText = @(
                ' '
            )
            $result.CompletionMatches.CompletionText |
            Should -BeExactly $CompletionText
        }
        It "Vim -t Argument only completes nothing" {
            $result = & $module TabExpansion2 `
                -inputScript 'vim -t Argument' -cursorColumn 15
            $CompletionText = ' '
            $result.CompletionMatches.CompletionText |
            Should -BeExactly $CompletionText
        }
        AfterAll {
            Pop-Location
        }
    }
    Context "Vim -t tag TabExpansion2 Tests" {
        BeforeAll {
            $TestPath = "TestDrive:\tags"
            Copy-Item $PSScriptRoot\VimTags $TestPath
            Push-Location ((Get-Item $TestPath).DirectoryName)
        }
        It "Vim -t completes tags" {
            $result = & $module TabExpansion2 `
                -inputScript 'vim -t ' -cursorColumn 7
            $CompletionText = @(
                'ArgumentList',
                'Building',
                'ConfirmPreference',
                'DeployParams',
                'Destination'
            )
            $result.CompletionMatches.CompletionText |
            Should -BeExactly $CompletionText
        }
        It "Vim -t Argument only completes ArgumentList" {
            $result = & $module TabExpansion2 `
                -inputScript 'vim -t Argument' -cursorColumn 15
            $CompletionText = 'ArgumentList'
            $result.CompletionMatches.CompletionText |
            Should -BeExactly $CompletionText
        }
        AfterAll {
            Pop-Location
        }
    }
    Context "Vim -uU TabExpansion2 Tests" {
        It "Vim -u completes NONE NORC DEFAULTS ProviderItem ProviderContainer" {
            $result = & $module TabExpansion2 `
                -inputScript 'vim -u ' -cursorColumn 7
            $CompletionText = @(
                'DEFAULTS',
                'NONE',
                'NORC'
            )
            $result.CompletionMatches |
            Where-Object -Property ResultType -eq 'ParameterValue' |
            Select-Object -ExpandProperty CompletionText |
            Should -BeExactly $CompletionText

            $ResultType = @(
                'ProviderItem',
                'ProviderContainer'
            )
            $result.CompletionMatches |
            Where-Object -Property ResultType -ne 'ParameterValue' |
            Select-Object -ExpandProperty ResultType |
            Should -BeIn $ResultType
        }
        It "Vim -U completes NONE NORC ProviderItem ProviderContainer" {
            $result = & $module TabExpansion2 `
                -inputScript 'vim -U ' -cursorColumn 7

            $CompletionText = @(
                'NONE',
                'NORC'
            )
            $result.CompletionMatches |
            Where-Object -Property ResultType -eq 'ParameterValue' |
            Select-Object -ExpandProperty CompletionText |
            Should -BeExactly $CompletionText

            $ResultType = @(
                'ProviderItem',
                'ProviderContainer'
            )
            $result.CompletionMatches |
            Where-Object -Property ResultType -ne 'ParameterValue' |
            Select-Object -ExpandProperty ResultType |
            Should -BeIn $ResultType
        }
    }
    Context "Vim -oOp TabExpansion2 Tests" {
        It "Vim -o[N] completes N=1..4" {
            $result = & $module TabExpansion2 `
                -inputScript 'vim -o' -cursorColumn 6

            $BeExactly = (1..4).ForEach( { "-o$_" }) + '-o'
            $result.CompletionMatches.CompletionText |
            Should -BeExactly $BeExactly
        }
        It "Vim -O[N] completes N=1..4" {
            $result = & $module TabExpansion2 `
                -inputScript 'vim -O' -cursorColumn 6

            $BeExactly = (1..4).ForEach( { "-O$_" }) + '-O'
            $result.CompletionMatches.CompletionText |
            Should -BeExactly $BeExactly
        }
        It "Vim -p[N] completes N=1..4" {
            $result = & $module TabExpansion2 `
                -inputScript 'vim -p' -cursorColumn 6

            $BeExactly = (1..4).ForEach( { "-p$_" }) + '-p'
            $result.CompletionMatches.CompletionText |
            Should -BeExactly $BeExactly
        }
    }
    Context "Vim -V TabExpansion2 Tests" {
        It "Vim -V[N] completes N=0 1 2 4 5 8 9 11 12 13 14 15" {
            $result = & $module TabExpansion2 `
                -inputScript 'vim -V' -cursorColumn 6
            $BeExactly = @(0, 1, 2, 4, 5, 8, 9, 11, 12, 13, 14, 15)
            $BeExactly = $BeExactly.ForEach( { "-V$_" }) + '-V'
            $result.CompletionMatches.CompletionText |
            Should -BeExactly $BeExactly
        }
        It "Vim -V10 completes ProviderItem ProviderContainer" {
            $result = & $module TabExpansion2 `
                -inputScript 'vim -V10' -cursorColumn 8

            $ResultType = @(
                'ProviderItem',
                'ProviderContainer'
            )
            $result.CompletionMatches.ResultType |
            Should -BeIn $ResultType
        }
        It "Vim -V0 completes ParameterName ProviderItem ProviderContainer" {
            $result = & $module TabExpansion2 `
                -inputScript 'vim -V0' -cursorColumn 7

            $ResultType = @(
                'ParameterName',
                'ProviderItem',
                'ProviderContainer'
            )
            $result.CompletionMatches.ResultType |
            Should -BeIn $ResultType
        }
        It "Vim -V10'C:\' Column 13 completes -V10'*'" {
            $result = & $module TabExpansion2 `
                -inputScript 'vim -V10''C:\''' -cursorColumn 13

            $result.CompletionMatches.CompletionText |
            Should -MatchExactly '^-V10''.*''$'

            $ResultType = @(
                'ProviderItem',
                'ProviderContainer'
            )
            $result.CompletionMatches.ResultType |
            Should -BeIn $ResultType
        }
    }
}
