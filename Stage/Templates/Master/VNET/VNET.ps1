$rg = "ARM-AC-Demo"

New-AzResourceGroupDeployment -Name "new-vm-vnet" -ResourceGroupName $rg -TemplateFile "Test2/test2.json" -TemplateParameterFile "Test2/test2.parameters.json"