[Home](../README.md)

# Corman USA Inc

- **Address**:-
- **PhoneNo**:-
- **OfficeTimings**:-

## Point of Contact if any / CTO information

1. **Adriana Feo** - adriana@itmas.com 
2. **Alessandra Laurano** - alessandra@itmas.com

## Network / Infrastructure Diagram


## Emails info


## Important Servers / Functions

* ITM GENOA-DC


## Printer Info


## File-share Info


## Backups info


## AV Software info


## Firewall info


## Important Notes

### SPS Commerce plugin (Adapter for use with QuickBooks)

**Contact information**
* Max Schroeder - mjschroeder@spscommerce.com
* Matthew Koopmeiners - mjkoopmeiners@spscommerce.com
* SPS Commerce 
    Customer Support Resolution  
    888-739-3232  
    support@spscommerce.com

Plugin information

These users are using this on an RDP server (ITM GENOA-RDS ) where they login to and use the software users are created on ITM GENOA-DC and users needs to be a part of below mentioned groups.
```Powershell console
Get-ADUser MBardin -Properties * | Select *
Get-ADPrincipalGroupMembership mcolon | select name
name
----
Domain Users
Accounting
SSL-VPN
Accounts
Employees
Terminal_Users
```