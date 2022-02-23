Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

$LocalAdminName = continuousadmin
$localAdminPassword = hashish4\typefaces
$Computername = ""
$ninjaSource= "https://app.ninjarmm.com/agent/installer/36bd05d1-c9ca-4fe5-bb1e-5f870fed0e07/interactiveadvertisingbureauny2-5.3.2848-windows-installer.msi"
$connectwiseSource= "https://cnhelp.tech/Bin/ConnectWiseControl.ClientSetup.msi?h=cnhelp.tech&p=8041&k=BgIAAACkAABSU0ExAAgAAAEAAQCFEuQhT8A%2BtzJ6J1F%2Be0IFWA7UgOKvXUBB2S8WJka3YXAW1kLptN161Gu%2Fv7TFR1y2GlWgBNAXyrx2VaoCpXIsZtmDPypxW3r%2FRHZRVRmzoo6UMEKLmnn%2FAZX8KGCGgZeqPYyxoj2rnailBNOKgn6Sb5pGo1MQlts%2BKLtnZRdMA%2BWxjq9TigVdSiMp1nFg5qfZSBIflXZ6XhaM1ac6CASXIGicxS0qh4Su9xj3tll%2Fou7BTkAfrd%2B2Xwjf0BdIpEQpNzu4Eu%2BZ95OHSgSYzCxE1JVXWi7g8qbbVJHtJeHZFs29kbJrgH8EciTOzomWQuEu5OLqxDvUAf8%2BiCCCUl%2Ft&e=Access&y=Guest&t=&c=IAB&c=NYC&c=&c=&c=&c=&c=&c="

# Setting up local Admin account
$AdminPassword = ConvertTo-SecureString $localAdminPassword -AsPlainText -Force
$AdminPassword = ConvertTo-SecureString $localAdminPassword -AsPlainText -Force
New-LocalUser -Name "$LocalAdminName"`
              -FullName "continuousadmin"`
              -Password $AdminPassword `
              -Description "continuousadmin"`
              -AccountNeverExpires `
              -PasswordNeverExpires
Add-LocalGroupMember -Group "Administrators"`
                     -Member "continuousadmin"


# Setting up Power settings on the machine
#Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
New-Item -Path C:\ -Name "Continuous" -ItemType Directory
powercfg.exe -x -monitor-timeout-ac 15
powercfg.exe -x -monitor-timeout-dc 15
powercfg.exe -x -disk-timeout-ac 0
powercfg.exe -x -disk-timeout-dc 0
powercfg.exe -x -standby-timeout-ac 0
powercfg.exe -x -standby-timeout-dc 0
powercfg.exe -x -hibernate-timeout-ac 0
powercfg.exe -x -hibernate-timeout-dc 0

# Installing softwares and configuring system settings unsing Boxstarter

. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force
Import-Module Boxstarter.Chocolatey
Set-WindowsExplorerOptions -DisableShowHiddenFilesFoldersDrives -DisableShowProtectedOSFiles -EnableShowFileExtensions -DisableOpenFileExplorerToQuickAccess -DisableShowRecentFilesInQuickAccess -DisableShowRibbon -EnableSnapAssist
Disable-InternetExplorerESC
Disable-GameBarTips
Enable-MicrosoftUpdate
Enable-RemoteDesktop
choco feature enable -n=allowGlobalConfirmation
cinst 7zip
choco upgrade chocolatey
cinst googlechrome
#cinst firefox
#cinst jre8
cinst vlc
#cinst javaruntime
cinst powershell
cinst powershell-core
Cinst adobereader
cinst slack
cinst zoom-outlook
cinst lastpass
cinst lastpass-chrome
cinst onedrive

# Disable Windows Hello Feature on machine
function disableWindowsHello{
    $regHive='REGISTRY::HKLM\SOFTWARE\Policies\Microsoft\PassportForWork'
    $refreshEnv=$false   
    if (!(Test-Path $regHive)){
        Write-Host "Creating registry path $regHive"
        New-Item -Path $regHive -Force
    }
    if ((get-itemproperty $regHive -EA Ignore).Enabled -ne 0){
        New-ItemProperty -Path $regHive -Name 'Enabled' -Value 0 -PropertyType DWORD -Force
        $refreshEnv=$true
    }
    if ((get-itemproperty $regHive -EA Ignore).DisablePostLogonProvisioning -ne 1){
        New-ItemProperty -Path $regHive -Name 'DisablePostLogonProvisioning' -Value 1 -PropertyType DWORD -Force
        $refreshEnv=$true
    }
    if($refreshEnv){
        write-host 'refreshing environment...'
        & 'RUNDLL32.EXE' USER32.DLL, UpdatePerUserSystemParameters 1, True
    }
    write-host "Windows Hello has been disabled on $env:computername"
}
disableWindowsHello

