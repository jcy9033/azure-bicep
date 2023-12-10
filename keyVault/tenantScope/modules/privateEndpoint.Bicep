@description('Key Vault의 이름')
param keyVaultName string

@description('Resource Group의 지역')
param location string = resourceGroup().location

@description('Virtual Network의 이름')
param virtualNetworkName string

@description('Key Vault의 리소스 ID')
param keyVaultId string

@description('Private Endpoint의 IP주소')
param privateIpAddress string

@description('Core Private DNS Zone의 이름')
param privateDnsZoneName string

@description('Core Private DNS Zone의 ID')
param privateDnsZoneId string

/*------------------------------------------------------------------------------------------------------------*/

@description('Private Endpoint생성 및 Key Vault와 링크 생성')
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: '${keyVaultName}-pep'
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
        name: '${keyVaultName}-pep-nic'
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

@description('Private Endpoint와 Private DNS Zone의 링크 생성')
resource privateEndpointDns 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-05-01' = {
  parent: privateEndpoint
  name: 'vault-PrivateDnsZoneGroup'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: privateDnsZoneName
        properties: {
          privateDnsZoneId: privateDnsZoneId
        }
      }
    ]
  }
}

/*------------------------------------------------------------------------------------------------------------*/
@description('main.bicep에서 사용할 Private Endpoint의 이름')
output name string = privateEndpoint.name

@description('main.bicep에서 사용할 Private Endpoint의 ID')
output id string = privateEndpoint.id
