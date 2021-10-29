$env:AGENT_TEMPDIRECTORY = "D:\test\temp"
$env:AGENT_TOOLSDIRECTORY = "D:\test\tools"
$env:INPUT_VERSION = "6.2.0"
$env:SYSTEM_CULTURE = "DE-de"


# Remove-Alias -Name Out-Default -Scope global

Import-Module .\ps_modules\VstsTaskSdk

Invoke-VstsTaskScript -ScriptBlock { . .\Install.ps1 }
