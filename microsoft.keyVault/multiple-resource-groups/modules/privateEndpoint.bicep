@description('Key Vault의 이름')
param resourceName string

@description('Key Vault Private link의 이름')
param keyVaultPlName string = 'kv-pl'

@description('Resource Group의 지역')
param location string = resourceGroup().location

@description('Virtual Network의 이름')
param virtualNetworkName string

@description('Key Vault의 리소스 ID')
param keyVaultId string

/*------------------------------------------------------------------------------------------------------------*/

@description('Private Endpoint생성 및 Key Vault와 링크 생성')
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: '${resourceName}-pep'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          groupId: 'vault'
          memberName: 'default'
          privateIPAddress: '10.0.0.10'
        }
      }
    ]
    privateLinkServiceConnections: [
      {
        name: keyVaultPlName
        properties: {
          privateLinkServiceId: keyVaultId
          groupIds: [
            'vault'
          ]
        }
      }
    ]
    subnet: {
      id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, 'Subnet-1')
    }
  }
}

/*------------------------------------------------------------------------------------------------------------*/

output id string = privateEndpoint.id
output name string = privateEndpoint.name
