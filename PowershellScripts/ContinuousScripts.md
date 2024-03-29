### Connecting to Powershell for Office 365

Open up Powershell as an administrator
```Powershell
$UserCredential = Get-Credential  

"Enter the Office 365 admin credentials."

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

Import-PSSession $Session -DisableNameChecking
```
---

## Exchange PowerShell Commands (Commonly used)


### Adding Full Access Permission:

```Powershell
Add-MailboxPermission "automappingmailbox" -user your mailbox -AccessRights fullaccess -AutoMapping $true
Add-MailboxPermission -Identity maggie -user michael -AccessRights FullAccess -AutoMapping $true
Remove-MailboxPermission -Identity Test1 -User Test2 -AccessRights FullAccess -InheritanceType All
```
### Adding permissions to a users calendar:
```Powershell
Add-MailboxFolderPermission anna:\Calendar -User kristin -AccessRights Editor

Get-MailboxFolderPermission anna:\Calendar

Remove-MailboxFolderPermission <mailbox>:\Calendar –User <Mailbox-that-will-be-removed-from-Calendar-Permissions> and then type Y to confirm.

Author: CreateItems, DeleteOwnedItems, EditOwnedItems, FolderVisible, ReadItems

Contributor: CreateItems, FolderVisible

Editor: CreateItems, DeleteAllItems, DeleteOwnedItems, EditAllItems, EditOwnedItems, FolderVisible, ReadItems

None: FolderVisible

NonEditingAuthor: CreateItems, FolderVisible, ReadItems

Owner: CreateItems, CreateSubfolders, DeleteAllItems, DeleteOwnedItems, EditAllItems, EditOwnedItems, FolderContact, FolderOwner, FolderVisible, ReadItems

PublishingEditor: CreateItems, CreateSubfolders, DeleteAllItems, DeleteOwnedItems, EditAllItems, EditOwnedItems, FolderVisible, ReadItems

PublishingAuthor: CreateItems, CreateSubfolders, DeleteOwnedItems, EditOwnedItems, FolderVisible, ReadItems

Reviewer: FolderVisible, ReadItems
```


## Adding Delegate Access via Powershell

#### User must have Editor access in order to be a delegate.
```Powershell
Add-MailboxFolderPermission patrick:\calendar -user john.skelton -AccessRights Editor -SharingPermissionFlags Delegate
```


#### Exporting .PST from Exchange:
```Powershell
New-ManagementRoleAssignment -Role "Mailbox Import Export" -User Administrator

New-MailboxExportRequest -Mailbox brenda -Filepath \\mailnj01\pst2\brenda.pst

Get-MailboxExportRequest

Remove
```

## Convert Mailbox to Shared
```Powershell
Set-Mailbox username@company.com -Type Shared

Set-Mailbox -Identity <identity> -MessageCopyForSentAsEnabled $True

```

## Disabling junk mail in Office 365
```Powershell
Set-MailboxJunkEmailConfiguration "David Pelton" -Enabled $false
#----------------------------------------------------------------------------------

<#
.SYNOPSIS
Powershell script to optimize Windows - NOT READY FOR PRODUCTION

.DESCRIPTION
Need to study this script and extract only really necessary tweaks. Right now it's overloaded with unnecessary changes that may actually break stuff.

.EXAMPLE
An example

.NOTES
General notes
#>
Function Prepare-System {
<# 
 .DISCLAIMER
  This script is provided "AS IS" with no warranties, confers no rights, and is not supported by VMware.
  
 .SYNOPSIS 
 Windows 7 (Enterprise) VDI Golden Image Optimizations Script
 
    .DESCRIPTION 
 Made for Windows 7 (Enteprise) and VMware View non-persistent floating pools with View Persona Management enabled
 
    .NOTES 
        NAME:  WIN7 VDI OPT.ps1 
        AUTHOR: Olivier AH-SON
        LASTEDIT: 10/09/2013 
        KEYWORDS: vdi, golden image, windows 7, optimization, powershell
 
#> 
```
 
### Function to set a registry property value
### Create the registry key if it doesn't exist