# Downloading and installing Ninja RMM and Connectwise
New-Item -Path C:\ -Name "Continuous" -ItemType Directory
#$ninjaSource="https://app.ninjarmm.com/agent/installer/36bd05d1-c9ca-4fe5-bb1e-5f870fed0e07/interactiveadvertisingbureauny2-5.3.2848-windows-installer.msi"
#$connectwiseSource=""https://cnhelp.tech/Bin/ConnectWiseControl.ClientSetup.msi?h=cnhelp.tech&p=8041&k=BgIAAACkAABSU0ExAAgAAAEAAQCFEuQhT8A%2BtzJ6J1F%2Be0IFWA7UgOKvXUBB2S8WJka3YXAW1kLptN161Gu%2Fv7TFR1y2GlWgBNAXyrx2VaoCpXIsZtmDPypxW3r%2FRHZRVRmzoo6UMEKLmnn%2FAZX8KGCGgZeqPYyxoj2rnailBNOKgn6Sb5pGo1MQlts%2BKLtnZRdMA%2BWxjq9TigVdSiMp1nFg5qfZSBIflXZ6XhaM1ac6CASXIGicxS0qh4Su9xj3tll%2Fou7BTkAfrd%2B2Xwjf0BdIpEQpNzu4Eu%2BZ95OHSgSYzCxE1JVXWi7g8qbbVJHtJeHZFs29kbJrgH8EciTOzomWQuEu5OLqxDvUAf8%2BiCCCUl%2Ft&e=Access&y=Guest&t=&c=IAB&c=NYC&c=&c=&c=&c=&c=&c=""
Start-BitsTransfer -Source $ninjaSource -Destination "C:\Continuous\ninjarmm.msi"
#Start-BitsTransfer -Source $connectwiseSource -Destination "C:\Continuous\connectwise.msi"
Start-Process -FilePath C:\Continuous\ninjarmm.msi /quiet -Wait
#Start-Process -FilePath C:\Continuous\connectwise.msi /quiet -Wait

# installing windows updates
Install-Module -Name "PSWindowsUpdate" -Force
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll

# Removing Windows Morddern Applications
Get-AppxPackage *Microsoft.ZuneMusic* | Remove-AppxPackage
Get-AppxPackage *Microsoft.Music.Preview* | Remove-AppxPackage
Get-AppxPackage *Microsoft.XboxGameCallableUI* | Remove-AppxPackage
Get-AppxPackage *Microsoft.XboxIdentityProvider* | Remove-AppxPackage
Get-AppxPackage *Microsoft.BingTravel* | Remove-AppxPackage
Get-AppxPackage *Microsoft.BingHealthAndFitness* | Remove-AppxPackage
Get-AppxPackage *Microsoft.BingFoodAndDrink* | Remove-AppxPackage
Get-AppxPackage *Microsoft.People* | Remove-AppxPackage
Get-AppxPackage *Microsoft.BingFinance* | Remove-AppxPackage
Get-AppxPackage *Microsoft.3DBuilder* | Remove-AppxPackage
Get-AppxPackage *Microsoft.BingNews* | Remove-AppxPackage
Get-AppxPackage *Microsoft.XboxApp* | Remove-AppxPackage
Get-AppxPackage *Microsoft.BingSports* | Remove-AppxPackage
Get-AppxPackage *Microsoft.Getstarted* | Remove-AppxPackage
Get-AppxPackage *Microsoft.Office.OneNote* | Remove-AppxPackage
Get-AppxPackage *Microsoft.WindowsMaps* | Remove-AppxPackage
Get-AppxPackage *Microsoft.MicrosoftSolitaireCollection* | Remove-AppxPackage
 Get-AppxPackage *Microsoft.MicrosoftOfficeHub* | Remove-AppxPackage
# Get-AppxPackage *Microsoft.BingWeather* | Remove-AppxPackage
Get-AppxPackage *Microsoft.BioEnrollment* | Remove-AppxPackage
Get-AppxPackage *Microsoft.WindowsPhone* | Remove-AppxPackage
Get-AppxPackage *spotify* | Remove-AppPackage
Get-AppxPackage *Xbox* | Remove-AppxPackage
Get-AppxPackage *skype* | Remove-AppxPackage
Get-AppxPackage *phone* | Remove-AppxPackage
Get-AppxPackage *mixed* | Remove-AppxPackage  
Get-AppxPackage *prime* | Remove-AppxPackage 
Get-AppxPackage *news* | Remove-AppxPackage 
Get-AppxPackage *solitaire* | Remove-AppxPackage
Get-AppxPackage *Spotify* | Remove-AppPackage
Get-AppxPackage *Disney* | Remove-AppPackage
Get-AppxPackage *XboxGameCallableUI*| Remove-AppPackage
Get-AppxPackage *Xbox*| Remove-AppPackage
Get-AppxPackage *Reality*| Remove-AppPackage
Get-AppxPackage *Skype*| Remove-AppPackage
Get-AppxPackage Microsoft.XboxIdentityProvider |Remove-AppPackage
Get-AppxPackage Microsoft.SkypeApp |Remove-AppPackage
Get-AppxPackage Microsoft.ZuneMusic |Remove-AppPackage


