@description('기존 Virtual Network의 이름')
param virtualNetworkName string

/*------------------------------------------------------------------------------------------------------------*/
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-05-01' existing = {
  name: virtualNetworkName
}

/*------------------------------------------------------------------------------------------------------------*/
@description('main.bicep에서 사용할 기존 Virtual Network의 이름')
output name string = virtualNetwork.name

@description('main.bicep에서 사용할 기존 Virtual Network의 이름')
output id string = virtualNetwork.id
