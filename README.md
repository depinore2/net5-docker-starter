### .NET Container Example ###

Root-level Dockerfile is for VS Code Development Container.

`testapi` is an example of a webapi project with automation written for remote debugging into the webapi container.
SSH and VSDBG must be configured in order to allow for the "remote debugging" capabilities to work on a linux container.  The scripts in the automation folders take care of that for you.

More info here: https://github.com/OmniSharp/omnisharp-vscode/wiki/Attaching-to-remote-processes

All scripts must be run in a `pwsh` shell.

## Initializing a Project ##
When adding a new project to this repo, make sure to place it at the same level as where testapi is now. From there, run `./automation/initproject.ps1`.  For example to create the testapi project, I ran: 
```
dotnet new webapi --name testapi; 
./automation/initproject.ps1 testapi;
```

`initproject` will create a debugger profile for you and add some automation scripts in the project folder.

## Interacting With a Project ##
*All of the following docs are for interacting with automation at the project level.  This means that all commands are against the automation folder in the project, and not to be confused by the top-level automation folder.*

### Building ###

To build your dotnet application and place it into a non-prod, debuggable container, run `./automation/build.ps1`.  

This will build your .net and place it in a container whose name is the same as your project folder name.

### Running ###

To run an instance of your project, run `./automation/run.ps1`.  This will run `docker run`, capture the IP address assigned to the container, and automatically update your debug profile to point to that new IP.

By default, your container's ports will be open only to your development container.  If you would like to bind the ports to one of your containers to your physical machine, change the arguments passed to `docker run` in the `./automation/run.ps1`.

A common scenario is exposing port 80 and/or 443 so that you can use your physical computer's browser to interact with your application.

For that, you would add the arguments: `-p 80:80 -p 443:443` to the `docker run` command.

For more information on exposing ports, refer to this: https://docs.docker.com/engine/reference/commandline/run/#publish-or-expose-port--p---expose

### Debugging ###

Debugging code in a container is in many ways just like debugging code on a remote machine.  For Omnisharp, which is the VS Code Extension used for C# development, it uses SSH to communicate back and forth between your editor and your running application.

There should be a debug profile automatically generated for you by the automation in this solution, which configures omnisharp to connect to your container via SSH.

Make sure you already started your container, select the appropriate debug profile for the container you want to attach to, and click Debug.

For more information on how remote debugging works with Omnisharp, refer to this: https://github.com/OmniSharp/omnisharp-vscode/wiki/Attaching-to-remote-processes

To see how this particular solution implements the above documentation, refer to 