# Trend Store Application Deployment

This repository is my end-to-end DevOps deployment project for the **Trendify / Trend Store React application**.

The goal of the project was to take a ready React application, containerize it with Docker, provision AWS infrastructure with Terraform, deploy it to Kubernetes on AWS EKS, and automate the full build-push-deploy flow using Jenkins.

Application source given in the requirement:

```text
https://github.com/Vennilavanguvi/Trend.git
```

In my repository, the application is already available as a production build inside the `dist/` folder. The Docker container uses Nginx to serve this app on port `3000`.

## Project requirement summary

The project asked for:

- Clone the given React application.
- Dockerize the application.
- Run the application on port `3000`.
- Create AWS infrastructure using Terraform.
- Create VPC, IAM, EC2 with Jenkins, EKS, and related resources.
- Push the Docker image to DockerHub.
- Create Kubernetes deployment and service YAML files.
- Deploy the application to AWS EKS using Jenkins.
- Configure GitHub webhook for automatic Jenkins builds.
- Add monitoring or health-checking commands.
- Submit GitHub link, README, screenshots, and Kubernetes LoadBalancer DNS/ARN.

## Final project flow

This is the flow I followed:

```text
Application files
   |
   v
Docker image using Nginx
   |
   v
DockerHub repository
   |
   v
AWS infrastructure using Terraform
   |
   |-- VPC
   |-- EC2 Jenkins server
   |-- IAM roles/policies
   |-- EKS cluster
   `-- EKS worker node group
   |
   v
Jenkins CI/CD pipeline
   |
   |-- Clone GitHub repo
   |-- Build Docker image
   |-- Push image to DockerHub
   |-- Connect to EKS
   `-- Deploy Kubernetes YAML files
   |
   v
Application exposed using Kubernetes LoadBalancer
```

## Repository structure

```text
.
|-- dist/                     # Pre-built React production files
|-- Dockerfile                # Docker image for the application
|-- nginx.conf                # Nginx config to serve app on port 3000
|-- deployment.yaml           # Kubernetes Deployment
|-- service.yaml              # Kubernetes Service
|-- servicemonitor.yaml       # Prometheus ServiceMonitor for monitoring
|-- values.yaml               # Helm values for kube-prometheus-stack
|-- ingress.yaml              # ALB Ingress routing file
|-- jenkinsfile               # Jenkins declarative pipeline
|-- terraform/
|   |-- env/                  # Main Terraform environment
|   `-- modules/              # VPC, EC2, EKS, keypair and pod identity modules
|-- screenshots/              # Proof screenshots
|-- .gitignore
`-- .dockerignore
```

Important: I did not ignore the `dist/` folder because this project deploys the already-built React output. The Dockerfile copies `dist/` into the Nginx container.

## 1. Dockerizing the application

I created a Dockerfile using the official Nginx Alpine image.

The Dockerfile copies the `dist/` folder into the container and uses a custom `nginx.conf` file to serve the application on port `3000`.

```dockerfile
FROM nginx:stable-alpine

COPY dist/ /web/data/
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 3000
```

The Nginx config listens on port `3000`:

```nginx
server {
  listen 3000;
  root /web/data/;

  location / {
    try_files $uri $uri/ /index.html;
  }
}
```

Then I built the Docker image:

```bash
docker build -t trend-store-app:latest .
```

Proof:

![Docker image build](screenshots/Screenshot%202026-06-11%20160844.png)

After building the image, I ran the container locally and mapped container port `3000` to host port `3000`.

```bash
docker run -d --rm --name trend-store -p 3000:3000 trend-store-app:latest
docker ps
```

Proof:

![Docker container running](screenshots/Screenshot%202026-06-11%20161755.png)

Then I opened the application in the browser using:

```text
http://localhost:3000
```

Proof:

![Application running locally](screenshots/Screenshot%202026-06-11%20161919.png)

## 2. Pushing the image to DockerHub

After confirming the application was working locally, I tagged the image with my DockerHub repository name.

```bash
docker tag trend-store-app:latest joelrobinson791/trend-store-app:v1
docker images
```

Proof:

![Docker image tagged](screenshots/Screenshot%202026-06-11%20184900.png)

Then I pushed the image to DockerHub:

```bash
docker push joelrobinson791/trend-store-app:v1
```

Proof:

