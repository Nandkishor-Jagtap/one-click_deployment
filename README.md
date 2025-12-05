Architecture (My Deployment)
Client → ALB (public subnets)
          ↓
      Target Group
          ↓
      Auto Scaling Group
          ↓
 Private EC2 Instances (no public IPs)
          ↓
      NAT Gateway (egress only)
          ↓
      Internet Gateway


✔ 2 public subnets
✔ 2 private subnets
✔ Public ALB
✔ Private ASG
✔ NAT for outbound internet only
✔ No public EC2

Components I Created
1. VPC

CIDR: 10.0.0.0/16

DNS hostnames enabled

2. Subnets

Public subnets

10.0.1.0/24

10.0.0.0/24

Private subnets

10.0.2.0/24

10.0.3.0/24

Screenshots verify these four subnets.

3. NAT Gateway

Placed in public subnet 10.0.0.0/24

Allocated Elastic IP

Used only for private EC2 internet access

4. Route Tables
Public Route Table

Default route → Internet Gateway

Private Route Table

Default route → NAT Gateway

Both verified in screenshots.

5. Security Groups
ALB SG

Allows HTTP (80) from anywhere

EC2 SG

Allows port 8080 only from ALB SG

No SSH exposed

6. Application Load Balancer (ALB)

Type: Application

Scheme: Internet-facing

Listener: HTTP 80

Target Group health check: /health

7. Target Group

Type: Instance

Port: 8080

Protocol: HTTP

Health check: /health

Status: healthy

Screenshot shows instance registered & healthy.

8. Launch Template

AMI: Amazon Linux 2

Instance type: t2.micro

User-data installs Python app and starts server on port 8080

9. Auto Scaling Group

Min: 1

Max: 2

Desired: 1

Subnets: private subnets only

REST API (My App)

Runs on port 8080 with two endpoints:

/

Returns:

Hello from private EC2!

/health

Returns:

ok


Both tested using ALB DNS and confirmed with 200 responses (screenshot provided).

One-Click Deploy

From the terraform/ folder:

terraform init
terraform apply -auto-approve


This command provisions:

✔ VPC
✔ Subnets
✔ NAT
✔ IGW
✔ Route tables
✔ ALB
✔ Target Group
✔ Launch Template
✔ ASG
✔ IAM role
✔ Security Groups
✔ EC2 (private)
✔ Health checks
✔ Fully running API

Testing the Deployment

After apply, run:

terraform output alb_dns


Example result:

oneclick-devops-alb-1749141582.us-east-1.elb.amazonaws.com


Test endpoints:

curl http://<ALB_DNS>/
curl http://<ALB_DNS>/health


Output:

Hello from private EC2!
ok


(Screenshots match exactly.)

Teardown

To avoid AWS charges:

terraform destroy -auto-approve


This destroys NAT, ALB, ASG, EC2, VPC, all resources.

Project Structure
one-click-deployment/
│
├── terraform/
│   ├── provider.tf
│   ├── vpc.tf
│   ├── subnets.tf
│   ├── nat.tf
│   ├── security.tf
│   ├── alb.tf
│   ├── launch_template_asg.tf
│   ├── outputs.tf
│   └── variables.tf
│
├── app/
│   └── server.py
│
└── scripts/
    ├── deploy.sh
    └── destroy.sh
✔ ASG
✔ API test: /
✔ API test: /health
