# 🚀 One-Click Deployment – DevOps Assignment

This project implements a **one-click deployable infrastructure** using **Terraform**, which provisions a complete AWS environment containing:

- VPC with **2 public** + **2 private subnets**
- Internet Gateway + NAT Gateway
- Public **Application Load Balancer (ALB)**
- **Auto Scaling Group (ASG)** deployed in private subnets
- REST API app running on private EC2 instances (no public IP)
- Health checks on `/health`
- One-click deploy (`terraform apply`)
- One-click teardown (`terraform destroy`)

---

## 🧱 **Architecture (My Deployment)**

```
Client → ALB (public subnets) → Target Group → ASG → Private EC2 instances (no public IPs)
↓
NAT Gateway (egress)
↓
Internet Gateway

yaml
Copy code

### ✔️ 2 public subnets  
### ✔️ 2 private subnets  
### ✔️ Public ALB  
### ✔️ Private ASG  
### ✔️ NAT for outbound internet  
### ✔️ NO public EC2 instances  
```
---

# 🛠️ **Components I Created**

---

## 1️⃣ **VPC**
- CIDR: `10.0.0.0/16`
- DNS hostnames: **Enabled**

---

## 2️⃣ **Subnets**

### **Public subnets**
- `10.0.1.0/24`
- `10.0.0.0/24`

### **Private subnets**
- `10.0.2.0/24`
- `10.0.3.0/24`

---

## 3️⃣ **Internet Gateway**
- Attached to VPC

---

## 4️⃣ **NAT Gateway**
- Created in public subnet
- Used by private subnets for outbound access

---

## 5️⃣ **Route Tables**

### **Public Route Table**
- `0.0.0.0/0` → Internet Gateway

### **Private Route Table**
- `0.0.0.0/0` → NAT Gateway

---

## 6️⃣ **Security Groups**

### **ALB SG**
- Allows HTTP (80) from internet

### **EC2 SG**
- Allows HTTP only from ALB security group
- No SSH (as per best practices)

---

## 7️⃣ **Launch Template**
- EC2 Amazon Linux 2
- User-data installs Python API (Flask)
- Runs server on **port 8080**

---

## 8️⃣ **Auto Scaling Group**
- Min: **1**
- Max: **2**
- Desired: **1**
- Uses private subnets only
- Connected to Target Group

---

## 9️⃣ **Application Load Balancer**
- Internet-facing
- Listener: HTTP 80
- Target Group:
  - Health endpoint: `/health`
  - Type: Instance
  - Protocol: HTTP 8080

---

# 🧪 **REST API Testing**

After deployment:

### Test main endpoint  
curl http://<ALB-DNS>

php
Copy code

> Output:  
`Hello from private EC2!`

### Test health endpoint  
curl http://<ALB-DNS>/health

yaml
Copy code

> Output:  
`ok`

---

# 📸 **Screenshots Included**
(Your repo should include these)

- ✔️ VPC  
- ✔️ Subnets (public + private)  
- ✔️ Route Tables  
- ✔️ NAT Gateway  
- ✔️ ALB configuration  
- ✔️ Target Group health check  
- ✔️ ASG details  
- ✔️ API test output (curl screenshot)  

---

# ▶️ **How to Deploy (One-Click)**
terraform init
terraform apply -auto-approve

yaml
Copy code

---

# 🧹 **Teardown (Destroy Everything)**
terraform destroy -auto-approve

yaml
Copy code

---

# 📂 **Repository Structure**
```
one-click-deployment/
│
├── terraform/ # All IaC code
├── app/ # REST API source code
├── scripts/
│ ├── deploy.sh
│ ├── destroy.sh
│ └── test.sh # (optional)
└── README.md
```

---
