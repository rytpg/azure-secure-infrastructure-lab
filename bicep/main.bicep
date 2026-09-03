param location string = resourceGroup().location

param vnetName string = 'vnet-az104-iac-test'
param nsgName string = 'nsg-web-iac-test'

param vnetAddressPrefix string = '10.20.0.0/16'
param webSubnetPrefix string = '10.20.1.0/24'
param privateEndpointSubnetPrefix string = '10.20.2.0/24'

resource webNsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: nsgName
  location: location

  properties: {
    securityRules: [
      {
        name: 'Allow-HTTP-Internet'
        properties: {
          priority: 200
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'

          sourcePortRange: '*'
          destinationPortRange: '80'

          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location

  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }

    subnets: [
      {
        name: 'snet-web'
        properties: {
          addressPrefix: webSubnetPrefix

          networkSecurityGroup: {
            id: webNsg.id
          }
        }
      }

      {
        name: 'snet-private-endpoints'
        properties: {
          addressPrefix: privateEndpointSubnetPrefix
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output nsgId string = webNsg.id