param location string = resourceGroup().location
param virtualNetworkName string = 'system-vnet'

/*------------------------------------------------------------------------------------------------------------*/
@description('Virtual Network 생성')
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet-1'
        properties: {
          addressPrefix: '10.0.0.0/24'
          privateEndpointNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'subnet-2'
        properties: {
          addressPrefix: '10.0.1.0/24'
          privateEndpointNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

/*------------------------------------------------------------------------------------------------------------*/

output name string = virtualNetwork.name
output id string = virtualNetwork.id
