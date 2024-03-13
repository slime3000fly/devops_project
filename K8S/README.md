# Movie Recommendations App

## Table of Contents
1. [Project Description](#project-description)
2. [Deployment](#Deployment)
3. [Components](#components)
4. [Architecture](#architecture)
5. [Knowledge Base](#knowledge-base)

## Project Description:
The Movie Recommendations App project is a comprehensive microservices-based solution,<br /> 
configured in a Kubernetes cluster, that allows users to receive personalized movie recommendations. <br />
The app consists of three main components: backend, frontend and MongoDB database.

## Deployment
You can deploy this project using kubernetes cluster and dployments or helm chart from file ```helm install --name robot-shop --namespace robot-shop .```

## Components:
  ### Backend:
  A microservice that handles the logic involved in recommending movies 
  Uses Kubernetes for container management, scaling and resource access management. 

  ### Frontend:
  User interface that allows users to browse and receive movie recommendations.
  Built on REACT technologies.

  ### MongoDB Database:
  A database that stores information about movies.
  Utilizes StatefulSet and persistent volume for increased reliability.

## Architecture:
The project uses microservices to easily scale and expand individual components.<br />
Communication between microservices is via HTTP protocols. The entire project is managed by a Kubernetes. container orchestrator.

## Knowledge Base:
- Deployment: Used for applications that aren't dependent on previous operations and<br />can have replaceable instances (e.g., backend, frontend).
- StatefulSet: Applied to applications that need to remember their previous state and<br />require unique, persistent identities (e.g., databases).
- RBAC and Secrets: RBAC (Role-Based Access Control) is employed for managing permissions within a Kubernetes cluster,<br /> including controlling access to secrets. Secrets contain sensitive information and are used to securely store confidential data,<br /> such as API keys or database credentials, for applications.
- Nginx allowing frontend to communicate with container in cluster
- Ngnix hack for static sites: ```error_page  405     =200 $uri;```