# Get-AzureADGroupSID

PowerShell script which returns the security identifier (SID) of the requested Azure Active Directory group.

## Script requirements

- Azure Active Directory read access.
- Local administrator rights to install the AzueAD module.

## How to run the script

Download and run the `Get-AzureADGroupSID.ps1` script with the `-groupName`parameter followed by the name of the group.

```powershell
.\get-azureadgroupsid.ps1 -groupName "GROUP NAME"
```

## User Experience

Console Output:
![Alt text](https://github.com/tristantyson/Get-AzureADGroupSID/blob/main/media/UserExperience.gif "PowerShell Output")