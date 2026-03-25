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

## 🏗 High-Level Architecture
The pipeline is divided into two main stages: Continuous Integration (CI) and Continuous Deployment (CD) via GitOps.

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
|Backend | Terraform Cloud Platfrom
| CI/CD Automation | GitHub Actions |
| GitOps Controller | ArgoCD |
| Containerization | Docker |
| Orchestration |AKS|
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
