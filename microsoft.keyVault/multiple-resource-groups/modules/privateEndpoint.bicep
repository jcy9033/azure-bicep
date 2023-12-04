@description('Key Vault의 이름')
param resourceName string

@description('Resource Group의 지역')
param location string = resourceGroup().location

@description('Virtual Network의 이름')
param virtualNetworkName string

@description('Key Vault의 리소스 ID')
param keyVaultId string

@description('Private Endpoint의 IP주소')
param privateIpAddress string

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
          privateIPAddress: privateIpAddress
        }
      }
    ]
    privateLinkServiceConnections: [
      {
        name: '${resourceName}-pep'
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
