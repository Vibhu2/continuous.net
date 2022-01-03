# Fetch O365 sync status details of each client 
# Module AzureAD
# 
# 

Connect-PartnerCenter
Connect-MsolService
$customer = Get-PartnerCustomer

Get-MsolCompanyInformation -TenantId 7c9650fb-4c7b-4298-9eb8-9b61db4b9fb0 | Select-Object -Property DisplayName,DirectorySynchronizationEnabled,LastDirSyncTime,PasswordSynchronizationEnabled,LastPasswordSyncTime | Format-Table -AutoSize

