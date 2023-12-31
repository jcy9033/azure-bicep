@description('Location of virtual machine')
param location string = resourceGroup().location

@description('Evironment Code of virtual machine')
param env_code string = 'DEV'

@description('System number of virtual machine')
param system_number int = 1

@description('Name of virtual machine')
param vm_name string = 'AZR${env_code}SRV_${system_number}'

param subent_id string = '/subscriptions/0b5f5005-c30c-4a28-89c1-9457d0cd5e0f/resourceGroups/system-1/providers/Microsoft.Network/virtualNetworks/system-1-nw/subnets/subnet-1'

/*------------------------------------------------------------------------------------------------------------*/

param admin_user_name string = 'azureuser'

@secure()
param admin_user_password string

/*------------------------------------------------------------------------------------------------------------*/

@description('Ubuntu 16.04 for testing')
resource ubuntuVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: vm_name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1ms'
    }
    osProfile: {
      computerName: 'Ubuntu'
      adminUsername: admin_user_name
      adminPassword: admin_user_password
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '16.04-LTS'
        version: 'latest'
      }
      osDisk: {
        name: '${vm_name}-osDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: '${vm_name}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig-1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subent_id
          }
        }
      }
    ]
  }
}
