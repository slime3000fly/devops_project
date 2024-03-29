# Project README: Environment Configuration for Internet Sites

## Table of Contents

1. [Project Description](#project-description)
2. [CI/CD](#cicd)
3. [Prerequisites](#prerequisites)
4. [Folder list](#folder-list)
5. [Installation and Configuration GCP](#installation-and-configuration-gce)
6. [Installation and Configuration GKE](#installation-and-configuration-gke)
7. [Installation and Configuration Static page (bucket)](#installation-and-configuration-static-page-bucket)
8. [Secrets](#secrets)

## Project Description
- GCE folder: Contains instructions to automatically create a Virtual Machine (VM) on Google Compute Engine (GCE), download an operating system image, and launch a website. This environment configuration checks if the docker image is up to date
- GKE folder: Demonstrates the setup of a Kubernetes cluster using Google Kubernetes Engine (GKE) for hosting containerized website.

## CI/CD
CI/CD pipelines have been set up using GitHub Actions. Any change in the repository triggers the pipeline to start, resulting in the creation of a new Docker image that is then published to Docker Hub

## Prerequisites
To install and configure project in GoogleCloud file, you need to meet the following prerequisites:

1. A Google Cloud Platform (GCP) account with the appropriate permissions for creating and managing virtual machines.
2. A GCP API key in GoogleCloud file that allows the creation of virtual machines.

## Folder list
1. [GCE](#installation-and-Configuration-GCE)
2. [GKE](##installation-and-Configuration-GKE)
3. [Static](##Installation-and-Configuration-Static-page-(bucket))

## Folders
### Installation and Configuration GCE
#### To run this configuration you must have ansible, terraform installed
#### You need an API key for GCE and ssh key in ~/.ssh/

1. Clone this project to your local machine:
   ```shell
   git clone
2. Copy GCP API key to main folder
3. Navigate to folder with setup.
     ```shell
    cd GoogleCloud/GCE/infra
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
    cd GoogleCloud/GKE/infra
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

## Secrets
admin acconut password - admin  
ansible valut password - password

## Knowledge Base:
To reference a file from the parent directory in a Dockerfile, use the following approach:  
```docker build -t <some tag> -f <dir/dir/Dockerfile> .```  
in this case, the context of the docker will be switched to the parent directory and accessible for ADD and COPY