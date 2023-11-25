using './keyVault.bicep'

param keyVaultName = 'chanpu-kv-101'
param keyVaultPlName = 'kv-pl'
param subnetId = '/subscriptions/11c25900-1ec1-42ce-8988-db8c5f092c18/resourceGroups/chanpu-network/providers/Microsoft.Network/virtualNetworks/chanpu-network-1/subnets/PaaS-1'
param virtualNetworkId = '/subscriptions/11c25900-1ec1-42ce-8988-db8c5f092c18/resourceGroups/chanpu-network/providers/Microsoft.Network/virtualNetworks/chanpu-network-1'
param securityGroupId = '52744881-57b8-49d5-bee2-e027d3be71b9'
