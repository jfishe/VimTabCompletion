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
            # Kill Vim server
            $VimProcess.Kill()
        }
    }
}
