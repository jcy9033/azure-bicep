@description('パラメータ変更必要')
param location string = resourceGroup().location
param locationCode string = location == 'japaneast' ? 'JPE' : 'JPW'
param nextHopIpAddress object = {
  JPE: '<東日本IPアドレス>'
  JPW: '<西日本IPアドレス>'
}

resource newRt 'Microsoft.Network/routeTables@2019-11-01' = {
  name: 'RT_KNET_${locationCode}'
  location: location
  properties: {
    routes: [
      {
        name: 'KNET_Default'
        properties: {
          addressPrefix: '10.0.0.0/8'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: locationCode == 'JPE' ? nextHopIpAddress.JPE : nextHopIpAddress.JPW
        }
      }
    ]
    disableBgpRoutePropagation: true
  }
}

output id string = newRt.id
