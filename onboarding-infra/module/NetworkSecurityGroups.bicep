param knet string
param location string
param locationCode string
param env string
param dept string
param vnet object
param subnets array
param nsgRules array = [
  /* Network security group rules - Inbound */
  {
    useSourceknet: false
    useDestinationknet: false
    useSubnetAddressPrefix: true
    useSubnetName: true
    name: ''
    description: '<管理者アドインルール>'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: ''
    destinationAddressPrefix: ''
    access: 'Allow'
    priority: int(4000)
    direction: 'Inbound'
  }
  {
    useSourceknet: false
    useDestinationknet: false
    useSubnetAddressPrefix: true
    useSubnetName: true
    name: ''
    description: '<管理者アドインルール>'
    protocol: 'Udp'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: ''
    destinationAddressPrefix: ''
    access: 'Allow'
    priority: int(4001)
    direction: 'Inbound'
  }
  {
    useSourceknet: false
    useDestinationknet: false
    useSubnetAddressPrefix: false
    useSubnetName: false
    name: 'GO_Deny_ALL_TCP_IN'
    description: '<管理者アドインルール>'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Deny'
    priority: int(4090)
    direction: 'Inbound'
  }
  {
    useSourceknet: false
    useDestinationknet: false
    useSubnetAddressPrefix: false
    useSubnetName: false
    name: 'GO_Deny_ALL_UDP_IN'
    description: '<管理者アドインルール>'
    protocol: 'Udp'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Deny'
    priority: int(4091)
    direction: 'Inbound'
  }
  {
    useSourceknet: true
    useDestinationknet: false
    useSubnetAddressPrefix: true
    useSubnetName: false
    name: 'GO_Allow_ALL_ICMP_IN'
    description: '<管理者アドインルール>'
    protocol: 'Icmp'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: ''
    destinationAddressPrefix: ''
    access: 'Allow'
    priority: int(4092)
    direction: 'Inbound'
  }
  /* Network security group rules - Outbound */
  {
    useSourceknet: false
    useDestinationknet: false
    useSubnetAddressPrefix: true
    useSubnetName: true
    name: ''
    description: '<管理者アドインルール>'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: ''
    destinationAddressPrefix: ''
    access: 'Allow'
    priority: int(4000)
    direction: 'Outbound'
  }
  {
    useSourceknet: false
    useDestinationknet: false
    useSubnetAddressPrefix: true
    useSubnetName: true
    name: ''
    description: '<管理者アドインルール>'
    protocol: 'Udp'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: int(4001)
    direction: 'Outbound'
  }
  {
    useSourceknet: false
    useDestinationknet: false
    useSubnetAddressPrefix: false
    useSubnetName: false
    name: 'GO_Deny_ALL_TCP_OUT'
    description: '<管理者アドインルール>'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Deny'
    priority: int(4090)
    direction: 'Outbound'
  }
  {
    useSourceknet: false
    useDestinationknet: false
    useSubnetAddressPrefix: false
    useSubnetName: false
    name: 'GO_Deny_ALL_UDP_OUT'
    description: '<管理者アドインルール>'
    protocol: 'Udp'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Deny'
    priority: int(4091)
    direction: 'Outbound'
  }
  {
    useSourceknet: false
    useDestinationknet: true
    useSubnetAddressPrefix: true
    useSubnetName: false
    name: 'GO_Allow_ALL_ICMP_OUT'
    description: '<管理者アドインルール>'
    protocol: 'Icmp'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: ''
    destinationAddressPrefix: ''
    access: 'Allow'
    priority: int(4092)
    direction: 'Outbound'
  }
]

resource newNsg 'Microsoft.Network/networkSecurityGroups@2019-11-01' = [for subnet in subnets: {
  name: 'JP-nsg-${locationCode}-${env}-${dept}-${subnet.name}'
  location: location
  properties: {
    securityRules: [for (nsgRule, i) in nsgRules: {
      name: nsgRule.useSubnetName ? 'GO_${nsgRule.access}_${vnet.name}_${subnet.name}_${nsgRule.protocol == 'Tcp' ? (nsgRule.direction == 'Inbound' ? 'TIN' : 'TOUT') : (nsgRule.direction == 'Inbound' ? 'UIN' : 'UOUT')}' : nsgRule.name
      properties: {
        description: nsgRule.description
        protocol: nsgRule.protocol
        sourcePortRange: nsgRule.sourcePortRange
        destinationPortRange: nsgRule.destinationPortRange
        sourceAddressPrefix: nsgRule.useSourceknet ? knet : nsgRule.useSubnetAddressPrefix ? subnet.addressPrefix : nsgRule.sourceAddressPrefix
        destinationAddressPrefix: nsgRule.useDestinationknet ? knet : nsgRule.useSubnetAddressPrefix ? subnet.addressPrefix : nsgRule.destinationAddressPrefix
        access: nsgRule.access
        priority: nsgRule.priority
        direction: nsgRule.direction
      }
    }]
  }
}]

output nsgInfo array = [for (name, i) in subnets: {
  nsgName: newNsg[i].name
  resourceId: newNsg[i].id
}]
