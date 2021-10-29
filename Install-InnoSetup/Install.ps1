<#
    .SYNOPSIS
    This script installs a specific version of InnoSetup at the build agent
    .DESCRIPTION
    To compile an InnoSetup script the InnoSetup Compiles has to be isntalled at the build agent. This script downloads and installs a specific version of InnoSetup
    .PARAMETER version
    The version of InnoSetup which schould be installed (see https://jrsoftware.org/isdlold.php)
    .NOTES
    Written by Jens Brand
    #>


    <#checks, if InnoSetup is already installed#>
    function Test-IfAlreadyInstalled {
        <#check if directory exists#>
       $result = (test-path -path $toolDirectory)
       
       <#Check if there are files in the directory#>
       if ($result -eq $true){
           $result = ((Get-ChildItem $toolDirectory | Measure-Object ).Count -ne 0);
       }
   
       return  $result
   }
   
   <#Downloads the installer in temp folder#>
   function Get-InnoSetup {
       $url = 'https://files.jrsoftware.org/is/' + $version.SubString(0,$version.IndexOf('.')) + '/' + $fileName
       
       Write-Host "Downloading the version => $version"
       Write-Host "Source.: " $url	
       Write-Host "Target.: " $app	
       
       New-Item -ItemType Directory -Force -Path $folderTemp | Out-Null
       
       Invoke-WebRequest -Uri $url -OutFile $app
   }
   
   <#Installs Inno Setup in tools directory of build agent#>
   function Install-InnoSetup {
       Write-Host "Installing..."
       
       New-Item -ItemType Directory -Force -Path $toolDirectory | Out-Null
       
       $ArgumentList = "/VERYSILENT /DIR=""" + $toolDirectory + """"
       Write-Host "ArgumentList..." $ArgumentList
       <#Start-Process -FilePath $app -ArgumentList $ArgumentList -Wait#>
       Invoke-VstsTool -FileName $app -Arguments $ArgumentList
       Write-Host "install complete"

    }

    [string]$version = Get-VstsInput -Name version

    $fileName = "innosetup-" + $version + ".exe"
    $folderTemp = Join-Path $env:AGENT_TEMPDIRECTORY "\InnoSetup\"
    $toolDirectory = Join-Path $env:AGENT_TOOLSDIRECTORY "\InnoSetup\$version\"
    $app = $folderTemp + $fileName
    Try 
    {
        Write-Host "Checking if the version to be downloaded already exists ..."
        if (-not (Test-IfAlreadyInstalled))
        {
            Get-InnoSetup
            Install-InnoSetup
        }
        else
        {
            Write-Host "The version already exists!"
        }
            
        Write-Host "Process completed successfully!"-ForegroundColor Green
    }
    Catch {
        throw
    }