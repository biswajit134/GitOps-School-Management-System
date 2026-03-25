<h1 align="center">
    SCHOOL MANAGEMENT SYSTEM
</h1>

<h3 align="center">
Streamline school management, class organization, and add students and faculty.<br>
Seamlessly track attendance, assess performance, and provide feedback. <br>
Access records, view marks, and communicate effortlessly.
</h3>

# About

The School Management System is a web-based application built using the MERN (MongoDB, Express.js, React.js, Node.js) stack. It aims to streamline school management, class organization, and facilitate communication between students, teachers, and administrators.

## Features

- **User Roles:** The system supports three user roles: Admin, Teacher, and Student. Each role has specific functionalities and access levels.

- **Admin Dashboard:** Administrators can add new students and teachers, create classes and subjects, manage user accounts, and oversee system settings.

- **Attendance Tracking:** Teachers can easily take attendance for their classes, mark students as present or absent, and generate attendance reports.

- **Performance Assessment:** Teachers can assess students' performance by providing marks and feedback. Students can view their marks and track their progress over time.

- **Data Visualization:** Students can visualize their performance data through interactive charts and tables, helping them understand their academic performance at a glance.

- **Communication:** Users can communicate effortlessly through the system. Teachers can send messages to students and vice versa, promoting effective communication and collaboration.

## Technologies Used

- Frontend: React.js, Material UI, Redux
- Backend: Node.js, Express.js
- Database: MongoDB

<br>
<h1 align="center">♾️ DevOps Implementations with GitOps principle</h1>


