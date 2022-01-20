#AzureAD user removal using Partner Portal.ps1
# in this script we are accessing clients account using our partner portal and then checking users of the partner and removing them one by one

Connect-PartnerCenter
Get-command -Module partnercenter
$Customer= Get-PartnerCustomer | Out-GridView -PassThru
$customerID=$customer.CustomerId
Get-PartnerCustomerUser -CustomerId "$customerID"
$users=Get-PartnerCustomerUser -CustomerId "$customerID"
$selectDeleteusers= $users | Select-Object -Property UserPrincipalName,DisplayName,State,UserId | Out-GridView -PassThru
#Remove-PartnerCustomerUser -CustomerId "$customerID" -UserId $selectDeleteusers.UserPrincipalName
Remove-PartnerCustomerUser -CustomerId "$customerID" -UserPrincipalName $selectDeleteusers.UserPrincipalName
#$users | Select-Object -Property UserPrincipalName,DisplayName,State,UserId | Out-GridView




