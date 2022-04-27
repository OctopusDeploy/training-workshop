[CmdletBinding()]
param (
	[switch] $Local,
	[switch] $ShortForm,
	[switch] $ForBlobInfo
)

. "$PSScriptRoot\shared-octo-utils.ps1"
. "$PSScriptRoot\shared-config.ps1"


EnableHighlight
if (!$Local) {
	Write-Host "Discovering student list from Azure storage."
	$storageContext = (Get-AzStorageAccount -ResourceGroupName $azResourceGroupName -Name $azStorageAccount).Context
	$blobItems = Get-AzStorageBlob -Container $azStorageStudentContainer -Context $storageContext # | ForEach-Object { Write-StudentEntry -slug $_.Name }
	Write-Host "Blob items found: $($blobItems.Length)"

	foreach ($item in $blobItems) {
		$filePath = "$dataFolder\$($item.Name)"
		$slug = $item.Name.Replace(".json", "")
		if (!(Test-Path "$filePath")) {
			Write-Host "Getting blob file for '$($item.Name)'..."
			Get-AzStorageBlobContent -Container $azStorageStudentContainer -Context $storageContext -Blob $item.Name -Destination $filePath
		}
	}
#	$blobItems | Select-Object
}

$studentFiles = Get-ChildItem "$dataFolder\*.json"

foreach ($file in $studentFiles) {
	$slug = $file.Name.Replace(".json", "")

	if ($ShortForm) {
		Write-Host $slug
		continue
	}

	$studentInfo = Get-Content $file | ConvertFrom-Json
	$switches = ""
	if (!$studentInfo.AzureApps[0].ResourceId -or $studentInfo.AzureApps[0].ResourceId.Length -eq 0) {
		$switches = "-skipAzure -forceCleanup "
	}
	Write-Host "..\repo\admin\testing\deprovision-student.ps1 -studentSlug $slug $switches| ..\repo\admin\testing\update-existing-git-branch.ps1 -studentSlug $slug | ($($file.Length))"

	$blobItem = $blobItems | Where-Object -Property Name -EQ $file.Name
	if (!$blobItem) {
		Write-Warning "Student info missing from blob storage for slug:  $slug"
	}
}
DisableHighlight
