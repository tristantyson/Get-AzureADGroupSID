<#PSScriptInfo

.VERSION 1.3

.GUID 4da60fad-3ad2-47f3-a26d-7dcbe0b8988d

.AUTHOR Tristan Tyson (tech.tristantyson.com)

.TAGS AzureAD AzureAD-Group-SID

.RELEASENOTES
    11/18/22 - Initial release to PSGallery

#>

<#
.DESCRIPTION

    Retrieves the ObjectID of the requested Azure AD group and converts it to the SID.

.PARAMETER groupName
    The name of the AzureAD group you want to query.
#>
Param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [string[]] $groupName
)      
       
# Get NuGet
$provider = Get-PackageProvider NuGet -ErrorAction Ignore
if (-not $provider) {
    Write-Host "Installing provider NuGet..."
    Find-PackageProvider -Name NuGet -ForceBootstrap -IncludeDependencies
}

$authModule = get-installedmodule -name Microsoft.Graph.Authentication -ErrorAction Ignore
if (-not $authmodule) {
    Write-Host "Installing Microsoft Graph Module..."
    Install-Module Microsoft.Graph.Authentication -Force
}


        
# Connect to Graph
$graph = Connect-MgGraph -scope 'Group.Read.All' 
Write-Host "Connected to Microsoft Graph$($graph.TenantId)"

# Get AzureAD Group Object
$groupInfo = Get-MgGroup -Filter "DisplayName eq '$groupName'"
$groupObjectID = $groupInfo.Id

if ($groupObjectID) {
    # Convert the ObjectID to SID
    Write-Verbose "Converting ObjectID to SID"
    $bytes = [Guid]::Parse($groupObjectID).ToByteArray()
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