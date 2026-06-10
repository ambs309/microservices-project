
# Cloud Information Systems - Final Project

## Microservices Project deployed on AWS with Terraform, Docker, ECR, GitHub Actions and Ansible

This repository contains a cloud deployment of a Java Spring Boot microservices application for the **Cloud Information Systems** final project.

The goal of this project is not only to run a set of microservices, but to demonstrate a complete cloud engineering workflow:

1. provision AWS infrastructure with Terraform;
2. containerize each microservice with Docker;
3. store Docker images in Amazon ECR;
4. automate build and push using GitHub Actions;
5. deploy the application to an EC2 instance using Ansible;
6. expose the system through an API Gateway;
7. validate the deployment through terminal commands.

The project reuses the provided microservices application from the course and extends it with cloud infrastructure, automation and deployment tooling.

---

## Repository

```text
https://github.com/ambs309/microservices-project
```

Main working branch:

```text
final-project-approach-a-clean
```

---

## 1. Application overview

The application is composed of four Spring Boot services:

| Service | Description | Port |
|---|---|---|
| API Gateway | Single entry point for client requests using Spring Cloud Gateway | 8088 on AWS |
| User Service | Manages users | 8081 |
| Product Service | Manages products and inventory | 8082 |
| Order Service | Manages orders and communicates with User/Product services | 8083 |

The API Gateway exposes the backend services through `/api/...` routes.

The direct backend routes are:

```text
http://localhost:8081/users
http://localhost:8082/products
http://localhost:8083/orders
```

Through the gateway:

```text
http://localhost:8088/api/users
http://localhost:8088/api/products
http://localhost:8088/api/orders
```

Expected result on a clean database:

```text
[]
[]
[]
```

---

## 2. Cloud architecture

The AWS architecture created for this project includes:

```text
AWS Region: eu-central-1

VPC
├── Public Subnets
│   └── EC2 instance running Docker containers
├── Private Subnets
│   └── RDS PostgreSQL database
├── Internet Gateway
├── Security Groups
├── IAM Role for EC2
├── SQS queue + Dead Letter Queue
├── ECR repositories
└── AWS Budget alert
```

The application deployment flow is:

```text
Developer
   |
   | git push
   v
GitHub Actions
   |
   | build Docker images
   | push images
   v
Amazon ECR
   |
   | ansible deploy
   | docker pull
   v
EC2 instance
   |
   | docker-compose
   v
API Gateway + Microservices
```

---

## 3. Technologies used

### Application

```text
Java 21
Spring Boot 3.4.0
Spring Cloud Gateway
Spring Data JPA
OpenFeign
Kafka dependencies from the original application
H2 database for the current application runtime
Maven
JUnit 5
Mockito
Docker
```

### Cloud and DevOps

```text
AWS EC2
AWS VPC
AWS RDS PostgreSQL
AWS SQS + DLQ
AWS ECR
AWS IAM
AWS Budgets
Terraform
GitHub Actions
Ansible
Docker Compose
Kafka
Zookeeper
```

---

## 4. Project structure

```text
microservices-project/
├── api-gateway/
│   ├── Dockerfile
│   └── src/
├── user-service/
│   ├── Dockerfile
│   └── src/
├── product-service/
│   ├── Dockerfile
│   └── src/
├── order-service/
│   ├── Dockerfile
│   └── src/
├── ansible/
│   └── deploy.yml
├── infrastructure/
│   └── terraform/
│       ├── environments/
│       │   └── dev/
│       │       ├── main.tf
│       │       ├── variables.tf
│       │       ├── outputs.tf
│       │       ├── providers.tf
│       │       └── terraform.tfvars.example
│       └── modules/
│           ├── budget/
│           ├── ecr/
│           ├── ec2/
│           ├── iam/
│           ├── rds/
│           ├── sqs/
│           └── vpc/
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── docker-ecr.yml
├── docker-compose.yml
├── docker-compose.light.yml
├── pom.xml
└── README.md
```

---

## 5. What each part does

### Terraform

Terraform creates the AWS infrastructure:

```text
VPC
Subnets
Route tables
Internet Gateway
Security Groups
EC2 instance
RDS PostgreSQL database
SQS queue
Dead Letter Queue
IAM role and policies
ECR repositories
Budget alert
```

The infrastructure code is located in:

```text
infrastructure/terraform/
```

The main environment is:

```text
infrastructure/terraform/environments/dev/
```

### Docker

Each service has its own Dockerfile:

```text
api-gateway/Dockerfile
user-service/Dockerfile
product-service/Dockerfile
order-service/Dockerfile
```