![Docker push command](screenshots/Screenshot%202026-06-11%20184848.png)

DockerHub repository proof:

![DockerHub repository](screenshots/Screenshot%202026-06-11%20184912.png)

In the final Jenkins pipeline, the image is pushed using both a unique commit-based tag and a readable tag like `latest`.

## 3. Provisioning AWS infrastructure with Terraform

I used Terraform to create the AWS infrastructure required for this project.

Terraform code is located inside:

```text
terraform/env
```

The main Terraform configuration calls reusable modules from:

```text
terraform/modules
```

The infrastructure includes:

- VPC
- Public subnets
- Private subnets
- Internet Gateway
- NAT Gateway
- EC2 instance for Jenkins
- Security group for Jenkins
- IAM role and policies
- EKS cluster
- EKS managed worker node group
- EKS add-ons
- Pod identity roles for EBS CSI and VPC CNI

I first reviewed the Terraform plan:

```bash
cd terraform/env
terraform init
terraform plan
```

Proof:

![Terraform plan](screenshots/Screenshot%202026-06-19%20130653.png)

The plan showed the AWS resources that Terraform was going to create:

![Terraform resource plan](screenshots/Screenshot%202026-06-21%20030443.png)

Then I applied the Terraform configuration:

```bash
terraform apply
```

During apply, Terraform created the EKS cluster and related resources:

![Terraform creating EKS](screenshots/Screenshot%202026-06-22%20111750.png)

![EKS still creating](screenshots/Screenshot%202026-06-22%20112348.png)

After Terraform completed, it showed the outputs for EC2, EKS, VPC, subnets, IAM roles, and other created resources.

Proof:

![Terraform apply complete](screenshots/Screenshot%202026-06-23%20120034.png)

![Terraform outputs](screenshots/Screenshot%202026-06-23%20120053.png)

## 4. Setting up Jenkins on EC2

Terraform created an EC2 instance for Jenkins. The Jenkins server was reachable on port `8080`.

I opened Jenkins in the browser:

```text
http://<jenkins-ec2-public-ip>:8080
```

The first screen was the Jenkins unlock screen.

Proof:

![Unlock Jenkins](screenshots/Screenshot%202026-06-23%20115431.png)

Then I installed the required Jenkins plugins.

Proof:

![Jenkins plugins installing](screenshots/Screenshot%202026-06-23%20121134.png)

I also installed the AWS Credentials plugin because the pipeline needs AWS credentials to connect Jenkins to EKS.

Proof:

![AWS credentials plugin](screenshots/Screenshot%202026-06-23%20124718.png)

## 5. Preparing the Jenkins server for Docker builds

Since Jenkins needs to build Docker images, Docker must be installed on the Jenkins EC2 server.

I installed Docker:

```bash
sudo apt install docker.io -y
```

Proof:

![Docker installation on Jenkins server](screenshots/Screenshot%202026-06-23%20143101.png)

Then I added both the `jenkins` user and `ubuntu` user to the Docker group:

```bash
sudo usermod -aG docker jenkins
sudo usermod -aG docker ubuntu
id jenkins
```

At first, Jenkins could not access the Docker socket. After restarting Jenkins, Docker commands were able to run from the Jenkins user context.

```bash
sudo systemctl restart jenkins
```

Proof:

![Docker permission fix](screenshots/Screenshot%202026-06-23%20144647.png)

## 6. Configuring Jenkins credentials

I created credentials in Jenkins so that sensitive values are not written directly inside the Jenkinsfile.

Credentials used:

| Credential ID | Purpose |
| --- | --- |
| `git-access` | Allows Jenkins to clone the GitHub repository |
| `jenkins` | AWS access key and secret key used by Jenkins to connect to AWS/EKS |

Proof:

![Jenkins credentials](screenshots/Screenshot%202026-06-23%20214659.png)

The AWS credential is used in the Jenkinsfile inside this block:

```groovy
withCredentials([
    aws(
        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
        credentialsId: 'jenkins',
        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
    )
]) {
    // AWS CLI and kubectl commands run here
}
```

This does not show an `aws login` command because AWS CLI automatically reads `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` from environment variables.

## 7. Configuring Jenkins pipeline parameters

I made the pipeline parameterized so I can reuse it without hardcoding every value.

Parameters used:

