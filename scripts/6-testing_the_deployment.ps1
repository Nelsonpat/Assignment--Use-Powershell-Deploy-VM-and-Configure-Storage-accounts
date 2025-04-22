# Define Resource Variables

$resourceGroupName = "Prac-Alpha"
$vmName = "Prac-Alpha-VM"
$storageAccountName = "$vmName-Storage"

# Check Virtual Machine Deployment Status

Write-Host "Checking Virtual Machine deployment status..." -ForegroundColor Cyan
Try {
    $vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName
    $vmStatus = $vm.ProvisioningState
    Write-Host "Virtual Machine '$vmName' is in state: $vmStatus" -ForegroundColor Green
} Catch {
    Write-Host "Error retrieving VM. It may not exist or failed to deploy. Error: $_" -ForegroundColor Red
}

# Check Storage Account Deployment Status

Write-Host "Checking Storage Account deployment status..." -ForegroundColor Yellow
Try {
    $storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName
    Write-Host "Storage Account '$storageAccountName' exists and is accessible!" -ForegroundColor Green
    Write-Host "Blob Endpoint: $($storageAccount.PrimaryEndpoints.Blob)" -ForegroundColor Green
} Catch {
    Write-Host "Error retrieving Storage Account. It may not exist or failed to deploy. Error: $_" -ForegroundColor Red
}

# Optional: Check VM Running Status

Write-Host "Checking if the VM is running..." -ForegroundColor Magenta
Try {
    $vmInstanceView = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName -Status
    $vmPowerState = ($vmInstanceView.Statuses | Where-Object { $_.Code -like "PowerState/*" }).DisplayStatus
    Write-Host "VM Power State: $vmPowerState" -ForegroundColor Green
} Catch {
    Write-Host "Error retrieving VM power state. Error: $_" -ForegroundColor Red
}

Write-Host "Deployment validation completed." -ForegroundColor Blue