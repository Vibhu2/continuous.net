Start-Transcript

# Getting the list of users from a simple text file

Import-Module *activedirectory*
$users = Get-Content "C:\it\Users.txt"

# Checking out users once by one and if found removing them from Active Directory
foreach ($user in $users) {
   Get-AdUser -Filter "Name -like '$user'" |   Remove-ADUser -Confirm:$false
} 