<#
.SYNOPSIS
Gets the SID of an AzureAD group based on the name.
 
.DESCRIPTION
Retrieves the ObjectID of the requested Azure AD group and converts it to the SID.
Author: Tristan Tyson (tech.tristantyson.com)

.PARAMETER groupName
The name of the AzureAD group you want to know the SID of
#>

Param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)] [string[]] $groupName
)

# Import and insall the AzureAD module if youve not used it before
$module = Import-Module AzureAD -PassThru -ErrorAction Ignore
            if (-not $module)
            {
                Write-Host "Installing module AzureAD"
                Install-Module AzureAD -Force
            }

# Connect to your Azure tenant
$aadId = Connect-AzureAD
Write-Host "Connected to Azure AD tenant $($aadId.TenantId)"

# Get the group ObjectID
$ObjectId = (Get-AzureADGroup -Filter "DisplayName eq '$groupName'").objectid
Write-Host "Retrieving ObjectID"

# Convert the ObjectID to SID
Write-Host "Converting ObjectID to SID"
$bytes = [Guid]::Parse($ObjectId).ToByteArray()
$array = New-Object 'UInt32[]' 4
[Buffer]::BlockCopy($bytes, 0, $array, 0, 16)
$sid = "S-1-12-1-$array".Replace(' ', '-')
Write-Host ""

#Output SID
write-host "SID: $sid"