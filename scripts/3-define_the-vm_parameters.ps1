# Variables: These can be adjusted according to specific requirements

$resourceGroupName = "Prac-Alpha"
$location = "EastUS"
$vmName = "Prac-Alpha-VM"
$adminUser = "Nelly"
$adminPassword = ConvertTo-SecureString "Secure-PassWord123" -AsPlainText -Force
$image = "Win2019Datacenter" # Any valid image that is appropriate for the use case can be use here
$vmSize = "Standard_DS1_v2"
$nicName = "$vmName-NIC"
$publicIpName = "$vmName-PublicIP"
$vnetName = "$vmName-VNet"
$subnetName = "Alpha-Subnet"
$nsgName = "$vmName-NSG"

# Create credentials for VM
 $credentials = New-Object System.Management.Automation.PSCredential ($adminUser, $adminPassword)