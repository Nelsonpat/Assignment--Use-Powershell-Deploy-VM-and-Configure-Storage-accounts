# Create storage account

        Write-Host "Creating storage account: $storageAccountName..." -ForegroundColor Cyan

New-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName `
  -Location $Location -SkuName Standard_LRS -Kind StorageV2 -EnableHttpsTrafficOnly $true

Set-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName `
  -EnableHttpsTrafficOnly $true -MinimumTlsVersion TLS1_2

#Check the created storage account 

$storageAccount = Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName
Write-Host "Storage Account '$StorageAccountName' created successfully!" -ForegroundColor Green