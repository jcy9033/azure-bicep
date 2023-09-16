targetScope = 'resourceGroup'

@description('パラメータ変更必要') 
param dept string = '<部署名>'
@allowed([
  'DEV'
  'PRD'
])
param env string = '<環境>'

@description('(第1オクテットから、第3オクテットまで記載)')
param virtualNetworkAddressBase string = '<xxx.xxx.xxx>'

@description('仮想ネットワーク空間の利用者要件がある場合、パラメータ変更必要')
param vnet object = {
  name: 'JP-vnet-${locationCode}-${env}-${dept}' 
  addressPrefix: '${virtualNetworkAddressBase}.0/24'
}

@description('サブネット構成の利用者要件がある場合、パラメータ変更必要')
param subnets array = [
  {
    name: 'JPSNFrontenddev001'
    addressPrefix: '${virtualNetworkAddressBase}.0/27'
  }
  {
    name: 'JPSNBackenddev001'
    addressPrefix: '${virtualNetworkAddressBase}.32/27'
  }
  {
    name: 'JPSNAppdev001'
    addressPrefix: '${virtualNetworkAddressBase}.64/27'
  }
  {
    name: 'JPSNPaasdev001'
    addressPrefix: '${virtualNetworkAddressBase}.96/27'
  }
  {
    name: 'JPSNPaasdev002'
    addressPrefix: '${virtualNetworkAddressBase}.128/27'
  }
  {
    name: 'JPSNAgwedev001'
    addressPrefix: '${virtualNetworkAddressBase}.160/27'
  }
  {
    name: 'JPSNSparedev001'
    addressPrefix: '${virtualNetworkAddressBase}.192/27'
  }
  {
    name: 'JPSNSparedev002'
    addressPrefix: '${virtualNetworkAddressBase}.224/27'
  }
]

/*-----------------------------------------------------------------------------------------------------------------------*/

@description('パラメータ変更不要')
param location string = resourceGroup().location
param locationCode string = location == 'japaneast' ? 'JPE' : 'JPW'
param hiddenTagName string = '<タグ名>'
param hiddenTagValue string = '<タグの値>'
param knet string = '10.0.0.0/8'
param peeringNameWithSpoke string = '${locationCode}<ハブ仮想ネットワークのプレフィックス>'
param existingHubVnetId string = locationCode == 'JPE' ? '<東日本ハブ仮想ネットワークID>' : '<西日本ハブ仮想ネットワークID>'


@description('Module: Route Table for Subnets')
module newRt 'module/RouteTable.bicep' = {
  name: 'rtModule'
  params: {
    location: location
  }
}

@description('Module: Network Security Group for Subnets')
module newNsg 'module/NetworkSecurityGroups.bicep' = {
  name: 'nsgModule'
  params: {
    location: location
    dept: dept
    env: env
    locationCode: locationCode
    vnet: vnet
    subnets: subnets
    knet: knet
  }
}

@description('Resource: Country Hosting - Virtual Network')
resource newVnet 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnet.name
  location: location
  tags: {
    '${hiddenTagName}': hiddenTagValue // Avoid creation restrictions by adding hidden tags
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet.addressPrefix
      ]
    }
    subnets: [for (subnet, i) in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.addressPrefix
        routeTable: {
          id: newRt.outputs.id
        }
        networkSecurityGroup: {
          id: newNsg.outputs.nsgInfo[i].resourceId
        }
        privateEndpointNetworkPolicies: 'Enabled'
      }
    }]
  }
}

output newVnetInfo object = {
  vnetName: newVnet.name
  vnetId: newVnet.id
}



@description('Network peering displayed in the spoke virtual network')
resource peeringWithSpoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-07-01' = {
  parent: newVnet
  name: peeringNameWithSpoke
  properties: {
    // You must modify parameters of the virtual network peering below
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: true
    remoteVirtualNetwork: {
      id: existingHubVnetId
    }
  }
}
