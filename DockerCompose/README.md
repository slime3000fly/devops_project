# Movie Recommendations App

## Table of Contents

1. [Project Description](#project-description)
2. [Components](#components)
3. [Architecture](#architecture)
4. [Knowledge Base](#knowledge-base)

## Project Description:
This project utilizes an application from K8S file  
The Movie Recommendations App project is a comprehensive microservices-based solution,<br /> 
configured in a Kubernetes cluster, that allows users to receive personalized movie recommendations. <br />
The app consists of three main components: backend, frontend and MongoDB database.

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
