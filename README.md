# Azure Secure Infrastructure Lab

A Microsoft Azure infrastructure project designed around the skills covered by AZ-104.

This project was built to simulate a small production style Azure environment with network segmentation, redundant web compute, load balancing, secure Blob Storage, private connectivity, monitoring, backup, governance, RBAC, and IaC.

## Architecture
![Azure Infrastructure Architecture](architecture/architecture.png)


## Technologies Used

- Microsoft Azure
- Microsoft Entra ID
- Azure RBAC
- Azure Virtual network
- Network Security Groups
- Azure Virtual Machines
- Nginx
- Azure Load Balancer
- Azure Blob Storage
- Azure Private Endpoint
- Azure Private DNS
- Azure Monitor
- Azure Alerts & Action Groups
- Azure Network Watcher
- Azure Backup
- Recovery Services Vault
- Azure CLI
- Bicep

## Overview
The environment contains two Ubuntu web servers running Nginx within a dedicated web subnet.

HTTP traffic enters through a public Azure standard load balancer, which distributes the requests across both backend virtual machines. A HTTP health probe is used to remove unhealthy instances from rotation.

A seperate subnet hosts a private endpoint for azure blob storage. Public network access to the storage account is disabled, and workloads inside the VNet resolve the storage account to its private IP using Azure private DNS.

Azure Monitor provides metric based alerting for the virtual machines (e.g Avg CPU % threshold), and Network Watcher is used for network troubleshooting.

Azure Backup protects one of the web servers using a Recovery Services vault.

A subset of the network infrastructure is also deployed using Bicep to demonstrate repeatable Infrastructure as Code deployment.

## Networking

The Azure network was segmented using a VNet with seperate subnets for application workloads and private endpoints.

- Web subnet for the Nginx virtual machines
- Subnet for the Azure private endpoints
- Subnet level Network Security Group
- HTTP allowed from the Internet
- SSH restricted to an admin source IP
- Default inbound deny behaviour

The NSG was implemented at subnet level rather than applying NSGs to individual VM NICs to reduce unnecessary rule complexity.

## High Availability Web Tier

Two ubuntu linux virtual machines were deployed and configured with Nginx.

Each server hosts a unique web page so traffic distribution can be verified.

An Azure standard load balancer provided:
- Public frontend IP configuration
- Backend pool containing both of the VM network interfaces
- TCP port 80 load balancing rule
- HTTP health probe on port 80

Nginx was deliberately stopped on one backend server to verify that the health probe marked the instance unhealthy and prevented new traffic from being directed to it.

## Secure Azure Storage

An Azure Storage account was configured with:

- Blob versioning
- Blob soft delete
- Container soft delete
- Lifecycle management
- Restricted SAS access
- HTTPS only access
- Private Blob container

Blob versioning and soft delete were tested by overwriting and deleting test data and then recovering previous versions.

A lifecycle management rule was configured to automatically remove previous blob versions after the defined retention period.

## Private Connectivity

Azure Blob Storage was secured using Azure Private Link.

A Blob Private Endpoint was deployed into a dedicated subnet and received a private IP address inside the VNet.

The Private DNS zone:

'privatelink.blob.core.windows.net'

was linked to the VNet so the normal Azure Storage hostname resolved to the Private Endpoint address from the virtual machines.

Public network access to the Storage account was then disabled.

DNS resolution from the web VM confirmed that Blob Storage resolved to the Private Endpoint address rather than a public Azure Storage IP.


## Monitoring and Alerting

Azure Monitor was configured to track platform metrics for the web virtual machines.

A metric alert monitored CPU utilization and used an Azure Monitor Action Group for notification.

CPU load was deliberately generated on a VM to verify that the alert rule could enter a fired state.


## Infrastructure as Code

A subset of the networking environment was recreated using Bicep.

The template deploys:

- Virtual Network
- Web subnet
- Private Endpoint subnet
- Network Security Group
- HTTP security rule
- NSG to subnet association

The deployment workflow included:

1. Bicep template validation
2. Azure deployment What If
3. Resource group scoped deployment using Azure CLI
4. Re running What If to verify the desired state

## Backup and Recovery

Azure Backup was configured for one of the web virtual machines using a Recovery Services vault.

The implementation included:

- Enhanced VM backup policy
- On demand backup
- Backup job monitoring
- Recovery point creation
- Inspection of VM restore options

This provided a recoverable point in time copy of the protected virtual machine.

## Identity and Governance

Microsoft Entra security groups were created for different access levels.

Azure RBAC was assigned at resource group scope using roles including:

- Reader
- Contributor

Additional governance controls included:

- Resource tags
- Azure Policy
- Resource lock
- Group based role assignment

Azure Policy was used to inherit an Environment tag from the resource group onto resources that did not explicitly contain the tag.

## Key Skills Demonstrated

This project provided practical experience with:

- Designing Azure network segmentation
- Configuring NSG rules and priorities
- Deploying and administering Linux VMs
- Implementing Azure Load Balancer
- Configuring Azure Storage data protection
- Generating restricted SAS access
- Securing PaaS resources with Private Endpoints
- Configuring Azure Private DNS
- Implementing Azure RBAC
- Applying Azure Policy
- Configuring Azure Monitor alerts
- Diagnosing connectivity with Network Watcher
- Protecting Azure VMs with Azure Backup
- Deploying infrastructure using Bicep and Azure CLI


