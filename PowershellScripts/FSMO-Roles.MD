# Transferring FSMO roles between AD servers.

When you create a domain, all FSMO roles assigned to the first domain controller in the forest by default. You can transfer FSMO roles from one DC to another both the Active Directory graphics snap-ins and the PowerShell command line. Transfer FSMO roles using AD PowerShell has the following benefits:

- You do not need to connect with a MMC snap-ins to the future role owner;
- Transferring or seizing FSMO roles does not require a connection to the current or future role owner. You can run AD-PowerShell module cmdlets on a Windows 7 client or on a member server running Windows Server (with the RSAT package installed);
- To seize the FSMO role (if the current owner is not available), it suffices to use an additional parameter -force.
To get the current forest level FSMO role owners (Domain Naming Master and Schema Master roles) you can use the following PowerShell command:
```Powershell
Get-ADForest contoso.com| ft DomainNamingMaster, SchemaMaster
```
To view domain-wide FSMO roles (Infrastructure Master, PDC Emulator and Relative Identifier Master roles):
```Powershell
Get-ADDomain contoso.com | ft InfrastructureMaster, PDCEmulator, RIDMaster
```
## Transfer FSMO Roles using PowerShell
To transfer FSMO roles between Active Directory domain controllers use the PowerShell cmdlet Move-ADDirectoryServerOperationMasterRole.

To use the Move-ADDirectoryServerOperationMasterRole cmdlet, you must meet the following requirements:

* There must be at least one domain controller with a version of Windows Server 2008 R2 or higher;
* Installed PowerShell 3.0 or newer;
* Imported Active Directory module (2.0  or newer).
First of all, you need to load the Active Directory PowerShell module:

```Powershell
Import-Module ActiveDirectory
```
Tip. In Windows Server 2012 or later, the Active Directory module for PowerShell is loaded by default.

Unlike the Ntdsutil.exe utility, the Move-ADDirectoryServerOperationMasteRole cmdlet can be performed from any domain computer to migrate the Operations Master roles if you have the appropriate rights (Domain admins and Enterprise Admins).

For example, to transfer the PDC Emulator role to a domain controller named dc2, use the command:
```Powershell
Move-ADDirectoryServerOperationMasterRole -Identity "dc2" PDCEmulator
```
It is possible to transfer several roles at once:

```Powershell
Move-ADDirectoryServerOperationMasterRole -Identity “dc2” –OperationMasterRole DomainNamingMaster,PDCEmulator,RIDMaster,SchemaMaster,InfrastructureMaster
```
Tip. To simplify the command, you can replace the names of roles with numbers from 0 to 4. The correspondence of names and numbers is given in the table:
| PDCEmulator          | 0 |
|----------------------|---|
| RIDMaster            | 1 |
| InfrastructureMaster | 2 |
| SchemaMaster         | 3 |
| DomainNamingMaster   | 4 |

Thus, the last command can be replaced by a shorter one:

```Powershell
Move-ADDirectoryServerOperationMasterRole “dc2” –OperationMasterRole 0,1,2,3,4
```
After entering the transfer command for all or several roles, a window appears asking whether you want to confirm your actions or cancel them.

In the event that the current owner of one or all of the FSMO roles fails, the forced transfer of FSMO roles is performed by the same command, but with the -Force option:

```Powershell
Move-ADDirectoryServerOperationMasterRole -Identity “dc2” –OperationMasterRole DomainNamingMaster,PDCEmulator,RIDMaster,SchemaMaster,InfrastructureMaster –Force
```
Important. After the FSMO roles has been seized, the domain controller from which the roles was seized should never be connected to the domain.

As you can see, to transfer FSMO roles using PowerShell just follow the steps above! It is quite simple.