```Powershell
Function Set-RegistryKey
{
 [CmdletBinding()]
 Param(
 [Parameter(Mandatory=$True,HelpMessage="Please Enter Registry Item Path",Position=1)]
 $Path,
 [Parameter(Mandatory=$True,HelpMessage="Please Enter Registry Item Name",Position=2)]
 $Name,
 [Parameter(Mandatory=$True,HelpMessage="Please Enter Registry Property Item Value",Position=3)]
 $Value,
 [Parameter(Mandatory=$False,HelpMessage="Please Enter Registry Property Type",Position=4)]
 $PropertyType = "DWORD"
 )
 
 # If path does not exist, create it
 If( (Test-Path $Path) -eq $False ) {
 
 $newItem = New-Item -Path $Path -Force
 
 } 
 ```
 ### Update registry value, create it if does not exist (DWORD is default)

```Powershell
 $itemProperty = Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue
 If($itemProperty -ne $null) {
 $itemProperty = Set-ItemProperty -Path $Path -Name $Name -Value $Value
 } Else {
 
 $itemProperty = New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $PropertyType
 }
 
}
```
### Get script path

```Powershell
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
```
### Set location to the root of the system drive
```Powershell
Set-Location -Path $env:SystemDrive
``
### Disable firewall on all profiles (domain, etc.) (Never disable the service!)
netsh advfirewall set allprofiles state off | Out-Host
 
### Disable Error Reporting
Set-RegistryKey -Path "HKLM:\SOFTWARE\Microsoft\PCHealth\ErrorReporting" -Name "DoReport" -Value 0
 
### Disable automatic updates
Set-RegistryKey -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" -Name "AUOptions" -Value 1
Set-RegistryKey -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" -Name "AUState" -Value 7
 
###  Remove Windows components
$featuresToDisable = @(
 "MediaPlayback",
 # If "WindowsMediaPlayer" removed, be aware WMV embedded videos on websites won't work (typically videos on Microsoft website)
 # Removed because another player is used as the standard
 "WindowsMediaPlayer", 
 "MediaCenter", 
 "OpticalMediaDisc", 
 "TabletPCOC", 
 "Printing-Foundation-InternetPrinting-Client", 
 "Printing-Foundation-Features", 
 "FaxServicesClientPackage",
 # If you want to keep the Start Menu search bar,
 # don't remove the "SearchEngine-Client-Package" component 
 "SearchEngine-Client-Package", 
 "WindowsGadgetPlatform"
)
 
foreach($feature in $featuresToDisable)
{
 dism /online /Disable-Feature /Quiet /NoRestart /FeatureName:$feature  | Out-Host
}
 
### Disable NTFS last access timestamp
fsutil behavior set disablelastaccess 1  | Out-Host
 
### Disable TCP/IP / Large Send Offload
Set-RegistryKey -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "DisableTaskOffload" -Value 1
 
### Disable hard disk timeouts 
POWERCFG /SETACVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0  | Out-Host
POWERCFG /SETDCVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0  | Out-Host
 
### Disable hibernation
powercfg /hibernate off | Out-Host
 
### Disable monitor time out (never)
powercfg -change -monitor-timeout-ac 0
 
###Disable system restore
# System Restore will be disabled on the system drive (usually C:)
Disable-ComputerRestore -Drive $env:SystemDrive 
Set-RegistryKey -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name "DisableSR" -Value 1
 
### Disable memory dumps (system crashes, BSOD)
Set-RegistryKey -Path "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl" -Name "CrashDumpEnabled" -Value 0
Set-RegistryKey -Path "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl" -Name "LogEvent" -Value 0
Set-RegistryKey -Path "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl" -Name "SendAlert" -Value 0
Set-RegistryKey -Path "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl" -Name "AutoReboot" -Value 1
 
### Disable default system screensaver
Set-RegistryKey -Path "Registry::\HKEY_USERS\.DEFAULT\Control Panel\Desktop" -Name "ScreenSaveActive" -Value 0
 
### Increase service startup timeouts
Set-RegistryKey -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "ServicesPipeTimeout" -Value 180000
 
### Increase Disk I/O Timeout to 200 seconds
Set-RegistryKey -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Disk" -Name "TimeOutValue" -Value 200
 
### Disable paging the executive
Set-RegistryKey -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "DisablePagingExecutive" -Value 1
 
### Size virtual machine RAM
# Disable the automatic management of the paging filing size
$ComputerSystem = gwmi Win32_ComputerSystem -EnableAllPrivileges
$ComputerSystem.AutomaticManagedPagefile = $False
$AutomaticManagedPagefile = $ComputerSystem.Put()
 
# Modify the existing page file of the C drive to set a fixed size of 2048MB
# Keeping the pagefile at a single size prevents the system from expanding, which creates a significant amount of IO
$CurrentPageFile = gwmi -query "Select * FROM Win32_PageFileSetting WHERE Name='C:\\pagefile.sys'"
$CurrentPageFile.InitialSize = [int]2048
$CurrentPageFile.MaximumSize = [int]2048
$pageFile = $CurrentPageFile.Put()
 
### Disable Machine Account Password Changes
Set-RegistryKey -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -Name "DisablePasswordChange" -Value 1
 
### Configure Event Logs to 1028KB (Minimum size under Vista/7) and overflowaction to "overwrite" 
$logs = Get-EventLog -LogName * | foreach{$_.Log.ToString()}
$limitParam = @{
  logname = ""
  Maximumsize = 1024KB
  OverflowAction = "OverwriteAsNeeded"
}
 
foreach($log in $logs) {
 
    $limitParam.logname = $log 
    Limit-EventLog @limitParam | Where {$_.Log -eq $limitparam.logname}
    Clear-EventLog -LogName $log
 
}
 
### Set PopUp Error Mode to "Neither" 
Set-RegistryKey -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Windows" -Name "ErrorMode" -Value 2
 
### Disable UAC secure desktop prompt
Set-RegistryKey -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Value 0
 
### Disable New Network dialog
$newNetworkDialog = New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force
 
### Disable AutoUpdate of drivers from WU
Set-RegistryKey -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "searchorderConfig" -Value 0
 
### Turn off Windows SideShow
Set-RegistryKey -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Sideshow" -Name "Disabled" -Value 1
 
### Disable IE First Run Wizard and RSS Feeds
Set-RegistryKey -Path "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -Value 1
 
### Disable the ability to clear the paging file during shutdown 
Set-RegistryKey -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SessionManager\Memory Management" -Name "ClearPageFileAtShutdown" -Value 0
 
###############################################
# Disable unnecessary services
###############################################
$servicesToDisable = @(
 "SensrSvc", # Adaptive Brightness
 "ALG", # Application Layer Gateway Service
 "BITS", # Background Intelligent Transfer Service
 "BDESVC", # BitLocker Drive Encryption Service
 "wbengine", # Block Level Backup Engine Service
 "bthserv", # Bluetooth Support Service
 "PeerDistSvc", # BranchCache
 "Browser", # Computer Browser
 "UxSms", # Desktop Window Manager Session Manager - Disable only if Aero not necessary
 "DPS", # Diagnostic Policy Service
 "WdiServiceHost", # Diagnostic Service Host
 "WdiSystemHost", # Diagnostic System Host
 "defragsvc", # Disk Defragmenter
 "TrkWks", # Distributed Link Tracking Client
 "EFS", # Encrypting File System (EFS)
 "Fax", # Fax - Not present in Windows 7 Enterprise
 "fdPHost", # Function Discovery Provider Host
 "FDResPub", # Function Discovery Resource Publication
 #"HomeGroupListener", # HomeGroup Listener - Not present in Windows 7 Enterprise
 "HomeGroupProvider", # HomeGroup Provider
 "UI0Detect", # Interactive Services Detection
 "iphlpsvc", # IP Helper
 "Mcx2Svc", # Media Center Extender Service
 "MSiSCSI", # Microsoft iSCSI Initiator Service
 "netprofm", # Network List Service
 "NlaSvc", # Network Location Awareness
 "CscService", # Offline Files
 "WPCSvc", # Parental Controls
 "wercplsupport", # Problem Reports and Solutions Control Panel Support
 "SstpSvc", # Secure Socket Tunneling Protocol Service
 "wscsvc", # Security Center
 "ShellHWDetection", # Shell Hardware Detection
 "SNMPTRAP", # SNMP Trap
 "SSDPSRV", # SSDP Discovery
 "SysMain", # Superfetch
 "TabletInputService", # Tablet PC Input Service
 "TapiSrv", # Telephony
 "Themes", # Themes - Disable only if you want to run in Classic interface
 "upnphost", # UPnP Device Host
 "SDRSVC", # Windows Backup
 "WcsPlugInService", # Windows Color System
 "wcncsvc", # Windows Connect Now - Config Registrar
 "WinDefend", # Windows Defender
 "WerSvc", # Windows Error Reporting Service
 "ehRecvr", # Windows Media Center Receiver Service
 "ehSched", # Windows Media Center Scheduler Service
 "WMPNetworkSvc", # Windows Media Player Network Sharing Service
 "WSearch", # Windows Search
 "wuauserv", # Windows Update
 "Wlansvc", # WLAN AutoConfig
 "WwanSvc" # WWAN AutoConfig
)
 
foreach($service in $servicesToDisable)
{
    Stop-Service -Name $service -Force # 'Force' parameter stops dependent services 
    Set-Service -Name $service -StartupType Disabled
}
###############################################
 
# Disable SuperFetch
# Service stopped and disabled
Set-RegistryKey -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnableSuperfetch" -Value 0
 
### Disable schedule tasks
$tasksToDisable = @(
 "microsoft\windows\Application Experience\AitAgent",
 "microsoft\windows\Application Experience\ProgramDataUpdater",
 "microsoft\windows\Autochk\Proxy",
 "microsoft\windows\Bluetooth\UninstallDeviceTask", 
 "microsoft\windows\Customer Experience Improvement Program\Consolidator", 
 "microsoft\windows\Customer Experience Improvement Program\KernelCeipTask",
 "microsoft\windows\Customer Experience Improvement Program\UsbCeip",
 "microsoft\windows\Defrag\ScheduledDefrag",
 "microsoft\windows\Diagnosis\Scheduled",
 "microsoft\windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector",
 "microsoft\windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver", 
 "microsoft\windows\Maintenance\WinSAT", 
 "microsoft\windows\MobilePC\HotStart", 
 "microsoft\windows\RAC\RacTask",
 "microsoft\windows\Ras\MobilityManager",
 "microsoft\windows\Registry\RegIdleBackup",
 "microsoft\windows\SideShow\AutoWake", 
 "microsoft\windows\SideShow\GadgetManager",
 "microsoft\windows\SideShow\SessionAgent",
 "microsoft\windows\SideShow\SystemDataProviders",
 "microsoft\windows\SystemRestore\SR",
 "microsoft\windows\UPnP\UPnPHostConfig",
 "microsoft\windows\WDI\ResolutionHost",
 "microsoft\windows\Windows Filtering Platform\BfeOnServiceStartTypeChange", 
 "microsoft\windows\Windows Media Sharing\UpdateLibrary", 
 "microsoft\windows\WindowsBackup\ConfigNotification"
)
 
foreach ($task in $tasksToDisable) 
{
 schtasks /change /tn $task /Disable | Out-Host
}
 
### Disable unnecessary boot features (for the current operating system)[A]
# Disable the boot debugging 
bcdedit /bootdebug off
bcdedit /debug off
# Disable the bootlog
bcdedit /set bootlog no
# Disable the boot screen animation
# Note: bootux - Not supported in Windows 8 and Windows Server 2012.
bcdedit /set bootux disabled
# Note: Do not use the quietboot option in Windows 8 as it will prevent the display of bug check data in addition to all boot graphics.
bcdedit /set quietboot on
 
 
### Perform a disk cleanup 
### Automate by creating the reg checks corresponding to 
>"cleanmgr /sageset:100" so we can use "sagerun:100" 
```Powershell
"cleanmgr /sageset:100" so we can use "sagerun:100" 
Set-RegistryKey -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders" -Name "StateFlags0100" -Value 2
Set-RegistryKey -Path "HKLM:\software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files" -Name "StateFlags0100" -Value 2
Set-RegistryKey -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Internet Cache Files" -Name "StateFlags0100" -Value 2
Set-RegistryKey -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Memory Dump Files" -Name "StateFlags0100" -Value 2
Set-RegistryKey -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Offline Pages Files" -Name "StateFlags0100" -Value 2
Set-RegistryKey -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Old ChkDsk Files" -Name "StateFlags0100" -Value 2
Set-RegistryKey -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Previous Installations" -Name "StateFlags0100" -Value 0
Set-RegistryKey -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin" -Name "StateFlags0100" -Value 2
Set-RegistryKey -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Setup Log Files" -Name "StateFlags0100" -Value 2
Set-RegistryKey -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error memory dump files" -Name "StateFlags0100" -Value 2
Set-RegistryKey -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error minidump files" -Name "StateFlags0100" -Value 2
Set-RegistryKey -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" -Name "StateFlags0100" -Value 2
Set-RegistryKey -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Setup Files" -Name "StateFlags0100" -Value 2
Set-RegistryKey -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" -Name "StateFlags0100" -Value 2
Set-RegistryKey -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Upgrade Discarded Files" -Name "StateFlags0100" -Value 0
Set-RegistryKey -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Archive Files" -Name "StateFlags0100" -Value 2
Set-RegistryKey -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Queue Files" -Name "StateFlags0100" -Value 2
Set-RegistryKey -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting System Archive Files" -Name "StateFlags0100" -Value 2
Set-RegistryKey -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting System Queue Files" -Name "StateFlags0100" -Value 2
Set-RegistryKey -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Upgrade Log Files" -Name "StateFlags0100" -Value 2
cleanmgr.exe /sagerun:100  | Out-Host
```
# Customization of the default user 
```Powershell
$defaultUserHivePath = $env:SystemDrive + "\Users\Default\NTUSER.DAT"
$userLoadPath = "HKU\TempUser" 
```
### Load Hive
```Powershell
reg load $userLoadPath $defaultUserHivePath | Out-Host
```
### Create PSDrive
```Powershell
$psDrive = New-PSDrive -Name HKUDefaultUser -PSProvider Registry -Root $userLoadPath
```
### Reduce menu show delay 
```Powershell
Set-RegistryKey -Path "HKUDefaultUser:\Control Panel\Desktop" -Name "MenuShowDelay" -Value 0
```
### Disable cursor blink 
```Powershell
Set-RegistryKey -Path "HKUDefaultUser:\Control Panel\Desktop" -Name "CursorBlinkRate" -Value -1
Set-RegistryKey -Path "HKUDefaultUser:\Control Panel\Desktop" -Name "DisableCursorBlink" -Value 1
```
### Force off-screen composition in IE 
```Powershell
Set-RegistryKey -Path "HKUDefaultUser:\Software\Microsoft\Internet Explorer\Main" -Name "Force Offscreen Composition" -Value 1
```
### Disable screensavers
```Powershell
Set-RegistryKey -Path "HKUDefaultUser:\Software\Policies\Microsoft\Windows\Control Panel\Desktop" -Name "ScreenSaveActive" -Value 0
Set-RegistryKey -Path "HKUDefaultUser:\Control Panel\Desktop\" -Name "ScreenSaveActive" -Value 0
Set-RegistryKey -Path "Registry::\HKEY_USERS\.DEFAULT\Control Panel\Desktop" -Name "ScreenSaveActive" -Value 0
```
### Don't show window contents when dragging.
```Powershell 
Set-RegistryKey -Path "HKUDefaultUser:\Control Panel\Desktop" -Name "DragFullWindows" -Value 0
```
### Don't show window minimize/maximize animations
```Powershell
Set-RegistryKey -Path "HKUDefaultUser:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0
```
### Disable font smoothing 
```Powershell
Set-RegistryKey -Path "HKUDefaultUser:\Control Panel\Desktop" -Name "FontSmoothing" -Value 0
```
### Disable most other visual effects 
```powershell
Set-RegistryKey -Path "HKUDefaultUser:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 3
Set-RegistryKey -Path "HKUDefaultUser:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewAlphaSelect" -Value 0
Set-RegistryKey -Path "HKUDefaultUser:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Value 0
Set-RegistryKey -Path "HKUDefaultUser:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewWatermark" -Value 0
Set-RegistryKey -Path "HKUDefaultUser:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewShadow" -Value 0
Set-RegistryKey -Path "HKUDefaultUser:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x01,0x80)) -PropertyType "Binary"
```
# Disable Action Center Icon
```Powershell
Set-RegistryKey -Path "HKUDefaultUser:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCAHealth" -Value 1
```
### Disable Network Icon
```Powershell
Set-RegistryKey -Path "HKUDefaultUser:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCANetwork" -Value 1
```
### Disable IE Persistent Cache 
```Powershell
Set-RegistryKey -Path "HKUDefaultUser:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Cache" -Name "Persistent" -Value 0
Set-RegistryKey -Path "HKUDefaultUser:\Software\Microsoft\Feeds" -Name "SyncStatus" -Value 0
```
### Remove PSDrive
```Powershell
$psDrive = Remove-PSDrive HKUDefaultUser
```
### Clean up references not in use
```Powershell
$variables = Get-Variable | Where { $_.Name -ne "userLoadPath" } | foreach { $_.Name }
foreach($var in $variables) { Remove-Variable $var -ErrorAction SilentlyContinue }
[gc]::collect()
```
# Unload Hive
reg unload $userLoadPath | Out-Host
}

#---------------------------------------------------------------------

## Disable Touch Screen Using PowerShell
```Powershell
Get-PnpDevice | Where-Object {$_.FriendlyName -like '*touch screen*'} | Disable-PnpDevice -Confirm:$false
```
## Enable Touch Screen Using PowerShell
```Powershell
Get-PnpDevice | Where-Object {$_.FriendlyName -like '*touch screen*'} | Enable-PnpDevice -Confirm:$false
```
#---------------------------------------------------------------------

## Add Calendar Permissions in Office 365 via Powershell
```Powershell
Install-Module -Name ExchangeOnlineManagement
```
### Run the following commands to login to 365 via Powershell and login with your Office 365 admin credentials:
```Powershell
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline
```
### You can view current calendar permissions of the specified mailbox by using following:
```Powershell
Get-MailboxFolderPermission username:\calendar
```
### You can get the list off all user’s calendars default permissions using the following command:
```Powershell
Get-Mailbox –database mbxdbname| ForEach-Object {Get-MailboxFolderPermission $_”:\calendar”} | Where {$_.User -like “Default”} | Select Identity, User, AccessRights
```
 > You can use these available access roles:

> Owner — read, create, modify and delete all items and folders. Also this role allows manage items permissions;

> PublishingEditor — read, create, modify and delete items/subfolders;

> Editor — read, create, modify and delete items;

> PublishingAuthor — read, create all items/subfolders. You can modify and delete only items you create;

> Author — create and read items; edit and delete own items NonEditingAuthor – full read access and create items. You can delete only your own items;

> Reviewer — read only;

> Contributor — create items and folders;

> AvailabilityOnly — read free/busy information from calendar;

LimitedDetails;

None — no permissions to access folder and files.
>

### Now run the following command. In the example below, user2 would be able to open user1 calendar and edit it:
```Powershell
Add-MailboxFolderPermission -Identity user1@domain.com:\calendar -user user2@domain.com -AccessRights Editor
```
### If you need to change the Default permissions for the calendar folder (in order to allow all users view calendar of the specified user), run the command:
```Powershell
Set-MailboxFolderPermission -Identity user1@domain.com:\calendar -User Default -AccessRights Reviewer
```
### In some cases, you need to grant Reviewer permissions on a calendar folder in all mailboxes to all users in your Exchange organization. You can make this bulk permission change using simple PowerShell script. To change Default calendar permission for all mailbox in mailbox database to Reviewer:
```Powershell
Get-Mailbox –database mbxdbname| ForEach-Object {Set-MailboxFolderPermission $_”:\calendar” -User Default -AccessRights Reviewer}
```

### To remove permission use Remove-MailboxFolderPermission cmdlet:
```Powershell
Remove-MailboxFolderPermission -Identity user1@domain.com:\calendar –user user2@domain.com
```

### Now you can disconnect from Office 365 your session:
```Powershell
Disconnect-ExchangeOnline
```
----------------

### PowerShell Script to check for external forwarding mailboxes in all Office 365 Customer tenants
```powershell
Function Get-ExternalMailboxForwarding{
    $credential = Get-Credential
    Connect-MsolService -Credential $credential
    $customers = Get-msolpartnercontract
    foreach ($customer in $customers) {
     
        $InitialDomain = Get-MsolDomain -TenantId $customer.TenantId | Where-Object {$_.IsInitial -eq $true}
         
        Write-Host "Checking $($customer.Name)"
        $DelegatedOrgURL = "https://outlook.office365.com/powershell-liveid?DelegatedOrg=" + $InitialDomain.Name
        $s = New-PSSession -ConnectionUri $DelegatedOrgURL -Credential $credential -Authentication Basic -ConfigurationName Microsoft.Exchange -AllowRedirection
        Import-PSSession $s -CommandName Get-Mailbox, Get-AcceptedDomain -AllowClobber
        $mailboxes = $null
        $mailboxes = Get-Mailbox -ResultSize Unlimited
        $domains = Get-AcceptedDomain
     
        foreach ($mailbox in $mailboxes) {
     
            $forwardingSMTPAddress = $null
            Write-Host "Checking forwarding for $($mailbox.displayname) - $($mailbox.primarysmtpaddress)"
            $forwardingSMTPAddress = $mailbox.forwardingsmtpaddress
            $externalRecipient = $null
            if($forwardingSMTPAddress){
                    $email = ($forwardingSMTPAddress -split "SMTP:")[1]
                    $domain = ($email -split "@")[1]
                    if ($domains.DomainName -notcontains $domain) {
                        $externalRecipient = $email
                    }
     
                if ($externalRecipient) {
                    Write-Host "$($mailbox.displayname) - $($mailbox.primarysmtpaddress) forwards to $externalRecipient" -ForegroundColor Yellow
     
                    $forwardHash = $null
                    $forwardHash = [ordered]@{
                        Customer           = $customer.Name
                        TenantId           = $customer.TenantId
                        PrimarySmtpAddress = $mailbox.PrimarySmtpAddress
                        DisplayName        = $mailbox.DisplayName
                        ExternalRecipient  = $externalRecipient
                    }
                    $ruleObject = New-Object PSObject -Property $forwardHash
                    $ruleObject | Export-Csv C:\temp\customerExternalForward.csv -NoTypeInformation -Append
                }
            }
        }
    }

}
```
#--------------------------------------------------------------------------------------------------------------------------------

# Converting to a Shared Mailbox

### Launch Windows PowerShell and run it as an Administrator.
### Enter the Office 365 Admin Credentials of the Customer 
```Powershell
$UserCredential = Get-Credential            
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

