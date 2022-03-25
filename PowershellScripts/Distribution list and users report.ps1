Connect-ExchangeOnline
Get-DistributionGroup
team@iabtechlab.com
Techlab-bod@iabtechlab.com
Techlab-bod-ea@iabtechlab.com
Techlab-executivecomm@iabtechlab.com
techlab-financecomm@iabtechlab.com

$Distribution= Get-DistributionGroup

ForEach ($object in $Distribution) {

write-host -ForegroundColor Cyan $object
#Get-DistributionGroupMember -Identity "$object" | Select-Object -Property DisplayName,PrimarySmtpAddress | Format-Wide -Property DisplayName,PrimarySmtpAddress -AutoSize
Get-DistributionGroupMember -Identity "$object" | Format-table -Property DisplayName,PrimarySmtpAddress | Export-Csv -Path C:\Intel\iab Distributionlist.csv -NoTypeInformation
}

Get-DistributionGroupMember -Identity "team@iabtechlab.com" | Select-Object -Property DisplayName,PrimarySmtpAddress 