Each image is built independently and pushed to its own ECR repository.

### GitHub Actions

There are two workflows:

```text
.github/workflows/ci.yml
.github/workflows/docker-ecr.yml
```

The first workflow runs Maven tests.

The second workflow builds and pushes Docker images to Amazon ECR.

### Ansible

Ansible is used to deploy the application on the EC2 instance.

The playbook:

```text
ansible/deploy.yml
```

It performs the following actions:

```text
Installs required packages
Starts Docker
Installs Docker Compose
Logs in to Amazon ECR
Creates a Docker Compose file using ECR images
Stops previous containers
Pulls latest images
Starts all services
Shows running containers
```

---

## 6. Prerequisites

To reproduce this project, the following tools are required on the local machine:

```text
Git
Java 21
Maven
Docker
AWS CLI
Terraform
GitHub CLI
SSH client
```

Check versions:

```bash
git --version
java -version
mvn -version
docker --version
aws --version
terraform version
gh --version
```

The AWS CLI must be configured:

```bash
aws configure
```

The GitHub CLI must be authenticated:

```bash
gh auth login
```

---

## 7. Clone the project

```bash
git clone https://github.com/ambs309/microservices-project.git
cd microservices-project
git checkout final-project-approach-a-clean
```

---

## 8. Run tests locally

Before deploying anything to AWS, validate the application locally:

```bash
mvn clean test
```

Expected result:

```text
BUILD SUCCESS
```

---

## 9. Run locally with Docker Compose

A lightweight Docker Compose file is available for running the four main services without Kafka/Zookeeper.

This lightweight mode is useful for proving that the API Gateway and the three main backend services work correctly with lower resource usage.

```bash
docker-compose -f docker-compose.light.yml up -d
```

Check containers:

```bash
docker ps
```

Test direct services:

```bash
curl http://localhost:8081/users
curl http://localhost:8082/products
curl http://localhost:8083/orders
```

Test through API Gateway:

```bash
curl http://localhost:8088/api/users
curl http://localhost:8088/api/products
curl http://localhost:8088/api/orders
```

Expected result:

```text
[]
[]
[]
```

Stop local containers:

```bash
docker-compose -f docker-compose.light.yml down
```

---

## 10. Full runtime test with Kafka and Zookeeper

The first EC2 deployment attempt used a `t3.micro` instance. That instance was enough for a lighter deployment of the Spring Boot services, but it was too memory-constrained to comfortably run the complete stack with Kafka, Zookeeper and all Java services at the same time.

For that reason, the EC2 instance type was changed to `t3.small`.

This decision was made to support a fuller runtime test of the architecture with:

```text
API Gateway
User Service
Product Service
Order Service
Kafka
Zookeeper
```

This test is important because the original application contains Kafka-related components, and the final cloud deployment should be able to demonstrate the messaging layer in addition to the HTTP microservices.

On the EC2 instance, create a Kafka/Zookeeper compose file:

```bash
cd ~/app/microservices-project
```

```bash
cat > docker-compose.kafka-test.yml <<'EOF'
services:
  zookeeper:
    image: confluentinc/cp-zookeeper:7.6.1
    container_name: cis-zookeeper
    network_mode: host
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000

  kafka:
    image: confluentinc/cp-kafka:7.6.1
    container_name: cis-kafka
    network_mode: host
    depends_on:
      - zookeeper
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: localhost:2181
      KAFKA_LISTENERS: PLAINTEXT://0.0.0.0:9092
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_AUTO_CREATE_TOPICS_ENABLE: "true"

  user-service:
    image: 096631344736.dkr.ecr.eu-central-1.amazonaws.com/cis-final-project-dev-user-service:latest
    container_name: cis-user-service
    network_mode: host
    environment:
      SPRING_PROFILES_ACTIVE: docker
      JAVA_TOOL_OPTIONS: "-Xms64m -Xmx160m"

  product-service:
    image: 096631344736.dkr.ecr.eu-central-1.amazonaws.com/cis-final-project-dev-product-service:latest
    container_name: cis-product-service
    network_mode: host
    depends_on:
      - kafka
    environment:
      SPRING_PROFILES_ACTIVE: docker
      SPRING_KAFKA_BOOTSTRAP_SERVERS: localhost:9092
      JAVA_TOOL_OPTIONS: "-Xms64m -Xmx160m"

  order-service:
    image: 096631344736.dkr.ecr.eu-central-1.amazonaws.com/cis-final-project-dev-order-service:latest
    container_name: cis-order-service
    network_mode: host
    depends_on:
      - user-service
      - product-service
      - kafka
    environment:
      SPRING_PROFILES_ACTIVE: docker
      SPRING_KAFKA_BOOTSTRAP_SERVERS: localhost:9092
      SERVICES_USER_URL: http://localhost:8081
      SERVICES_PRODUCT_URL: http://localhost:8082
      JAVA_TOOL_OPTIONS: "-Xms64m -Xmx160m"

  api-gateway:
    image: 096631344736.dkr.ecr.eu-central-1.amazonaws.com/cis-final-project-dev-api-gateway:latest
    container_name: cis-api-gateway
    network_mode: host
    depends_on:
      - user-service
      - product-service
      - order-service
    environment:
      SPRING_PROFILES_ACTIVE: docker
      SERVER_PORT: 8088
      JAVA_TOOL_OPTIONS: "-Xms64m -Xmx160m"
EOF
```

