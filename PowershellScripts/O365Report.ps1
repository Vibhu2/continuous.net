# Fetch O365 sync status details of each client 
# Module AzureAD
# 
# Always use below script in terminal

Import-Module MSOnline,AzureAD,AzureADTenantID,AzureADUserFederation,MSAL.PS,NinjaRmmApi,Office365,Office365Connect,PartnerCenter
Connect-PartnerCenter
Connect-MsolService
$customer = Get-PartnerCustomer

$syncinfo= Foreach ($cust in $customer){
  Get-MsolCompanyInformation -TenantId $cust.CustomerId 
 }

$syncinfo | Select-Object -Property DisplayName,DirectorySynchronizationEnabled,LastDirSyncTime,PasswordSynchronizationEnabled,LastPasswordSyncTime | Format-Table -Expand -AutoSize -Force

<#/ Foreach ($cust in $customer){
Get-MsolCompanyInformation -TenantId $cust.CustomerId | Select-Object -Property DisplayName,DirectorySynchronizationEnabled,LastDirSyncTime,PasswordSynchronizationEnabled,LastPasswordSyncTime | Format-Table -AutoSize
 }
#>
