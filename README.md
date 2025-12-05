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

```
### ✔️ 2 public subnets  
### ✔️ 2 private subnets  
### ✔️ Public ALB  
### ✔️ Private ASG  
### ✔️ NAT for outbound internet  
### ✔️ NO public EC2 instances  

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


> Output:  
`Hello from private EC2!`

### Test health endpoint  
curl http://<ALB-DNS>/health

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


---

# 🧹 **Teardown (Destroy Everything)**
terraform destroy -auto-approve


---

# 📂 **Repository Structure**
```
one-click-deployment/
│
├── terraform/ # All IaC code
├── app/ 
├── scripts/
│ ├── deploy.sh
│ ├── destroy.sh
│ └── test.sh
└── README.md
```

---
Subnets
<img width="1366" height="690" alt="image" src="https://github.com/user-attachments/assets/daf9df26-5b7b-4d63-a2c3-6a7c52976416" />

VPC
<img width="1366" height="690" alt="image" src="https://github.com/user-attachments/assets/8049e2e7-f550-4ca9-87f5-d961351243c9" />

Route Tables
<img width="1366" height="687" alt="image" src="https://github.com/user-attachments/assets/0bcdf21c-888b-437a-b9da-84cf1e711059" />
<img width="1366" height="690" alt="image" src="https://github.com/user-attachments/assets/85c64746-0183-4a85-8203-16ce1aed9577" />

IGW
<img width="1365" height="687" alt="image" src="https://github.com/user-attachments/assets/f4e07645-babd-43e9-aa18-30bca8883573" />

NAT Gateway
<img width="1365" height="683" alt="image" src="https://github.com/user-attachments/assets/124d03b8-e5a9-43bd-a87f-d1a402c6acb5" />

ALB
<img width="1366" height="686" alt="image" src="https://github.com/user-attachments/assets/db8743f0-c0b4-4717-9c50-106fe2b1573a" />
<img width="1366" height="689" alt="image" src="https://github.com/user-attachments/assets/a0d657c2-188d-4d89-90b0-8ff83f2004e6" />

Target Group
<img width="1366" height="690" alt="image" src="https://github.com/user-attachments/assets/df1fd35f-c05c-4aa0-992d-0031091fed95" />

Auto Scaling
<img width="1366" height="690" alt="image" src="https://github.com/user-attachments/assets/30ea6b96-6a53-457b-9715-bbadd74f56d6" />

API Test
<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/1e2e25f4-539d-4f85-aaba-a8e35bb2d644" />