| Parameter | Type | Purpose |
| --- | --- | --- |
| `DOCKER_TOKEN` | Password parameter | DockerHub access token |
| `DOCKER_USERNAME` | String parameter | DockerHub username |
| `IMAGE_NAME` | String parameter | Docker image/repository name |
| `VERSION` | String parameter | Image tag, for example `latest` |
| `NAMESPACE` | String parameter | Kubernetes namespace |
| `AWS_REGION` | String parameter | AWS region |
| `EKS_CLUSTER_NAME` | String parameter | EKS cluster name |

Proof:

![Jenkins parameters](screenshots/Screenshot%202026-06-23%20214543.png)

## 8. Kubernetes deployment files

I created two Kubernetes YAML files.

### deployment.yaml

This file creates two replicas of the application pod.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: trend-store
spec:
  replicas: 2
  selector:
    matchLabels:
      app: trend-store
  template:
    metadata:
      labels:
        app: trend-store
    spec:
      containers:
        - name: trend-store
          image: joelrobinson791/trend-store-app:latest
          ports:
            - containerPort: 3000
```

### service.yaml

This file exposes the application using an AWS LoadBalancer.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: trend-store-service
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
spec:
  selector:
    app: trend-store
  ports:
    - protocol: TCP
      port: 3000
      targetPort: 3000
  type: LoadBalancer
```

I verified Kubernetes namespaces using:

```bash
kubectl get ns
```

Proof:

![Kubernetes namespaces](screenshots/Screenshot%202026-06-23%20152839.png)

## 9. Jenkins CI/CD pipeline

The Jenkinsfile is a declarative pipeline with these stages:

```text
Checkout
Pre-Build
Build
Post-Build
Deploy to EKS
```

### Checkout

Jenkins clones the GitHub repository:

```groovy
git(
    branch: 'main',
    credentialsId: 'git-access',
    url: 'https://github.com/Joel-563/trend-store.git'
)
```

### Pre-Build

The pipeline creates a short Git commit hash:

```bash
git rev-parse --short=7 HEAD
```

Then it prepares Docker image names:

```groovy
env.IMAGE_URI_UNIQUE =
    "${params.DOCKER_USERNAME}/${params.IMAGE_NAME}:${env.IMAGE_TAG}-${params.VERSION}"

env.IMAGE_URI_READABLE =
    "${params.DOCKER_USERNAME}/${params.IMAGE_NAME}:${params.VERSION}"
```

Then Jenkins logs in to DockerHub:

```bash
printf "%s" "$DOCKER_TOKEN" |
    docker login \
        --username "$DOCKER_USERNAME" \
        --password-stdin
```

### Build

Jenkins builds the Docker image:

```bash
docker build --tag "$IMAGE_URI_UNIQUE" .
```

### Post-Build

Jenkins tags and pushes the image:

```bash
docker tag "$IMAGE_URI_UNIQUE" "$IMAGE_URI_READABLE"
docker push "$IMAGE_URI_UNIQUE"
docker push "$IMAGE_URI_READABLE"
```

### Deploy to EKS

Jenkins connects to EKS and deploys the Kubernetes files:

```bash
aws eks update-kubeconfig \
    --name "$EKS_CLUSTER_NAME" \
    --region "$AWS_REGION"

kubectl apply -n "$NAMESPACE" -f deployment.yaml
kubectl apply -n "$NAMESPACE" -f service.yaml

kubectl rollout restart \
    -n "$NAMESPACE" \
    deployment/trend-store

kubectl rollout status \
    -n "$NAMESPACE" \
    deployment/trend-store \
    --timeout=2m
```

The pipeline also fetches and prints the LoadBalancer DNS:

```bash
kubectl get service trend-store-service \
  -n "$NAMESPACE" \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

## 10. Fixing pipeline issues

During the first deploy attempt, the pipeline failed because the EKS cluster name was not passed correctly.

Proof:

![Jenkins cluster not found error](screenshots/Screenshot%202026-06-23%20213524.png)

After correcting the parameter/configuration, the pipeline completed successfully.

Proof:

![Jenkins successful pipeline](screenshots/Screenshot%202026-06-23%20214031.png)

The successful Jenkins run showed all stages completed:

- Checkout SCM
- Checkout
- Pre-Build
- Build
- Post-Build
- Deploy to EKS

It also printed the LoadBalancer DNS and the final application URL.

## 11. Final deployed application

After Jenkins deployed the application to EKS, Kubernetes created an AWS LoadBalancer.

The pipeline printed an application URL like this:

```text
http://<load-balancer-dns>:3000
```

Final application proof:

![Application deployed through LoadBalancer](screenshots/Screenshot%202026-06-23%20214227.png)

The application is running successfully through the AWS LoadBalancer on port `3000`.

## 12. GitHub webhook automation

For automatic builds, I configured GitHub webhook integration with Jenkins.

GitHub webhook URL format:

```text
http://<jenkins-public-ip>:8080/github-webhook/
```

In Jenkins, the pipeline job should enable:

```text
GitHub hook trigger for GITScm polling
```

After this, whenever code is pushed to GitHub, Jenkins can automatically start the CI/CD pipeline.

## 13. Monitoring and health checks

For monitoring, I used Prometheus and Grafana.

The monitoring stack used for verification was an existing Prometheus setup that sends data to remote Grafana through Thanos. This allowed me to confirm that Kubernetes deployment metrics from the application namespace were being collected and displayed in Grafana.

I also added the Helm chart installation commands below so the same monitoring stack can be installed from scratch using the `kube-prometheus-stack` chart.

### Prometheus and Grafana installation using Helm

Add the Prometheus community Helm repository:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

Create a namespace for monitoring:

```bash
kubectl create namespace monitoring
```

Install Prometheus and Grafana using Helm:

```bash
helm upgrade --install prom prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
```

If custom values are required, the chart can be installed with `values.yaml`:

```bash
helm upgrade --install prom prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  -f values.yaml
```

Check the monitoring pods:

```bash
kubectl get pods -n monitoring
```

Check the monitoring services:

```bash
kubectl get svc -n monitoring
```

### Application monitoring approach

For this project, I monitored whether the application deployment was healthy by using Kubernetes metrics collected through `kube-state-metrics`.

The main PromQL query used was:

```promql
kube_deployment_status_replicas_available{namespace="test", deployment="trend-store"}
```

This query returns the number of available replicas for the `trend-store` deployment.

Expected value:

```text
2
```

If the value becomes `0`, it means no application pods are available.

Alert query:

```promql
kube_deployment_status_replicas_available{namespace="test", deployment="trend-store"} < 1
```

I also used this query to compare the desired replica count:

```promql
kube_deployment_spec_replicas{namespace="test", deployment="trend-store"}
```

### Verifying that Prometheus is receiving data

To confirm that Prometheus was receiving scrape data, I used:

```promql
up
```

For Kubernetes deployment metrics, I verified the `trend-store` deployment directly:

```promql
kube_deployment_status_replicas_available{namespace="test", deployment="trend-store"}
```

Proof of the Grafana alert query:

![Grafana alert query](screenshots/Screenshot%202026-06-29%20182232.png)

Proof of available replica metrics in Grafana:

![Grafana replica count dashboard](screenshots/Screenshot%202026-06-29%20182519.png)

### Testing monitoring by deleting one pod

To test whether Grafana could show a change in application availability, I deleted one application pod:

```bash
kubectl delete pod trend-store-799944596b-5zhks -n test
```

Proof:

![Deleting one application pod](screenshots/Screenshot%202026-06-29%20182627.png)

After the pod was deleted, the deployment temporarily dropped from two available replicas to one available replica. Kubernetes then recreated the pod and the graph returned back to two replicas.

Proof:

![Grafana replica drop and recovery](screenshots/Screenshot%202026-06-29%20182741.png)

### Basic Kubernetes health checks

For basic monitoring and troubleshooting, I also used Kubernetes commands.

Check cluster nodes:

```bash
kubectl get nodes
```

Check all pods:

```bash
kubectl get pods -A
```

Check namespace:

```bash
kubectl get ns
```

Check service and LoadBalancer:

```bash
kubectl get service -n <namespace>
```

Check pod logs:

```bash
kubectl logs -n <namespace> <pod-name>
```

Describe a service or pod:

```bash
kubectl describe service trend-store-service -n <namespace>
kubectl describe pod -n <namespace> <pod-name>
```

I also verified EKS DNS resolution using `nslookup`.

Proof:

![EKS DNS check](screenshots/Screenshot%202026-06-23%20151323.png)

## 14. How to get LoadBalancer DNS and ARN

Get the LoadBalancer DNS:

```bash
kubectl get service trend-store-service \
  -n <namespace> \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