________________________________________________________________________________________________________________________________


# Download windows app

New-Item -Path C:\ -ItemType Directory -Name EZdeploy

function Download-AppxPackage {
[CmdletBinding()]
param (
  [string]$Uri,
  [string]$Path = "."
)
   
  process {
    echo ""
    $StopWatch = [system.diagnostics.stopwatch]::startnew()
    $Path = (Resolve-Path $Path).Path
    #Get Urls to download
    Write-Host -ForegroundColor Yellow "Processing $Uri"
    $WebResponse = Invoke-WebRequest -UseBasicParsing -Method 'POST' -Uri 'https://store.rg-adguard.net/api/GetFiles' -Body "type=url&url=$Uri&ring=Retail" -ContentType 'application/x-www-form-urlencoded'
    $LinksMatch = ($WebResponse.Links | where {$_ -like '*.appx*'} | where {$_ -like '*_neutral_*' -or $_ -like "*_"+$env:PROCESSOR_ARCHITECTURE.Replace("AMD","X").Replace("IA","X")+"_*"} | Select-String -Pattern '(?<=a href=").+(?=" r)').matches.value
    $Files = ($WebResponse.Links | where {$_ -like '*.appx*'} | where {$_ -like '*_neutral_*' -or $_ -like "*_"+$env:PROCESSOR_ARCHITECTURE.Replace("AMD","X").Replace("IA","X")+"_*"} | where {$_ } | Select-String -Pattern '(?<=noreferrer">).+(?=</a>)').matches.value
    #Create array of links and filenames
    $DownloadLinks = @()
    for($i = 0;$i -lt $LinksMatch.Count; $i++){
        $Array += ,@($LinksMatch[$i],$Files[$i])
    }
    #Sort by filename descending
    $Array = $Array | sort-object @{Expression={$_[1]}; Descending=$True}
    $LastFile = "temp123"
    for($i = 0;$i -lt $LinksMatch.Count; $i++){
        $CurrentFile = $Array[$i][1]
        $CurrentUrl = $Array[$i][0]
        #Find first number index of current and last processed filename
        if ($CurrentFile -match "(?<number>\d)"){}
        $FileIndex = $CurrentFile.indexof($Matches.number)
        if ($LastFile -match "(?<number>\d)"){}
        $LastFileIndex = $LastFile.indexof($Matches.number)

        #If current filename product not equal to last filename product
        if (($CurrentFile.SubString(0,$FileIndex-1)) -ne ($LastFile.SubString(0,$LastFileIndex-1))) {
            #If file not already downloaded, add to the download queue
            if (-Not (Test-Path "$Path\$CurrentFile")) {
                "Downloading $Path\$CurrentFile"
                $FilePath = "$Path\$CurrentFile"
                $FileRequest = Invoke-WebRequest -Uri $CurrentUrl -UseBasicParsing #-Method Head
                [System.IO.File]::WriteAllBytes($FilePath, $FileRequest.content)
            }
        #Delete file outdated and already exist
        }elseif ((Test-Path "$Path\$CurrentFile")) {
            Remove-Item "$Path\$CurrentFile"
            "Removing $Path\$CurrentFile"
        }
        $LastFile = $CurrentFile
    }
    "Time to process: "+$StopWatch.ElapsedMilliseconds
  }
}


if (-Not (Test-Path "C:\Support\Store")) {
    Write-Host -ForegroundColor Green "Creating directory C:\Support\Store"
    New-Item -ItemType Directory -Force -Path "C:\Support\Store"
}

Download-AppxPackage "https://www.microsoft.com/store/productId/9NBLGGH4NNS1" "C:\EZdeploy"
$name= Get-ChildItem C:\EZdeploy -Filter *.appxbundle | Select-Object -Property fullname -

Add-AppxPackage "C:\EZdeploy\Microsoft.DesktopAppInstaller_2021.1207.203.0_neutral_~_8wekyb3d8bbwe.appxbundle"
Add-AppxPackage "$name"


# Rename Computer according to the client
Rename-Computer -NewName $Computername -Force -Restart

