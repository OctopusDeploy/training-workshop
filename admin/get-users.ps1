<#
Gets the raw user info from the configured Octopus Cloud instance.
#>

. "$PSScriptRoot\shared-types.ps1"

EnsureConfigLoaded

$odHeaders = @{ "X-Octopus-ApiKey" = $octopusKey } 

$response = (Invoke-WebRequest "$octopusURL/api/users" -Headers $odHeaders -Method Get -ErrorVariable octoError)

$result = $response.Content | ConvertFrom-Json

Write-Output $result.Items