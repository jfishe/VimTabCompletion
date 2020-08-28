. $PSScriptRoot\Shared.ps1

Describe "Vim TabExpansion Tests" {
    Context "Vim OPTIONS TabExpansion Tests" {
        It "Tab completes all long options" {
            $result = & $module TabExpansion 'vim --' ' '
            $result.CompletionText -contains '--' |
            Should -Be $true
            $result.CompletionText -contains '--clean' |
            Should -Be $true
            $result.CompletionText -contains '--cmd' |
            Should -Be $true
            $result.CompletionText -contains '--help' |
            Should -Be $true
            $result.CompletionText -contains '--literal' |
            Should -Be $true
            $result.CompletionText -contains '--nofork' |
            Should -Be $true

            if ($IsWindows) {
                $result.CompletionText -contains '--windowid' |
                Should -Be $true
            } else {
                $result.CompletionText -contains '--windowid' |
                Should -Be $false
            }

            $result.CompletionText -contains '--noplugin' |
            Should -Be $true
            $result.CompletionText -contains '--not-a-term' |
            Should -Be $true
            $result.CompletionText -contains '--remote' |
            Should -Be $true
            $result.CompletionText -contains '--remote-expr' |
            Should -Be $true
            $result.CompletionText -contains '--remote-send' |
            Should -Be $true
            $result.CompletionText -contains '--remote-silent' |
            Should -Be $true
            $result.CompletionText -contains '--remote-tab' |
            Should -Be $true
            $result.CompletionText -contains '--remote-tab-silent' |
            Should -Be $true
            $result.CompletionText -contains '--remote-tab-wait' |
            Should -Be $true
            $result.CompletionText -contains '--remote-tab-wait-silent' |
            Should -Be $true
            $result.CompletionText -contains '--remote-wait' |
            Should -Be $true
            $result.CompletionText -contains '--remote-wait-silent' |
            Should -Be $true
            $result.CompletionText -contains '--serverlist' |
            Should -Be $true
            $result.CompletionText -contains '--servername' |
            Should -Be $true
            $result.CompletionText -contains '--startuptime' |
            Should -Be $true
            $result.CompletionText -contains '--ttyfail' |
            Should -Be $true
            $result.CompletionText -contains '--version' |
            Should -Be $true
        }
        It "Tab completes all short options" {
            $result = & $module TabExpansion 'vim -' ' '
            $result.CompletionText -ccontains '-' |
            Should -Be $true
            $result.CompletionText -ccontains '-A' |
            Should -Be $true
            $result.CompletionText -ccontains '-b' |
            Should -Be $true
            $result.CompletionText -ccontains '-c' |
            Should -Be $true
            $result.CompletionText -ccontains '-C' |
            Should -Be $true
            $result.CompletionText -ccontains '-D' |
            Should -Be $true
            $result.CompletionText -ccontains '-e' |
            Should -Be $true
            $result.CompletionText -ccontains '-E' |
            Should -Be $true
            $result.CompletionText -ccontains '-f' |
            Should -Be $true
            $result.CompletionText -ccontains '-F' |
            Should -Be $true
            $result.CompletionText -ccontains '-h' |
            Should -Be $true
            $result.CompletionText -ccontains '-H' |
            Should -Be $true
            $result.CompletionText -ccontains '-i' |
            Should -Be $true
            $result.CompletionText -ccontains '-l' |
            Should -Be $true
            $result.CompletionText -ccontains '-L' |
            Should -Be $true
            $result.CompletionText -ccontains '-m' |
            Should -Be $true
            $result.CompletionText -ccontains '-M' |
            Should -Be $true
            $result.CompletionText -ccontains '-n' |
            Should -Be $true
            $result.CompletionText -ccontains '-N' |
            Should -Be $true
            $result.CompletionText -ccontains '-o' |
            Should -Be $true
            $result.CompletionText -ccontains '-O' |
            Should -Be $true
            $result.CompletionText -ccontains '-p' |
            Should -Be $true
            $result.CompletionText -ccontains '-q' |
            Should -Be $true
            $result.CompletionText -ccontains '-r' |
            Should -Be $true
            $result.CompletionText -ccontains '-s' |
            Should -Be $true
            $result.CompletionText -ccontains '-S' |
            Should -Be $true
            $result.CompletionText -ccontains '-t' |
            Should -Be $true
            $result.CompletionText -ccontains '-T' |
            Should -Be $true
            $result.CompletionText -ccontains '-u' |
            Should -Be $true
            $result.CompletionText -ccontains '-U' |
            Should -Be $true

            if ($IsWindows) {
                $result.CompletionText -ccontains '-P' |
                Should -Be $true
            } else {
                $result.CompletionText -ccontains '-P' |
                Should -Be $false
            }

            $result.CompletionText -ccontains '-v' |
            Should -Be $true
            $result.CompletionText -ccontains '-V' |
            Should -Be $true
            $result.CompletionText -ccontains '-w' |
            Should -Be $true
            $result.CompletionText -ccontains '-W' |
            Should -Be $true
            $result.CompletionText -ccontains '-x' |
            Should -Be $true
            $result.CompletionText -ccontains '-y' |
            Should -Be $true
        }
    }
}
