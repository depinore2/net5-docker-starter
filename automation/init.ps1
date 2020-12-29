$csProjectPath = "$psscriptroot/../$csprojname";
$launchjsonPath =  "$psscriptroot/../.vscode/launch.json"

if(!(test-path $launchjsonpath)) {
    Write-Host "Looks like you're missing a launch.json profile.  Creating one now..."
    mkdir -p "$psscriptroot/../.vscode"
    copy-item "$psscriptroot/launch.json" $launchjsonpath
}