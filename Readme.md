# Project README: Environment Configuration for Internet Sites

## Table of Contents

1. [Project Description](#project-description)
2. [CI/CD](#cicd)
4. [Folder list](#folder-list)
5. [Installation and Configuration Vagrant](#installation-and-configuration-Vagrant)

## Project Description
The "DevOps Project" repository serves as a comprehensive collection of configurations and setups for various DevOps tools and environments. It encompasses configurations for Google Compute Engine (GCE), Google Kubernetes Engine (GKE), as well as Vagrant setups etc.

## CI/CD
CI/CD pipelines have been set up using GitHub Actions. Any change in the repository triggers the pipeline to start, resulting in the creation of a new Docker image that is then published to Docker Hub

## Folder list
1. [GoogleCloud](GoogleCloud/README.md)
3. [Vagrant](##installation-and-Configuration-Vagrant)
4. [K8S](K8S/README.md)

## Folders
### Installation and Configuration Vagrant
#### To run this configuration you must have ansible, vagrant installed

1. Clone this project to your local machine:
   ```shell
   git clone
2. Navigate to folder with setup.
     ```shell
    cd Vagrant/infra
4. Type command
     ```shell
    vagrant up
5. Connect to the page
   ```shell
    http://VirtualMachine_IP_address:8080


If you want to see metric go to:
   ```shell
    http://VirtualMachine_IP_address:3000
   ```
