[CmdletBinding()]
param()

# For more information on the Azure DevOps Task SDK:
# https://github.com/Microsoft/vsts-task-lib
Trace-VstsEnteringInvocation $MyInvocation

<#Lädt ein securefile vom TFS heunter#>
<#Siehe auch: https://stackoverflow.com/a/54317270/5707462#>
function Get-SecureFile {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$FileId
    )

    $secTicket = Get-VstsSecureFileTicket -Id $FileId
    $secName = Get-VstsSecureFileName -Id $FileId
    $tempDirectory = Get-VstsTaskVariable -Name "Agent.TempDirectory" -Require
    $collectionUrl = Get-VstsTaskVariable -Name "System.TeamFoundationCollectionUri" -Require
    $project = Get-VstsTaskVariable -Name "System.TeamProject" -Require
    $filePath = Join-Path $tempDirectory $secName

    $token = Get-VstsTaskVariable -Name "System.AccessToken" -Require
    $user = Get-VstsTaskVariable -Name "Build.QueuedById" -Require

    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $User, $token)))
    $headers = @{
        Authorization = ("Basic {0}" -f $base64AuthInfo)
        Accept        = "application/octet-stream"
    } 

    $url = "$($collectionUrl)$project/_apis/distributedtask/securefiles/$($FileId)?ticket=$($secTicket)&download=true&api-version=5.0-preview.1"

    try {
        $response = Invoke-WebRequest -Uri $url -Method Get -Headers $headers -OutFile $filePath
        if ($response.StatusCode -lt 300) {
            Write-Host $response
            return $filePath
        }
        else {
            Write-Host $response.StatusCode
            Write-Host $response.StatusDescription
            return ""
        }
    }
    catch {
        Write-Host $_.Exception.Response.StatusDescription
        return ""
    }

}

[string]$version = Get-VstsInput -Name version
[string]$file = Get-VstsInput -Name file
[string]$secFileId = Get-VstsInput -Name secureFileId
[string]$signCertPassword = Get-VstsInput -Name signCertPassword
[string]$timeServer = Get-VstsInput -Name timeServer
[string]$signToolName = Get-VstsInput -Name signToolName

if ([string]::IsNullOrEmpty($secFileId)) {
    Write-Host "No secure file configured"
    $configureSignTool = $false
}
else {
    $secureFilePath = Get-SecureFile -FileId $secFileId
    $configureSignTool = $true
    Write-Host "Using secure file " $secureFilePath
}


$toolDirectory = Join-Path $env:AGENT_TOOLSDIRECTORY "\InnoSetup\$version\"
$innoCompiler = $toolDirectory + "ISCC.exe"

if (!(test-path -path $innoCompiler)) {
    throw "Inno Setup not installed!"
}

$extn = [IO.Path]::GetExtension($file)
if ($extn -ne ".iss") {
    throw "Not .iss file extension!"
}

Write-Host "Building..."

Write-Host "Compiler  =>" $innoCompiler
Write-Host "File .iss =>" $file

if ($configureSignTool) {
    $signTool = [string]::Format('/S{0}="signtool.exe sign /as /fd sha256 /f $q{1}$q /p $q{2}$q /tr $q{3}$q /td sha256 $f"', $signToolName, $secureFilePath, $signCertPassword, $timeServer)

    Write-Host "Starting Inno Setup compiler: " $innoCompiler $signTool $file
    Start-Process -FilePath $innoCompiler -ArgumentList $signTool, $file -Wait -RedirectStandardOutput stdout.txt -RedirectStandardError stderr.txt
}
else {
    Write-Host "Starting Inno Setup compiler: " $innoCompiler $file
    Start-Process -FilePath $innoCompiler $file -Wait -RedirectStandardOutput stdout.txt -RedirectStandardError stderr.txt
}

$(Get-Content stdout.txt)

$erro = $(Get-Content stderr.txt)
if ($erro) {
    throw $erro
}	
Write-Host "Process completed successfully!"-ForegroundColor Green

if (-not [string]::IsNullOrEmpty($secureFilePath)) {
    Write-Host "Erasing downloaded secure file: " + $secureFilePath
    Remove-Item -Path $secureFilePath 
}