Get the LoadBalancer ARN using AWS CLI:

```bash
LB_DNS=$(kubectl get service trend-store-service \
  -n <namespace> \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

aws elbv2 describe-load-balancers \
  --region <aws-region> \
  --query "LoadBalancers[?DNSName=='${LB_DNS}'].LoadBalancerArn" \
  --output text
```

If the command does not return the ARN, open the AWS Console:

```text
EC2 -> Load Balancers -> Search using DNS name -> Copy ARN
```

## Important files

| File | Purpose |
| --- | --- |
| `Dockerfile` | Builds the application container using Nginx |
| `nginx.conf` | Serves the React app on port `3000` |
| `deployment.yaml` | Creates Kubernetes deployment and pods |
| `service.yaml` | Exposes the application inside Kubernetes |
| `ingress.yaml` | Routes external ALB traffic to the application and Grafana paths |
| `servicemonitor.yaml` | Defines Prometheus scrape configuration for the application service |
| `values.yaml` | Stores Helm chart values for the Prometheus/Grafana stack |
| `jenkinsfile` | Automates CI/CD pipeline |
| `terraform/env/main.tf` | Main Terraform infrastructure entry point |
| `.gitignore` | Prevents secrets, Terraform state, keys, and local files from being committed |
| `.dockerignore` | Keeps Docker build context small |

## Beginner notes

These are the main things I learned while doing the project:

- `dist/` is required in this repo because the app is already built.
- Docker serves the app through Nginx, not through `npm start`.
- Jenkins needs Docker permission to build images.
- Jenkins credentials are different from Jenkins parameters.
- AWS CLI does not need a separate login command when credentials are injected as environment variables.
- `kubectl apply` creates or updates Kubernetes resources.
- `kubectl rollout status` helps confirm whether the deployment succeeded.
- When using the `latest` tag, `kubectl rollout restart` helps force pods to pull/run the updated image.
- AWS LoadBalancer DNS can take a few minutes to become available.

## Common issues I faced

### Docker permission error in Jenkins

Fix:

```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### EKS cluster not found

This happened when the cluster name was not passed properly to the Jenkins pipeline.

Fix:

- Check `EKS_CLUSTER_NAME` parameter.
- Check `AWS_REGION` parameter.
- Run:

```bash
aws eks list-clusters --region <aws-region>
```

### LoadBalancer DNS is empty

Fix:

```bash
kubectl get service trend-store-service -n <namespace>
kubectl describe service trend-store-service -n <namespace>
```

Sometimes AWS needs a few minutes to create the LoadBalancer.

### ImagePullBackOff

Fix:

- Confirm the DockerHub image exists.
- Confirm image name in `deployment.yaml` is correct.
- Make DockerHub repository public or configure image pull secret.

## Full screenshot evidence

All screenshots are saved in the `screenshots/` folder.

<details>
<summary>Click to view all project screenshots</summary>

![Screenshot 2026-06-11 160844](screenshots/Screenshot%202026-06-11%20160844.png)

![Screenshot 2026-06-11 161755](screenshots/Screenshot%202026-06-11%20161755.png)

![Screenshot 2026-06-11 161919](screenshots/Screenshot%202026-06-11%20161919.png)

![Screenshot 2026-06-11 184848](screenshots/Screenshot%202026-06-11%20184848.png)

![Screenshot 2026-06-11 184900](screenshots/Screenshot%202026-06-11%20184900.png)

![Screenshot 2026-06-11 184912](screenshots/Screenshot%202026-06-11%20184912.png)

![Screenshot 2026-06-19 130611](screenshots/Screenshot%202026-06-19%20130611.png)

![Screenshot 2026-06-19 130623](screenshots/Screenshot%202026-06-19%20130623.png)

![Screenshot 2026-06-19 130653](screenshots/Screenshot%202026-06-19%20130653.png)

![Screenshot 2026-06-21 030354](screenshots/Screenshot%202026-06-21%20030354.png)

![Screenshot 2026-06-21 030414](screenshots/Screenshot%202026-06-21%20030414.png)

![Screenshot 2026-06-21 030421](screenshots/Screenshot%202026-06-21%20030421.png)

![Screenshot 2026-06-21 030430](screenshots/Screenshot%202026-06-21%20030430.png)

![Screenshot 2026-06-21 030437](screenshots/Screenshot%202026-06-21%20030437.png)

![Screenshot 2026-06-21 030443](screenshots/Screenshot%202026-06-21%20030443.png)

![Screenshot 2026-06-22 111750](screenshots/Screenshot%202026-06-22%20111750.png)

![Screenshot 2026-06-22 112348](screenshots/Screenshot%202026-06-22%20112348.png)

![Screenshot 2026-06-22 112355](screenshots/Screenshot%202026-06-22%20112355.png)

![Screenshot 2026-06-23 115431](screenshots/Screenshot%202026-06-23%20115431.png)

![Screenshot 2026-06-23 120034](screenshots/Screenshot%202026-06-23%20120034.png)

![Screenshot 2026-06-23 120043](screenshots/Screenshot%202026-06-23%20120043.png)

![Screenshot 2026-06-23 120053](screenshots/Screenshot%202026-06-23%20120053.png)

![Screenshot 2026-06-23 120103](screenshots/Screenshot%202026-06-23%20120103.png)

![Screenshot 2026-06-23 121134](screenshots/Screenshot%202026-06-23%20121134.png)

![Screenshot 2026-06-23 124653](screenshots/Screenshot%202026-06-23%20124653.png)

![Screenshot 2026-06-23 124718](screenshots/Screenshot%202026-06-23%20124718.png)

![Screenshot 2026-06-23 143045](screenshots/Screenshot%202026-06-23%20143045.png)

![Screenshot 2026-06-23 143101](screenshots/Screenshot%202026-06-23%20143101.png)

![Screenshot 2026-06-23 144647](screenshots/Screenshot%202026-06-23%20144647.png)

![Screenshot 2026-06-23 144850](screenshots/Screenshot%202026-06-23%20144850.png)

![Screenshot 2026-06-23 151102](screenshots/Screenshot%202026-06-23%20151102.png)

![Screenshot 2026-06-23 151121](screenshots/Screenshot%202026-06-23%20151121.png)

![Screenshot 2026-06-23 151323](screenshots/Screenshot%202026-06-23%20151323.png)

![Screenshot 2026-06-23 152839](screenshots/Screenshot%202026-06-23%20152839.png)

![Screenshot 2026-06-23 213524](screenshots/Screenshot%202026-06-23%20213524.png)

![Screenshot 2026-06-23 214031](screenshots/Screenshot%202026-06-23%20214031.png)

![Screenshot 2026-06-23 214227](screenshots/Screenshot%202026-06-23%20214227.png)

![Screenshot 2026-06-23 214457](screenshots/Screenshot%202026-06-23%20214457.png)

![Screenshot 2026-06-23 214520](screenshots/Screenshot%202026-06-23%20214520.png)

![Screenshot 2026-06-23 214543](screenshots/Screenshot%202026-06-23%20214543.png)

![Screenshot 2026-06-23 214556](screenshots/Screenshot%202026-06-23%20214556.png)

![Screenshot 2026-06-23 214605](screenshots/Screenshot%202026-06-23%20214605.png)

![Screenshot 2026-06-23 214659](screenshots/Screenshot%202026-06-23%20214659.png)

![Screenshot 2026-06-29 182232](screenshots/Screenshot%202026-06-29%20182232.png)

![Screenshot 2026-06-29 182519](screenshots/Screenshot%202026-06-29%20182519.png)

![Screenshot 2026-06-29 182627](screenshots/Screenshot%202026-06-29%20182627.png)

![Screenshot 2026-06-29 182741](screenshots/Screenshot%202026-06-29%20182741.png)

</details>

## Cleanup

Delete Kubernetes resources:

```bash
kubectl delete -n <namespace> -f service.yaml
kubectl delete -n <namespace> -f deployment.yaml
```

Destroy AWS infrastructure:

```bash
cd terraform/env
terraform destroy
```

## Final submission checklist

- GitHub repository link
- Dockerfile
- `.dockerignore`
- `.gitignore`
- Terraform code
- Kubernetes deployment and service YAML files
- Jenkinsfile
- DockerHub image proof
- Jenkins pipeline proof
- EKS cluster proof
- Prometheus/Grafana monitoring proof
- Application LoadBalancer DNS
- Application LoadBalancer ARN
- Screenshots
