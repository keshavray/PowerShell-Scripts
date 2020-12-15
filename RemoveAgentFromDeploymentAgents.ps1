
$agents = get-content  C:\Users\keshav\Desktop\agents.txt

$tag = "YOUR TAG"
 

$personalToken = "YOUR PERSONAL ACCESS TOKEN"
Write-Host "Initialize Authentication context" -ForegroundColor Yellow
$token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($personalToken)"))
$header = @{ authorization = "Basic $token" }

foreach ($agent in $agents){

$rmOrgUrl = "https://YOUR_ORG.visualstudio.com/PROJECT/_apis/distributedtask/deploymentgroups/id/targets?name=$agent&api-version=5.1-preview.1"

$content = Invoke-RestMethod -Uri $rmOrgUrl -Method Get -Headers $header -ContentType "application/json"
if ($content.value.tags.contains($tag)){
write-Host $agent -ForegroundColor green
$EditedTag = @()
foreach ($item in $Content.value.tags){if($item -notmatch $tag){$EditedTag += $Item}}
$bodyObj=@(
@{
"tags"=@($EditedTag);
"id"=$content.value.id
}
)
$bodyJson=ConvertTo-Json $bodyObj -Depth 10
Invoke-RestMethod -Method PATCH -Uri $rmOrgUrl -ContentType "application/json" -Headers $header -Body $bodyJson | out-null
}
}