Remove any previous containers:

```bash
docker rm -f cis-api-gateway cis-order-service cis-product-service cis-user-service cis-kafka cis-zookeeper 2>/dev/null || true
```

Start the full stack:

```bash
docker-compose -f docker-compose.kafka-test.yml up -d
```

Kafka and Zookeeper can take longer to become ready, so wait before testing:

```bash
sleep 120
```

Check that all containers are running:

```bash
docker ps
```

Expected containers:

```text
cis-zookeeper
cis-kafka
cis-user-service
cis-product-service
cis-order-service
cis-api-gateway
```

Check ports:

```bash
sudo ss -tulpn | grep -E '8081|8082|8083|8088|9092|2181'
```

Check available memory:

```bash
free -h
```

Test the API Gateway:

```bash
curl http://localhost:8088/api/users
curl http://localhost:8088/api/products
curl http://localhost:8088/api/orders
```

Expected result:

```text
[]
[]
[]
```

Test Kafka:

```bash
docker logs cis-kafka --tail=50
```

List Kafka topics:

```bash
docker exec cis-kafka kafka-topics --bootstrap-server localhost:9092 --list
```

If the command connects successfully and returns without a connection error, Kafka is operational.

If topics were created by the application, they will appear in the output.

This validates that the upgraded `t3.small` instance can run the main microservices plus the Kafka/Zookeeper asynchronous messaging layer.

To stop this full test stack:

```bash
docker rm -f cis-api-gateway cis-order-service cis-product-service cis-user-service cis-kafka cis-zookeeper
```

---

## 11. Configure Terraform variables

Go to the Terraform environment:

```bash
cd infrastructure/terraform/environments/dev
```

Create a local `terraform.tfvars` file from the example:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit it:

```bash
notepad terraform.tfvars
```

Example values:

```hcl
project_name = "cis-final-project"
environment  = "dev"
aws_region   = "eu-central-1"

billing_email = "your-email@example.com"

monthly_budget_limit_usd     = 20
budget_warning_threshold_usd = 5

allowed_ssh_cidr  = "YOUR_PUBLIC_IP/32"
ec2_key_name      = "cis-final-project-key"
ec2_instance_type = "t3.small"

db_name     = "microservices"
db_username = "appuser"
db_password = "CHANGE_THIS_PASSWORD"
```

Do not commit `terraform.tfvars`.

It contains local and sensitive configuration.

The `t3.small` instance type is intentionally used because the complete runtime test includes Kafka, Zookeeper and multiple Java services. This requires more memory than the lighter deployment.

---

## 12. Create the EC2 key pair

Create an AWS key pair:

```bash
aws ec2 create-key-pair \
  --region eu-central-1 \
  --key-name cis-final-project-key \
  --query "KeyMaterial" \
  --output text > ~/Downloads/cis-final-project-key.pem
```

Protect the key:

```bash
chmod 400 ~/Downloads/cis-final-project-key.pem
```

Verify the key exists:

```bash
aws ec2 describe-key-pairs \
  --region eu-central-1 \
  --key-names cis-final-project-key
```

---

## 13. Deploy AWS infrastructure with Terraform

Initialize Terraform:

```bash
terraform init
```

Format and validate:

```bash
terraform fmt -recursive ../..
terraform validate
```

Preview the infrastructure:

```bash
terraform plan
```

Apply:

```bash
terraform apply
```

When Terraform asks for confirmation:

```text
yes
```

After a successful apply, Terraform prints outputs such as:

```text
ec2_public_ip
ec2_public_dns
db_instance_endpoint
product_events_queue_url
ecr_repository_urls
```

Current ECR repository URLs used by this project:

