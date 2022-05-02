$rg = "ARM-AC-Demo"
New-AzResourceGroup -Name $rg -Location "westeurope" -Force

New-AzResourceGroupDeployment -Name "new-rg-storage-test" -ResourceGroupName $rg -TemplateFile "Testing/test.json" -TemplateParameterFile "Testing/test.parameters.json"