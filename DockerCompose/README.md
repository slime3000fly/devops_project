# This folder contains a project that uses docker-compose technology 

# Table of Contents
1. [Movie Recommendations App](#movie_recommendations_app)
  1.1. [Project Description](#project-description)
  1.2. [Components](#components)
  1.3. [Architecture](#architecture)
  1.4. [Knowledge Base](#knowledge-base)
2. [Wordpress](#wordpress)
  2.1 [Project Description](#wordpress-project-description)

# Movie Recommendations App

## Project Description:
This project utilizes an application from a Kubernetes file.  
The Movie Recommendations App project is a comprehensive microservices-based solution,<br /> 
configured in a Kubernetes cluster, that allows users to receive personalized movie recommendations. <br />
The app consists of three main components: backend, frontend, and MongoDB database.

## Components:

  ### Backend:
  A microservice that handles the logic involved in recommending movies. 
  Uses Kubernetes for container management, scaling, and resource access management. 

  ### Frontend:
  User interface that allows users to browse and receive movie recommendations.
  Built on REACT technologies.

  ### MongoDB Database:
  A database that stores information about movies.
  Utilizes StatefulSet and persistent volume for increased reliability.

## Architecture:
The project uses microservices to easily scale and expand individual components.<br />
Communication between microservices is via HTTP protocols. The entire project is managed by a Kubernetes container orchestrator.

# Wordpress

## WordPress Project Description:
The WordPress project provides a custom Docker image for running WordPress on an Ubuntu base. By default, the WordPress instance is configured to use HTTPS for secure communication, and it utilizes a self-signed certificate to establish encrypted connections.
