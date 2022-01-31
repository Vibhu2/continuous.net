Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

$LocalAdminName="continuousadmin"
#$localAdminPassword = ConvertTo-SecureString 'hashish4\typefaces' -AsPlainText -Force
$ninjaSource="https://app.ninjarmm.com/agent/installer/36bd05d1-c9ca-4fe5-bb1e-5f870fed0e07/interactiveadvertisingbureauny2-5.3.2848-windows-installer.msi"
$connectwiseSource="https://cnhelp.tech/Bin/ConnectWiseControl.ClientSetup.msi?h=cnhelp.tech&p=8041&k=BgIAAACkAABSU0ExAAgAAAEAAQCFEuQhT8A%2BtzJ6J1F%2Be0IFWA7UgOKvXUBB2S8WJka3YXAW1kLptN161Gu%2Fv7TFR1y2GlWgBNAXyrx2VaoCpXIsZtmDPypxW3r%2FRHZRVRmzoo6UMEKLmnn%2FAZX8KGCGgZeqPYyxoj2rnailBNOKgn6Sb5pGo1MQlts%2BKLtnZRdMA%2BWxjq9TigVdSiMp1nFg5qfZSBIflXZ6XhaM1ac6CASXIGicxS0qh4Su9xj3tll%2Fou7BTkAfrd%2B2Xwjf0BdIpEQpNzu4Eu%2BZ95OHSgSYzCxE1JVXWi7g8qbbVJHtJeHZFs29kbJrgH8EciTOzomWQuEu5OLqxDvUAf8%2BiCCCUl%2Ft&e=Access&y=Guest&t=&c=IAB&c=NYC&c=&c=&c=&c=&c=&c="


# Setting up local Admin account
$localAdminPassword = ConvertTo-SecureString 'hashish4\typefaces' -AsPlainText -Force
New-LocalUser -Name "continuousadmin"`
              -FullName "continuousadmin"`
              -Password $localAdminPassword`
              -Description "continuousadmin"`
              -AccountNeverExpires`
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
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -SuppressReboots

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
# Get-AppxPackage *Microsoft.WindowsCalculator* | Remove-AppxPackage
Get-AppxPackage *Microsoft.BingNews* | Remove-AppxPackage
Get-AppxPackage *Microsoft.XboxApp* | Remove-AppxPackage
Get-AppxPackage *Microsoft.BingSports* | Remove-AppxPackage
# Get-AppxPackage *Microsoft.WindowsCamera* | Remove-AppxPackage
Get-AppxPackage *Microsoft.Getstarted* | Remove-AppxPackage
# Get-AppxPackage *Microsoft.Office.OneNote* | Remove-AppxPackage
Get-AppxPackage *Microsoft.WindowsMaps* | Remove-AppxPackage
Get-AppxPackage *Microsoft.MicrosoftSolitaireCollection* | Remove-AppxPackage
# Get-AppxPackage *Microsoft.MicrosoftOfficeHub* | Remove-AppxPackage
# Get-AppxPackage *Microsoft.BingWeather* | Remove-AppxPackage
Get-AppxPackage *Microsoft.BioEnrollment* | Remove-AppxPackage
# Get-AppxPackage *Microsoft.WindowsStore* | Remove-AppxPackage
# Get-AppxPackage *Microsoft.Windows.Photos* | Remove-AppxPackage
Get-AppxPackage *Microsoft.WindowsPhone* | Remove-AppxPackage
Get-AppxPackage *spotify* | Remove-AppPackage
Get-AppxPackage *Xbox* | Remove-AppxPackage
Get-AppxPackage *skype* | Remove-AppxPackage
Get-AppxPackage *phone* | Remove-AppxPackage
Get-AppxPackage *mixed* | Remove-AppxPackage
Get-AppxPackage *prime* | Remove-AppxPackage
Get-AppxPackage *news* | Remove-AppxPackage
Get-AppxPackage *solitaire* | Remove-AppxPackage


# Rename Computer according to the client
Rename-Computer -NewName "LT-Number" -Force -Restart









