$launchJsonPath = "$psscriptroot/../.vscode/launch.json"

function Get-LaunchJson() {
    if(test-path $launchJsonPath) {
        gc $launchjsonPath | convertfrom-json -depth 99
    }
}
function Save-LaunchJson($content) {
    if(test-path $launchJsonPath) {
        $content | convertto-json -depth 99 | out-file $launchJsonPath
    }
    else {
        Write-Output "Unable to find launch.json at $launchJsonPath. Aborting."
    }
}
function Get-ConfigName($projName) {
    "$projName Attach"
}
function Set-BindIpAddress([string]$projName, [string]$ipAddress) {
    $launchjson = get-launchjson;
    if($launchJson) {
        $config = $launchJson.configurations | where name -eq (get-configname $projName);
        if($config) {
            $pipeArgs = $config.pipeTransport.pipeArgs;
            for($i = 0; $i -lt $pipeArgs.length; $i++) {
                if($pipeArgs[$i] -like 'root@*') {
                    $pipeArgs[$i] = "root@$ipAddress"
                }
            }
            Save-LaunchJson $launchJson;
        }
        else {
            Write-Error "Unable to find configuration profile that matches '$(get-configname $projname).  Aborting."
        }
    }
    else {
        Write-Error "Unable to find launch.json file at $launchJsonPath. Aborting."
    }
}