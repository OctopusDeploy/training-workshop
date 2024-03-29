[CmdletBinding()]
param (
	#	[Parameter(Mandatory=$true)]
	[string] $studentName,
	[string] $studentEmail
)
$ErrorActionPreference = 'Stop'

. "$PSScriptRoot\shared-types.ps1"

$studentInfo = [StudentInfo]::new()

if ($studentName.Length -eq 0) {
	Write-Host "################################################"
	Write-Host "## No student information supplied, generating random student identity"
	$randoId = [System.Guid]:: NewGuid()
	$studentName = "Z-Student " + $randoId.ToString().SubString(24)
	if ($studentEmail.Length -eq 0) {
		$studentEmail = "z-student+$($randoId.ToString().SubString(0, 8))@octopus.com"
		$studentInfo.SkipEmail = $true
	}
	Write-Host "## Student Name: $studentName"
	Write-Host "## Student Email: $studentEmail"
	Write-Host "################################################"
}

$studentInfo.StudentName = $studentName
$studentInfo.StudentEmail = $studentEmail
$studentInfo.StudentId = [System.Guid]::NewGuid()
$studentSuffix = $studentInfo.StudentId.ToString().Substring(0, 8)

$studentName = $studentName.Replace(" ", "")
$studentNamePrefix = $studentName.Substring(0, [System.Math]::Min(9, $studentName.Length))
$studentSlug = "$studentNamePrefix-$studentSuffix"
$studentInfo.StudentSlug = $studentSlug
$studentInfo.DisplayName = "Student - $studentName"
$studentInfo.GitBranchName = $studentBranch = "student/$studentSlug"
$studentInfo.InstructionsUrl = "https://github.com/OctopusDeploy/training-workshop/blob/$studentBranch/instructions/README.md"

$appEnvs = @("dev", "test", "prod")

foreach ($appEnv in $appEnvs) {
	$appInfo = [StudentAppInfo]::new()
	$appInfo.AppEnvironment = $appEnv
	$appInfo.AppSlug = "$studentSlug-$appEnv"
	$appInfo.AppURL = "{student-app-url-$appEnv}"
	$studentInfo.AzureApps += $appInfo
}

if (!(Test-Path -Path $dataFolder)) {
	New-Item -Path $dataFolder -ItemType Directory | Write-Host
}
$studentInfo | ConvertTo-Json | Out-File "$dataFolder\$studentSlug.json"

Write-Host "Provisioning student"
Write-Host " - Name: $studentName ($studentEmail)"
Write-Host " - Slug: $studentSlug"

Write-Output $studentInfo