```text
096631344736.dkr.ecr.eu-central-1.amazonaws.com/cis-final-project-dev-api-gateway
096631344736.dkr.ecr.eu-central-1.amazonaws.com/cis-final-project-dev-user-service
096631344736.dkr.ecr.eu-central-1.amazonaws.com/cis-final-project-dev-product-service
096631344736.dkr.ecr.eu-central-1.amazonaws.com/cis-final-project-dev-order-service
```

---

## 14. Configure GitHub Actions secrets

The Docker/ECR workflow needs AWS credentials.

Set the secrets in the repository:

```bash
gh secret set AWS_ACCESS_KEY_ID --repo ambs309/microservices-project --body "$(aws configure get aws_access_key_id)"
gh secret set AWS_SECRET_ACCESS_KEY --repo ambs309/microservices-project --body "$(aws configure get aws_secret_access_key)"
```

Verify:

```bash
gh secret list --repo ambs309/microservices-project
```

Expected secrets:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

---

## 15. Run GitHub Actions

Push to the project branch:

```bash
git push
```

Open GitHub Actions:

```text
https://github.com/ambs309/microservices-project/actions
```

The following workflows should run:

```text
CI
Build and Push Docker Images to ECR
```

The CI workflow validates the project with Maven.

The Docker/ECR workflow builds and pushes four images:

```text
api-gateway
user-service
product-service
order-service
```

---

## 16. Verify images in ECR

After the Docker/ECR workflow finishes, verify the images:

```bash
aws ecr list-images --region eu-central-1 --repository-name cis-final-project-dev-api-gateway
aws ecr list-images --region eu-central-1 --repository-name cis-final-project-dev-user-service
aws ecr list-images --region eu-central-1 --repository-name cis-final-project-dev-product-service
aws ecr list-images --region eu-central-1 --repository-name cis-final-project-dev-order-service
```

Expected result:

```text
latest
commit sha tag
```

---

## 17. Connect to the EC2 instance

Use the public IP generated by Terraform.

Example:

```bash
ssh -i ~/Downloads/cis-final-project-key.pem ec2-user@3.68.217.87
```

If the IP changes, get the current value:

```bash
terraform output ec2_public_ip
```

Then connect with:

```bash
ssh -i ~/Downloads/cis-final-project-key.pem ec2-user@<EC2_PUBLIC_IP>
```

---

## 18. Prepare the project on EC2

Inside the EC2 instance:

```bash
mkdir -p ~/app
cd ~/app
```

Clone the repository if it does not exist:

```bash
git clone https://github.com/ambs309/microservices-project.git
cd microservices-project
git checkout final-project-approach-a-clean
```

If the repository already exists:

```bash
cd ~/app/microservices-project
git fetch origin
git reset --hard origin/final-project-approach-a-clean
```

---

## 19. Deploy with Ansible on EC2

Install Ansible:

```bash
sudo dnf install -y ansible-core
```

Run the deployment playbook:

```bash
sudo ansible-playbook ansible/deploy.yml
```

Expected final recap:

```text
failed=0
```

Ansible will pull the images from ECR and start the containers.

This playbook deploys the lightweight runtime with the four main services from ECR. The Kafka/Zookeeper test can then be executed separately using the commands in section 10.

---

## 20. Validate the deployment on EC2

Check running containers:

```bash
docker ps
```

Expected containers:

```text
cis-api-gateway
cis-user-service
cis-product-service
cis-order-service
```

The images should come from ECR:

```text
096631344736.dkr.ecr.eu-central-1.amazonaws.com/cis-final-project-dev-api-gateway:latest
096631344736.dkr.ecr.eu-central-1.amazonaws.com/cis-final-project-dev-user-service:latest
096631344736.dkr.ecr.eu-central-1.amazonaws.com/cis-final-project-dev-product-service:latest
096631344736.dkr.ecr.eu-central-1.amazonaws.com/cis-final-project-dev-order-service:latest
```

Test the services through the API Gateway:

```bash
curl http://localhost:8088/api/users
curl http://localhost:8088/api/products
curl http://localhost:8088/api/orders
```

Expected result:

```text
[]
[]
[]
```

The same can be tested from the local machine using the EC2 public IP:

```bash
curl http://<EC2_PUBLIC_IP>:8088/api/users
curl http://<EC2_PUBLIC_IP>:8088/api/products
curl http://<EC2_PUBLIC_IP>:8088/api/orders
```

Example:

```bash
curl http://3.68.217.87:8088/api/users
curl http://3.68.217.87:8088/api/products
curl http://3.68.217.87:8088/api/orders
```

---

## 21. Useful operational commands

Check memory on EC2:

```bash
free -h
```

