
$agents = get-content  "C:\Users\keshav\Desktop\agents.txt"
$tag = "YOUR_TAG"
 
$personalToken = "YOUR PERSONAL ACCESS TOKEN"
Write-Host "Initialize Authentication context" -ForegroundColor Yellow
$token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($personalToken)"))
$header = @{ authorization = "Basic $token" }

foreach ($agent in $agents){

$rmOrgUrl = "https://your_org.visualstudio.com/project/_apis/distributedtask/deploymentgroups/group_id/targets?name=$agent&api-version=5.1-preview.1"

$content = Invoke-RestMethod -Uri $rmOrgUrl -Method Get -Headers $header -ContentType "application/json"

if (!($Content.value.tags.Contains($tag))){
write-Host $agent -ForegroundColor Green
$EditedTag = @()
$EditedTag += $Content.value.tags
$EditedTag += $tag

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
