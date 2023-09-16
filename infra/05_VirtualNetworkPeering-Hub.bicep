targetScope = 'resourceGroup'

@description('パラメータ変更必要')
param newVnet object = {
  name: '<リモート仮想ネットワーク名>'
  id: '<リモート仮想ネットワークID>'
}

/*-----------------------------------------------------------------------------------------------------------------------*/

@description('パラメータ変更不要')
@allowed([
  'japaneast'
  'japanwest'
])
param location string = 'japaneast'
param locationCode string = location == 'japaneast' ? 'JPE' : 'JPW'

@description('Network peering displayed in the hub virtual network')
resource peeringWithHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-07-01' = {
  name: 'JP-VNET-${locationCode}-CountryHostingHub/${newVnet.name}-JP-Peering'
  properties: {
    allowVirtualNetworkAccess: true 
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: newVnet.id
    }
  }
}
