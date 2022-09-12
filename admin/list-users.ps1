<#
	Lists the users found in the Octopus Cloud training instance.
#>

[CmdletBinding()]
param (
	# [switch] $Local,
	# [switch] $ShortForm,
	# [switch] $ListForm,
	# [switch] $ForBlobInfo,
	# [string] $commandPrefix
)
. "$PSScriptRoot\shared-types.ps1"

$users = . $PSScriptRoot\get-users.ps1

foreach ($user in $users) {
	Write-Host "$($user.DisplayName) | $($user.EmailAddress) | $(GetCmdBaseDir)\delete-user.ps1 -userId $($user.Id)"
}
