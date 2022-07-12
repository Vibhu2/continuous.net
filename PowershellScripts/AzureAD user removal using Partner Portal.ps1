# list of all the modules used in the script
$module = "MSOnline","AzureAD","AzureADTenantID","AzureADUserFederation","MSAL.PS","NinjaRmmApi","Office365","Office365Connect","PartnerCenter","ExchangeOnlineManagement"


Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
<#Get-MsolDomain
if($? = $True){

Write-Host " you are connected to tatent"
Get-MsolDomain

}
else { 
Write-Host " please connect to a tanent"
}
#>

<#
    Connecting to all the resources and importing all the Required Modules in one go.
#>
Function vbConnect-ToResources{
    Import-Module MSOnline,AzureAD,AzureADTenantID,AzureADUserFederation,MSAL.PS,NinjaRmmApi,Office365,Office365Connect,PartnerCenter,ExchangeOnlineManagement
    Connect-PartnerCenter
    Connect-MsolService
    Connect-ExchangeOnline
    Connect-AzureAD
}


<#

    This Function is to check ADSync status of all of our partners if they have sync if yes when was the last sync performed.

#>
Function vbGet-PartnerSyncStatus {
    $customer = Get-PartnerCustomer
    $syncinfo= Foreach ($cust in $customer){
    Get-MsolCompanyInformation -TenantId $cust.CustomerId 
}

$syncinfo | Select-Object -Property DisplayName,DirectorySynchronizationEnabled,LastDirSyncTime,PasswordSynchronizationEnabled,LastPasswordSyncTime | Out-GridView -Title " Sync Status of all the customers"
}

<#
    In below Function we are just choosing a customer from the list of customers we have in our Admin center 
    variable used for customer id is $CustomerID
#>
function vbselect-customer{
    #Get-command -Module partnercenter
    $Customer= Get-PartnerCustomer | Out-GridView -PassThru -Title "Select your Target Customer you want to work With"
    $CustomerID=$customer.CustomerId
    $allusers = Get-PartnerCustomerUser -CustomerId "$customerID"
}

# this function is used to select the user on which we will be running commands to 
# this function is dependent on function vbselect-customer for its data
# variables used are $Primaryuser and $Secondaryuser

Function vbselect-primaryuser{
    $Primaryuser= $allusers | Out-GridView -Title "Select Primary user" -OutputMode Single
}

Function vbselect-Secondaryuser{
    $Secondaryuser= $allusers | Out-GridView -Title "Select Secondary user" -OutputMode Single
}

<#
    AzureAD user removal using Partner Portal.ps1
    In this script we are accessing clients account using our partner portal and then checking users of the partner and removing them one by one
#>
Function vbDelete-AzureadUser{
    $selectDeleteusers= $users | Select-Object -Property UserPrincipalName,DisplayName,State,UserId,LastDirectorySyncTime | Out-GridView -OutputMode Multiple -Title "Select user for Deletion"
    #Remove-PartnerCustomerUser -CustomerId "$customerID" -UserId $selectDeleteusers.UserPrincipalName
    #Remove-PartnerCustomerUser -CustomerId "$customerID" -UserPrincipalName $selectDeleteusers.UserPrincipalName
    #$users | Select-Object -Property UserPrincipalName,DisplayName,State,UserId | Out-GridView
    #Write-Output  "Deleted folowing users" $selectDeleteusers.DisplayName
}

#------------------------------------------------------------------------------

Function vbConnect-ToClientExchange {
   
    Import-Module $module -Verbose
    Connect-ExchangeOnline
    Connect-MsolService
}

# creating a New user on office365

New-MsolUser -UserPrincipalName test@natechamberlain.onmicrosoft.com`
             -DisplayName "Test Account"`
             -FirstName "Test"`
             -LastName "Account"

# Disabling a user

Set-MsolUser -UserPrincipalName testingMayDeleteLater@natechamberlain.com`
             -BlockCredential $true

# setting other parameters.

Set-MsolUser -UserPrincipalName "test@natechamberlain.onmicrosoft.com"`
             -Office "Kansas City"`
             -Title "Accounts Payable Manager"`
             -Department "Finance"

# Getting a list of all users with user properties

Get-MsolUser | Select-Object UserPrincipalName, DisplayName, Department, Title, Office
Get-msoluser | Where {$_.Department -eq "Finance"}

# Changing a user password

Set-MsOlUserPassword –UserPrincipalName "bertha@natechamberlain.com"`
                     –NewPassword "Password1"`
                     –ForceChangePassword $false


#$username = Get-Mailbox -ResultSize 1000 | Select-Object -Property Name,DisplayName,Alias,IsDirSynced,Database,SamAccountName | Out-GridView -Title "Select the user for Calender permissions" -OutputMode Single

<#
    Checking Calender Permissions of a user
#>
Function vbget-MailboxPermission{
    $username = Get-Mailbox -ResultSize 1000 | Out-GridView -Title "Select the user for Calender permissions" -OutputMode Single
    # $username = Get-Mailbox -ResultSize 1000 | Select-Object -Property Name,DisplayName,Alias,IsDirSynced,Database,SamAccountName | Out-GridView -Title "Select the user for Calender permissions" -OutputMode Single
    \Get-MailboxFolderPermission $username':'\calendar
    #$name =$username.Name
    #Get-MailboxFolderPermission "$name"':'\calendar
    #Get-MailboxFolderPermission '$username.Name:\calendar'
}


<# 
    Add Calendar Permissions in Office 365 viavPowershell
#>


# Disconnect-partnercenter
# Review and Delicate calender permissions
# Get-Mailbox -ResultSize 1000 | Select-Object -Property Name,DisplayName,Alias,IsDirSynced,Database,SamAccountName | Out-GridView

