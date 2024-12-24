# Microservices

This repository contains a deployment for flask app onto GCP GKE cluster (I know well how to do this with AWS but I took it as a challenge to do the task with Google Cloud as I saw the it's a preferred cloud provider at the JD), The repo contains the below:
1. Flask python app with Dockerfile to containrize the flask app
2. Terraform code for creating VPC, subnet, cluster and a way to deploy kubernetes resources.
3. Kubernetes manifests to create a deployment and a service.
4. Github action workflow to automate the deployment of this container into the GKE

### Overview

The workflow will run a Terraform code which will create a VPC, a Subnet and a cluster and configure a kubernetes provider just in case we decide to create k8s resources with terrafrom. a deployment with 1 replica will be created after cluster creation and exposed through service type LB. for sure in real production will need to add more replicas, auto-scaling group and another private subnet to secure our backend.
The workflow also configure Docker to use the gcloud command-line tool as a credential (secured in github secrets) for sure the repo should be private but here it's a demo.
It also get the GKE credentials so we can deploy to the cluster, build the Docker image, push the Docker image to Google Container Registry and deploy the Docker image to the GKE cluster

## Pre-requisites

1. Service Account on GCP with needed roles (JSON Credential saved in secrets).
2. GCR/docker repo to push the image to it.
3. Bucket to have the .tfstate file (Backend).

## Repository Structure

### Docker

**Dockerfile**
To containerize the Python application.

### terraform

**cluster.tf**
This file contains the GKE vpc, subnet and cluster configuration. in real projects we should seprate the vpc and subnet into a network folder and create a network module to be generic.

**app.tf**
Just in case we need to create the deployment and the service with terraform.

**provier.tf**
This contains the region which will be used by terraform to deploy the GCP resources

**variables.tf**
This contains the variables which I used in the code.

**terraform.tfvars**
To pass variables values.

### flask-app

**app folder**:  
This directory contains the flask app.

**run.py Modify**:  
File has been modified to include both host and port values.

**Requirements Modify**:  
File has been modified to include a `Werkzeug==2.2.3`. latest version of `Werkzeug` that comes with Python does not support the Flask version used in this project `Flask==2.2.2`, causing compatibility.
The version `Werkzeug==2.2.3` ensures the Flask app works as expected.

### Kubernetes-deployment

**deployment-def.yaml**: 
Used to create the deployment, container will use an image from GCR which built and uploaded with github workflow and exposing port 5000

**service-def.yaml**: 
This configuration contains the service used to explose the deployment externally, it uses service type loadbalancer which creates a loadbalancer on GCP.

### .github/workflows

**demo.yml** this contains the workflow which will be used to automate the build and the deployment of our application into the cluster.


## For test

curl http://34.58.177.80:5000:/users

**Expected output:**

StatusCode        : 200
StatusDescription : OK
Content           : [{"id":1,"name":"John Doe"},{"id":2,"name":"Jane Doe"}]

RawContent        : HTTP/1.1 200 OK
                    Connection: close
                    Content-Length: 56
                    Content-Type: application/json
                    Date: Mon, 23 Dec 2024 14:15:55 GMT
                    Server: Werkzeug/2.2.3 Python/3.13.1

                    [{"id":1,"name":"John Doe"},{"id":2...
Forms             : {}
Headers           : {[Connection, close], [Content-Length, 56], [Content-Type, application/json], [Date, Mon, 23 Dec 2024      
                    14:15:55 GMT]...}                                                                                          Images            : {}                                                                                                         InputFields       : {}                                                                                                         Links             : {}                                                                                                         
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 56

**************************************************************************

curl http://34.58.177.80:5000/products

**Expected output:**

StatusCode        : 200
StatusDescription : OK
Content           : [{"id":1,"name":"Laptop"},{"id":2,"name":"Smartphone"}]

RawContent        : HTTP/1.1 200 OK
                    Connection: close
                    Content-Length: 56
                    Content-Type: application/json
                    Date: Mon, 23 Dec 2024 14:16:37 GMT
                    Server: Werkzeug/2.2.3 Python/3.13.1

                    [{"id":1,"name":"Laptop"},{"id":2,"...
Forms             : {}
Headers           : {[Connection, close], [Content-Length, 56], [Content-Type, application/json], [Date, Mon, 23 Dec 2024      
                    14:16:37 GMT]...}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 56


