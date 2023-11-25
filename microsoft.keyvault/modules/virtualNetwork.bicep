param location string = resourceGroup().location
param virtualNetworkName string

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
        name: 'IaaS-1'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: 'PaaS-1'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}
