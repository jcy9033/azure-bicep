var privateDnsZoneName = 'privatelink${environment().suffixes.keyvaultDns}'

@description('Key Vault Private DNS Zone생성')
resource keyVaultPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
}
