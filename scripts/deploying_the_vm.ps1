# Creating a Virtual Network and Subnet
Write-Host "Creating Virtual Network and Subnet..." -ForegroundColor DarkCyan

$vnet = New-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Location $location -Name $vnetName -AddressPrefix "10.0.0.0/16"
$vnet = Add-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix "10.0.0.0/24" -VirtualNetwork $vnet
$vnet | Set-AzVirtualNetwork
$subnet = $vnet.Subnets | Where-Object { $_.Name -eq $subnetName } # Ensures $subnet contains valid .Id

# Creating a Public IP Address
Write-Host "Creating Public IP address..." -ForegroundColor Yellow

$publicIp = New-AzPublicIpAddress -Name $publicIpName -ResourceGroupName $resourceGroupName -Location $location -AllocationMethod Dynamic

# Creating the Network Security Group and Rules
Write-Host "Creating Network Security Group..." -ForegroundColor DarkMagenta

$nsgName = "$vmName-NSG"
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Location $location -Name $nsgName
$nsg = Add-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name "Allow-RDP" -Protocol "Tcp" -Direction "Inbound" `
    -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389 -Access Allow
$nsg | Set-AzNetworkSecurityGroup

# Creating a Network Interface with NSG
Write-Host "Creating Network Interface..." -ForegroundColor Green  

$nic = New-AzNetworkInterface -Name $nicName -ResourceGroupName $resourceGroupName -Location $location `
    -SubnetId $subnet.Id -PublicIpAddressId $publicIp.Id -NetworkSecurityGroupId $nsg.Id

# Configure the Virtual Machine
Write-Host "Configuring VM..." -ForegroundColor Blue

$vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize |
    Set-AzVMOperatingSystem -Windows -ComputerName $vmName -AdminUsername $adminUser -AdminPassword $adminPassword |
    Set-AzVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2019-Datacenter" -Version "latest" |
    Add-AzVMNetworkInterface -Id $nic.Id

# Create the Virtual Machine
Write-Host "Creating Virtual Machine: $vmName. This might take a few minutes..." -ForegroundColor Cyan

New-AzVM -ResourceGroupName $resourceGroupName -Location $location -VM $vmConfig

Write-Host "Virtual Machine '$vmName' created successfully with configured networking settings." -ForegroundColor DarkYellow
Write-Host "VM deployed!" -ForegroundColor DarkYellow
Write-Host "VM Name: $vmName" -ForegroundColor DarkYellow