Check containers:

```bash
docker ps
docker ps -a
```

Check logs:

```bash
docker logs cis-api-gateway --tail=100
docker logs cis-user-service --tail=100
docker logs cis-product-service --tail=100
docker logs cis-order-service --tail=100
```

For Kafka/Zookeeper logs:

```bash
docker logs cis-kafka --tail=100
docker logs cis-zookeeper --tail=100
```

Restart lightweight deployment:

```bash
cd ~/app/microservices-project
sudo ansible-playbook ansible/deploy.yml
```

Stop lightweight containers:

```bash
docker rm -f cis-api-gateway cis-user-service cis-product-service cis-order-service
```

Stop full Kafka/Zookeeper test stack:

```bash
docker rm -f cis-api-gateway cis-order-service cis-product-service cis-user-service cis-kafka cis-zookeeper
```

---

## 22. Security notes

The project includes the following security-related practices:

```text
EC2 access restricted by SSH CIDR
Security Groups separated for application and database
RDS deployed in private subnets
EC2 uses IAM role instead of hardcoded AWS credentials
ECR repositories use image scanning on push
ECR lifecycle policy keeps only the latest images
Terraform variables kept outside Git through terraform.tfvars
AWS Budget alert configured
```

The EC2 role has permissions for:

```text
SSM managed instance core
ECR read access
SQS access
```

GitHub Actions uses repository secrets for AWS credentials.

---

## 23. Cost control

This project creates real AWS resources.

The main resources that may generate cost are:

```text
EC2 instance
RDS database
ECR storage
SQS usage
Data transfer
```

A budget alert is configured through Terraform.

Check AWS resources with:

```bash
aws ec2 describe-instances --region eu-central-1
aws rds describe-db-instances --region eu-central-1
aws sqs list-queues --region eu-central-1
aws ecr describe-repositories --region eu-central-1
```

The EC2 instance was upgraded to `t3.small` to support Kafka/Zookeeper testing. This improves runtime capacity but may increase cost compared with `t3.micro`.

---

## 24. Cleanup

To remove the AWS infrastructure:

```bash
cd infrastructure/terraform/environments/dev
terraform destroy
```

Confirm:

```text
yes
```

This removes the Terraform-managed resources, including:

```text
EC2
RDS
VPC resources
SQS queues
ECR repositories
IAM resources
Budget
```

Because the ECR repositories use `force_delete = true`, Terraform can remove them even if images exist.

---

## 25. Current project status

Completed:

```text
Spring Boot microservices application
API Gateway routing correction
Dockerfiles for all services
Terraform infrastructure
Custom VPC
EC2 instance
RDS PostgreSQL
SQS queue and DLQ
IAM role and policies
ECR repositories
GitHub Actions CI
GitHub Actions Docker build and push to ECR
Ansible deployment
Application running on EC2 using ECR images
t3.small EC2 instance selected to support Kafka/Zookeeper runtime testing
Kafka/Zookeeper full-stack test documented
```

Validated commands:

```bash
curl http://localhost:8088/api/users
curl http://localhost:8088/api/products
curl http://localhost:8088/api/orders
```

Validated result:

```text
[]
[]
[]
```

---

## 26. Known limitations

The original application uses H2 for the current runtime profile. RDS PostgreSQL is provisioned as part of the AWS infrastructure, but the current deployed runtime still uses the application profile already present in the reference project.

The original application contains Kafka-based components. The lightweight deployment focuses on the four main Spring Boot services and the API Gateway. Kafka and Zookeeper are tested separately on the upgraded `t3.small` instance to validate that the cloud environment can support the asynchronous messaging layer.

SQS and DLQ are provisioned in Terraform as the AWS asynchronous messaging infrastructure. At this stage, they are part of the cloud infrastructure demonstration, while Kafka remains the messaging technology present in the original application code.

The EC2 deployment uses a single instance and Docker Compose. This is appropriate for the scope of the final project, but a production architecture would use ECS, EKS, an Application Load Balancer, private service networking, centralized logging, secrets management and autoscaling.

---

## 27. Evidence checklist for evaluation

Recommended screenshots:

```text
GitHub Actions CI successful
GitHub Actions Docker/ECR workflow successful
ECR repositories with images and latest tags
Terraform apply outputs
EC2 instance running as t3.small
RDS instance created
SQS queue and DLQ created
Ansible PLAY RECAP with failed=0
docker ps showing ECR images
curl commands returning [][][] through the API Gateway
docker ps showing Kafka and Zookeeper in the full runtime test
Kafka topics command executing successfully
free -h showing memory available on t3.small
```

