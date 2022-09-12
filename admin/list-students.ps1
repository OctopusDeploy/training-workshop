[CmdletBinding()]
param (
	[switch] $Local,
	[switch] $ShortForm,
	[switch] $ListForm,
	[switch] $ForBlobInfo,
	[string] $commandPrefix
)

. "$PSScriptRoot\shared-octo-utils.ps1"
. "$PSScriptRoot\shared-config.ps1"
. "$PSScriptRoot\shared-types.ps1"

$cmdBaseDir = GetCmdBaseDir

EnableHighlight
if (!$Local) {
	$studentItems = UpdateLocalStudentData
}

$studentFiles = Get-ChildItem "$dataFolder\*.json"

foreach ($file in $studentFiles) {
	$slug = $file.Name.Replace(".json", "")

	if ($commandPrefix) {
		Write-Host "$commandPrefix$slug"
		continue
	}

	if ($ShortForm -and !$ListForm) {
		$studentInfo = Get-Content $file | ConvertFrom-Json
		Write-Host "$slug - $($studentInfo.StudentName)"
		continue
	}

	if ($ListForm -and !$ShortForm) {
		Write-Host $slug
		continue
	}

	$studentInfo = Get-Content $file | ConvertFrom-Json
	$switches = ""
	if (!$studentInfo.AzureApps[0].ResourceId -or $studentInfo.AzureApps[0].ResourceId.Length -eq 0) {
		$switches = "-skipAzure -forceCleanup "
	}
	Write-Host "($($file.Length)) | $cmdBaseDir\deprovision-student.ps1 -studentSlug $slug $switches| $cmdBaseDir\update-existing-git-branch.ps1 -studentSlug $slug"

	$studentItem = $studentItems | Where-Object -Property Name -EQ $file.Name
	if (!$studentItem) {
		Write-Warning "Student info missing from blob storage for slug:  $slug"
	}
}
DisableHighlight
