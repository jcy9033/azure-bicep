@description('Private DNS Zone의 이름')
param privateDnsZoneName string

@description('Vritual Network Link의 이름')
param virtualNetworkLinkName string

@description('Virtual Network의 ID')
param virtualNetworkId string

/*------------------------------------------------------------------------------------------------------------*/

@description('Key Vault Private DNS Zone생성')
resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
}

@description('Private DNS Zone과 Virtual Network의 링크 생성')
resource virtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZone
  name: virtualNetworkLinkName
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetworkId
    }
  }
}

/*------------------------------------------------------------------------------------------------------------*/
@description('main.bicep에서 사용할 Private DNS Zone의 이름')
output name string = privateDnsZone.name

@description('main.bicep에서 사용할 Private DNS Zone의 ID')
output id string = privateDnsZone.id
