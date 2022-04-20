$rg = "AC-ARM"

# New-AzResourceGroup -Name $rg -Location "westeurope" -Force

New-AzResourceGroupDeployment -Name "adnane-des-deploy" -ResourceGroupName $rg -TemplateFile "02-des.json" -TemplateParameterFile "02-des.parameters.json"