Import-PSSession $Session -DisableNameChecking

Set-Mailbox ( enter the email address of the User ) -Type Shared

exit
```
____

## How to disable junk mail folder in Office 365.
link - https://docs.microsoft.com/en-us/powershell/module/exchange/antispam-antimalware/set-mailboxjunkemailconfiguration?view=exchange-ps

---------
### Disable SPAM filtering in Office 365
```Powershell
Set-MailboxJunkEmailConfiguration user.name -Enabled $false
```
### To verify status run: 
```Powershell
Get-MailboxJunkEmailConfiguration user.name
```
### To disable SPAM filtering globally for all users withing organisation (via PowerShell):
```Powershell
Get-Mailbox | Set-MailboxJunkEmailConfiguration –Enabled $False
```
## Links to scripts
* [Create Unified Audit  Logs on all tenants:](https://gcits.com/knowledge-base/enabling-unified-audit-log-delegated-office-365-tenants-via-powershell/)
* [Enable Mailbox auditing on all tenants:](https://gcits.com/knowledge-base/enable-mailbox-auditing-on-all-users-for-all-office-365-customer-tenants/)
* [Confirm and disable POP/IMAP on all tenants:]( https://gcits.com/knowledge-base/disable-pop-imap-mailboxes-office-365/)
* [Disable forwarding inbox rules on all tenants:](https://gcits.com/knowledge-base/find-inbox-rules-forward-mail-externally-office-365-powershell/)
* [Verify same name warning:](https://gcits.com/knowledge-base/warn-users-external-email-arrives-display-name-someone-organisation/)
* [Find out Administrators for all tenants; enable MFA and remove unwated](https://gcits.com/knowledge-base/get-list-every-customers-office-365-administrators-via-powershell-delegated-administration/)
* [Setup Pwned checks and email us weekly:](https://gcits.com/knowledge-base/check-office-365-accounts-against-have-i-been-pwned-breaches/)
* [Find all external forwarders across our tenants:](https://gcits.com/knowledge-base/find-external-forwarding-mailboxes-office-365-customer-tenants-powershell/)
* [Alerts for elevated privlages:](https://gcits.com/knowledge-base/get-alerts-elevation-privilege-operations-office-365-customer-tenants/)
* [Montior for external mailbox forwarders in all tenants:](https://gcits.com/knowledge-base/monitor-external-mailbox-forwards-office-365-customer-tenants/)
* [Setup IP whitelistin for our environment: ](https://gcits.com/knowledge-base/running-delegated-admin-powershell-scripts-with-mfa-enabled-accounts/)
* [Monitor office365 Admin role changes:](https://gcits.com/knowledge-base/monitor-office-365-admin-role-changes-in-all-customer-tenants/)
* [Use runbooks to automate this:](https://docs.microsoft.com/en-us/azure/automation/manage-office-365#:~:text=From%20your%20Automation%20account%2C%20select,Office%20365%20credential%20is%20there.)  
* [Link2](https://blog.kloud.com.au/2016/08/24/schedule-office-365-powershell-tasks-using-azure-automation/)
* [Link3](https://www.thelazyadministrator.com/2019/11/20/office-365-email-address-policies-with-azure-automation/)

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## PowerShell Basics: How to Force AzureAD Connect to Sync
```powershell
Import-Module ADSync
Get-ADSyncScheduler
```
## The report should show intervals of 30 minute syncs and a sync policy type of Delta. A sync policy type of Initial is usually shown after AzureAD Connect's initial sync but can also be forced as detailed in the next step.
Now run the following command to initialize the AzureAD Sync immediately.
```powershell
Start-ADSyncSyncCycle -PolicyType Delta
```
## This will only sync current changes.  Run the following command to force a complete sync but note that the length of sync time would be greatly increased.
```Powershell
Start-ADSyncSyncCycle -PolicyType Initial
```
### Power Shell commands for subscribing/un-subscribing to Office 365 mail groups

**Connect to Powershell:**
```Powershell
Connect-ExchangeOnline -UserPrincipalName sbleyadmin@continuous.net
```
**Find out who is subscribed:**
```Powershell
Get-UnifiedGroupLinks -Identity avl@continuous.net -LinkType Subscribers
```
**Remove user:**
```Powershell
Remove-UnifiedGroupLinks -Identity avl@continuous.net -LinkType Members -Links laura@contoso.com
```
**Remove all users:**
```Powershell
Get-UnifiedGroupLinks avl@continuous.net -LinkType subscriber | % { Remove-UnifiedGroupLinks avl@continuous.net -Links $_.PrimarySmtpAddress -LinkType subscriber }
```
___

