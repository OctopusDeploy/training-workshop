<#
Gets the raw student space info from the configured Octopus Cloud instance.
#>
. "$PSScriptRoot\shared-types.ps1"

EnsureConfigLoaded

$odHeaders = @{ "X-Octopus-ApiKey" = $octopusKey }

$response = (Invoke-WebRequest "$octopusURL/api/spaces" -Headers $odHeaders -Method Get -ErrorVariable octoError)

$spacesInfo = $response.Content | ConvertFrom-Json

Write-Output $spacesInfo.Items | Where-Object { $_.Description -like "*for workshop student*" }
