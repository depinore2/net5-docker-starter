$sshFolder = "$psscriptroot/../_ssh"
mkdir -p $sshfolder
get-childitem "$sshfolder/debug*" | remove-item
ssh-keygen -f "$sshfolder/debug" -N '""'