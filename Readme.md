# Project README: Environment Configuration for Internet Sites

## Table of Contents

1. [Project Description](#project-description)
2. [CI/CD](#cicd)
3. [Prerequisites](#prerequisites)
4. [Folder list](#folder-list)
5. [Installation and Configuration GCP](#installation-and-configuration-gce)
6. [Installation and Configuration GKE](#installation-and-configuration-gke)
7. [Installation and Configuration Vagrant](#installation-and-configuration-Vagrant)
8. [Installation and Configuration Static page (bucket)](#installation-and-configuration-static-page-bucket)
9. [Secrets](#secrets)

## Project Description
The goal of this project is to demonstrate the capability of configuring environments for hosting internet sites. Currently, there is a "VM" folder that contains instructions to automatically create a Virtual Machine (VM) on Google Cloud Platform (GCP), download an operating system image, and launch a website accessible from the internet. 

- GCE folder: Contains instructions to automatically create a Virtual Machine (VM) on Google Compute Engine (GCE), download an operating system image, and launch a website. This environment configuration checks if the docker image is up to date
- GKE folder: Demonstrates the setup of a Kubernetes cluster using Google Kubernetes Engine (GKE) for hosting containerized website.

## CI/CD
CI/CD pipelines have been set up using GitHub Actions. Any change in the repository triggers the pipeline to start, resulting in the creation of a new Docker image that is then published to Docker Hub

## Prerequisites
To install and configure this project, you need to meet the following prerequisites:

1. A Google Cloud Platform (GCP) account with the appropriate permissions for creating and managing virtual machines.
2. A GCP API key that allows the creation of virtual machines.

## Installation and Configuration GCE
### To run this configuration you must have ansible, terraform installed
### You need an API key for GCE and ssh key
1. Clone this project to your local machine:
   ```shell
   git clone
2. Copy GCP API key to main folder
3. Navigate to folder with setup.
     ```shell
    cd GCE/infra
4. Run bash script
     ```shell
    bash RUN.bash
5. Enter the password for Ansible Vault when needed
6. To connect to the page, open a web browser and enter:
    ```shell
    http://YOUR_MACHINE_IP

## Installation and Configuration GKE
### To run this configuration you must have kubernetes, terraform installed

1. Clone this project to your local machine:
   ```shell
   git clone
2. Copy GCP API key to main folder
3. Navigate to folder with setup.
     ```shell
    cd GKE/infra
4. Run bash script
     ```shell
    bash RUN.bash
5. Log in to the GCP Console:
6. Navigate to the "Kubernetes Engine" Section
7. Find my-gke-cluster
8. Go to the "Services & Ingress" Tab
9. Locate the Public IP Address
    In the "Services & Ingress" section, you will find your Load Balancer along with its public IP address. It will be displayed next to the service name. Click on it to get more details.
10. Connect to the page
    ```shell
    http://IP_address

### Installation and Configuration GKE
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
    http://VirtualMachine_IP_address

## Secrets
admin acconut password - admin  
ansible valut password - password

## Installation and Configuration Static page (bucket)
### To run this configuration you must have terrafrom installed
1. Clone this project to your local machine:
   ```shell
   git clone
2. Copy GCP API key to main folder
3. Navigate to folder with setup.
     ```shell
    cd Static
4. Run bash script
     ```shell
    bash RUN.bash
5. URL to page is:  
    https://storage.googleapis.com/my_uniqe_devops_static_name/index.html
