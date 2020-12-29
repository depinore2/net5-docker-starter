import-module "$psscriptroot/../../automation/launchJson.psm1"

$projname = (get-childitem "$psscriptroot/../*.csproj")[0].BaseName;
docker rm /$projname -f >$null 2>&1;
if($lastExitCode -eq 0) {
    Write-Output "Removed old $projname container that was already there."
}

############# CHANGE THE FOLLOWING LINE TO CHANGE HOW YOUR CONTAINER IS RUN #############

docker run -p 80:80 --name $projname -d $projname;

#########################################################################################

$newContainer = & "$psscriptroot/getContainers.ps1" | where name -eq "/$projname";

if($newContainer) {
    Write-Host "New Container [$projname] created."
    $ipaddress = $newContainer.NetworkSettings.ipAddress;
    Write-Host "[$projname] has IP $ipaddress"
    
    if((test-path "$psscriptroot/../../.vscode/launch.json")) {
        Write-Host "Updating your .vscode file to reflect your container's IP address..."
        Set-BindIpAddress $projName $ipaddress;
    }
}
else {
    throw "Unable to find container $projname."
}