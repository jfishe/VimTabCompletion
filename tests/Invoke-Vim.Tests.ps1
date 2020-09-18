Describe "Invoke-Vim Tests" {
    BeforeAll {
        . $PSScriptRoot\Shared.ps1

        # Get a value for $Env:VIMRUNTIME
        $VimRunTime = Get-Command -CommandType Application -Name 'vim.bat'
        $Pattern = @( '^set VIM_EXE_DIR=', '^"%VIM_EXE_DIR%\\[a-zA-Z].*\.exe')
        $VimRunTime = $VimRunTime | Get-Content |
        Select-String -Pattern $Pattern
        $VimRunTime = ($VimRunTime -split '=')[1]
        $VimVersion = Split-Path $VimRunTime -Leaf
        $VIM = Split-Path $VimRunTime -Parent
    }
    AfterAll {
        #Remove environment variables
        Remove-Item Env:\VIMRUNTIME -Force -ErrorAction Ignore
        Remove-Item Env:\VIM_EXE_DIR -Force -ErrorAction Ignore
        Remove-Item Env:\VIM  -Force -ErrorAction Ignore
    }
    BeforeEach {
        #Remove environment variables
        Remove-Item Env:\VIMRUNTIME -Force -ErrorAction Ignore
        Remove-Item Env:\VIM_EXE_DIR -Force -ErrorAction Ignore
        Remove-Item Env:\VIM  -Force -ErrorAction Ignore
    }
    Context "Invoke-Vim -VimPath" {
        It "Invoke-Vim -VimPath 'Nowhere' throws RuntimeException" {
            $ExpectedMessage = 'Could not find Vim at VimPath [Nowhere] '
            $ExpectedMessage += 'or in $Env:VIMRUNTIME.'

            { & $module Invoke-Vim -VimPath 'Nowhere' } |
            Should -Throw -ExpectedMessage $ExpectedMessage `
                -ExceptionType ([System.Management.Automation.RuntimeException])
        }
        It '$Env:VIMRUNTIME; Invoke-Vim -VimPath ''Nowhere'' should not throw' {
            $Env:VIMRUNTIME = "$VimRunTime"

            { & $module Invoke-Vim -VimPath 'Nowhere' --cmd 'qa!' } |
            Should -Not -Throw
        }
        It '$Env:VIM; Invoke-Vim -VimPath ''vim.bat'' should not throw' {
            $Env:VIM = "$VIM"

            { & $module Invoke-Vim -VimPath 'vim.bat' --cmd 'qa!' } |
            Should -Not -Throw
        }
        It '$Env:VIM=Nowhere; Invoke-Vim -VimPath ''vim.bat'' should throw MethodInvocationException' {
            $VimLocation = "TestDrive:\vim\vim82\"
            New-Item -Path $VimLocation -ItemType Directory -Verbose
            New-Item -Path $VimLocation -Name 'vim.exe' -ItemType File -Verbose
            $Env:VIM = Split-Path $VimLocation
            Write-Warning "`$Env:VIM: $Env:VIM"
            # Copy-Item "$VimRuntime\vim.exe" $VimLocation -Verbose

            { & $module Invoke-Vim -VimPath 'vim.bat' --cmd 'qa!'} |
            Should -Throw `
                -ExceptionType ([System.Management.Automation.MethodInvocationException])
        }
    }
    Context "Invoke-Vim -g Tests" {
        It "Invoke-Vim -g should not throw" {
            { & $module Invoke-Vim -g --cmd 'qa!' } |
            Should -Not -Throw
        }
    }
}

