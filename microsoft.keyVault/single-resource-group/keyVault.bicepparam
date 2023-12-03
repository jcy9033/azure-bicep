using './keyVault.bicep'

// Name of key vault
param keyVaultName = 'chanpu-dev-kv-20231202'

// Private link name of key vault
param keyVaultPlName = 'kv-pl'

// Subent id for private endpoint
param subnetId = '/subscriptions/611a7ed8-17fa-480a-901d-d7084803c376/resourceGroups/chanpu-dev/providers/Microsoft.Network/virtualNetworks/chanpu-vnet/subnets/default'

// Virtual network id for private dns zone(privatelink.vaultcore.azure.net)
param virtualNetworkId = '/subscriptions/611a7ed8-17fa-480a-901d-d7084803c376/resourceGroups/chanpu-dev/providers/Microsoft.Network/virtualNetworks/chanpu-vnet'

// Object id of the security group
param securityGroupId = 'cfa4eb1d-5a01-445a-84ad-1f198ebab44c'