![image](https://img.shields.io/badge/Microsoft%20Azure-0078D4?style=for-the-badge&logo=Microsoft%20Azure&logoColor=white)  ![image](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=Docker&logoColor=white)  ![image](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=Kubernetes&logoColor=white)   ![image](https://img.shields.io/badge/Helm-0F1689?style=for-the-badge&logo=Helm&logoColor=white)  ![image](https://img.shields.io/badge/Argo-EF7B4D?style=for-the-badge&logo=Argo&logoColor=white)   ![image](https://img.shields.io/badge/GitHub%20Actions-2088FF?style=for-the-badge&logo=GitHub%20Actions&logoColor=white)  ![image](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=Terraform&logoColor=white)  ![image](https://img.shields.io/badge/SonarQube-4E9BCD?style=for-the-badge&logo=SonarQube&logoColor=white)  ![image](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=Git&logoColor=white)

This repository outlines the end-to-end automation and infrastructure-as-code (IaC) practices used to deploy the School Management System. The architecture follows GitOps principles, ensuring that the state of the Kubernetes cluster matches the configuration stored in Git.

## Project Priview
![image](https://github.com/biswajit134/GitOps-School-Management-System/blob/main/SS/Recording%202026-03-24%20213853+00-00-00.000-00-05-21.133.gif?raw=true)

## 🏗 High-Level Architecture
The pipeline is divided into two main stages: Continuous Integration (CI) and Continuous Deployment (CD) via GitOps.

![image](https://github.com/biswajit134/GitOps-School-Management-System/blob/main/SS/Screenshot%202026-03-25%20033439.png?raw=true)


 1. **Code Commit:** Developer pushes code to GitHub.
 2. **CI Pipeline (GitHub Actions/Jenkins):**
      * Static Code Analysis (SonarQube).

      * Unit Testing (Jest).

      * Software Composition Analysis (Trivy).

      * Docker Image Build & Push to Docker Hub/ECR.
3. **Manifest Update:** The CI pipeline updates the Kubernetes manifest repository with the new image tag.

4. **CD Pipeline (ArgoCD):** ArgoCD detects the change in the manifest repo and synchronizes the state to the AKS cluster

## 🛠 Tech Stack
| Category | Tools Used |
| -------- | ---------- |
|IaC       |Terraform
|Terraform State Management | HashiCorp Cloud Platform
| CI/CD Automation | GitHub Actions |
| GitOps Controller | ArgoCD |
| Containerization | Docker |
| Orchestration |Kubernetes|
|Managed Kubernetes Providers| Azure Kubernetes Service (AKS)|
|Cloud Provider|Azure
Static Analysis|SonarQube
Security Scanning|Trivy
Artifact Repo	|Docker Hub

## 🚀 DevOps Pipeline Details
1. **Continuous Integration (CI):**
    The CI workflow is defined in .github/workflows/. Key stages include:

    * Compile & Test: Uses Maven to ensure code quality and functional correctness.

    * Security Gate: Scans for vulnerabilities in dependencies and the Dockerfile.

    * Quality Gate: SonarQube analysis to maintain clean code standards.

    * Image Build & Push: Generates a lightweight Docker image using multi-stage builds and pushes it to the registry with a unique build ID.

2. **Continuous Delivery (GitOps):**
We use ArgoCD to manage the deployment.

    * **Pull Model:** ArgoCD monitors the /k8s_manifest directory in this repo.

    * **Self-Healing:** If someone manually edits a deployment in the cluster, ArgoCD will automatically revert it to match the Git configuration.

    * **Automated Sync:** As soon as the CI pipeline updates the image version in the deployment YAML, ArgoCD triggers a rolling update in the cluster.

## 📦 Kubernetes Resources
The project includes the following manifests under the k8s_manifest  directory:

  * **deployment.yaml:** Defines the desired state (replicas, image, resources).

  * **service.yaml:** Exposes the application using a LoadBalancer or ClusterIP.

  * **ingress.yaml:** (Optional) Handles external routing and SSL termination.

  * **configmap.yaml & secrets.yaml:**  Manages environment variables and sensitive database credentials.

  ## 🔧 Setup & Installation

 **Prerequisites**

  * **Git:** For the versioning the code
  * **azure CLI:** Get azure cloud credentials
  * **Terraform:** Make Infrastructure 

## STEPS

 ### 1. Create MongoDB free cluster in mongoDB atlas platfrom and save mongoDB connection string 

 ![image](https://github.com/biswajit134/GitOps-School-Management-System/blob/main/SS/Screenshot%202026-03-24%20214001.png?raw=true)

 ### 2. Create Dockerfile for frontend and backend using multistage docker build

  frontend/Dockerfile :
   ```
   FROM node:20-alpine AS base
WORKDIR /app
COPY package*.json ./
RUN npm ci

FROM node:alpine
WORKDIR /app
COPY --from=base /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
CMD [ "npm", "start" ]
```
backend/Dockerfile :
```
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
EXPOSE 5000
CMD ["npm", "start"]
```

### 3. Create .github/workflows/dockerimagebuild.yml make CI part using Github Actions.
```
name:  build docker image and push to dockerhub
on:
    push:
        branches:
            - main
        paths-ignore:
            - "README.md"
            - ".github/**"
            - "k8s_manifest/**"
            - "terraform/**"
            - "argocd/**"
            - "temp_sms_frontend_manifest/**"
            - "SS/**"
    workflow_dispatch:
        
        
jobs:
    compile:
      runs-on: ubuntu-latest
      steps:
        - name: Checkout code
          uses: actions/checkout@v2
        - run: echo "Checked out code successful"


        - name: Set up node js
          uses: actions/setup-node@v4
          with:
            node-version: '20'

        - name: Frontend Compilation (syntax check)
          run: |
            cd frontend
            find . -name "*.js" -exec node --check {} +

        - name: Backend Compilation (syntax check)
          run: |
            cd backend
            find . -name "*.js" -exec node --check {} +





    #     # sonarQube analysis
    # sonarqube:
    #   needs: compile
    #   runs-on: ubuntu-latest
    #   steps:
    #   - uses: actions/checkout@v4
    #     with:
    #       # Disabling shallow clones is recommended for improving the relevancy of reporting
    #       fetch-depth: 0
    #   - name: SonarQube Scan
    #     uses: SonarSource/sonarcloud-github-action@master # Ex: v4.1.0 or sha1, See the latest version at https://github.com/marketplace/actions/official-sonarqube-scan
    #     env:
    #       SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
    #       GITHUB_TOKEN: ${{ secrets.GIT_TOKEN }}
        
    #     with:
    #       args: >
    #         -Dsonar.projectKey=GitOps-School-Management-System


    #         -Dsonar.organization=biswajit134
     

    build:
        runs-on: ubuntu-latest
        needs: compile
        steps:
            - name: Checkout code
              uses: actions/checkout@v2
            - run: echo "Checked out code successful"

            - name: Log in to Docker Hub
              uses: docker/login-action@v1
              with:
                username: ${{ secrets.DOCKER_USERNAME }}
                password: ${{ secrets.DOCKER_PASSWORD }}


            - name: docker build images
              run: |
                docker build -t biswajit134/sms_frontend:latest ./frontend
                docker build -t biswajit134/sms_backend:latest ./backend
                echo "Docker images built successfully"
              
            - name: Push images to Docker Hub
              run: |
                docker push biswajit134/sms_frontend:latest
                docker push biswajit134/sms_backend:latest
                echo "Docker images pushed to Docker Hub successfully"
    

```

### 4. PUSH CI code into Github and CI Pipeline trigger, run respective jobs

 * Compile
 * SonarQube Analisys
 * Docker image Build
 * Docker image Push on Docker Hub




![image](https://github.com/biswajit134/GitOps-School-Management-System/blob/main/SS/Screenshot%202026-03-24%20152321.png?raw=true)


### 5. Use terraform for provision the AKS Cluster
[terraform](https://github.com/biswajit134/GitOps-School-Management-System/tree/main/terraform)

### 6. Use Terraform Cloud platfrom for terraform backend mantain terraform.tfstate file and also mantain GitOps principle

### 7. Deploy AKS Cluster in Azure 
<p> Create all resources accorting the terraform file </p>

![image](https://github.com/biswajit134/GitOps-School-Management-System/blob/main/SS/Screenshot%202026-03-24%20144554.png?raw=true)

* Namespaces

![image](https://github.com/biswajit134/GitOps-School-Management-System/blob/main/SS/Screenshot%202026-03-24%20144523.png?raw=true)

* Service 

![image](https://github.com/biswajit134/GitOps-School-Management-System/blob/main/SS/Screenshot%202026-03-24%20144453.png?raw=true)


### 8. ArgoCD Deployment

![image](https://github.com/biswajit134/GitOps-School-Management-System/blob/main/SS/Screenshot%202026-03-24%20144023.png?raw=true)

### 9. Project is live at LB URL

* Frontend
![image](https://github.com/biswajit134/GitOps-School-Management-System/blob/main/SS/Screenshot%202026-03-24%20213944.png?raw=true)

* Backend
![image](https://github.com/biswajit134/GitOps-School-Management-System/blob/main/SS/Screenshot%202026-03-24%20214023.png?raw=true)

* Database(MongoDB)
![image](https://github.com/biswajit134/GitOps-School-Management-System/blob/main/SS/Screenshot%202026-03-24%20214001.png?raw=true)
