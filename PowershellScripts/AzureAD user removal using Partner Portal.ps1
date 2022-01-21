#AzureAD user removal using Partner Portal.ps1
# in this script we are accessing clients account using our partner portal and then checking users of the partner and removing them one by one

Function vbConnect-ToResources{
Import-Module MSOnline,AzureAD,AzureADTenantID,AzureADUserFederation,MSAL.PS,NinjaRmmApi,Office365,Office365Connect,PartnerCenter,ExchangeOnlineManagement
Connect-PartnerCenter
Connect-MsolService
Connect-ExchangeOnline
}

Function vbGet-PartnerSyncStatus {
$customer = Get-PartnerCustomer
$syncinfo= Foreach ($cust in $customer){
  Get-MsolCompanyInformation -TenantId $cust.CustomerId 
 }

$syncinfo | Select-Object -Property DisplayName,DirectorySynchronizationEnabled,LastDirSyncTime,PasswordSynchronizationEnabled,LastPasswordSyncTime | Out-GridView -Title " Sync Status of all the customers"
}

function vbselect-customer{
#Get-command -Module partnercenter
$Customer= Get-PartnerCustomer | Out-GridView -PassThru -Title "Select your Target Customer you want to work With"
$customerID=$customer.CustomerId
Get-PartnerCustomerUser -CustomerId "$customerID"
$users=Get-PartnerCustomerUser -CustomerId "$customerID" 
}

Function vbDelete-AzureadUser{
$selectDeleteusers= $users | Select-Object -Property UserPrincipalName,DisplayName,State,UserId,LastDirectorySyncTime | Out-GridView -OutputMode Multiple -Title "Select user for Deletion"
#Remove-PartnerCustomerUser -CustomerId "$customerID" -UserId $selectDeleteusers.UserPrincipalName
#Remove-PartnerCustomerUser -CustomerId "$customerID" -UserPrincipalName $selectDeleteusers.UserPrincipalName
#$users | Select-Object -Property UserPrincipalName,DisplayName,State,UserId | Out-GridView
#Write-Output  "Deleted folowing users" $selectDeleteusers.DisplayName
}

#Disconnect-partnercenter

# Review and Delicate calender permissions




