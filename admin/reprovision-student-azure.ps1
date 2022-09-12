[CmdletBinding()]
param (
	[Parameter(Mandatory = $true)]
	[object] $studentSlug
)

. "$PSScriptRoot\shared-config.ps1"
. "$PSScriptRoot\shared-types.ps1"
EnsureConfigLoaded

$studentInfo = GetStudentInfo($studentSlug)
$studentInfo = . "$PSScriptRoot\provision-student-azure.ps1" -studentInfo $studentInfo