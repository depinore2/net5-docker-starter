& "$psscriptroot/genkey.ps1"

$projectFolder = (resolve-path "$psscriptroot/..").Path
$projName = (get-childitem "$projectFolder/*.csproj")[0].BaseName;

$dotnetCommand = "dotnet publish `"$projectFolder/$projName.csproj`" -o `"$projectFolder/_artifacts`""
$dockerCommand = "docker build $projectFolder -t $($projName.ToLower()) -f `"$psscriptroot/Dockerfile_debug`""

write-host $dotnetCommand
iex $dotnetCommand

Write-Host $dockerCommand
iex $dockerCommand
