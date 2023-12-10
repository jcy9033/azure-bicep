[CmdletBinding()]
param (
  [Parameter()]
  [ValidateNotNullOrEmpty()]
  [string]
  $dept
)

$environments = @("DEV", "PRD")

foreach ($env in $environments) {
    # Determine subscriptionName based on current environment in loop
    switch ($env) {
        "DEV" {
            $subscriptionName = "<サブスクリプション名>$dept"
        }
        "PRD" {
            $subscriptionName = "<サブスクリプション名>$dept"
        }
    }

    Select-AzSubscription -SubscriptionName $subscriptionName

    # Code to get the status of the "EncryptionAtHost" feature
    $featureState = Get-AzProviderFeature -FeatureName "EncryptionAtHost" -ProviderNamespace "Microsoft.Compute"

    # Code to check if the feature is already registered
    if ($featureState.Status -eq "Registered") {
        Write-Output "For $env, EncryptionAtHost feature is already registered."
    } else {
        # Register the "EncryptionAtHost" feature
        Register-AzProviderFeature -FeatureName "EncryptionAtHost" -ProviderNamespace "Microsoft.Compute"
        Write-Output "For $env, EncryptionAtHost feature has been registered. It may take some time for the feature to be activated."
    }
}
