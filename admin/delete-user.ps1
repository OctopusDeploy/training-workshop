[CmdletBinding()]
param (
	[Parameter(Mandatory = $true)][string]$userId
)

. "$PSScriptRoot\shared-types.ps1"
EnsureConfigLoaded

$odHeaders = @{ "X-Octopus-ApiKey" = $octopusKey }

$response = (Invoke-WebRequest "$octopusURL/api/users/$userId" -Headers $odHeaders -Method Delete -ErrorVariable octoError)

Write-Output $response