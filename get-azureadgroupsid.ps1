<#
.SYNOPSIS
Gets the SID of an AzureAD group based on the name.
 
.DESCRIPTION
Retrieves the ObjectID of the requested Azure AD group and converts it to the SID.
Author: Tristan Tyson (tech.tristantyson.com).

.PARAMETER groupName
The name of the AzureAD group you want to query.
#>

Param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [string[]] $groupName
)
try {
    # Import and insall the AzureAD module if youve not used it before
    $module = Import-Module AzureAD -PassThru -ErrorAction Ignore
    if (-not $module) {
        Write-Host "Installing module AzureAD"
        Install-Module AzureAD -Force
    }

    # Connect to your Azure tenant
    $aadId = Connect-AzureAD -ErrorAction Stop
    Write-Verbose "Connected to Azure AD tenant $($aadId.TenantId)" 

    # Get the group ObjectID
    $groupObject = Get-AzureADGroup -Filter "DisplayName eq '$groupName'" -ErrorAction Stop
    $ObjectId = $groupObject.objectid
    Write-Verbose "Retrieving ObjectID"

    if ($ObjectId) {
        # Convert the ObjectID to SID
        Write-Verbose "Converting ObjectID to SID"
        $bytes = [Guid]::Parse($ObjectId).ToByteArray()
        $array = New-Object 'UInt32[]' 4
        [Buffer]::BlockCopy($bytes, 0, $array, 0, 16)
        $sid = "S-1-12-1-$array".Replace(' ', '-')
    }
    else {
        throw "Unable to find group: $groupName"
    }
    # Create Object
    $azureADGroupSID = [PSCustomObject]@{
        Name     = $groupObject.DisplayName
        sid      = $sid
        ObjectID = $ObjectId
    }
    $azureADGroupSID.sid
}
catch {
    throw $_
}