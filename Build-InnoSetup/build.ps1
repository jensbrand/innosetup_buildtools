[CmdletBinding()]
param()

# For more information on the Azure DevOps Task SDK:
# https://github.com/Microsoft/vsts-task-lib
Trace-VstsEnteringInvocation $MyInvocation


[string]$version = Get-VstsInput -Name version
[string]$file = Get-VstsInput -Name file

$toolDirectory = Join-Path $env:AGENT_TOOLSDIRECTORY "\InnoSetup\$version\"
$innoCompiler = $toolDirectory + "ISCC.exe"

if (!(test-path -path $innoCompiler))
{
    throw "Inno Setup not installed!"
}

$extn = [IO.Path]::GetExtension($file)
if ($extn  -ne ".iss")
{
    throw "Not .iss file extension!"
}

Write-Host "Building..."

Write-Host "Compiler  =>" $innoCompiler
Write-Host "File .iss =>" $file

Start-Process -FilePath $innoCompiler $file -Wait -RedirectStandardOutput stdout.txt -RedirectStandardError stderr.txt

$(Get-Content stdout.txt)

$erro = $(Get-Content stderr.txt)
if ($erro){
    throw $erro
}	
Write-Host "Process completed successfully!"-ForegroundColor Green
