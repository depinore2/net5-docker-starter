param([Parameter(Mandatory=$true)][string]$csprojName)

import-module "$psscriptroot/launchJson.psm1"

$csProjectPath = "$psscriptroot/../$csprojname";
$launchjsonPath =  "$psscriptroot/../.vscode/launch.json"

if(!(test-path "$psscriptroot/../$csprojName")) {
    throw "Expected to find a project folder at $((resolve-path "$psscriptroot/..").Path)/$csprojName, matching the name of the project provided."
}
else {
    & "$psscriptroot/init.ps1"
    $launchJson = gc $launchJsonPath -raw | convertfrom-json
    $desiredConfigurationName = "$csprojName Attach"
    $matchingConfigurationProfile = $launchJson.configurations | where name -eq $desiredConfigurationName;

    if(!($matchingConfigurationProfile)) {
        $projectConfiguration = (gc "$psscriptroot/launch_configuration.json").Replace('{{PROJECTNAME}}', $csprojName) | convertfrom-json -depth 99;
        $launchJson.configurations += $projectConfiguration;
        $launchJson | convertto-json -depth 99 | Out-File $launchJsonPath;

        Write-Output "Added a new debug configuration `"$desiredConfigurationName`"."
    }

    copy-item -path "$psscriptroot/automation" -destination $csprojectpath -force -recurse
    (gc "$csprojectpath/automation/start.sh" -raw).Replace('{{PROJECTNAME}}', $csprojName) | Out-File "$csprojectpath/automation/start.sh"
}