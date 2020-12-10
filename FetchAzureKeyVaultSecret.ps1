# This script will pull the secret vaule from keyvault using Azure Service principal ID and Secret

$username = "your_Service_Principal_ID"

$password = "your_Service_Principal_Secret"

$secstr = New-Object -TypeName System.Security.SecureString

$password.ToCharArray() | ForEach-Object {$secstr.AppendChar($_)}

$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $secstr

Connect-AzAccount -ServicePrincipal -Credential $cred -Tenant Tenant_ID

$secret_test_vaule = (Get-AzKeyVaultSecret -VaultName Vault_Name -Name Secret_Name).SecretValueText
