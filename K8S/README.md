# Movie Recommendations App

## Description:
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

## Architecture:
The project uses microservices to easily scale and expand individual components.<br />
Communication between microservices is via HTTP protocols. The entire project is managed by a Kubernetes. container orchestrator.