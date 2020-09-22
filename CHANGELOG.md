# Change Log

## [1.3.0](https://github.com/jfishe/VimTabCompletion/compare/1.2.1...1.3.0)
<a name="1.3.0"></a>

> 2020-09-20

### Build

* !deploy 1.3.0
* **appveyor:** enable interactive console

### Fix

* **VimCompletion:** do not complete files for -rLt

### Test

* fix --servername results
* **TabExpansion:** wait vim server start
* **appveyor:** add start Responding & HasExited


## [1.2.1](https://github.com/jfishe/VimTabCompletion/compare/1.2.0...1.2.1)
<a name="1.2.1"></a>

> 2020-09-19

### Build

* **appveyor:** add PS 5 test skip docs|chore

### Docs

* **README:** fix ctags warning
* **README:** !deploy 1.2.1 add ctags dependency


## [1.2.0](https://github.com/jfishe/VimTabCompletion/compare/1.1.0...1.2.0)
<a name="1.2.0"></a>

> 2020-09-19

### Build

* **appveyor:** !deploy 1.2.0
* **appveyor:** start separate pwsh
* **appveyor:** output $Error
* **appveyor:** !deploy 1.2.0 refreshenv
* **appveyor:** add NugetApiKey
* **psd1:** !deploy 1.2.0

### Chore

* **appveyor:** cinst ctags
* **appveyor:** enable rdp
* **gitignore:** add tags*

### Docs

* **Invoke-Vim:** reorder parameters
* **about:** add Invoke-Vim

### Feat

* enable -r on PS5 and higher
* **Invoke-Vim:** use System.Diagnostics.Process

### Fix

* **TabExpansion:** remove Invoke-Vim

### Refactor

* **Invoke-Vim:** reorder Parameters so ParameterSetNames are close together.

### Test

* **Invoke-Vim:** ignore remove environment var
* **appveyor:** fix quotes & Start race


## [1.1.0](https://github.com/jfishe/VimTabCompletion/compare/1.0.0...1.1.0)
<a name="1.1.0"></a>

> 2020-09-05

### Docs

* **about:** update PS 5 not implemented !deploy
* **about:** remove $PSVersionTable.Platform

### Feat

* add TabExpansion Windows PowerShell

### Fix

* **Get-VimOption:** add IsWindows
* **Get-VimSwapFile:** add missing path separator
* **IsWindows:** add missing IsOS variables PS 5.x
* **TabExpansion2:** re-order ps1 loading

### Test

* PS 5 corrupts here-string tags
* convert TabExpansion tests to TabExpansion2
* **Shared:** fix moduleManifestPath resolution
* **TabExpansion:** add -rLVuUtoOpT
* **TabExpansion:** add --servername
* **TabExpansion:** add all long and short options


## [1.0.0](https://github.com/jfishe/VimTabCompletion/compare/0.0.1...1.0.0)
<a name="1.0.0"></a>

> 2020-08-08

### Build

* add TabExpansionPlusPlus
* **PSDepend:** update PSDependVersion
* **PSDepend:** update versions
* **gutctags:** exclude output/
* **tests:** set Pester Path

### Chore

* gitignore _build_dependicies_
* **ctags:** add gutctags

### Docs

* update help for each function !deploy
* add Invoke-Git License
* **Get-VimArguments:** update help
* **README:** update local deploy

### Feat

* add servername completion with serverlist
* cleanup Get-VimOption ToolTips
* **Get-VimOption:** add gui options
* **Get-VimSwapFile:** add completer for swapfile
* **VimCompletion:** add -t tag completion
* **VimCompletion:** complete -V[N][fname]
* **VimCompletion:** complete files after Param
* **VimCompletion:** add -u & -U completion
* **VimCompletion:** add --remote <files>
* **VimCompletion:** add -[oOp][N]
* **VimCompletion:** list swap for -r|-L
* **VimCompletion:** add -T
* **VimCompletion:** define evim Command
* **VimTabCompletion:** complete -r|-L swapfiles

### Fix

* split AST Extent for -r|-L
* **Get-VimArguments:** copy zsh arguments
* **Get-VimArguments:** ForEach-Object return
* **Get-VimArguments:** add missing options --, +
* **Get-VimOption:** remove trailing spaces
* **Get-VimSwapFile:** split line capture [-1]
* **ParameterValue:** determine previousWord

### Refactor

* use New-TabItem for -r and -L
* move CompletionResult to New-TabItem
* use Get-VimOption build ToolTip
* rename Get-VimArguments
* rename Get-VimArguments
* replace Argument with CompletionText
* remove Get-VimChildItem
* move Get-VimArguments to private
* **VimCompletion:** add Get-VimChildItem


## 0.0.1
<a name="0.0.1"></a>

> 2020-06-28

### Build

* add tabexpansionplusplus dependency !deploy
* **git:** ignore output

### Chore

* remove templates

### Feat

* add argumentcompleter for vim

