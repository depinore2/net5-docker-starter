FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

# Register microsoft repository with ubuntu
RUN apt-get update
RUN apt-get install wget apt-transport-https software-properties-common -y
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb

# download powershell and dotnet sdk
RUN apt-get update
RUN apt-get install -y dotnet-sdk-5.0 powershell

# install docker CLI tooling so that I can create docker images inside of my development container.
RUN apt-get install docker.io -y

# install SSH tools
RUN apt-get install ssh -y